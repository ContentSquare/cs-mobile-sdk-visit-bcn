//
//  MVASubwayGraph.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVASubwayGraph.h"

@implementation MVASubwayGraph

-(void)createSubwayGraphWithDBTMB:(MVADataTMB *)dataTMB andFGC:(MVADataFGC *)dataFGC
{
    self.dataBus = nil;
    self.dataFGC = dataFGC;
    self.dataTMB = dataTMB;
    
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    self.type = 1;
    
    // CREACIÓ DELS NODES TMB
    self.nodes = [[NSMutableArray alloc] initWithCapacity:([dataTMB.stops count] + [dataFGC.stops count])];
    for (int i = 0; i < [dataTMB.stops count]; ++i) {
        MVANode *node = [[MVANode alloc] init];
        node.stop = [dataTMB.stops objectAtIndex:i];
        node.distance = [NSNumber numberWithDouble:0.0];
        node.score = [NSNumber numberWithDouble:0.0];
        node.pathNodes = [[NSMutableArray alloc] init];
        node.pathEdges = [[NSMutableArray alloc] init];
        node.identificador = i;
        node.open = NO;
        node.previous = nil;
        [self.nodes addObject:node];
    }
    
    // CREACIÓ DELS NODES FGC
    for (int i = 0; i < [dataFGC.stops count]; ++i) {
        MVANode *node = [[MVANode alloc] init];
        node.stop = [dataFGC.stops objectAtIndex:i];
        node.distance = [NSNumber numberWithDouble:0.0];
        node.score = [NSNumber numberWithDouble:0.0];
        node.pathNodes = [[NSMutableArray alloc] init];
        node.pathEdges = [[NSMutableArray alloc] init];
        node.identificador = (i + (int)[dataTMB.stops count]);
        node.open = NO;
        node.previous = nil;
        [self.nodes addObject:node];
    }
    
    self.cal = [dataTMB getCurrentCalendarforSubway:YES];
    self.edgeList = [[NSMutableArray alloc] initWithCapacity:([dataTMB.stops count] + [dataFGC.stops count])];
    for(int i = 0; i < ((int)[dataTMB.stops count] + (int)[dataFGC.stops count]); ++i) {
        [self.edgeList addObject:[[NSMutableArray alloc] init]];
    }
    //CREACIÓ DE LES ARESTES TMB
    for (int i = 0; i < [dataTMB.routes count]; ++i) {
        MVARoute *route = [dataTMB.routes objectAtIndex:i];
        for (int j = 0; j < [route.trips count]; ++j) {
            NSString *tripID = [route.trips objectAtIndex:j];
            if ([tripID hasSuffix:self.cal.serviceID]) {
                NSNumber *num = [dataTMB.tripsHash objectForKey:tripID];
                MVATrip *trip = [dataTMB.trips objectAtIndex:[num intValue]];
                for (int k = 1; k < [trip.sequence count]; ++k) {
                    NSString *idA = [trip.sequence objectAtIndex:(k - 1)];
                    NSNumber *numA = [dataTMB.stopsHash objectForKey:idA];
                    
                    NSString *idB = [trip.sequence objectAtIndex:k];
                    NSNumber *numB = [dataTMB.stopsHash objectForKey:idB];
                    
                    MVAEdge *edge = [[MVAEdge alloc] init];
                    edge.destini = [self.nodes objectAtIndex:[numB intValue]];
                    edge.weight = [NSNumber numberWithInt:1];
                    edge.change = NO;
                    edge.tripID = tripID;
                    
                    NSMutableArray *array = [self.edgeList objectAtIndex:[numA intValue]];
                    [array addObject:edge];
                    [self.edgeList setObject:array atIndexedSubscript:[numA intValue]];
                }
            }
        }
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *anomesdia = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *services = [[NSMutableArray alloc] init];
    //CREACIÓ DE LES ARESTES FGC
    for(int i = 0; i < [dataFGC.dates count]; ++i) {
        MVADate *date = [dataFGC.dates objectAtIndex:i];
        if ([[NSString stringWithFormat:@"%d",date.date] isEqualToString:anomesdia]) {
            [services addObject:date.serviceID];
        }
    }
    NSMutableDictionary *trips = [[NSMutableDictionary alloc] init];
    NSMutableArray *routeTrips = [[NSMutableArray alloc] initWithCapacity:((int)[dataFGC.routes count] * 2)];
    for(int i = 0; i < ((int)[dataFGC.routes count] * 2); ++i) {
        [routeTrips addObject:[[NSMutableArray alloc] init]];
    }
    for (int i = 0; i < [dataFGC.trips count]; ++i) {
        MVATrip *trip = [dataFGC.trips objectAtIndex:i];
        if ([services containsObject:trip.serviceID]) {
            [trips setObject:@"Existe" forKeyedSubscript:trip.tripID];
            NSString *routeID = trip.routeID;
            NSNumber *pos = [dataFGC.routesHash objectForKey:routeID];
            if (trip.direcUP) {
                NSArray *ida = [routeTrips objectAtIndex:[pos intValue]];
                if ([ida count] == 0) {
                    [routeTrips setObject:trip.sequence atIndexedSubscript:[pos intValue]];
                }
            }
            else {
                NSArray *vuelta = [routeTrips objectAtIndex:([pos intValue] + [dataFGC.routes count])];
                if ([vuelta count] == 0) {
                    [routeTrips setObject:trip.sequence atIndexedSubscript:([pos intValue] + [dataFGC.routes count])];
                }
            }
        }
    }
    for (int i = (int)[self.dataTMB.stops count]; i < (int)[self.nodes count]; ++i) {
        MVANode *node = [self.nodes objectAtIndex:i];
        MVAStop *stop = node.stop;
        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
        dispatch_apply([stop.times count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(size_t size) {
            MVATime *time = [stop.times objectAtIndex:size];
            if ([trips objectForKey:time.tripID] == nil) {
                //NSLog(@"Borra");
                @synchronized (set) {
                    [set addIndex:(int)size];
                }
            }
        });
        [stop.times removeObjectsAtIndexes:set];
    }
    int tmbstops = (int)[dataTMB.stops count];
    for(int i = 0; i < [routeTrips count]; ++i) {
        NSArray *seq = [routeTrips objectAtIndex:i];
        MVARoute *route;
        BOOL up = NO;
        if (i < [dataFGC.routes count]) {
            up = YES;
            route = [dataFGC.routes objectAtIndex:i];
        }
        else {
            route = [dataFGC.routes objectAtIndex:(i - (int)[dataFGC.routes count])];
        }
        if ([seq count] > 0) {
            for (int j = 0; j < ([seq count] - 1); ++j) {
                NSString *stopID1 = [seq objectAtIndex:j];
                NSString *stopID2 = [seq objectAtIndex:(j + 1)];
                NSNumber *pos1 = [dataFGC.stopsHash objectForKey:stopID1];
                NSNumber *pos2 = [dataFGC.stopsHash objectForKey:stopID2];
                
                MVAEdge *edge = [[MVAEdge alloc] init];
                edge.destini = [self.nodes objectAtIndex:([pos2 intValue] + tmbstops)];
                edge.weight = [NSNumber numberWithInt:1];
                edge.change = NO;
                if (up) edge.tripID = [route.routeID stringByAppendingString:@"-UP"];
                else  edge.tripID = [route.routeID stringByAppendingString:@"-DOWN"];// REVISAR
                
                NSMutableArray *array = [self.edgeList objectAtIndex:([pos1 intValue] + tmbstops)];
                [array addObject:edge];
                [self.edgeList setObject:array atIndexedSubscript:([pos1 intValue] + tmbstops)];
            }
        }
    }
    
    //CREACIÓ DE CONEXIONS TMB <-> TMB
    MVACustomModifications *modi = [[MVACustomModifications alloc] init];
    for (int i = 0; i < [modi.tmbEdgeConections count]; ++i) {
        MVATriple *tri = [modi.tmbEdgeConections objectAtIndex:i];
        
        NSString *idA = (NSString *)tri.elem1;
        NSNumber *numA = [dataTMB.stopsHash objectForKey:idA];
        NSString *idB = (NSString *)tri.elem2;
        NSNumber *numB = [dataTMB.stopsHash objectForKey:idB];
        
        if (numA != nil && numB != nil) {
            MVAEdge *e = [[MVAEdge alloc] init];
            e.destini = [self.nodes objectAtIndex:[numB intValue]];
            e.weight = [NSNumber numberWithInt:120];//(NSNumber *)tri.elem3;
            e.change = YES;
            NSMutableArray *array = [self.edgeList objectAtIndex:[numA intValue]];
            [array addObject:e];
            [self.edgeList setObject:array atIndexedSubscript:[numA intValue]];
            
            MVAEdge *e2 = [[MVAEdge alloc] init];
            e2.destini = [self.nodes objectAtIndex:[numA intValue]];
            e2.weight = [NSNumber numberWithInt:120];//(NSNumber *)tri.elem3;
            e2.change = YES;
            NSMutableArray *array2 = [self.edgeList objectAtIndex:[numB intValue]];
            [array2 addObject:e2];
            [self.edgeList setObject:array2 atIndexedSubscript:[numB intValue]];
        }
    }
    
    //CREACIÓ DE CONEXIONS TMB <-> FGC
    for (int i = 0; i < [modi.fgcEdgeConections count]; ++i) {
        MVATriple *tri = [modi.fgcEdgeConections objectAtIndex:i];
        
        NSString *idA = (NSString *)tri.elem1;
        NSNumber *numA = [dataTMB.stopsHash objectForKey:idA];
        NSString *idB = (NSString *)tri.elem2;
        NSNumber *numB = [dataFGC.stopsHash objectForKey:idB];
        
        if (numA != nil && numB != nil) {
            MVAEdge *e = [[MVAEdge alloc] init];
            e.destini = [self.nodes objectAtIndex:([numB intValue] + tmbstops)];
            e.weight = [NSNumber numberWithInt:120];//(NSNumber *)tri.elem3;
            e.change = YES;
            NSMutableArray *array = [self.edgeList objectAtIndex:[numA intValue]];
            [array addObject:e];
            [self.edgeList setObject:array atIndexedSubscript:[numA intValue]];
            
            MVAEdge *e2 = [[MVAEdge alloc] init];
            e2.destini = [self.nodes objectAtIndex:[numA intValue]];
            e2.weight = [NSNumber numberWithInt:120];//(NSNumber *)tri.elem3;
            e2.change = YES;
            NSMutableArray *array2 = [self.edgeList objectAtIndex:([numB intValue] + tmbstops)];
            [array2 addObject:e2];
            [self.edgeList setObject:array2 atIndexedSubscript:([numB intValue] + tmbstops)];
        }
    }
    
    //CREACIÓ DE CONEXIONS FGC <-> FGC
    for(int i = 0; i < [dataFGC.stops count]; ++i) {
        MVAStop *stop1 = [dataFGC.stops objectAtIndex:i];
        NSScanner *scanner = [NSScanner scannerWithString:stop1.stopID];
        NSString *prefix;
        [scanner scanUpToString:@"-" intoString:&prefix];
        for(int j = 0; j < [dataFGC.stops count]; ++j) {
            MVAStop *stop2 = [dataFGC.stops objectAtIndex:j];
            NSScanner *scanner2 = [NSScanner scannerWithString:stop2.stopID];
            NSString *prefix2;
            [scanner2 scanUpToString:@"-" intoString:&prefix2];
            if ((![stop1.stopID isEqualToString:stop2.stopID]) && ([prefix2 isEqualToString:prefix])) {
                NSNumber *numA = [dataFGC.stopsHash objectForKey:stop1.stopID];
                NSNumber *numB = [dataFGC.stopsHash objectForKey:stop2.stopID];
                MVAEdge *e = [[MVAEdge alloc] init];
                e.destini = [self.nodes objectAtIndex:([numB intValue] + tmbstops)];
                e.weight = [NSNumber numberWithInt:120];
                e.change = YES;
                NSMutableArray *array = [self.edgeList objectAtIndex:([numA intValue] + tmbstops)];
                [array addObject:e];
                [self.edgeList setObject:array atIndexedSubscript:([numA intValue] + tmbstops)];
            }
        }
    }
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Subway creation time: %.16f",dif);
}

@end