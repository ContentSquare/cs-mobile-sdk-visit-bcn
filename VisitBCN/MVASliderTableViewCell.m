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
 *  <#Description#>
 *
 *  @since version 1.0
 */
- (void)awakeFromNib
{
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

/**
 *  <#Description#>
 *
 *  @param selected <#selected description#>
 *  @param animated <#animated description#>
 *
 *  @since version 1.0
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  <#Description#>
 *
 *  @param sender <#sender description#>
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
 *  <#Description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
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
 *  <#Description#>
 *
 *  @param speed <#speed description#>
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
