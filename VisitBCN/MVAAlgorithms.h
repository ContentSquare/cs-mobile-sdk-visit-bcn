//
//  MVAAlgorithms.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 22/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVADataTMB.h"
#import "MVADataFGC.h"
#import "MVADataBus.h"
#import "MVAPath.h"
#import "MVAGraph.h"
#import "MVAPriorityQueue.h"
#import "MVAPunIntViewController.h"

@interface MVAAlgorithms : NSObject

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSMutableArray *nodes;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSMutableArray *edgeList;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property int type;

/**
 *  <#Description#>
 *
 *  @see MVADataBus class
 *  @since version 1.0
 */
@property MVADataBus *dataBus;

/**
 *  <#Description#>
 *
 *  @see MVADataFGC class
 *  @since version 1.0
 */
@property MVADataFGC *dataFGC;

/**
 *  <#Description#>
 *
 *  @see MVADataTMB class
 *  @since version 1.0
 */
@property MVADataTMB *dataTMB;

/**
 *  <#Description#>
 *
 *  @see MVACalendar class
 *  @since version 1.0
 */
@property MVACalendar *cal;

/**
 *  <#Description#>
 *
 *  @see MVAPriorityQueue class
 *  @since version 1.0
 */
@property MVAPriorityQueue *openNodes;

/**
 *  <#Description#>
 *
 *  @see MVAPunIntViewController class
 *  @since version 1.0
 */
@property MVAPunIntViewController *viewController;

/**
 *  Dijkstra's algorithm
 *
 *  @param nodeA Origin node for the Dijkstra computation
 *  @param nodeB Destination node for the Dijkstra computation
 *  @param crds  Coordinates of the final destination
 *
 *  @return The MVAPath object for the given parameters and the current graph
 */
-(MVAPath *)dijkstraPathtoNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds;

/**
 *  A* algorithm
 *
 *  @param nodeA Origin node for the A* computation
 *  @param nodeB Destination node for the A* computation
 *  @param crds  Coordinates of the final destination
 *
 *  @return The MVAPath object for the given parameters and the current graph
 *
 *  @since version 1.0
 */
-(MVAPath *)astarPathtoNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds;

@end