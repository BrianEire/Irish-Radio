#import "AudioPlayer.h"
@import AVFoundation;
@import AudioToolbox;
@import MediaPlayer;
#import "Radio.h"


void *kCurrentItemDidChangeKVO  = &kCurrentItemDidChangeKVO;
void *kRateDidChangeKVO         = &kRateDidChangeKVO;
void *kStatusDidChangeKVO       = &kStatusDidChangeKVO;
void *kDurationDidChangeKVO     = &kDurationDidChangeKVO;
void *kTimeRangesKVO            = &kTimeRangesKVO;
void *kBufferFullKVO            = &kBufferFullKVO;
void *kBufferEmptyKVO           = &kBufferEmptyKVO;
void *kDidFailKVO = &kDidFailKVO;

@interface AudioPlayer ()

@property (nonatomic, strong) MPRemoteCommandCenter *rcc;


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag;
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError *)error;
@end


@implementation AudioPlayer
{
}

+ (AudioPlayer *)sharedManager {
    static AudioPlayer *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        _streaming = NO;
        
        _rcc = [MPRemoteCommandCenter sharedCommandCenter];
        
        MPRemoteCommand *pauseCommand = [_rcc pauseCommand];
        [pauseCommand setEnabled:YES];
        [pauseCommand addTarget:self action:@selector(pauseEvent)];

        MPRemoteCommand *playCommand = [_rcc playCommand];
        [playCommand setEnabled:YES];
        [playCommand addTarget:self action:@selector(playEvent)];
        
        _readyToStream = NO;
    }
    return self;
}

-(void) pauseEvent
{
    [_rcc.playCommand setEnabled:YES];
    [_rcc.pauseCommand setEnabled:NO];
    [self.player pause];
    _streaming = NO;
}

-(void) playEvent
{
    [self.player play];
    [_rcc.playCommand setEnabled:NO];
    [_rcc.pauseCommand setEnabled:YES];
    _streaming = YES;
    _readyToStream = YES;
}

#pragma mark - Timer

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
}


-(void)playStream:(Radio*) theRadioStation
{
    self.songName = @" ";
    
    _readyToStream = YES;
    _radioStationToPlay = theRadioStation;
    
    if (self.player != nil)
    {
        [self.playerItem removeObserver:self forKeyPath:@"timedMetadata"];
        [self.player removeObserver:self forKeyPath:@"currentItem.status"];
        [self.player removeObserver:self forKeyPath:@"currentItem.loadedTimeRanges"];
    }
    
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]];
    
    [self.playerItem addObserver:self forKeyPath:@"timedMetadata" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:kAudioSessionCategory_MediaPlayback
                        error:&setCategoryError])
    {
    }
    
    [self.player addObserver:self forKeyPath:@"currentItem.status"              options:NSKeyValueObservingOptionNew context:kStatusDidChangeKVO];
    [self.player addObserver:self forKeyPath:@"currentItem.loadedTimeRanges"    options:NSKeyValueObservingOptionNew context:kTimeRangesKVO];
    
    [self.player play];
    _streaming= YES;
    
}



-(void) pauseStreamer
{
    [self.player pause];
    _streaming= NO;
}

-(void) resumeStreamer
{
    [self.player play];
    _streaming= YES;
    
}


- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object
                         change:(NSDictionary*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"timedMetadata"])
    {
        AVPlayerItem* playerItemX = object;
        for (AVMetadataItem* metadata in playerItemX.timedMetadata)
        {
            if ([[metadata commonKey]  isEqual: @"title"])
            {
                self.songName = [NSString stringWithString:[metadata.value copyWithZone:nil]];
            }
        }
    }

    else if (kStatusDidChangeKVO == context)
    {
        if (self.player.status == AVPlayerStatusReadyToPlay)
        {
        }
    }
    else if (kTimeRangesKVO == context)
    {
        NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
        
        if (![[NSNull null] isEqual:timeRanges])
        {
            if (timeRanges && [timeRanges count])
            {
                CMTimeRange timerange = [[timeRanges objectAtIndex:0] CMTimeRangeValue];
                _bufferLength = CMTimeGetSeconds(timerange.duration);
            }
        }
    }
}



@end
