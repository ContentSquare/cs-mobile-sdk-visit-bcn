//
//  MVAGraphs.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVABusGraph.h"
#import "MVASubwayGraph.h"
#import "MVADataTMB.h"
#import <CoreLocation/CoreLocation.h>

@interface MVAGraphs : NSObject

@property MVABusGraph *busGraph;
@property MVASubwayGraph *subwayGraph;
@property MVAPath *subwayPath;
@property MVAPath *busPath;

-(void)generateGraphsWithBUSDB:(MVADataBus *)dataBus andTMBDB:(MVADataTMB *)dataTMB andFGCDB:(MVADataFGC *)dataFGC;
-(void)computePathsWithOrigin:(CLLocationCoordinate2D)origin andDestination:(MVAPunInt *)punInt;

-(void)load;
-(void)save;

@end