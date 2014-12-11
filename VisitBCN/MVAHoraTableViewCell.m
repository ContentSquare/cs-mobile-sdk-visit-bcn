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

- (void)awakeFromNib {
    // Initialization code
    [self.datePicker setMinimumDate:[NSDate date]];
    NSComparisonResult result = [[NSDate date] compare:[self loadCustomDate]];
    self.label.text = @"Calculate trips for custom time";
    if (result == NSOrderedDescending) [self.datePicker setMinimumDate:[self loadCustomDate]];
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
        [self.mySwitch setOn:[self customDate] animated:YES];
        [self.cellSwitch setBackgroundColor:[UIColor clearColor]];
        
        [self.datePicker setDate:[self loadCustomDate] animated:NO];
        [self.datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    }
    if ([self customDate]) [self.mySwitch setThumbTintColor:[UIColor whiteColor]];
    else [self.mySwitch setThumbTintColor:[UIColor lightGrayColor]];
    [self.datePicker setUserInteractionEnabled:[self customDate]];
    [self.datePicker setHidden:![self customDate]];
    [self initTime];
}

- (IBAction)timeChanged:(id)sender {
    NSDate *pickerDate = [(UIDatePicker *)sender date];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    [defaults setObject:pickerDate forKey:@"VisitBCNCustomDate"];
}

- (void)switchChanged:(SevenSwitch *)sender {
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

-(NSDate *)loadCustomDate
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSDate *date = [defaults objectForKey:@"VisitBCNCustomDate"];
    if (!date) return [NSDate date];
    return date;
}

@end
