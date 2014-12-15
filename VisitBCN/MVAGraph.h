//
//  MVAGraph.h
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
#import <CoreLocation/CoreLocation.h>
#import "MVADataTMB.h"
#import "MVADataFGC.h"
#import "MVADataBus.h"
#import "MVAPath.h"
#import "MVAPunInt.h"
#import "MVAPunIntViewController.h"

@interface MVAGraph : NSObject

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
 *  @since version 1.0
 */
@property MVADataBus *dataBus;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVADataFGC *dataFGC;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVADataTMB *dataTMB;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVACalendar *cal;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVAPunIntViewController *viewController;

/**
 *  <#Description#>
 *
 *  @param originNodes  <#originNodes description#>
 *  @param destiniNodes <#destiniNodes description#>
 *  @param identifier   <#identifier description#>
 *  @param oCoords      <#oCoords description#>
 *  @param punInt       <#punInt description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
-(MVAPath *)computePathFromNodes:(NSArray *)originNodes toNode:(NSMutableDictionary *)destiniNodes withAlgorithmID:(int)identifier andOCoords:(CLLocationCoordinate2D)oCoords andDest:(MVAPunInt *)punInt;

/**
 *  <#Description#>
 *
 *  @param cordA <#cordA description#>
 *  @param cordB <#cordB description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
-(double)distanceForCoordinates:(CLLocationCoordinate2D)cordA andCoordinates:(CLLocationCoordinate2D)cordB;

@end