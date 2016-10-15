@import UIKit;

@class Radio, Reachability, AudioPlayer, RadioStationDataLoader;
@interface RadioViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
}

@property (nonatomic, strong) IBOutlet UIView * radioUIView;
@property (nonatomic, strong) IBOutlet UIView * radioUIView2;
@property (nonatomic, strong) IBOutlet UITableView * radioStationTableView;

@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic, strong) RadioStationDataLoader * radioDataLoader;
@property (nonatomic, strong) NSDictionary *alphabetizedDictionary;
@property (nonatomic, strong) NSArray *sectionIndexTitles;
@property (nonatomic, strong) NSMutableArray *RadioStationList;
@property (nonatomic, strong) AudioPlayer *radioStreamPlayer;
@property (nonatomic, strong) Radio *aRadio;
@end
