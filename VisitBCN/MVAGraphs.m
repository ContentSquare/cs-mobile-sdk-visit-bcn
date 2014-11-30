//
//  MVAGraphs.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAGraphs.h"

@implementation MVAGraphs

-(void)generateGraphsWithBUSDB:(MVADataBus *)dataBus andTMBDB:(MVADataTMB *)dataTMB andFGCDB:(MVADataFGC *)dataFGC
{
    self.subwayGraph = [[MVASubwayGraph alloc] init];
    self.busGraph.dataBus = dataBus;
    self.busGraph.dataTMB = dataTMB;
    [self.subwayGraph createSubwayGraphWithDBTMB:dataTMB andFGC:dataFGC];
}

-(void)computePathsWithOrigin:(CLLocationCoordinate2D)origin andDestination:(MVAPunInt *)punInt
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    dispatch_apply(2, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(size_t size) {
        if (size == 0) {
            self.subwayPath = [self pathForSubwayGraphWithOrigin:origin andDestination:punInt];
        }
        else {
            self.busPath = [self pathForBusGraphWithOrigin:origin andDestination:punInt];
        }
    });
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Total execution time: %.16f",dif);
}

-(MVAPath *)pathForBusGraphWithOrigin:(CLLocationCoordinate2D)origin andDestination:(MVAPunInt *)punInt
{
    NSMutableArray *originA = [[NSMutableArray alloc] init];
    NSMutableDictionary *destA = [[NSMutableDictionary alloc] initWithCapacity:4];
    NSMutableDictionary *routeStopO = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *routesO = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *routesD = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [self.busGraph.nodes count]; ++i) {
        MVANode *node = [self.busGraph.nodes objectAtIndex:i];
        CLLocationCoordinate2D stopCords = CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude);
        double distO = [self.busGraph distanceForCoordinates:origin andCoordinates:stopCords];
        double distD = [self.busGraph distanceForCoordinates:punInt.coordinates andCoordinates:stopCords];
        if (distO <= [self loadWalkingDist]) {
            if ([routesO objectForKey:[node.stop.routes firstObject]] == nil) {
                [routesO setObject:[NSNumber numberWithDouble:distO] forKey:[node.stop.routes firstObject]];
                [routeStopO setObject:[NSNumber numberWithInt:(int)[originA count]] forKey:[node.stop.routes firstObject]];
                [originA addObject:[NSNumber numberWithInt:node.identificador]];
            }
            else {
                NSNumber *dist = [routesO objectForKey:[node.stop.routes firstObject]];
                if (distO < [dist doubleValue]) {
                    NSNumber *pos = [routeStopO objectForKey:[node.stop.routes firstObject]];
                    [originA setObject:[NSNumber numberWithInt:node.identificador] atIndexedSubscript:[pos intValue]];
                    [routesO setObject:[NSNumber numberWithDouble:distO] forKey:[node.stop.routes firstObject]];
                }
            }
        }
        else if (distD <= [self loadWalkingDist]) {
            if ([routesD objectForKey:[node.stop.routes firstObject]] == nil) {
                [destA setObject:[node.stop.routes firstObject] forKeyedSubscript:[NSNumber numberWithInt:node.identificador]];
                [routesD setObject:[NSNumber numberWithDouble:distD] forKey:[node.stop.routes firstObject]];
            }
            else {
                NSNumber *dist = [routesD objectForKey:[node.stop.routes firstObject]];
                if (distD < [dist doubleValue]) {
                    NSArray *array = [destA allKeysForObject:[node.stop.routes firstObject]];
                    NSNumber *key = [array firstObject];
                    [destA removeObjectForKey:key];
                    [destA setObject:[node.stop.routes firstObject] forKey:[NSNumber numberWithInt:node.identificador]];
                    [routesD setObject:[NSNumber numberWithDouble:distD] forKey:[node.stop.routes firstObject]];
                }
            }
        }
        
    }
    
    if ([originA count] == 0 || [[destA allKeys] count] == 0) return nil;
    
    return [self.busGraph computePathFromNodes:originA
                                          toNode:destA
                               withAlgorithmID:[self loadAlg]
                                      andOCoords:origin
                                      andDest:punInt];
}

