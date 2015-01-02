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

/**
 *  Function that gets called to initialize the cell
 *
 *  @since version 1.0
 */
- (void)awakeFromNib
{
    // Initialization code
    self.created = NO;
}

/**
 *  Function that gets called to initialize the cell
 *
 *  @since version 1.0
 */
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

/**
 *  Function that gets called when the cell is selected
 *
 *  @param selected A bool that indicates if the cell has been selected
 *  @param animated A bool that indicates if the selection needs to be animated or not
 *
 *  @since version 1.0
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

/**
 *  Function that gets called when the user changes the value of the slider
 *
 *  @param sender The slider object
 *
 *  @since version 1.0
 */
- (IBAction)sliderChanged:(id)sender
{
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

/**
 *  This function loads the walking speed indicated by the user. (The default value is 5km/h)
 *
 *  @return The speed in m/s
 */
-(double)loadWalkingSpeed
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [defaults objectForKey:self.objectName];
    if(data == nil){
        if ([self.objectName isEqualToString:@"VisitBCNWalkingSpeed"]) {
            [defaults setDouble:(5000.0/3600) forKey:self.objectName];
            return 5000.0;
        }
        else {
            [defaults setDouble:2000.0 forKey:self.objectName];
            return 2000.0;
        }
    }
    else {
        if ([self.objectName isEqualToString:@"VisitBCNWalkingSpeed"]) return ([defaults doubleForKey:self.objectName] * 3600);
        return [defaults doubleForKey:self.objectName];
    }
}

/**
 *  Function that saves the selected speed by the user
 *
 *  @param speed The speed selected
 *
 *  @since version 1.0
 */
-(void)saveSpeed:(double)speed
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    if ([self.objectName isEqualToString:@"VisitBCNWalkingSpeed"]) [defaults setDouble:(speed/3600) forKey:self.objectName];
    else [defaults setDouble:speed forKey:self.objectName];
}

@end
