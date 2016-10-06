@import UIKit;

@interface Radio : NSObject 
{
}

@property (nonatomic, readwrite) NSInteger stationID;
@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSString *streamType;
@property (nonatomic, strong) NSString *streamURL;
@property (nonatomic, strong) NSString *streamBandwidth;
@property (nonatomic, strong) NSString *radioGenres;
@property (nonatomic, strong) NSString *radioGenresTwo;
@property (nonatomic, strong) NSString *recommended;

@end

