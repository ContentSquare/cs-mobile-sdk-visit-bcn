//
//  MVADataBase.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class englobes all the data of the FGC subway network.
 *
 *  We can represent this class as a table:
 *
 *  | Stops | Stops hash | Routes | Routes hash | Trips | Trips hash | Frequencies | Calendars | Dates |
 *  |:-----:|:----------:|:------:|:-----------:|:-----:|:----------:|:-----------:|:---------:|:-----:|
 *  | Array | Hash table | Array  | Hash table  | Array | Hash table |    Array    |   Array   | Array |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "SSZipArchive.h"
#import "CHCSVParser.h"
#import "MVAStop.h"
#import "MVARoute.h"
#import "MVATrip.h"
#import "MVADate.h"
#import "MVATime.h"
#import "MVACalendar.h"
#import "MVAFrequencies.h"

@interface MVADataTMB : NSObject

/**
 *  Stops of the TMB subway network
 *
 *  @see MVAStop class
 *  @since version 1.0
 */
@property NSMutableArray *stops;

/**
 *  This hash table is used to index the stopIDs and make more efficient the algorithm executions
 *
 *  @since version 1.0
 */
@property NSMutableDictionary *stopsHash;

/**
 *  Routes of the TMB subway network
 *
 *  @see MVARoute class
 *  @since version 1.0
 */
@property NSMutableArray *routes;

/**
 *  This hash table is used to index the routeIDs and make more efficient the algorithm executions
 *
 *  @since version 1.0
 */
@property NSMutableDictionary *routesHash;

/**
 *  Trips of the TMB subway network
 *
 *  @see MVATrip class
 *  @since version 1.0
 */
@property NSMutableArray *trips;

/**
 *  This hash table is used to index the tripIDs and make more efficient the algorithm executions
 *
 *  @since version 1.0
 */
@property NSMutableDictionary *tripsHash;

/**
 *  Frequencies of the trains that circulate in the TMB subway network
 *
 *  @see MVAFrequencies class
 *  @since version 1.0
 */
@property NSMutableArray *freqs;

/**
 *  Calendars of the TMB subway network
 *
 *  @see MVACalendar class
 *  @since version 1.0
 */
@property NSMutableArray *calendars;

/**
 *  Calendar dates that indicate the exceptions
 *
 *  @see MVADate class
 *  @since version 1.0
 */
@property NSMutableArray *dates;

/**
 *  This function returns the calendar object for the calendar used in the algorithm calculations
 *
 *  @param subway A boolean that indicates if the desired calendar is for the subway or the bus service.
 *
 *  @return The MVACalendar object with the desired calendar data
 *
 *  @see MVACalendar class
 *  @since version 1.0
 */
-(MVACalendar *)getNextCalendarforSubway:(BOOL)subway;

/**
 *  This function returns the calendar object for the calendar, plus 1 day, used in the algorithm calculations
 *
 *  @param subway A boolean that indicates if the desired calendar is for the subway or the bus service.
 *
 *  @return The MVACalendar object with the desired calendar data
 *
 *  @see MVACalendar class
 *  @since version 1.0
 */
-(MVACalendar *)getCurrentCalendarforSubway:(BOOL)subway;

/**
 *  This function initiates the parsing of the TMB subway data
 *
 *  @since version 1.0
 */
-(void)parseDataBase;

@end