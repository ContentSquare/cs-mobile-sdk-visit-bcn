//
//  MVAGraph.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MVADataTMB.h"
#import "MVADataFGC.h"
#import "MVADataBus.h"
#import "MVAPath.h"
#import "MVAPunInt.h"

@interface MVAGraph : NSObject

@property NSMutableArray *nodes;
@property NSMutableArray *edgeList;
@property int type;
@property MVADataBus *dataBus;
@property MVADataFGC *dataFGC;
@property MVADataTMB *dataTMB;
@property MVACalendar *cal;

-(MVAPath *)computePathFromNodes:(NSArray *)originNodes toNode:(NSMutableDictionary *)destiniNodes withAlgorithmID:(int)identifier andOCoords:(CLLocationCoordinate2D)oCoords andDest:(MVAPunInt *)punInt;
-(double)distanceForCoordinates:(CLLocationCoordinate2D)cordA andCoordinates:(CLLocationCoordinate2D)cordB;

@end