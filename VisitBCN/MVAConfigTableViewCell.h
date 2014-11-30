//
//  MVAConfigTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 26/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"
#import "MVAConfigurationTableViewController.h"

@interface MVAConfigTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *cellSwitch;

@property NSString *objectName;
@property MVAConfigurationTableViewController *papi;

-(void)configSwitch;

@end
