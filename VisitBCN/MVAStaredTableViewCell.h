//
//  MVAStaredTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 22/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UITableViewCell and is used to create the cell for the stared itineraries
 *
 *  @see MVAStaredTableViewController class
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>

@interface MVAStaredTableViewCell : UITableViewCell

/**
 *  The display of the date of the itinerary
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

/**
 *  The display of the hour of the itinerary
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

/**
 *  The display of the origin's picture
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *origFoto;

/**
 *  The display of the destination's picture
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *destFoto;

@end
