//
//  MVATaxis.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVATaxis : NSObject

-(void)openHailo;
-(void)loadHailoTime;
-(void)loadUberTime;
-(void)loadUberProducts;
-(void)loadUberPrice;
-(void)openUber;

@property NSDictionary *hailoTimes;
@property NSDictionary *uberTimes;
@property NSDictionary *uberProducts;
@property NSDictionary *uberPrices;

@end
