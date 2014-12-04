//
//  MVAHoraTableViewCell.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 1/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVAHoraTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *cellSwitch;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
