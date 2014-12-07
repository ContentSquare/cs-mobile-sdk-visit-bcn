//
//  MVATaxis.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MVATaxis : NSObject

-(void)openHailo;
-(void)loadHailoTime;

-(void)openUber;
-(void)loadUberTime;
-(void)loadUberProducts;
-(void)loadUberPrice;

-(double)taxiFareWithDistance:(double)dist andTime:(double)time;

@property NSDictionary *hailoTimes;
@property NSDictionary *uberTimes;
@property NSDictionary *uberProducts;
@property NSDictionary *uberPrices;

@property CLLocationCoordinate2D orig;
@property CLLocationCoordinate2D dest;

@property int type;

@end
