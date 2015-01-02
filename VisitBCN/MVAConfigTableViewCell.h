//
//  MVAConfigTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 26/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UITableViewCell and is used to create the algorithm and rain custom cells
 *
 *  @see MVAConfigurationTableViewController class
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"
#import "MVAConfigurationTableViewController.h"

@interface MVAConfigTableViewCell : UITableViewCell

/**
 *  The image of the cell
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *logo;

/**
 *  The label with the text of the cell
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *label;

/**
 *  The switch
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIView *cellSwitch;

/**
 *  An string used to customize the cell between the algorithm cell and the rain cell
 *
 *  @since version 1.0
 */
@property NSString *objectName;

/**
 *  The view controller that creates this cell
 *
 *  @since version 1.0
 */
@property MVAConfigurationTableViewController *papi;

/**
 *  Function that gets called to initialize the cell
 *
 *  @since version 1.0
 */
-(void)configSwitch;

@end
