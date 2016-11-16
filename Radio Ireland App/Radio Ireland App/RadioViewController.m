#import "RadioViewController.h"
#import "AudioPlayer.h"
#import "Radio.h"
#import "RadioUIVC.h"
#import "CGLAlphabetizer.h"
#import "Reachability.h"
#import "RadioStationDataLoader.h"
#import "Constants.h"

@interface RadioViewController ()
@end


@implementation RadioViewController
{}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.radioStreamPlayer = [AudioPlayer sharedManager];
    
    self.radioUIViewController = [[RadioUIVC alloc]init];
    [self.radioUIView addSubview:self.radioUIViewController.view];
    self.radioUIViewController.view.frame = CGRectMake(0, 0,  self.radioUIView.frame.size.width,self.radioUIView.frame.size.height);
    
    [self addChildViewController:self.radioUIViewController];
    [self.radioUIViewController didMoveToParentViewController:self];
    
    self.radioUIView.backgroundColor = UIColorFromRGB(AppColorDarkGray);
    self.radioStationTableView.sectionIndexColor = UIColorFromRGB(AppColorDarkGray);
    self.radioStationTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [self testInternetConnection];
    
    self.radioDataLoader = [[RadioStationDataLoader alloc] init];
    
}


#pragma mark - TABLE Methods
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionIndexTitles;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionIndexTitles count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *sectionIndexTitle = self.sectionIndexTitles[section];
    return [self.alphabetizedDictionary[sectionIndexTitle] count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionIndexTitles[section];
}


- (Radio *)objectAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sectionIndexTitle = self.sectionIndexTitles[indexPath.section];
    return self.alphabetizedDictionary[sectionIndexTitle][indexPath.row];
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]){
        view.tintColor = UIColorFromRGB(AppColorGreen);
        UILabel *textLabel = [(UITableViewHeaderFooterView *)view textLabel];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = UIColorFromRGB(AppColorGreen);
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:15.0];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    Radio *myRadio = [self objectAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        nameLabel.text = myRadio.stationName;
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        nameLabel.textColor = UIColorFromRGB(AppColorDarkGray);
        nameLabel.tag = 10;
        [cell.contentView addSubview: nameLabel];
        
        UILabel * descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 , 30, 300, 20)];
        descriptionLabel.text = myRadio.radioGenres;
        descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
        descriptionLabel.textColor = UIColorFromRGB(AppColorDarkGray);
        descriptionLabel.tag = 11;
        [cell.contentView addSubview: descriptionLabel];
    }
    else{
        for (UILabel* view in [cell.contentView subviews]){
            if (view.tag == 10){
                view.text = myRadio.stationName;
            }
            else if (view.tag == 11){
                view.text = myRadio.radioGenres;
            }
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Radio * myRadio = [self objectAtIndexPath:indexPath];
    [self.radioStreamPlayer playStream:myRadio];
}


#pragma mark - Load Data
- (void)loadRadioStationList{
    [self.radioDataLoader getRadioStationList:^(NSArray *data, NSDictionary *dictData){
        
        self.alphabetizedDictionary = [[NSDictionary alloc] initWithDictionary:dictData];
        self.sectionIndexTitles = [[NSArray alloc] initWithArray:data];
        
        [self.radioStationTableView reloadData];
    }];
}


#pragma mark - Reachability
- (void)testInternetConnection{
    self.internetReachable = [Reachability reachabilityWithHostname:@"www.google.com"];
    __weak typeof(self) weakSelf = self;
    self.internetReachable.reachableBlock = ^(Reachability*reach){
        __strong typeof(self) strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf loadRadioStationList];
        });
    };

    self.internetReachable.unreachableBlock = ^(Reachability*reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Internet Connection", nil)
                                                message:NSLocalizedString(@"Internet Connection is NOT working. Please try again later.", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        });
    };
    
    [self.internetReachable startNotifier];
}

@end
