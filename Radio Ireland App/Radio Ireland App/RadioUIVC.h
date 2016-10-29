@import UIKit;
#import "NSTimer+PausableTimer.h"

@interface RadioUIVC : UIViewController
{}


@property (nonatomic, weak) IBOutlet UILabel * bufferLabel;
@property (nonatomic, weak) IBOutlet UILabel * stationNameLabel;
@property (nonatomic, weak) IBOutlet UILabel * songNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView * bufferImage;
@property (nonatomic, strong) NSTimer *animationTimer;

- (void)setupRadioUI;
- (IBAction)playPauseButtonTapped;

@end
