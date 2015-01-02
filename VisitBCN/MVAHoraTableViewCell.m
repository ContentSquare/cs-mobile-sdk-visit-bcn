//
//  MVAHoraTableViewCell.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 1/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAHoraTableViewCell.h"
#import "SevenSwitch.h"

@interface MVAHoraTableViewCell()

@property SevenSwitch *mySwitch;

@end

@implementation MVAHoraTableViewCell

/**
 *  Function that gets called to initialize the cell
 *
 *  @since version 1.0
 */
- (void)awakeFromNib
{
    [self.datePicker setMinimumDate:[NSDate date]];
    NSDate *customDate = [self loadCustomDate];
    NSComparisonResult result = [[NSDate date] compare:customDate];
    self.label.text = @"Calculate trips for custom time";
    BOOL custom = [self customDate];
    if (result == NSOrderedDescending) [self.datePicker setMinimumDate:customDate];
    if (self.mySwitch == nil) {
        self.mySwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(0, 0, self.cellSwitch.frame.size.width, self.cellSwitch.frame.size.height)];
        [self.mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.mySwitch.offImage = [UIImage imageNamed:@"cross"];
        self.mySwitch.onImage = [UIImage imageNamed:@"check"];
        
        self.mySwitch.onTintColor = self.cellSwitch.backgroundColor;
        [self.mySwitch setBackgroundColor:[UIColor clearColor]];
        self.mySwitch.isRounded = NO;
        
        self.mySwitch.borderColor = [UIColor lightGrayColor];
        
        [self.cellSwitch addSubview:self.mySwitch];
        [self.mySwitch setOn:custom animated:YES];
        [self.cellSwitch setBackgroundColor:[UIColor clearColor]];
        
        [self.datePicker setDate:customDate animated:NO];
        [self.datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    }
    if (custom) [self.mySwitch setThumbTintColor:[UIColor whiteColor]];
    else [self.mySwitch setThumbTintColor:[UIColor lightGrayColor]];
    [self.datePicker setUserInteractionEnabled:custom];
    [self.datePicker setHidden:!custom];
    [self initTime];
}

/**
 *  Function that gets called when the user changes the custom time selected
 *
 *  @param sender The date picker
 *
 *  @since version 1.0
 */
- (IBAction)timeChanged:(id)sender
{
    NSDate *pickerDate = [(UIDatePicker *)sender date];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    [defaults setObject:pickerDate forKey:@"VisitBCNCustomDate"];
}

/**
 *  Function that gets called when the user changes the switch value
 *
 *  @param sender The SevenSwitch object
 *
 *  @since version 1.0
 */
- (void)switchChanged:(SevenSwitch *)sender
{
    BOOL state = sender.on;
    if (state) {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
        [defaults setObject:@"YES" forKey:@"VisitBCNCustomDateEnabled"];
        NSDate *pickerDate = [self.datePicker date];
        [defaults setObject:pickerDate forKey:@"VisitBCNCustomDate"];
    }
    else {
        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
        [defaults setObject:@"NO" forKey:@"VisitBCNCustomDateEnabled"];
    }
    [self.datePicker setUserInteractionEnabled:state];
    [self.datePicker setHidden:!state];
    [self.papi.tableView beginUpdates];
    [self.papi.tableView endUpdates];
}

/**
 *  This function calculates the initial time for this graph execution
 *
 *  @return The time in seconds
 *
 *  @since version 1.0
 */
-(double)initTime
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self loadCustomDate]];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger seconds = [components second];
    double sec_rep = (hour * 3600) + (minute * 60) + seconds;
    return sec_rep;
}

/**
 *  This function loads if the user has selected a custom date
 *
 *  @return A boolean
 *
 *  @since version 1.0
 */
-(BOOL)customDate
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [defaults objectForKey:@"VisitBCNCustomDateEnabled"];
    if (data == nil) {
        [defaults setObject:@"NO" forKey:@"VisitBCNCustomDateEnabled"];
        return NO;
    }
    NSString *string = [defaults objectForKey:@"VisitBCNCustomDateEnabled"];
    if ([string isEqualToString:@"NO"]) return NO;
    return YES;
}

/**
 *  This function loads either the custom date chosen by the user or the current date of the device
 *
 *  @return An NSDate object
 *
 *  @since version 1.0
 */
-(NSDate *)loadCustomDate
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSDate *date = [defaults objectForKey:@"VisitBCNCustomDate"];
    if (!date) return [NSDate date];
    return date;
}

@end
