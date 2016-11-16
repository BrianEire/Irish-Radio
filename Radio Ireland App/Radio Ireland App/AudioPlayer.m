#import "AudioPlayer.h"
@import AVFoundation;
@import AudioToolbox;
@import MediaPlayer;
#import "Radio.h"

void *kTimeRangesKVO            = &kTimeRangesKVO;

@interface AudioPlayer ()

@property (nonatomic, strong) MPRemoteCommandCenter *rcc;
@property (nonatomic, strong) MPRemoteCommand *pauseCommand;
@property (nonatomic, strong) MPRemoteCommand *playCommand;

@end


@implementation AudioPlayer{
}


+ (AudioPlayer *)sharedManager {
    static AudioPlayer *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


- (id)init{
    if (self = [super init]){
        _streaming = NO;
        
        self.myAVAudioSession = [AVAudioSession sharedInstance];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:self.myAVAudioSession];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(routeChange:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:self.myAVAudioSession];
        
        
        self.rcc = [MPRemoteCommandCenter sharedCommandCenter];
        
        self.pauseCommand = [_rcc pauseCommand];
        [self.pauseCommand addTarget:self action:@selector(pauseEvent)];

        self.playCommand = [_rcc playCommand];
        [self.playCommand addTarget:self action:@selector(playEvent)];
        
        _readyToStream = NO;
    }
    return self;
}


-(void)routeChange:(NSNotification*)notification{
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    
    switch (routeChangeReason){
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            NSError* error;
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            _streaming= NO;
        }
            break;
        default:
        {}
            break;
    }
    
}


-(void)audioSessionInterruptionNotification:(NSNotification*)notification{
    
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]){
        //Check to see if it was a Begin interruption
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]){
            [self.player pause];
            _streaming= NO;
        }
        else if([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeEnded]]){
            //this seems buggy, calling after a slight delay works 100%, without it is unreliable
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.05 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self resumeStreamer];
            });
        }
    }
}


#pragma mark - Stream KVO
- (void) observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object
                         change:(NSDictionary*)change context:(void*)context{
    
    if ([keyPath isEqualToString:@"currentItem.timedMetadata"]){
        AVQueuePlayer* queuePlayer = object;
        for (AVMetadataItem* metadata in queuePlayer.currentItem.timedMetadata){
            if ([[metadata commonKey]  isEqual: @"title"]){
                self.songName = [NSString stringWithString:[metadata.value copyWithZone:nil]];
            }
        }
    }

    if ([keyPath isEqualToString:@"currentItem.loadedTimeRanges"]){
        NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
        
        if (![[NSNull null] isEqual:timeRanges]){
            if (timeRanges && [timeRanges count]){
                CMTimeRange timerange = [[timeRanges objectAtIndex:0] CMTimeRangeValue];
                _bufferLength = CMTimeGetSeconds(timerange.duration);
            }
        }
    }
}



#pragma mark - Stream Control Methods
-(void)playStream:(Radio*) theRadioStation{
    self.songName = @" ";
    
    _readyToStream = YES;
    _radioStationToPlay = theRadioStation;
    
    if (self.player != nil){
       [self.player removeObserver:self forKeyPath:@"currentItem.timedMetadata"];
       [self.player removeObserver:self forKeyPath:@"currentItem.status"];
       [self.player removeObserver:self forKeyPath:@"currentItem.loadedTimeRanges"];
    }
    
    
    
    NSArray *queue = @[
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]],
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]],
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]],
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]],
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]],
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]],
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]],
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]],
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]],
                       [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_radioStationToPlay.streamURL]]];
    
    self.player = [[AVQueuePlayer alloc] initWithItems:queue];
    self.player.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
    
    NSError *setCategoryError = nil;
    if (![self.myAVAudioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:kAudioSessionCategory_MediaPlayback
                        error:&setCategoryError]){
    }
    

    [self.player addObserver:self forKeyPath:@"currentItem.timedMetadata" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"currentItem.loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"currentItem.status" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.player play];
    _streaming= YES;
    
}


-(void) pauseEvent{
    [self.player pause];
    _streaming = NO;
}


-(void) playEvent{
    [self.player play];
    _streaming = YES;
    _readyToStream = YES;
}


-(void) pauseStreamer{
    [self.player pause];
    _streaming= NO;
}


-(void) resumeStreamer{
    [self.player play];
    _streaming= YES;
}
@end
