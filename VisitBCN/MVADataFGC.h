//
//  MVADataFGC.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSZipArchive.h"
#import "CHCSVParser.h"
#import "MVAStop.h"
#import "MVARoute.h"
#import "MVATrip.h"
#import "MVADate.h"
#import "MVATime.h"

/**
 *  This class englobes all the data of the FGC subway network.
 *
 *  We can represent this class as a table:
 *
 *  | Dates |  Services  | Stops | Stops hash | Routes | Routes hash | Trips | Trips hash |
 *  |:-----:|:----------:|:-----:|:----------:|:------:|:-----------:|:-----:|:----------:|
 *  | Array |   Array    | Array | Hash table | Array  | Hash table  | Array | Hash table |
 *
 *  @since version 1.0
 */

@interface MVADataFGC : NSObject

/**
 *  Array that contains al the dates of the FGC calendar
 *
 *  @see MVADate class
 *  @since version 1.0
 */
@property NSMutableArray *dates;

/**
 *  Array that contains the service of the FGC routes
 *
 *  @since version 1.0
 */
@property NSMutableArray *services;

/**
 *  Stops of the FGC subway network
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
 *  Routes of the FGC subway network
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
 *  Trips of the FGC subway network
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
 *  This function initiates the parsing of the FGC data
 *
 *  @since version 1.0
 */
-(void)parseDataBase;

@end