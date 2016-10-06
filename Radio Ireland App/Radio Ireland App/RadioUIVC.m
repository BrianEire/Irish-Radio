#import "RadioUIVC.h"
#import "AudioPlayer.h"
//#import "DTShapeView.h"
#import "DTShapeButton.h"
#import "NSTimer+PausableTimer.h"
#import "CATransaction+AnimateWithDuration.h"
#import "Constants.h"


@interface RadioUIVC ()

@property (weak, nonatomic) IBOutlet DTShapeButton *recordButton;
@property (weak, nonatomic) IBOutlet DTShapeButton *TriButton;
@property (weak, nonatomic) AudioPlayer *radioStreamPlayer;
@end

@implementation RadioUIVC
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.radioStreamPlayer = [AudioPlayer sharedManager];

    [self setupRadioUI];
}

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
    
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue        = @(1*2*M_PI);
    spinAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    spinAnimation.duration       = 1.0;
    spinAnimation.repeatCount    = INFINITY;
    [self.TriButton.shape.shapeLayer addAnimation:spinAnimation forKey:@"spin animation"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.animationTimer resume];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.animationTimer pause];
}

-(void)animateRadioUI
{
    double bufferPercentage = self.radioStreamPlayer.bufferLength / MaxBufferLength;
    double height = MaxBufferHeight * (bufferPercentage);

    self.bufferImage.frame = CGRectMake(203, 63-height , 36, height); 
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


- (IBAction)playPauseButtonTapped:(id)sender
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
