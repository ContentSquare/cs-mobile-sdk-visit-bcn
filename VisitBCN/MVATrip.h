//
//  MVATrip.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class represents a trip that operates in a certain route in one of the two directions and with a certain type of service.
 *
 *  We can represent this class as a table:
 *
 *  | RouteID  | ServiceID |  TripID  | DirectionID | Trip Name | Direction | Sequence | Frequencies |
 *  |:--------:|:---------:|:--------:|:-----------:|:---------:|:---------:|:--------:|:-----------:|
 *  | NSString | NSString  | NSString |  NSString   | NSString  |  Boolean  |  Array   |    Array    |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>

@interface MVATrip : NSObject

/**
 *  The identifier of the route
 *  @see MVARoute class
 */
@property NSString *routeID;

/**
 *  The identifier of the service
 *  @see MVACalendar class
 *
 *  @since version 1.0
 */
@property NSString* serviceID;

/**
 *  The identifier of the trip
 *  @see MVATrip class
 *
 *  @since version 1.0
 */
@property NSString* tripID;

/**
 *  The identifier of the direction
 *
 *  @since version 1.0
 */
@property NSString* directionID;

/**
 *  The name of the trip
 *
 *  @since version 1.0
 */
@property NSString* tripName;

/**
 *  A boolean that indicates the direction of this trips
 *
 *  @since version 1.0
 */
@property BOOL direcUP;

/**
 *  The sequence of stops of this trip
 *
 *  @since version 1.0
 */
@property NSMutableArray *sequence;

/**
 *  The frequencies of this trip
 *  @see MVAFrequencies class
 *
 *  @since version 1.0
 */
@property NSMutableArray *freqs;

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

@end
