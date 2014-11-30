//
//  MVASliderTableViewCell.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVASliderTableViewCell.h"

@interface MVASliderTableViewCell()

@property BOOL created;

@end

@implementation MVASliderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.created = NO;
}

-(void)initCell
{
    double speed = [self loadWalkingSpeed];
    if (!self.created) [self.speedSlider setValue:speed animated:YES];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:3];
    [formatter setMaximumFractionDigits:3];
    [formatter setMinimumIntegerDigits:1];
    [formatter setMaximumIntegerDigits:1];
    [formatter setPaddingCharacter:@"0"];
    [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
    self.speed.text = [formatter stringFromNumber:[NSNumber numberWithDouble:(speed/1000)]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sliderChanged:(id)sender {
    double speed = self.speedSlider.value;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:3];
    [formatter setMaximumFractionDigits:3];
    [formatter setMinimumIntegerDigits:1];
    [formatter setMaximumIntegerDigits:1];
    [formatter setPaddingCharacter:@"0"];
    [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
    self.speed.text = [formatter stringFromNumber:[NSNumber numberWithDouble:(speed/1000)]];
    [self saveSpeed:speed];
    self.created = YES;
}

-(double)loadWalkingSpeed
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSData *data = [defaults objectForKey:self.objectName];
    if(data == nil){
        if ([self.objectName isEqualToString:@"VisitBCNWalkingSpeed"]) {
            [defaults setDouble:5000.0 forKey:self.objectName];
            return 5000.0;
        }
        else {
            [defaults setDouble:1000.0 forKey:self.objectName];
            return 1000.0;
        }
    }
    else {
        return [defaults doubleForKey:self.objectName];
    }
}


-(void)saveSpeed:(double)speed
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    [defaults setDouble:speed forKey:self.objectName];
}

@end
