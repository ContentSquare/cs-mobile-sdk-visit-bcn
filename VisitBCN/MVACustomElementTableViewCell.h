//
//  MVACustomElementTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 3/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>

@interface MVACustomElementTableViewCell : UITableViewCell

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIImageView *foto;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *nombre;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UILabel *coords;

@end
