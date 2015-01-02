//
//  MVAPunIntTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 * This class is a sbclass of UITableViewCell and is used to create the cells displayed in the list of the main window of the app
 *
 *  @see MVAPuntsIntsTableViewController class
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>

@interface MVAPunIntTableViewCell : UITableViewCell

/**
 * The background image
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *fondo;

/**
 * The display of the distance
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *distance;

/**
 * The display of the name
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *name;

/**
 * The display of the address
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *street;

/**
 * The display of the GPS arrow
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *gps;

@end
