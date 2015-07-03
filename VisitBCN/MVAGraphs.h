//
//  MVAGraphs.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class contains the two graphs and all the propoerties needed for storing the result of their coputation.
 *
 *  We can represent this class as a table:
 *
 *  | Bus graph | Subway graph | Subway path |  Subway error  |  Bus path  | Bus error  |   View controller   |
 *  |:---------:|:------------:|:-----------:|:--------------:|:----------:|:----------:|:-------------------:|
 *  | MVAGraph  |   MVAGraph   |   MVAPath   |     String     |  MVAPath   |   String   |  UIVeiwController   |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVABusGraph.h"
#import "MVASubwayGraph.h"
#import "MVADataTMB.h"
#import <CoreLocation/CoreLocation.h>

@interface MVAGraphs : NSObject

/**
 *  The bus graph
 *
 *  @see MVABusGraph class
 *  @since version 1.0
 */
@property MVABusGraph *busGraph;

/**
 *  The subway graph
 *
 *  @see MVASubwayGraph class
 *  @since version 1.0
 */
@property MVASubwayGraph *subwayGraph;

/**
 *  The subway path that we obtain from the graph's computation
 *
 *  @see MVAPath class
 *  @since version 1.0
 */
@property MVAPath *subwayPath;

/**
 *  If an error occurs, this string will contain the description
 *
 *  @since version 1.0
 */
@property NSString *subwayError;

/**
 *  The bus path that we obtain from the graph's computation
 *
 *  @see MVAPath class
 *  @since version 1.0
 */
@property MVAPath *busPath;

/**
 *  If an error occurs, this string will contain the description
 *
 *  @since version 1.0
 */
@property NSString *busError;

/**
 *  The view controller that called this algorithm execution
 *
 *  @see MVAPunIntViewController class
 *  @since version 1.0
 */
@property MVAPunIntViewController *viewController;

/**
 *  Function that generates the grphs from the data bases
 *
 *  @param dataBus The bus network data base
 *  @param dataTMB The TMB subway network data base 
 *  @param dataFGC The FGC network data base
 *
 *  @since version 1.0
 */
-(void)generateGraphsWithBUSDB:(MVADataBus *)dataBus andTMBDB:(MVADataTMB *)dataTMB andFGCDB:(MVADataFGC *)dataFGC;

/**
 *  Function that computes both paths from the origin to the destination point
 *
 *  @param origin Origin coordinates
 *  @param punInt Destination point
 *
 *  @since version 1.0
 */
-(void)computePathsWithOrigin:(CLLocationCoordinate2D)origin andDestination:(MVAPunInt *)punInt;

/**
 *  Function that loads the bus graph
 *
 *  @since version 1.0
 */
-(void)load;

/**
 *  Function that saves the bus graph
 *
 *  @since version 1.0
 */
-(void)save;

@end