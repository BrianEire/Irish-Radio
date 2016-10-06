@import UIKit;
#import "RadioStationDataLoader.h"
#import "AudioPlayer.h"

@class Radio;

@interface RadioViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    Radio *aRadio;
}
@property (nonatomic, strong) IBOutlet UIView * radioUIView;
@property (nonatomic, strong) IBOutlet UITableView * radioStationTableView;

@property (nonatomic, strong) RadioStationDataLoader * radioDataLoader;
@property (nonatomic, strong) NSDictionary *alphabetizedDictionary;
@property (nonatomic, strong) NSArray *sectionIndexTitles;
@property (nonatomic, strong) NSMutableArray *RadioStationList;
@property (nonatomic, strong) AudioPlayer *radioStreamPlayer;


@end
