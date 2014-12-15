//
//  MVAConfigTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 26/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"
#import "MVAConfigurationTableViewController.h"

@interface MVAConfigTableViewCell : UITableViewCell

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *logo;

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
@property (weak, nonatomic) IBOutlet UIView *cellSwitch;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSString *objectName;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVAConfigurationTableViewController *papi;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
-(void)configSwitch;

@end
