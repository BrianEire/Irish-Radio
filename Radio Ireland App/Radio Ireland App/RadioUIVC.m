#import "RadioUIVC.h"
#import "AudioPlayer.h"
#import "DTShapeButton.h"
#import "NSTimer+PausableTimer.h"
#import "CATransaction+AnimateWithDuration.h"
#import "Constants.h"


@interface RadioUIVC ()

@property (strong, nonatomic) IBOutlet DTShapeButton *recordButton;
@property (strong, nonatomic) IBOutlet DTShapeButton *TriButton;
@property (strong, nonatomic) AudioPlayer *radioStreamPlayer;
@property (strong, nonatomic) CABasicAnimation *spinAnimation;
@end

@implementation RadioUIVC
{
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.radioStreamPlayer = [AudioPlayer sharedManager];
    [self setupRadioUI];
}


-(void)viewDidAppear:(BOOL)animated
{
    [self.animationTimer resume];
    [self.TriButton.shape.shapeLayer addAnimation:self.spinAnimation forKey:@"spin animation"];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [self.animationTimer pause];
    [self.TriButton.shape.shapeLayer removeAllAnimations];
}

#pragma mark - Radio UI Methods
- (void)setupRadioUI
{
    [self.stationNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [self.songNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
    self.songNameLabel.textColor = UIColorFromRGB(AppColorGreen);
    self.bufferLabel.textColor = UIColorFromRGB(AppColorGreen);
    
    self.view.backgroundColor = UIColorFromRGB(AppColorDarkGray);
    
    self.animationTimer = [NSTimer timerWithTimeInterval:1.5 target:self selector:@selector(animateRadioUI) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSDefaultRunLoopMode];
    
    self.TriButton.shape.path = [UIBezierPath bezierPathWithOvalInRect:self.TriButton.bounds];
    
    self.TriButton.shape.strokeEnd = 0.15;
    self.TriButton.shape.strokeColor = UIColorFromRGB(AppColorGreen);
    self.TriButton.hidden = YES;
    
    self.spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    self.spinAnimation.toValue        = @(1*2*M_PI);
    self.spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    self.spinAnimation.duration       = 1.0;
    self.spinAnimation.repeatCount    = INFINITY;
    [self.TriButton.shape.shapeLayer addAnimation:self.spinAnimation forKey:@"spin animation"];
}


-(void)animateRadioUI
{
    double bufferPercentage = self.radioStreamPlayer.bufferLength / MaxBufferLength;
    double height = MaxBufferHeight * (bufferPercentage);

    self.bufferImage.frame = CGRectMake(202, 63-height , 36, height);
    self.bufferImage.hidden = NO;

    if ([self.radioStreamPlayer.radioStationToPlay.stationName isEqual: [NSNull null]])
    {
        self.stationNameLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Select a Station", nil)];
    }
    else if (self.radioStreamPlayer.radioStationToPlay.stationName == nil)
    {
        self.stationNameLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"Select a Station", nil)];
    }
    else
    {
        self.stationNameLabel.text = [NSString stringWithFormat:@"%@", self.radioStreamPlayer.radioStationToPlay.stationName];
    }
    
    if ([self.radioStreamPlayer.songName isEqual: [NSNull null]])
    {
        self.songNameLabel.text = [NSString stringWithFormat:@"%@", @" "];
    }
    else if (self.radioStreamPlayer.songName == nil)
    {
        self.songNameLabel.text = [NSString stringWithFormat:@"%@", @" "];
    }
    else
    {
        self.songNameLabel.text = [NSString stringWithFormat:@"%@", self.radioStreamPlayer.songName];
    }
    
    if (self.radioStreamPlayer.streaming)
    {
        [self.recordButton setImage:[UIImage imageNamed:@"Pause-30.png" ] forState:UIControlStateNormal];
        self.TriButton.hidden = NO;
    }
    else
    {
    }
}


#pragma mark - Button Methods
- (IBAction)playPauseButtonTapped
{
    
    if (!self.radioStreamPlayer.readyToStream)
    {
        return;
    }
    
    if (!self.radioStreamPlayer.streaming)
    {
        [self.recordButton setImage:[UIImage imageNamed:@"Pause-30.png" ] forState:UIControlStateNormal];
        [self.radioStreamPlayer resumeStreamer];
        self.TriButton.hidden = NO;
    }
    else
    {
        [self.recordButton setImage:[UIImage imageNamed:@"Triangle-30.png" ] forState:UIControlStateNormal];
        [self.radioStreamPlayer pauseStreamer];
        self.TriButton.hidden = YES;
    }
}



@end
