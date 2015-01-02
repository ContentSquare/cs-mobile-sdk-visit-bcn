//
//  MVATime.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class represents a reference time for a stop inside a certain trip.
 *
 *  We can represent this class as a table:
 *
 *  |  TripID  | Arrival time | Departure time |  StopID  | Sequence |
 *  |:--------:|:------------:|:--------------:|:--------:|:--------:|
 *  | NSString |   NSString   |    NSString    | NSString | NSString |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVAStop.h"

@interface MVATime : NSObject

/**
 *  The identifier of the trip
 *
 *  @see MVATrip class
 *  @since version 1.0
 */
@property NSString *tripID;

/**
 *  The arrival time of this reference data
 *
 *  @since version 1.0
 */
@property NSString *arrivalTime;

/**
 *  The departure time of this reference data
 *
 *  @since version 1.0
 */
@property NSString *departureTime;

/**
 *  The identifier of the stop
 *
 *  @see MVAStop class
 *  @since version 1.0
 */
@property NSString *stopID;

/**
 *  The position of this stop in the sequence of stops that has the trip
 *
 *  @since version 1.0
 */
@property int sequence;

/**
 *  This function is used to insert a given data to the correct field
 *
 *  @param elem  The data to be inserted
 *  @param index The index of this data in the GTFS file
 *
 *  @since version 1.0
 */
-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index;

/**
 *  This function is used to insert a given data to the correct field
 *
 *  @param subways An array with the subway stops
 *  @param isFGC   A boolean that indicates if the data passed is for the FGC agency
 *  @param hash    A Hashtable used to store the data efficiently
 *  @param route   The route identifier
 *
 *  @since version 1.0
 */
-(void)insertInMetro:(NSMutableArray *)subways isFGC:(BOOL)isFGC andHash:(NSMutableDictionary *)hash andRoute:(NSString *)route;

@end