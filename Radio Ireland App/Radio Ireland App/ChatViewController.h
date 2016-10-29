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

@property (nonatomic, weak) IBOutlet UITableView * myTableView;
@property (nonatomic, weak) IBOutlet UITextField * userNameTF;
@property (nonatomic, weak) IBOutlet UIButton * submitAccountButton;
@property (nonatomic, weak) IBOutlet UITextView * messageTV;
@property (nonatomic, weak) IBOutlet UIButton * sendMessage;
@property (nonatomic, weak) IBOutlet UIView  * registerView;
@property (nonatomic, weak) IBOutlet UIView * sendMessageView;
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;


- (IBAction)registerUserName:(id)sender;
- (IBAction)sendNewMessage:(id)sender;
- (IBAction)CancelMessage;

@end
