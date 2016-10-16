//
//  RadioViewController2.h
//  Radio Ireland App
//
//  Created by BD on 15/10/2016.
//  Copyright © 2016 Brian Doyle. All rights reserved.
//

@import UIKit;

@class Radio, Reachability, AudioPlayer, RadioStationDataLoader, RadioUIVC;
@interface RadioViewController2 : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
}

@property (nonatomic, strong) IBOutlet UIView * radioUIView;
//@property (nonatomic, strong) IBOutlet UIView * radioUIView2;
@property (nonatomic, strong) IBOutlet UITableView * radioStationTableView;
@property (nonatomic, strong) IBOutlet RadioUIVC * radioUIViewController;
@property (nonatomic, strong) Reachability *internetReachable;
@property (nonatomic, strong) RadioStationDataLoader * radioDataLoader;
@property (nonatomic, strong) NSDictionary *alphabetizedDictionary;
@property (nonatomic, strong) NSArray *sectionIndexTitles;
@property (nonatomic, strong) NSMutableArray *RadioStationList;
@property (nonatomic, strong) AudioPlayer *radioStreamPlayer;
@property (nonatomic, strong) Radio *aRadio;


- (IBAction)btn;

@end
