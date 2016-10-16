#import "ChatDataHandler.h"
#import <AFNetworking/AFNetworking.h>
//#import "AFHTTPRequestOperation.h"
#import "Constants.h"

@implementation ChatDataHandler


- (id)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userIsRegistered = [defaults boolForKey:@"userIsRegistered"];
    
     if (self.userIsRegistered)
     {
         self.savedUserName = [defaults objectForKey:@"savedUserName"];
     }
    return self;
}


- (void)registerUserName:(NSString*)userName andCallback:(void (^)(int))callback
{
    NSString *nameString = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([nameString length] < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"User Name", nil)
                                                        message:NSLocalizedString(@"User Name must be atleast 2 characters long", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        
        callback((int) UserNameTooShort);
        
        return;
    }
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *UDIDstring = [NSString stringWithString:[oNSUUID UUIDString]];

    NSDictionary *parameters2 = [NSDictionary dictionaryWithObjectsAndKeys: UDIDstring, @"udid", nameString, @"name", @"some_secret", @"secret", nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:ChatUserNameRegURL
      parameters:parameters2 progress:nil
         success:^(NSURLSessionDataTask *task, id responseObject)
     {
         
         NSString *text = [[NSString alloc] initWithData:responseObject
                                                encoding:NSUTF8StringEncoding];
         
         if ([text isEqualToString: @"Success"])
         {

             self.savedUserName = [NSString stringWithString:nameString];
             self.userIsRegistered = YES;
             // Store the data
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:self.savedUserName forKey:@"savedUserName"];
             [defaults setBool:YES forKey:@"userIsRegistered"];
             [defaults synchronize];
             
             callback((int) UserNameRegistered);

         }
         else
         {
             callback((int) UserNameRegisterFailed);
         }
         
     }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             
             callback((int) UserNameRegisterFailed);
         }];
}


- (void)sendChatMessage:(NSString*)chatMsg andCallback:(void (^)(BOOL))callback
{
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *UDIDstring = [NSString stringWithString:[oNSUUID UUIDString]];
    
    if ([chatMsg length] < 2)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Message", nil)
                                                        message:NSLocalizedString(@"Messages must be atleast 2 characters long", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
        
        callback((BOOL) NO);
        
        return;
    }
    
    
    
    NSDictionary *parameters2 = [NSDictionary dictionaryWithObjectsAndKeys: UDIDstring, @"udid", self.savedUserName, @"name", @"clubname", @"clubname", chatMsg, @"message", @"some_secret", @"secret", nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:ChatSendMsgURL
      parameters:parameters2 progress:nil
         success:^(NSURLSessionDataTask *task, id responseObject)
     {
         callback((BOOL) YES);
     }
         failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        callback((BOOL) NO);
         }];
}


- (void)getChatMessages:(void (^)(NSArray *))callback
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:ChatLoadAllMsgURL
      parameters:nil progress:nil
     
         success:^(NSURLSessionDataTask *task, id responseObject)
     {
         callback((NSArray*) responseObject);
     }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error Retrieving Chat", nil)
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
}


- (void)getNewChatMessages:(NSString*)lastMsgID andCallback:(void (^)(NSArray *))callback
{
    NSDictionary *parameters2 = [NSDictionary dictionaryWithObjectsAndKeys: lastMsgID, @"theid", nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:ChatUpdateChatURL
      parameters:parameters2 progress:nil
     
         success:^(NSURLSessionDataTask *task, id responseObject)
     {
         callback((NSArray*) responseObject);
     }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}


@end
