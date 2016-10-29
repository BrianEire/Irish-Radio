@import UIKit;

@class Radio, Reachability, AudioPlayer, RadioUIVC, RadioStationDataLoader;
@interface RadioViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
}

@property (nonatomic, weak) IBOutlet UIView * radioUIView;
@property (nonatomic, weak) IBOutlet UITableView * radioStationTableView;
@property (nonatomic, strong) RadioUIVC * radioUIViewController;

@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic, strong) RadioStationDataLoader * radioDataLoader;
@property (nonatomic, strong) NSDictionary *alphabetizedDictionary;
@property (nonatomic, strong) NSArray *sectionIndexTitles;
@property (nonatomic, strong) NSMutableArray *RadioStationList;
@property (nonatomic, strong) AudioPlayer *radioStreamPlayer;
@property (nonatomic, strong) Radio *aRadio;
@end

