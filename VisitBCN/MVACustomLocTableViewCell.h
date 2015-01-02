//
//  MVACustomLocTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 3/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UITableViewCell and is used to create the custom location cell
 *
 *  @see MVAConfigurationTableViewController class
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>

@interface MVACustomLocTableViewCell : UITableViewCell

/**
 *  The image of the cell
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *logo;

/**
 *  The name of the cell
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *label;

@end