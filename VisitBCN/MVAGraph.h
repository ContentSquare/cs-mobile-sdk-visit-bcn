//
//  MVAGraph.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is an abstract class representing a graph.
 *
 *  We can represent this class as a table:
 *
 *  | Nodes | Edge list | Type |  Bus data   |  FGC data  |  TMB data  |  Calendar   |   View controller   |
 *  |:-----:|:---------:|:----:|:-----------:|:----------:|:----------:|:-----------:|:-------------------:|
 *  | Array |   Array   | Int  | MVADataBus  | MVADataFGC | MVADataTMB | MVACalendar |  UIVeiwController   |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MVADataTMB.h"
#import "MVADataFGC.h"
#import "MVADataBus.h"
#import "MVAPath.h"
#import "MVAPunInt.h"
#import "MVAPunIntViewController.h"

@interface MVAGraph : NSObject

/**
 *  An array containing all the nodes of the graph
 *
 *  @since version 1.0
 */
@property NSMutableArray *nodes;

/**
 *  An array with all the edges of the graph. For each node, this array contains a list of edges.
 *
 *  @since version 1.0
 */
@property NSMutableArray *edgeList;

/**
 *  The type of graph
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
 *  The view controller that called this algorithm execution
 *
 *  @see MVAPunIntViewController class
 *  @since version 1.0
 */
@property MVAPunIntViewController *viewController;

/**
 *  Function that calls the algorithms for this graph
 *
 *  @param originNodes  The origin nodes that are inside the desired radius
 *  @param destiniNodes The destination nodes that are inside the desired radius
 *  @param identifier   The identifier of the algorithm (0 = Dijkstra, 1 = A*).
 *  @param oCoords      The origin coordinates
 *  @param punInt       The destination point
 *
 *  @return An MVAPath object with the computed path
 *
 *  @since version 1.0
 */
-(MVAPath *)computePathFromNodes:(NSArray *)originNodes toNode:(NSMutableDictionary *)destiniNodes withAlgorithmID:(int)identifier andOCoords:(CLLocationCoordinate2D)oCoords andDest:(MVAPunInt *)punInt;

/**
 *  Haversine distance between two coordinates
 *
 *  @param cordA The first coordinate
 *  @param cordB The second coordinate
 *
 *  @return The distance in meters
 *
 *  @see http://www.movable-type.co.uk/scripts/latlong.html
 *  @since version 1.0
 */
-(double)distanceForCoordinates:(CLLocationCoordinate2D)cordA andCoordinates:(CLLocationCoordinate2D)cordB;

@end