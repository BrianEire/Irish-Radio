#import "NSTimer+PausableTimer.h"

@implementation NSTimer (PausableTimer)

static char * kPausedDate = "pausedDate";
static char * kNextFireDate = "nextFireDate";

@dynamic pausedDate;
@dynamic nextFireDate;

-(void)pause {

  self.pausedDate = [NSDate date];

  self.nextFireDate = [self fireDate];

  [self setFireDate:[NSDate distantFuture]];
}

-(void)resume
{
  float pauseTime = -1.0 * [self.pausedDate timeIntervalSinceNow];

  [self setFireDate:[self.nextFireDate initWithTimeInterval:pauseTime sinceDate:self.nextFireDate]];
}

- (void)setPausedDate:(NSDate *)pausedDate
{
  objc_setAssociatedObject(self, kPausedDate, pausedDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)pausedDate
{
  return objc_getAssociatedObject(self, kPausedDate);
}

- (void)setNextFireDate:(NSDate *)nextFireDate
{
  objc_setAssociatedObject(self, kNextFireDate, nextFireDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDate *)nextFireDate
{
  return objc_getAssociatedObject(self, kNextFireDate);
}

@end
