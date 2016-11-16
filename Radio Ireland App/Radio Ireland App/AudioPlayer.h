@import AVFoundation;
#import "Radio.h"

@interface AudioPlayer : NSObject <AVAudioSessionDelegate>
{
}

@property (readonly, nonatomic, assign, getter = isStreaming) BOOL streaming;
@property (readonly, nonatomic, assign, getter = isReadyToStream) BOOL readyToStream;
@property (assign) double bufferLength;
@property (nonatomic, strong) NSString* songName;
@property (nonatomic, strong) Radio* radioStationToPlay;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVQueuePlayer *player;
@property (nonatomic, strong) AVAudioSession *myAVAudioSession;


+ (id)sharedManager;
- (void)playStream:(Radio*)theRadioStation;
- (void)resumeStreamer;
- (void)pauseStreamer;


@end
