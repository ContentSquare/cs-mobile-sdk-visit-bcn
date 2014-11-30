//
//  MVASliderTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVASliderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *slowLogo;
@property (weak, nonatomic) IBOutlet UIImageView *fastLogo;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;

@property NSString *objectName;

-(void)initCell;

@end
