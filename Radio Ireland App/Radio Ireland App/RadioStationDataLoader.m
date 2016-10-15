#import <AFNetworking/AFNetworking.h>
//#import "AFHTTPRequestOperation.h"
#import "Radio.h"
#import "CGLAlphabetizer.h"
#import "Reachability.h"
#import "RadioStationDataLoader.h"
#import "Constants.h"

@implementation RadioStationDataLoader



-(void) getRadioStationList:(void (^)(NSArray *data, NSDictionary *dictData))callback
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [manager GET:RadioStationListURL
      parameters:nil progress:nil
     
         success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
         [XMLParser setShouldProcessNamespaces:YES];
         XMLParser.delegate = self;
         [XMLParser parse];
         
         callback((NSArray*)self.sectionIndexTitles, (NSDictionary*)self.alphabetizedDictionary);
     }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Radio List"
                                                             message:[error localizedDescription]
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles:nil];
         [alertView show];
     }];
}
/*
-(void) getRadioStationList:(void (^)(NSArray *data, NSDictionary *dictData))callback
{
    NSString *string = RadioStationListURL;
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        [XMLParser setShouldProcessNamespaces:YES];
        XMLParser.delegate = self;
        [XMLParser parse];
        
         callback((NSArray*)self.sectionIndexTitles, (NSDictionary*)self.alphabetizedDictionary);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Radio List"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    [operation start];
}
*/
#pragma mark - XML Parser

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.radioStationList = [[NSMutableArray alloc]init];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"Radios"])
    {
    }
    else if([elementName isEqualToString:@"RadioL"])
    {
        self.aRadio = [[Radio  alloc] init];
        self.aRadio.stationID = [[attributeDict objectForKey:@"id"] integerValue];
    }
    else if([elementName isEqualToString:@"RadioN"])
    {
        self.aRadio = [[Radio  alloc] init];
        self.aRadio.stationID = [[attributeDict objectForKey:@"id"] integerValue];
    }
    else
    {
    }
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!currentElementValue)
    {
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    }
    else
    {
        [currentElementValue appendString:string];
    }
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if([elementName isEqualToString:@"Radios"])
    {
        if (currentElementValue != nil)
        {
            currentElementValue = nil;
        }
        return;
    }
    
    if([elementName isEqualToString:@"RadioN"])
    {
        [self.radioStationList addObject:self.aRadio];
        self.aRadio = nil;
    }
    if([elementName isEqualToString:@"RadioL"])
    {
        [self.radioStationList addObject:self.aRadio];
        self.aRadio = nil;
    }
    else
    {
        [self.aRadio setValue:[currentElementValue stringByReplacingOccurrencesOfString:@"\n" withString:@""] forKey:elementName];
    }
    
    currentElementValue = nil;
}


- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    self.alphabetizedDictionary = [CGLAlphabetizer alphabetizedDictionaryFromObjects:self.radioStationList usingKeyPath:@"stationName"];
    
    self.sectionIndexTitles = [CGLAlphabetizer indexTitlesFromAlphabetizedDictionary:self.alphabetizedDictionary];
}


@end
