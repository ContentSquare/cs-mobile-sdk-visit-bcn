//
//  MVAAlgorithms.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 22/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVADataTMB.h"
#import "MVADataFGC.h"
#import "MVADataBus.h"
#import "MVAPath.h"
#import "MVAGraph.h"
#import "MVAPriorityQueue.h"
#import "MVAPunIntViewController.h"

@interface MVAAlgorithms : NSObject

@property NSMutableArray *nodes;
@property NSMutableArray *edgeList;
@property int type;
@property MVADataBus *dataBus;
@property MVADataFGC *dataFGC;
@property MVADataTMB *dataTMB;
@property MVACalendar *cal;

@property MVAPriorityQueue *openNodes;
@property MVAPunIntViewController *viewController;

-(MVAPath *)dijkstraPathFrom:(MVANode *)nodeA toNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds;
-(MVAPath *)astarPathFrom:(MVANode *)nodeA toNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds;

@end