//
//  MVAPunIntTableViewCell.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPunIntTableViewCell.h"
#import "QuartzCore/CALayer.h"

@implementation MVAPunIntTableViewCell

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
- (void)awakeFromNib
{
    self.gps.layer.shadowColor = [UIColor blackColor].CGColor;
    self.gps.layer.shadowOffset = CGSizeMake(0, 1);
    self.gps.layer.shadowOpacity = 1;
    self.gps.layer.shadowRadius = 1.0;
    self.gps.clipsToBounds = NO;
}

@end
