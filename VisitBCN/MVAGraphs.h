//
//  MVAGraphs.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
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
 *  <#Description#>
 *
 *  @see MVABusGraph class
 *  @since version 1.0
 */
@property MVABusGraph *busGraph;

/**
 *  <#Description#>
 *
 *  @see MVASubwayGraph class
 *  @since version 1.0
 */
@property MVASubwayGraph *subwayGraph;

/**
 *  <#Description#>
 *
 *  @see MVAPath class
 *  @since version 1.0
 */
@property MVAPath *subwayPath;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSString *subwayError;

/**
 *  <#Description#>
 *
 *  @see MVAPath class
 *  @since version 1.0
 */
@property MVAPath *busPath;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSString *busError;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVAPunIntViewController *viewController;

/**
 *  <#Description#>
 *
 *  @param dataBus <#dataBus description#>
 *  @param dataTMB <#dataTMB description#>
 *  @param dataFGC <#dataFGC description#>
 */
-(void)generateGraphsWithBUSDB:(MVADataBus *)dataBus andTMBDB:(MVADataTMB *)dataTMB andFGCDB:(MVADataFGC *)dataFGC;

/**
 *  <#Description#>
 *
 *  @param origin <#origin description#>
 *  @param punInt <#punInt description#>
 */
-(void)computePathsWithOrigin:(CLLocationCoordinate2D)origin andDestination:(MVAPunInt *)punInt;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
-(void)load;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
-(void)save;

@end