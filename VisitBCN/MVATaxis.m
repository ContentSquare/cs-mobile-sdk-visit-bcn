//
//  MVATaxis.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVATaxis.h"

@implementation MVATaxis

NSString * const hailoAPI = @"";

# pragma mark - Hailo methods

-(void)openHailo
{
    NSString *urlString = @"hailoapp://confirm?pickupCoordinate=";
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%f,",self.orig.latitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%f",self.orig.longitude]];
    urlString = [urlString stringByAppendingString:@"&destinationCoordinate="];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%f,",self.dest.latitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%f",self.dest.longitude]];
    
    urlString = [urlString stringByAppendingString:@"&referrer="];
    
    urlString = [urlString stringByAppendingString:hailoAPI];
    NSURL* url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)loadHailoTime
{
    NSString *urlString = @"https://api.hailoapp.com/drivers/eta?api_token=";
    urlString = [urlString stringByAppendingString:[self urlencodeString:hailoAPI]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&latitude=%f",self.dest.latitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&longitude=%f",self.dest.longitude]];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestObj returningResponse:&responseCode error:&error];
    
    if(error){
        NSLog (@"HOLA");
    }
    else {
        NSError *e = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error: &e];
        
        if (!dict) {
            NSLog(@"Error parsing JSON: %@", e);
        }
        else {
            self.hailoTimes = dict;
        }
    }
}

/**
 *  Function that encodes an string to use it for the APIs
 *
 *  @param unencodedString The unencoded string
 *
 *  @return The encoded string
 *
 *  @since version 1.0
 */
-(NSString *)urlencodeString:(NSString *)unencodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)unencodedString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}

-(double)taxiFareWithDistance:(double)dist andDate:(NSDate *)date
{
    long day = [self dayOfWeek:date];
    double initTime = [self initTimeForDate:date];
    if (day >= 1 && day <= 5) {
        if (initTime >= 28800 && initTime <= 72000) {
            return (2.10 + (1.07 * (dist/1000.0)));
        }
        else {
            double est = (2.10 + (1.30 * (dist/1000.0)));
            return est;
        }
    }
    else {
        if (initTime >= 28800 && initTime <= 72000) {
            double est = (2.10 + (1.30 * (dist/1000.0)));
            return est;
        }
        else {
            return (2.30 + (1.40 * (dist/1000.0)));
        }
    }
}

/**
 *  Functiont that converts the initial time for this execution into an integer that represents the date in seconds
 *
 *  @param date The date of the trip
 *
 *  @return Integer with the date in seconds
 *
 *  @since version 1.0
 */
-(int)initTimeForDate:(NSDate *)date
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    int hour = (int)[components hour];
    int minute = (int)[components minute];
    int seconds = (int)[components second];
    int sec_rep = (hour * 3600) + (minute * 60) + seconds;
    return sec_rep;
}

/**
 *  Returns the day of the week for a given date
 *
 *  @param anyDate A NSDate object
 *
 *  @return The day of the week in European mode
 *
 *  @since version 1.0
 */
-(long)dayOfWeek:(NSDate *)anyDate
{
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setLocale:frLocale];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:anyDate];
    int weekday = (int)[comps weekday];
    int europeanWeekday = ((weekday + 5) % 7) + 1;
    return europeanWeekday;
}

/**
 *  Function that loads if the user has chosen a custom date for the execution
 *
 *  @return A bool with the answer to the query
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
 *  Function that loads the custom date chosen by the user
 *
 *  @return The date in an NSDate object
 *
 *  @since version 1.0
 */
-(NSDate *)loadCustomDate
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    if (![self customDate]) return [NSDate date];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSDate *date = [defaults objectForKey:@"VisitBCNCustomDate"];
    if (!date) return [NSDate date];;
    return date;
}

@end
