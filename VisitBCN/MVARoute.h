//
//  MVARoute.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class represents a route.
 *
 *  We can represent this class as a table:
 *
 *  | RouteID  | AgencyID | Short name | Long name |  Type   |  URL  |  Color  | Text Color | Trips |
 *  |:--------:|:--------:|:----------:|:---------:|:-------:|:-----:|:-------:|:----------:|:-----:|
 *  | NSString | Integer  |  NSString  | NSString  | Integer | NSURL | UIColor |  UIColor   | Array |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>

@interface MVARoute : NSObject

/**
 *  The identifier of the route.
 *
 *  @since version 1.0
 */
@property NSString* routeID;

/**
 *  The identifier of the agency
 *
 *  @since version 1.0
 */
@property int agencyID;

/**
 *  The short name of the route
 *
 *  @since version 1.0
 */
@property NSString* shortName;

/**
 *  The full name of the route
 *
 *  @since version 1.0
 */
@property NSString* longName;

/**
 *  The route type
 *
 *  @since version 1.0
 */
@property int type;

/**
 *  The URL with the information of the route
 *
 *  @since version 1.0
 */
@property NSURL* url;

/**
 *  The route's color
 *
 *  @since version 1.0
 */
@property UIColor* color;

/**
 *  The route's text color
 *
 *  @since version 1.0
 */
@property UIColor* textColor;

/**
 *  The trips that operate in this route
 *
 *  @see MVATrip class
 *  @since version 1.0
 */
@property NSMutableArray *trips;

/**
 *  This function is used to insert a given data to the correct field
 *
 *  @param elem  The data to insert
 *  @param index The index of the data in the GTFS file
 *  @param isFGC Boolean variable that indicates the source of the data
 *
 *  @since version 1.0
 */
-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index isFGC:(BOOL)isFGC;

@end