#import "ChatViewController.h"
#import "NSTimer+PausableTimer.h"
#import "ChatDataHandler.h"
#import "Constants.h"

# define TABLE_CELL_Y_PADDING 27

@interface ChatViewController ()

@end

@implementation ChatViewController
{
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.userNameTF.delegate = self;
    self.messageTV.delegate = self;
    
    self.chatHandler = [[ChatDataHandler alloc] init];
    
    if (self.chatHandler.userIsRegistered)
    {
        [self showChatMessageUI];
    }

    [self loadChatData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    self.chatMsgLoadingtimer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(updateChatMessages) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.chatMsgLoadingtimer forMode:NSDefaultRunLoopMode];
    

    
}


-(void) viewWillDisappear:(BOOL)animated
{
    [self.chatMsgLoadingtimer pause];
}


-(void) viewWillAppear:(BOOL)animated
{
    self.nameLabel.text = NSLocalizedString(@"Name", nil);
    self.userNameTF.placeholder = NSLocalizedString(@"Enter a chat name", nil);
    [self.submitAccountButton setTitle:NSLocalizedString(@"Register", nil)forState:UIControlStateNormal];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.myTableView.contentSize.height > self.myTableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.myTableView.contentSize.height -     self.myTableView.frame.size.height);
        [self.myTableView setContentOffset:offset animated:YES];
    }
    
    [self hideKeyboardAndSlideDownUI:self.userNameTF];
    [self hideKeyboardAndSlideDownUI:self.messageTV];
    
    [self.chatMsgLoadingtimer resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * myMessage = [self.myArray objectAtIndex:indexPath.row];
    
    CGRect textRect = [[myMessage objectForKey:@"message"] boundingRectWithSize:CGSizeMake(300, FLT_MAX)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15.0]}
                                                                        context:nil];
    CGSize size = textRect.size;
    return size.height + TABLE_CELL_Y_PADDING;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if (cell == nil)
    {
      
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        NSDictionary * myMessage = [self.myArray objectAtIndex:indexPath.row];
        
        NSRange range = NSMakeRange(10, 6);
        NSString * dateString = [NSString stringWithString:[myMessage objectForKey:@"date"]];
        NSString *result = [dateString substringWithRange:range];
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 290, 20)];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@ @ %@",NSLocalizedString(@"by", nil),[myMessage objectForKey:@"name"], result];
        nameLabel.textColor = [UIColor darkGrayColor];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        
        nameLabel.tag = 10;
        [cell.contentView addSubview: nameLabel];
        
        UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 300, 20)];

         messageLabel.text = [myMessage objectForKey:@"message"];
        [messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15.0]];
         messageLabel.tag = 11;
         messageLabel.numberOfLines = 0;
        [messageLabel sizeToFit];
         [cell.contentView addSubview: messageLabel];
    }
   else
    {
        NSDictionary * myMessage = [self.myArray objectAtIndex:indexPath.row];
        
        NSRange range = NSMakeRange(10, 6);
        NSString * dateString = [NSString stringWithString:[myMessage objectForKey:@"date"]];
        NSString *result = [dateString substringWithRange:range];
        
        for (UILabel* view in [cell.contentView subviews])
        {
            if (view.tag == 10)  //Condition if that view belongs to any specific class
            {
                view.text = [NSString stringWithFormat:@"%@ %@ @ %@",NSLocalizedString(@"by", nil),[myMessage objectForKey:@"name"], result];
            }
            else if (view.tag == 11)
            {
                CGRect textRect = [[myMessage objectForKey:@"message"] boundingRectWithSize:CGSizeMake(300, FLT_MAX)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:15.0]}
                                                     context:nil];
                CGSize size = textRect.size;
                view.text = [myMessage objectForKey:@"message"];
                view.frame = CGRectMake(10, 22, size.width, size.height);
            }
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    self.keyBoardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    if (self.view.frame.origin.y < 40)
    {
        CGRect frame = self.view.frame;
        frame.origin.y = 40;
        self.view.frame = frame;
    }
  
    self.view.frame = CGRectOffset(self.view.frame, 0, -self.keyBoardHeight);
}


-(void)keyboardDidHide:(NSNotification *)notification
{
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void) showChatMessageUI
{
    if (self.chatHandler.userIsRegistered)
    {
        self.registerView.layer.hidden = true;
        self.sendMessageView.layer.hidden = false;
    }
    else
    {
        self.registerView.layer.hidden = false;
        self.sendMessageView.layer.hidden = true;
    }
}


-(void) hideKeyboardAndSlideDownUI:(id) theActiveUIObject
{
    [theActiveUIObject resignFirstResponder];
    if (self.view.frame.origin.y < 0)
    {
        self.view.frame = CGRectOffset(self.view.frame, 0, self.keyBoardHeight);
    }
}


-(IBAction)CancelMessage
{
    self.messageTV.text = @"";
    [self.messageTV resignFirstResponder];
    
    if (self.view.frame.origin.y < 0)
    {
        self.view.frame = CGRectOffset(self.view.frame, 0, self.keyBoardHeight);
    }
}


-(void) scrollTableToBottom
{
    if (self.myTableView.contentSize.height > self.myTableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.myTableView.contentSize.height -     self.myTableView.frame.size.height);
        [self.myTableView setContentOffset:offset animated:YES];
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 20) ? NO : YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 100;
}


#pragma mark - Messaging Functions

-(void) updateChatMessages
{
    if ([self.myArray count] == 0)
    {
        [self loadChatData];
        return;
    }
    
    NSDictionary * messageDict = [self.myArray objectAtIndex:[self.myArray count]-1];
    NSString * theID = [NSString stringWithString:[messageDict objectForKey:@"id"]];
    
    [self.chatHandler getNewChatMessages:theID andCallback:^(NSArray * result){
       
        [self.myArray addObjectsFromArray:(NSArray *)result];
        
        [self.myTableView reloadData];
        [self scrollTableToBottom];
        
    }];
}


- (IBAction)sendNewMessage:(id)sender
{
    [self hideKeyboardAndSlideDownUI:self.messageTV];
    
    [self.chatHandler sendChatMessage:self.messageTV.text andCallback:^(BOOL result){
        
        [self CancelMessage];
        
        if (result)
        {
            [self updateChatMessages];
        }
        else
        {
        }
    }];
}


- (IBAction)registerUserName:(id)sender
{
    [self.chatHandler registerUserName:self.userNameTF.text andCallback:^(int result){
        
        if (result == userNameRegistered)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil)
                                                                message:NSLocalizedString(@"Chat name created.", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else if (result == userNameTooShort)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"User Name", nil)
                                                            message:NSLocalizedString(@"User Name must be atleast 2 characters long", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else if (result == userNameRegisterFailed)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                                message:NSLocalizedString(@"Could not create this name, please try again.", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        else if (result == userNameX)
        {
        }
        
        [self showChatMessageUI];
        [self hideKeyboardAndSlideDownUI:self.userNameTF];
        
    }];
}


- (void)loadChatData
{
    [self.chatHandler getChatMessages:^(NSArray* result){
        
        self.myArray = [[NSMutableArray alloc] initWithArray:(NSArray *)result];
        self.myArray = [[self.myArray reverseObjectEnumerator].allObjects mutableCopy];
        
        [self.myTableView reloadData];
        [self scrollTableToBottom];
    }];
}

@end
