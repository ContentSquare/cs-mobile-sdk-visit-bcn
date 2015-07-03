//
//  MVACustomElementTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 3/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UITableViewCell and is used to create the cells for the custom locations created by the user
 *
 *  @see MVACustomLocationsTableViewController class
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>

@interface MVACustomElementTableViewCell : UITableViewCell

/**
 *  The image of the cell
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *foto;

/**
 *  The display of the name of the custom location
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *nombre;

/**
 *  The display of the coordinates of the custom location
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *coords;

@end
