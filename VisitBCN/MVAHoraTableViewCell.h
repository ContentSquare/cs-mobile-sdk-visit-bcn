//
//  MVAHoraTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 1/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UITableViewCell and is used to create the custom date picker
 *
 *  @see MVAConfigurationTableViewController class
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>
#import "MVAConfigurationTableViewController.h"

@interface MVAHoraTableViewCell : UITableViewCell

/**
 *  The switch view
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIView *cellSwitch;

/**
 *  The label of the cell
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *label;

/**
 *  The date picker
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

/**
 *  The view controller that creates this cell
 *
 *  @since version 1.0
 */
@property MVAConfigurationTableViewController *papi;

@end
