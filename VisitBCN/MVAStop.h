//
//  MVAStop.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 03/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVACustomModifications.h"

/**
 *  This class represents a stop.
 *
 *  We can represent this class as a table:
 *
 *  |  StopID  |  Code   |   Name   | Latitude | Longitude | Times | Routes |
 *  |:--------:|:-------:|:--------:|:--------:|:---------:|:-----:|:------:|
 *  | NSString | Integer | NSString |  Double  |  Double   | Array | Array  |
 *
 *  @since version 1.0
 */

@interface MVAStop : NSObject

/**
 *  The stop identifier
 *
 *  @since version 1.0
 */
@property NSString *stopID;

/**
 *  The stop code provided by the agency
 *
 *  @since version 1.0
 */
@property int code;

/**
 *  The stop's name
 *
 *  @since version 1.0
 */
@property NSString *name;

/**
 *  The latitude of the stop's coordinates
 *
 *  @since version 1.0
 */
@property double latitude;

/**
 *  The longitude of the stop's coordinates
 *
 *  @since version 1.0
 */
@property double longitude;

/**
 *  The example stop times
 *
 *  @since version 1.0
 */
@property NSMutableArray *times;

/**
 *  The routes that operate in this stop
 *
 *  @since version 1.0
 */
@property NSMutableArray *routes;

/**
 *  This function is used to insert a given data to the correct field
 *
 *  @param elem  The data to be inserted
 *  @param index The index of this data in the GTFS file
 *  @param isFGC A boolean that indicates if the data is for the FGC agency
 *
 *  @since version 1.0
 */
-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index isFGC:(BOOL)isFGC;
-(void)insertInBus:(NSMutableArray *)busStops metro:(NSMutableArray *)subwayStops isFGC:(BOOL)isFGC;
-(BOOL)isEqualToStop:(MVAStop *)stop;

@end