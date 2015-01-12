//
//  MVAAlgorithms.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 22/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class contains the both algorithms (Dijkstra and A*)
 *
 *  We can represent this class as a table:
 *
 *  | Nodes | EdgeList | Type |  Bus data  |  FGC data  |  TMB data  |  Calendar   |   Open Nodes   | View Controller  |
 *  |:-----:|:--------:|:----:|:----------:|:----------:|:----------:|:-----------:|:--------------:|:----------------:|
 *  | Array |  Array   | Int  | MVADataBus | MVADataFGC | MVADataTMB | MVACalendar | Priority Queue | UIViewController |
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
 *  An array containin all the nodes of the graph that will be explored
 *
 *  @since version 1.0
 */
@property NSMutableArray *nodes;

/**
 *  An array with all the edges of the graph that will be explored
 *
 *  @since version 1.0
 */
@property NSMutableArray *edgeList;

/**
 *  The type of graph that will be explored (subway or bus).
 *
 *  @since version 1.0
 */
@property int type;

/**
 *  The bus network data base
 *
 *  @see MVADataBus class
 *  @since version 1.0
 */
@property MVADataBus *dataBus;

/**
 *  The FGC network data base
 *
 *  @see MVADataFGC class
 *  @since version 1.0
 */
@property MVADataFGC *dataFGC;

/**
 *  The TMB subway network data base
 *
 *  @see MVADataTMB class
 *  @since version 1.0
 */
@property MVADataTMB *dataTMB;

/**
 *  The current calendar for the execution
 *
 *  @see MVACalendar class
 *  @since version 1.0
 */
@property MVACalendar *cal;

/**
 *  A priority queue that will be used to explore the graph
 *
 *  @see MVAPriorityQueue class
 *  @since version 1.0
 */
@property MVAPriorityQueue *openNodes;

/**
 *  The view controller that called this algorithm execution
 *
 *  @see MVAPunIntViewController class
 *  @since version 1.0
 */
@property MVAPunIntViewController *viewController;

/**
 *  Dijkstra's algorithm.
 *
 *  @param nodeB Destination node for the Dijkstra computation
 *  @param crds  Coordinates of the final destination
 *
 *  @return The MVAPath object for the given parameters and the current graph
 */
-(MVAPath *)dijkstraPathtoNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds;

/**
 *  A* algorithm.
 *
 *  @param nodeB Destination node for the A* computation
 *  @param crds  Coordinates of the final destination
 *
 *  @return The MVAPath object for the given parameters and the current graph
 *
 *  @since version 1.0
 */
-(MVAPath *)astarPathtoNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds;

@end