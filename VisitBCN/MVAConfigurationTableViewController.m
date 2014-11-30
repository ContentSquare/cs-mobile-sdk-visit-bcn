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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section <= 1) return 55.0;
    return 95.0;
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
    } else if (indexPath.section == 1) {
        MVAConfigTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switchCell" forIndexPath:indexPath];
        switchCell.papi = self;
        switchCell.objectName = @"VisitBCNRain";
        switchCell.logo.image = [UIImage imageNamed:@"rain-blue"];
        [switchCell.cellSwitch setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
        [switchCell configSwitch];
        return switchCell;
    }
    else if (indexPath.section == 2) {
        MVASliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:@"sliderCell" forIndexPath:indexPath];
        [sliderCell.speedSlider setMaximumValue:9000];
        [sliderCell.speedSlider setMinimumValue:1000];
        [sliderCell.text setText:@"Walking speed (Km/h)"];
        sliderCell.objectName = @"VisitBCNWalkingSpeed";
        sliderCell.slowLogo.image = [UIImage imageNamed:@"walker-red"];
        sliderCell.fastLogo.image = [UIImage imageNamed:@"running-green"];
        [sliderCell.speedSlider setMinimumTrackTintColor:[UIColor redColor]];
        [sliderCell initCell];
        return sliderCell;
    }
    else {
        MVASliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:@"sliderCell" forIndexPath:indexPath];
        [sliderCell.speedSlider setMaximumValue:2500];
        [sliderCell.speedSlider setMinimumValue:500];
        [sliderCell.text setText:@"Walking distance (Km)"];
        sliderCell.objectName = @"VisitBCNWalkingDist";
        sliderCell.slowLogo.image = [UIImage imageNamed:@"car-black"];
        sliderCell.fastLogo.image = [UIImage imageNamed:@"trainer-yellow"];
        [sliderCell.speedSlider setMinimumTrackTintColor:[UIColor greenColor]];
        [sliderCell initCell];
        return sliderCell;
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
