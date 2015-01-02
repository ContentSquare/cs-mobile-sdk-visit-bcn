//
//  MVABusSeq.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 13/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class represents a stop inside a route and it's position in the stop list.
 *
 *  We can represent this class as a table:
 *
 *  | RouteID  |  StopID  | Position |
 *  |:--------:|:--------:|:--------:|
 *  | NSString | NSString | NSString |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>

@interface MVABusSeq : NSObject

/**
 *  The identifier of the route
 *
 *  @see MVARoute class
 *  @since version 1.0
 */
@property NSString *routeID;

/**
 *  The identifier of the stop
 *
 *  @see MVAStop class
 *  @since version 1.0
 */
@property NSString *stopID;

/**
 *  The position in the trip of the current stop for the current route
 *
 *  @since version 1.0
 */
@property NSString *pos;

@end