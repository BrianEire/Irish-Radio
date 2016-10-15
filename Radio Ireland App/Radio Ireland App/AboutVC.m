#import "AboutVC.h"
#import "Constants.h"

@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.aboutLabel.textColor = UIColorFromRGB(AppColorDarkGray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
