//
//  MVAEdge.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class represents an edge of the graph.
 *
 *  We can represent this class as a table:
 *
 *  | Destini | Weight | TripID | Change |
 *  |:-------:|:------:|:------:|:------:|
 *  |  Node   | Number | String |  BOOL  |
 *
 *  @see MVAGraph class
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVANode.h"

@interface MVAEdge : NSObject

/**
 *  The destination node of the edge
 *
 *  @see MVANode class
 *  @since version 1.0
 */
@property MVANode *destini;

/**
 *  The weight of the edge
 *
 *  @since version 1.0
 */
@property NSNumber *weight;

/**
 *  The identifier of the trip
 *
 *  @see MVATrip class
 *  @since version 1.0
 */
@property NSString *tripID;

/**
 *  This boolean indicates if this edge is used for changing between stops
 *
 *  @since version 1.0
 */
@property BOOL change;

@end