//
//  MVANode.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class represents a MVANode inside the graph.
 *
 *  We can represent this class as a table:
 *
 *  | Stop | Distance | Score  | Path Nodes | Path Edges | Identificador | Open | Previous |  Type   |
 *  |:----:|:--------:|:------:|:----------:|:----------:|:-------------:|:----:|:--------:|:-------:|
 *  | Stop |  Number  | Number |   Array    |   Array    |    Integer    | BOOL |   Node   | Integer |
 *
 *  @see MVAGraph class
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVAStop.h"

@interface MVANode : NSObject

/**
 *  The stop that identifies this node
 *
 *  @see MVAStop class
 *  @since version 1.0
 */
@property MVAStop *stop;

/**
 *  This property is used in both algorithms and indicates the current value of the node
 *
 *  @since version 1.0
 */
@property NSNumber *distance;

/**
 *  This property is used for the A* algorithm and indicates the current prediction for this node
 *
 *  @since version 1.0
 */
@property NSNumber *score;

/**
 *  An array with the nodes that form the minimum path from the origin to this node
 *
 *  @since version 1.0
 */
@property NSMutableArray *pathNodes;

/**
 *  An array with the edges that form the minimum path from the origin to this node
 *
 *  @see MVAEdge class
 *  @since version 1.0
 */
@property NSMutableArray *pathEdges;

/**
 *  The identifier of the object
 *
 *  @since version 1.0
 */
@property int identificador;

/**
 *  This boolean indicates if the node has been opened previously
 *
 *  @since version 1.0
 */
@property BOOL open;

/**
 *  This MVANode obect points to the previos MVANode in the path. This property is used in the A* algorithm
 *
 *  @see MVAStop class
 *  @since version 1.0
 */
@property MVANode *previous;

/**
 *  This property is used to customize the treatment of this node for the two graphs. If type is 1 then is a subway node, if is 2 then is a bus node
 *
 *  @since version 1.0
 */
@property int type;

@end