//
//  MVATaxis.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVATaxis.h"

@implementation MVATaxis

NSString * const hailoAPI = @"26lsOoj9SzZQo4+RPBqb2UGX+ImifoDA9T78Y50hu8Kgn1ppWHbq1x9yAv84TFEJtQlpsPsQdqbYxow969HlNJJlMmYfhQxHErgB/Yl4CcUo+QoX3yYvKGB9tuK84x1WKC1bulbR3vG7COCnskty4iAJZmOFSdP6o7ztWcPcZAyAsLN8ssOfIFZarZOSbQJuiX5SLwFDIRrf230snbM3+w==";

NSString * const uberAPI = @"rrAyHsIkVixZmeRG79WWnxupFtWRVaRKE_Gbdapz";

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

- (NSString *)urlencodeString:(NSString *)unencodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (CFStringRef)unencodedString,
                                                                                                    NULL,
                                                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                    kCFStringEncodingUTF8 ));
    return encodedString;
}

# pragma mark - Uber methods

-(void)loadUberTime
{
    NSString *urlString = @"https://api.uber.com/v1/estimates/time?server_token=";
    urlString = [urlString stringByAppendingString:uberAPI];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&start_latitude=%f",self.orig.latitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&start_longitude=%f",self.orig.longitude]];
    
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
            self.uberTimes = dict;
        }
    }
}

-(void)loadUberProducts
{
    NSString *urlString = @"https://api.uber.com/v1/products?server_token=";
    urlString = [urlString stringByAppendingString:uberAPI];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&latitude=%f",self.orig.latitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&longitude=%f",self.orig.longitude]];
    
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
            self.uberProducts = dict;
        }
    }
}

-(void)loadUberPrice
{
    NSString *urlString = @"https://api.uber.com/v1/estimates/price?server_token=";
    urlString = [urlString stringByAppendingString:uberAPI];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&start_latitude=%f",self.orig.latitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&start_longitude=%f",self.orig.longitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&end_latitude=%f",self.dest.latitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&end_longitude=%f",self.dest.longitude]];
    
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
            self.uberPrices = dict;
        }
    }
}

-(void)openUber
{
    NSArray *prices = [self.uberPrices objectForKey:@"prices"];
    NSDictionary *estPrice = [prices firstObject];
    NSString *urlString = @"uber://?client_id=YOUR_CLIENT_ID";
    urlString = [urlString stringByAppendingString:uberAPI];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&action=setPickup&pickup[latitude]=%f",self.orig.latitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&pickup[longitude]=%f",self.orig.longitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&dropoff[latitude]=%f",self.dest.latitude]];
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&dropoff[longitude]=%f",self.dest.longitude]];
    urlString = [urlString stringByAppendingString:@"&product_id="];
    urlString = [urlString stringByAppendingString:[estPrice objectForKey:@"product_id"]];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(double)taxiFareWithDistance:(double)dist andTime:(double)time
{
    long day = [self dayOfWeek:[self loadCustomDate]];
    double initTime = [self initTime];
    if (day >= 1 && day <= 5) {
        if (initTime >= 28800 && initTime <= 72000) {
            return (2.10 + (1.03 * (dist/1000.0)));
        }
        else {
            double est = (2.10 + (1.03 * (dist/1000.0)));
            return fmax(est, 7);
        }
    }
    else {
        if (initTime >= 28800 && initTime <= 72000) {
            double est = (2.10 + (1.03 * (dist/1000.0)));
            return fmax(est, 7);
        }
        else {
            return (2.30 + (1.40 * (dist/1000.0)));
        }
    }
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

-(NSDate *)loadCustomDate
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    if (![self customDate]) return [NSDate date];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSDate *date = [defaults objectForKey:@"VisitBCNCustomDate"];
    if (!date) return [NSDate date];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    date = [NSDate dateWithTimeInterval:seconds sinceDate: date];
    return date;
}

@end
