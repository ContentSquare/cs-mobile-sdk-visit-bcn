//
//  MVAConfigurationTableViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 26/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAConfigurationTableViewController.h"
#import "MVAConfigTableViewCell.h"
#import "MVASliderTableViewCell.h"
#import "MVAHoraTableViewCell.h"
#import "MVACustomLocTableViewCell.h"

@interface MVAConfigurationTableViewController ()

@end

@implementation MVAConfigurationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) return @"Changing the algorithm doesn't have any effect on the results and is used just as a case of study.";
    if (section == 1) return @"This will reduce the walking and driving speed.";
    if (section == 2) return @"Choose between Uber or Hailo and get relevant information when asking for an itinerary with an internet connection.";
    if (section == 3) return @"Changing this value, will influence in the travelling and arrival time.";
    if (section == 4) return @"This will fix the maximum distance desired from the actual point to the nearest stops and from the arrival stops to the desired destination.";
    if (section == 5) return @"Select if you want a custom origin location or to find the way back home.";
    if (section == 6) return @"This option permits to select a future date for calculating the itineraries.";
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat w = self.view.frame.size.width;
    NSString *text = [self tableView:tableView titleForFooterInSection:section];
    return ([self heightForView:[UIFont systemFontOfSize:10.0f] text:text andSize:(w - 16)] + 20);
}

-(CGFloat)heightForView:(UIFont *)font text:(NSString *)text andSize:(CGFloat)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = font;
    label.text = text;
    [label sizeToFit];
    return label.frame.size.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat w = self.view.frame.size.width;
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(8, 5, (w - 16), ([self tableView:tableView heightForFooterInSection:section] - 20));
    myLabel.numberOfLines = 0;
    [myLabel setFont:[UIFont systemFontOfSize:10.0f]];
    myLabel.text = [self tableView:tableView titleForFooterInSection:section];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section <= 2 || indexPath.section == 5) return 55.0;
    if (indexPath.section <= 4) return 95.0;
    return 225.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MVAConfigTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switchCell" forIndexPath:indexPath];
        switchCell.papi = self;
        switchCell.objectName = @"VisitBCNAlgorithm";
        switchCell.logo.image = [UIImage imageNamed:@"code-purple"];
        [switchCell.cellSwitch setBackgroundColor:[UIColor purpleColor]];
        [switchCell configSwitch];
        return switchCell;
    }
    else if (indexPath.section == 1) {
        MVAConfigTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switchCell" forIndexPath:indexPath];
        switchCell.papi = self;
        switchCell.objectName = @"VisitBCNRain";
        switchCell.logo.image = [UIImage imageNamed:@"rain-blue"];
        [switchCell.cellSwitch setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
        [switchCell configSwitch];
        return switchCell;
    }
    else if (indexPath.section == 2) {
        MVAConfigTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switchCell" forIndexPath:indexPath];
        switchCell.papi = self;
        switchCell.objectName = @"VisitBCNTaxi";
        switchCell.logo.image = [UIImage imageNamed:@"taxi-color"];
        [switchCell.cellSwitch setBackgroundColor:[UIColor colorWithRed:(16.0f/255.0f) green:(17.0f/255.0f) blue:(36.0f/255.0f) alpha:1.0f]];
        [switchCell configSwitch];
        return switchCell;
    }
    else if (indexPath.section == 3) {
        MVASliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:@"sliderCell" forIndexPath:indexPath];
        [sliderCell.speedSlider setMaximumValue:9000];
        [sliderCell.speedSlider setMinimumValue:1000];
        [sliderCell.text setText:@"Walking speed (Km/h)"];
        sliderCell.objectName = @"VisitBCNWalkingSpeed";
        sliderCell.slowLogo.image = [UIImage imageNamed:@"old-red"];
        sliderCell.fastLogo.image = [UIImage imageNamed:@"running-green"];
        [sliderCell.speedSlider setMinimumTrackTintColor:[UIColor redColor]];
        [sliderCell initCell];
        return sliderCell;
    }
    else if (indexPath.section == 4) {
        MVASliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:@"sliderCell" forIndexPath:indexPath];
        [sliderCell.speedSlider setMaximumValue:2500];
        [sliderCell.speedSlider setMinimumValue:500];
        [sliderCell.text setText:@"Walking distance (Km)"];
        sliderCell.objectName = @"VisitBCNWalkingDist";
        sliderCell.slowLogo.image = [UIImage imageNamed:@"car-black"];
        sliderCell.fastLogo.image = [UIImage imageNamed:@"trainer-yellow"];
        [sliderCell.speedSlider setMinimumTrackTintColor:[UIColor colorWithRed:(135.0f/255.0f) green:(193.0f/255.0f) blue:(87.0f/255.0f) alpha:1.0f]];
        [sliderCell initCell];
        return sliderCell;
    }
    else if (indexPath.section == 5) {
        MVACustomLocTableViewCell *customLocCell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        return customLocCell;
    }
    else {
        MVAHoraTableViewCell *horaCell = [tableView dequeueReusableCellWithIdentifier:@"horaCell" forIndexPath:indexPath];
        return horaCell;
    }
}

@end
