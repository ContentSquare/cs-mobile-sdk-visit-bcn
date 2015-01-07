//
//  MVADataBus.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCSVParser.h"
#import "MVABusSeq.h"
#import "MVAStop.h"
#import "MVARoute.h"
#import "MVAFrequencies.h"

/**
 *  This class englobes all the data of the bus network.
 *
 *  We can represent this class as a table:
 *
 *  | Bus stops |  Bus hash  | Bus routes | Bus routes hash | Trips ida | Trips ida hash | Trips vuelta | Trips vuelta hash | Frequencies |
 *  |:---------:|:----------:|:----------:|:---------------:|:---------:|:--------------:|:------------:|:-----------------:|:-----------:|
 *  |   Array   | Hash table |   Array    |   Hash table    |   Array   |   Hash table   |    Array     |    Hash table     |    Array    |
 *
 *  @since version 1.0
 */

@interface MVADataBus : NSObject

/**
 *  The stops of the bus network
 *
 *  @see MVAStop class
 *  @since version 1.0
 */
@property NSMutableArray *busStops;

/**
 *  This hash table is used to index the stopIDs and make more efficient the algorithm executions
 *
 *  @since version 1.0
 */
@property NSMutableDictionary *busHash;

/**
 *  The routes that operate in the bus network
 *
 *  @see MVARoute class
 *  @since version 1.0
 */
@property NSMutableArray *busRoutes;

/**
 *  This hash table is used to index the routeIDs and make more efficient the algorithm executions
 *
 *  @since version 1.0
 */
@property NSMutableDictionary *busRoutesHash;

/**
 *  The trips in the 'forward' direction
 *
 *  @see MVATrip class
 *  @since version 1.0
 */
@property NSMutableArray *tripsIda;

/**
 *  This hash table is used to index the 'tripsIda' and make more efficient the algorithm executions
 *
 *  @since version 1.0
 */
@property NSMutableDictionary *tripsHashIda;

/**
 *  The trips in the'backward' direction
 *
 *  @see MVATrip class
 *  @since version 1.0
 */
@property NSMutableArray *tripsVuelta;

/**
 *  This hash table is used to index the 'tripsVuelta' and make more efficient the algorithm executions
 *
 *  @since version 1.0
 */
@property NSMutableDictionary *tripsHashVuelta;

/**
 *  The frequencies of all the bus routes and directions
 *
 *  @see MVAFrequencies class
 *  @since version 1.0
 */
@property NSMutableArray *frequencies;

/**
 *  This function initiates the parsing of the bus data
 *
 *  @since version 1.0
 */
- (void)parseDataBase;

/**
 *  This function is used as a query to retrieve the frequency for a given stop, time and calendar. Cost: O(F), where F is the number of frequencies.
 *
 *  @param stop        The bus stop that performs the query
 *  @param currentTime The time for which the query is performed
 *  @param serviceID   The identifier of the service that operates in that stop at that moment
 *
 *  @return The frequency in seconds (double)
 *
 *  @since version 1.0
 */
-(double)frequencieForStop:(MVAStop *)stop andTime:(double)currentTime andCalendar:(NSString *)serviceID;

@end