-(MVAPath *)pathForSubwayGraphWithOrigin:(CLLocationCoordinate2D)origin andDestination:(MVAPunInt *)punInt
{
    NSMutableArray *originA = [[NSMutableArray alloc] init];
    NSMutableDictionary *destA = [[NSMutableDictionary alloc] initWithCapacity:4];
    NSMutableDictionary *routeStopO = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *routesO = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *routesD = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < [self.subwayGraph.nodes count]; ++i) {
        MVANode *node = [self.subwayGraph.nodes objectAtIndex:i];
        CLLocationCoordinate2D stopCords = CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude);
        double distO = [self.subwayGraph distanceForCoordinates:origin andCoordinates:stopCords];
        double distD = [self.subwayGraph distanceForCoordinates:punInt.coordinates andCoordinates:stopCords];
        if (distO <= [self loadWalkingDist]) {
            if ([routesO objectForKey:[node.stop.routes firstObject]] == nil) {
                [routesO setObject:[NSNumber numberWithDouble:distO] forKey:[node.stop.routes firstObject]];
                [routeStopO setObject:[NSNumber numberWithInt:(int)[originA count]] forKey:[node.stop.routes firstObject]];
                [originA addObject:[NSNumber numberWithInt:node.identificador]];
            }
            else {
                NSNumber *dist = [routesO objectForKey:[node.stop.routes firstObject]];
                if (distO < [dist doubleValue]) {
                    NSNumber *pos = [routeStopO objectForKey:[node.stop.routes firstObject]];
                    [originA setObject:[NSNumber numberWithInt:node.identificador] atIndexedSubscript:[pos intValue]];
                    [routesO setObject:[NSNumber numberWithDouble:distO] forKey:[node.stop.routes firstObject]];
                }
            }
        }
        else if (distD <= [self loadWalkingDist]) {
            if ([routesD objectForKey:[node.stop.routes firstObject]] == nil) {
                [destA setObject:[node.stop.routes firstObject] forKeyedSubscript:[NSNumber numberWithInt:node.identificador]];
                [routesD setObject:[NSNumber numberWithDouble:distD] forKey:[node.stop.routes firstObject]];
            }
            else {
                NSNumber *dist = [routesD objectForKey:[node.stop.routes firstObject]];
                if (distD < [dist doubleValue]) {
                    NSArray *array = [destA allKeysForObject:[node.stop.routes firstObject]];
                    NSNumber *key = [array firstObject];
                    [destA removeObjectForKey:key];
                    [destA setObject:[node.stop.routes firstObject] forKey:[NSNumber numberWithInt:node.identificador]];
                    [routesD setObject:[NSNumber numberWithDouble:distD] forKey:[node.stop.routes firstObject]];
                }
            }
        }
        
    }
    
    if ([originA count] == 0 || [[destA allKeys] count] == 0) return nil;
    
    return [self.subwayGraph computePathFromNodes:originA
                                           toNode:destA
                                  withAlgorithmID:[self loadAlg]
                                       andOCoords:origin
                                       andDest:punInt];
}

-(void)load
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    NSString *filePathBus = [[NSBundle mainBundle] pathForResource:@"busGraph" ofType:@"plist"];
    MVABusGraph* retreivedBus = [NSKeyedUnarchiver unarchiveObjectWithFile:filePathBus];
    if (retreivedBus != nil) {
        self.busGraph = retreivedBus;
    }
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Load Grafs time: %.16f",dif);
}

-(void)save
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains
                              (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex: 0];
    NSString *dogFilePath = [documentsDir stringByAppendingPathComponent:@"busGraph.plist"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.busGraph];
    [data writeToFile:dogFilePath atomically:YES];
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Save Grafs time: %.16f",dif);
}

-(int)loadAlg
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"VisitBCNAlgorithm";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setInteger:1 forKey:nom];
        return 1;
    }
    else {
        return (int)[defaults integerForKey:nom];
    }
}

-(double)loadWalkingDist
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.igrades.subjects"];
    NSString *nom = @"VisitBCNWalkingDist";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setDouble:1000.0 forKey:nom];
        return 1000.0;
    }
    else {
        return [defaults doubleForKey:nom];
    }
}


@end