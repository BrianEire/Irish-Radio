@import UIKit;
#import "ChatDataHandler.h"

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate ,NSXMLParserDelegate>
{

}

@property (nonatomic, strong) NSTimer *chatMsgLoadingtimer;
@property (nonatomic, strong) NSMutableArray * myArray;
@property (nonatomic, strong) NSMutableArray *chatList;
@property (nonatomic, strong) ChatDataHandler *chatHandler;
@property (nonatomic, assign) float keyBoardHeight;

@property (nonatomic, strong) IBOutlet UITableView * myTableView;
@property (nonatomic, strong) IBOutlet UITextField * userNameTF;
@property (nonatomic, strong) IBOutlet UIButton * submitAccountButton;
@property (nonatomic, strong) IBOutlet UITextView * messageTV;
@property (nonatomic, strong) IBOutlet UIButton * sendMessage;
@property (nonatomic, strong) IBOutlet UIView  * registerView;
@property (nonatomic, strong) IBOutlet UIView * sendMessageView;
@property (nonatomic, strong) IBOutlet UILabel * nameLabel;


- (IBAction)registerUserName:(id)sender;
- (IBAction)sendNewMessage:(id)sender;
- (IBAction)CancelMessage;

@end
