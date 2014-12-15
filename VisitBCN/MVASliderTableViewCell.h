//
//  MVASliderTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>

@interface MVASliderTableViewCell : UITableViewCell

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *slowLogo;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *fastLogo;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *speed;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *text;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;

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
-(void)initCell;

@end
