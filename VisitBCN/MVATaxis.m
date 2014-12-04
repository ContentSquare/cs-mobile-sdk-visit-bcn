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
    NSString *urlString = @"uber://?action=setPickup&pickup=my_location";
    NSURL* url = [NSURL URLWithString:urlString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
