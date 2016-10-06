@import Foundation;

@interface ChatDataHandler : NSObject <NSXMLParserDelegate>
{
    NSMutableArray * myArray;
}

@property (nonatomic, strong) NSString * savedUserName;
@property (nonatomic, assign) BOOL userIsRegistered;

- (void)getChatMessages:(void (^)(NSArray *))callback;
- (void)sendChatMessage:(NSString*)chatMsg andCallback:(void (^)(BOOL))callback;
- (void)registerUserName:(NSString*)userName andCallback:(void (^)(int))callback;
- (void)getNewChatMessages:(NSString*)lastMsgID andCallback:(void (^)(NSArray *))callback;

@end
