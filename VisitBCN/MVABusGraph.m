//
//  MVABusGraph.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVABusGraph.h"

@implementation MVABusGraph

-(void)createBusGraphWithDB:(MVADataBus *)dataBus
{
    self.dataBus = dataBus;
    self.dataFGC = nil;
    self.dataTMB = nil;
    
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    self.type = 2;
    
    // NODOS
    self.nodes = [[NSMutableArray alloc] init];
    for (int i = 0; i < [dataBus.busStops count]; ++i) {
        MVANode *node = [[MVANode alloc] init];
        node.stop = [dataBus.busStops objectAtIndex:i];
        node.distance = [NSNumber numberWithDouble:0.0];
        node.score = [NSNumber numberWithDouble:0.0];
        node.pathNodes = [[NSMutableArray alloc] init];
        node.pathEdges = [[NSMutableArray alloc] init];
        node.identificador = i;
        node.open = NO;
        node.previous = nil;
        [self.nodes addObject:node];
    }
    
    // ARESTAS
    self.edgeList = [[NSMutableArray alloc] initWithCapacity:[self.nodes count]];
    for(int i = 0; i < [dataBus.busStops count]; ++i) {
        [self.edgeList addObject:[[NSMutableArray alloc] init]];
    }
    for (int i = 0; i < [dataBus.busRoutes count]; ++i) {
        MVARoute *route = [dataBus.busRoutes objectAtIndex:i];
        NSNumber *numIda = [dataBus.tripsHashIda objectForKey:route.routeID];
        NSNumber *numVuelta = [dataBus.tripsHashVuelta objectForKey:route.routeID];
        NSArray *trip = [dataBus.tripsIda objectAtIndex:[numIda intValue]];
        for (int j = 0; j < ([trip count] - 1); ++j) {
            NSString *stopID1 = [trip objectAtIndex:j];
            NSString *stopID2 = [trip objectAtIndex:(j + 1)];
            NSNumber *numStop1 = [dataBus.busHash objectForKey:stopID1];
            NSNumber *numStop2 = [dataBus.busHash objectForKey:stopID2];
            MVAEdge *edge = [[MVAEdge alloc] init];
            MVANode *node = [self.nodes objectAtIndex:[numStop2 intValue]];
            edge.weight = [NSNumber numberWithDouble:0.0];
            edge.destini = node;
            edge.tripID = route.routeID;
            NSMutableArray *array = [self.edgeList objectAtIndex:[numStop1 intValue]];
            if (array == nil) array = [[NSMutableArray alloc] init];
            [array addObject:edge];
            [self.edgeList setObject:array atIndexedSubscript:[numStop1 intValue]];
        }
        trip = [dataBus.tripsVuelta objectAtIndex:[numVuelta intValue]];
        for (int j = 0; j < ([trip count] - 1); ++j) {
            NSString *stopID1 = [trip objectAtIndex:j];
            NSString *stopID2 = [trip objectAtIndex:(j + 1)];
            NSNumber *numStop1 = [dataBus.busHash objectForKey:stopID1];
            NSNumber *numStop2 = [dataBus.busHash objectForKey:stopID2];
            MVAEdge *edge = [[MVAEdge alloc] init];
            MVANode *node = [self.nodes objectAtIndex:[numStop2 intValue]];
            edge.weight = [NSNumber numberWithDouble:0.0];
            edge.destini = node;
            edge.tripID = route.routeID;
            NSMutableArray *array = [self.edgeList objectAtIndex:[numStop1 intValue]];
            [array addObject:edge];
            [self.edgeList setObject:array atIndexedSubscript:[numStop1 intValue]];
        }
    }
    
    // ARESTAS CAMINANDO Y MISMA
    for (int i = 0; i < [self.nodes count]; ++i) {
        MVANode *nodeA = [self.nodes objectAtIndex:i];
        NSScanner *scanner = [NSScanner scannerWithString:nodeA.stop.stopID];
        NSString *prefix;
        [scanner scanUpToString:@"+" intoString:&prefix];
        for (int j = (i + 1); j < [self.nodes count]; ++j) {
            MVANode *nodeB = [self.nodes objectAtIndex:j];
            NSScanner *scanner2 = [NSScanner scannerWithString:nodeB.stop.stopID];
            NSString *prefix2;
            [scanner2 scanUpToString:@"+" intoString:&prefix2];
            CLLocationCoordinate2D cordA = CLLocationCoordinate2DMake(nodeA.stop.latitude ,nodeA.stop.longitude);
            CLLocationCoordinate2D cordB = CLLocationCoordinate2DMake(nodeB.stop.latitude ,nodeB.stop.longitude);
            double dist = [self distanceForCoordinates:cordA andCoordinates:cordB];
            double walkingSpeed = (5000 / 3600);
            if (![nodeA.stop.stopID isEqualToString:nodeB.stop.stopID]) {
                if (![prefix isEqualToString:prefix2] && (dist < 150)) { // WALKING
                    MVAEdge *walkingGo = [[MVAEdge alloc] init];
                    walkingGo.destini = nodeB;
                    walkingGo.tripID = @"walking";
                    walkingGo.weight = [NSNumber numberWithDouble:(dist / walkingSpeed)]; // + F1/2
                    NSNumber *numStop1 = [dataBus.busHash objectForKey:nodeA.stop.stopID];
                    NSMutableArray *array = [self.edgeList objectAtIndex:[numStop1 intValue]];
                    [array addObject:walkingGo];
                    [self.edgeList setObject:array atIndexedSubscript:[numStop1 intValue]];
                    
                    MVAEdge *walkingBack = [[MVAEdge alloc] init];
                    walkingBack.destini = nodeA;
                    walkingBack.tripID = @"walking";
                    walkingBack.weight = [NSNumber numberWithDouble:(dist / walkingSpeed)]; // + F2/2
                    NSNumber *numStop2 = [dataBus.busHash objectForKey:nodeB.stop.stopID];
                    NSMutableArray *array2 = [self.edgeList objectAtIndex:[numStop2 intValue]];
                    [array2 addObject:walkingBack];
                    [self.edgeList setObject:array2 atIndexedSubscript:[numStop2 intValue]];
                }
                else if ([prefix isEqualToString:prefix2]) { // CHANGE
                    MVAEdge *walkingGo = [[MVAEdge alloc] init];
                    walkingGo.destini = nodeB;
                    walkingGo.tripID = @"change";
                    walkingGo.weight = [NSNumber numberWithDouble:120]; // F1/2
                    NSNumber *numStop1 = [dataBus.busHash objectForKey:nodeA.stop.stopID];
                    NSMutableArray *array = [self.edgeList objectAtIndex:[numStop1 intValue]];
                    [array addObject:walkingGo];
                    [self.edgeList setObject:array atIndexedSubscript:[numStop1 intValue]];
                    
                    MVAEdge *walkingBack = [[MVAEdge alloc] init];
                    walkingBack.destini = nodeA;
                    walkingBack.tripID = @"change";
                    walkingBack.weight = [NSNumber numberWithDouble:120]; // F2/2
                    NSNumber *numStop2 = [dataBus.busHash objectForKey:nodeB.stop.stopID];
                    NSMutableArray *array2 = [self.edgeList objectAtIndex:[numStop2 intValue]];
                    [array2 addObject:walkingBack];
                    [self.edgeList setObject:array2 atIndexedSubscript:[numStop2 intValue]];
                }
            }
        }
    }
    
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Bus creation time: %.16f",dif);
}

@end