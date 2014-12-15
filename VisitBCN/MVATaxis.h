//
//  MVATaxis.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MVATaxis : NSObject

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSDictionary *hailoTimes;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSDictionary *uberTimes;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSDictionary *uberProducts;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSDictionary *uberPrices;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D orig;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D dest;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property int type;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
-(void)openHailo;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
-(void)loadHailoTime;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
-(void)openUber;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
-(void)loadUberTime;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
-(void)loadUberProducts;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
-(void)loadUberPrice;

/**
 *  <#Description#>
 *
 *  @param dist <#dist description#>
 *  @param time <#time description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
-(double)taxiFareWithDistance:(double)dist andTime:(double)time;

@end
