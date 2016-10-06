#import "ViewController.h"
#import "RadioViewController.h"
#import "ChatViewController.h"
#import "AboutVC.h"
#import "Constants.h"

@interface ViewController ()
@property (nonatomic) CAPSPageMenu *pageMenu;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Select a Radio Station";
    self.pageMenu.title = @"Radio";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0];
    
    
    RadioViewController *controller1 = [[RadioViewController alloc]initWithNibName:@"RadioViewController" bundle:nil];
    controller1.title = @"Radio";
    
    AboutVC *controller3 = [[AboutVC alloc]initWithNibName:@"AboutVC" bundle:nil];
    controller3.title = @"About";
    
    ChatViewController *controller2 = [[ChatViewController alloc]initWithNibName:@"ChatViewController" bundle:nil];
    controller2.title = @"Chat";
    
    NSArray *controllerArray = @[controller1, controller2, controller3];
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: UIColorFromRGB(AppColorGreen),
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor darkGrayColor],
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor : [UIColor whiteColor],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor : [UIColor whiteColor],
                                 CAPSPageMenuOptionMenuItemSeparatorColor : [UIColor whiteColor],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0],
                                 CAPSPageMenuOptionMenuHeight: @(50.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(90.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorWidth:@(5.0)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    _pageMenu.hideTopMenuBar = YES;
    [self.view addSubview:_pageMenu.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
