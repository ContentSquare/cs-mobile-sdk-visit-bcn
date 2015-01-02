//
//  MVAFrequencies.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 13/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class represents a time frequency for a given trip.
 *
 *  We can represent this class as a table:
 *
 *  |  TripID  | Start time | End time | Headway  |
 *  |:--------:|:----------:|:--------:|:--------:|
 *  | NSString |  NSString  | NSString | NSString |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>

@interface MVAFrequencies : NSObject

/**
 *  The identifier of the trip
 *
 *  @see MVATrip class
 *  @since version 1.0
 */
@property NSString *tripID;

/**
 *  The starting time of this frequency
 *
 *  @since version 1.0
 */
@property NSString *startTime;

/**
 *  The ending time of this frequency
 *
 *  @since version 1.0
 */
@property NSString *endTime;

/**
 *  The headway time of the trains for this frequency
 *
 *  @since version 1.0
 */
@property NSString *headway;

/**
 *  This function is used to insert a given data to the correct field
 *
 *  @param elem  The data to be inserted
 *  @param index The index of this data in the GTFS file
 *
 *  @since version 1.0
 */
-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index;

@end