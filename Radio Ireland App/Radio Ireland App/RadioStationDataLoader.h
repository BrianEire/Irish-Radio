@import Foundation;
#import "Radio.h"


@class XMLParser;

@interface RadioStationDataLoader : NSObject <NSXMLParserDelegate>
{
    XMLParser *parser;
    NSMutableString *currentElementValue;
}

@property (nonatomic, strong) NSMutableArray *radioStationList;
@property (nonatomic, strong) Radio *aRadio;
@property (nonatomic, strong) NSDictionary *alphabetizedDictionary;
@property (nonatomic, strong) NSArray *sectionIndexTitles;

-(void) getRadioStationList:(void (^)(NSArray *data,NSDictionary *dictData))callback;
@end
