//
//  MVAPath.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class represents the path calculated by Dijkstra or A* algorithms
 *
 *  We can represent this class as a table:
 *
 *  | Nodes | Edges | Weight |
 *  |:-----:|:-----:|:------:|
 *  | Array | Array | Double |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVANode.h"
#import "MVAEdge.h"

@interface MVAPath : NSObject

/**
 *  The nodes that create the path, including a final node representing the point of interest
 *
 *  @see MVANode class
 *  @since version 1.0
 */
@property NSMutableArray *nodes;

/**
 *  The edges that create the path
 *
 *  @see MVAEdge class
 *  @since version 1.0
 */
@property NSMutableArray *edges;

/**
 *  The weight that's returned as a result of the execution
 *
 *  @since version 1.0
 */
@property double totalWeight;

@end