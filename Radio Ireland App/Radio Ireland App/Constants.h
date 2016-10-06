@import Foundation;

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define AppColorGreen 0x77dd77
#define AppColorDarkGray 0x282828

#define MaxBufferLength 78
#define MaxBufferHeight 56

#define userNameRegistered 0
#define userNameRegisterFailed 1
#define userNameTooShort 2
#define userNameX 3

@interface Constants : NSObject

@end

extern NSString * const RadioStationListURL;
extern NSString * const ChatUserNameRegURL;
extern NSString * const ChatSendMsgURL;
extern NSString * const ChatLoadAllMsgURL;
extern NSString * const ChatUpdateChatURL;

//extern NSString * const AppColorGreen;