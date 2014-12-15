//
//  MVAPunIntTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 * <#Description#>
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>

@interface MVAPunIntTableViewCell : UITableViewCell

/**
 * <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *fondo;

/**
 * <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *distance;

/**
 * <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *name;

/**
 * <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *street;

/**
 * <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *gps;

@end
