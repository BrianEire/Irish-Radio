@import UIKit;
#import "NSTimer+PausableTimer.h"

@interface RadioUIVC : UIViewController
{}


@property (nonatomic, strong) IBOutlet UILabel * bufferLabel;
@property (nonatomic, strong) IBOutlet UILabel * stationNameLabel;
@property (nonatomic, strong) IBOutlet UILabel * songNameLabel;
@property (nonatomic, strong) IBOutlet UIImageView * bufferImage;
@property (nonatomic, strong) NSTimer *animationTimer;

- (void)setupRadioUI;
- (IBAction)playPauseButtonTapped;

@end
