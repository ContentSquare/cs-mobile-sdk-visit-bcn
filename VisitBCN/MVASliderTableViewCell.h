//
//  MVASliderTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UITableViewCell and is used to create the cell
 *
 *  @see MVAConfigurationTableViewController class
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>

@interface MVASliderTableViewCell : UITableViewCell

/**
 *  The image for the slow speed limit
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *slowLogo;

/**
 *  The image for the fast speed limit
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *fastLogo;

/**
 *  The label that's used as a display of the selected speed
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *speed;

/**
 *  The label for the cell's text
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *text;

/**
 *  The slider used to select the speed
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;

/**
 *  An string used to customize the cell between the speed cell and the distance cell
 *
 *  @since version 1.0
 */
@property NSString *objectName;

/**
 *  Funcation that gets called to initialize the cell
 *
 *  @since version 1.0
 */
-(void)initCell;

@end
