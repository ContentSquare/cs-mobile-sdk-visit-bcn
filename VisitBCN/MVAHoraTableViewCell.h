//
//  MVAHoraTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 1/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>
#import "MVAConfigurationTableViewController.h"

@interface MVAHoraTableViewCell : UITableViewCell

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIView *cellSwitch;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *label;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVAConfigurationTableViewController *papi;

@end
