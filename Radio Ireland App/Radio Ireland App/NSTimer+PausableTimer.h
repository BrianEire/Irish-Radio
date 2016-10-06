@import Foundation;
#import <objc/runtime.h>

@interface NSTimer (PausableTimer)

@property (nonatomic, retain) NSDate *pausedDate;

@property (nonatomic, retain) NSDate *nextFireDate;

-(void)pause;

-(void)resume;

@end
