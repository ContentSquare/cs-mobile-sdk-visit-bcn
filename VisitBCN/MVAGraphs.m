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
    [self load];
    self.subwayGraph = [[MVASubwayGraph alloc] init];
    self.busGraph.dataBus = dataBus;
    self.busGraph.dataTMB = dataTMB;
    [self.subwayGraph createSubwayGraphWithDBTMB:dataTMB andFGC:dataFGC];
    
    NSLog(@"Bus graph nodes: %d",(int)[self.busGraph.nodes count]);
    int count = 0;
    for (int i = 0; i < [self.busGraph.edgeList count]; ++i) {
        NSArray *edges = [self.busGraph.edgeList objectAtIndex:i];
        count += [edges count];
    }
    NSLog(@"Bus graph edges: %d",(int)count);
    
    NSLog(@"Subway graph nodes: %d",(int)[self.subwayGraph.nodes count]);
    count = 0;
    for (int i = 0; i < [self.subwayGraph.edgeList count]; ++i) {
        NSArray *edges = [self.subwayGraph.edgeList objectAtIndex:i];
        count += [edges count];
    }
    NSLog(@"Subway graph edges: %d",(int)count);
}

-(void)computePathsWithOrigin:(CLLocationCoordinate2D)origin andDestination:(MVAPunInt *)punInt
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    self.subwayGraph.viewController = self.viewController;
    self.busGraph.viewController = self.viewController;
    
    self.subwayPath = [self pathForSubwayGraphWithOrigin:origin andDestination:punInt];
    self.busPath = [self pathForBusGraphWithOrigin:origin andDestination:punInt];
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Total execution time: %.16f",dif);
}

/**
 *  Function that computes the bus path from the origin location to the destination point
 *
 *  @param origin Origin coordinates
 *  @param punInt Destination point
 *
 *  @return An MVAPath object with the bus path
 *
 *  @since version 1.0
 */
-(MVAPath *)pathForBusGraphWithOrigin:(CLLocationCoordinate2D)origin andDestination:(MVAPunInt *)punInt
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    NSMutableArray *originA = [[NSMutableArray alloc] init];
    NSMutableDictionary *destA = [[NSMutableDictionary alloc] initWithCapacity:5];
    self.busError = nil;
    for (int i = 0; i < [self.busGraph.nodes count]; ++i) {
        MVANode *node = [self.busGraph.nodes objectAtIndex:i];
        CLLocationCoordinate2D stopCords = CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude);
        double distO = [self.busGraph distanceForCoordinates:origin andCoordinates:stopCords];
        double distD = [self.busGraph distanceForCoordinates:punInt.coordinates andCoordinates:stopCords];
        if ((distO <= [self loadWalkingDist]) && (node.stop.routes != nil)) {
            [originA addObject:[NSNumber numberWithInt:node.identificador]];
        }
        else if ((distD <= [self loadWalkingDist]) && (node.stop.routes != nil)) {
            [destA setObject:[node.stop.routes firstObject] forKeyedSubscript:[NSNumber numberWithInt:node.identificador]];
        }
    }
    
    if ([originA count] == 0 || [[destA allKeys] count] == 0) {
        self.busError = @"DEMASIADO LEJOS";
        return nil;
    }
    
    MVAPath *retPath = [self.busGraph computePathFromNodes:originA
                                                    toNode:destA
                                           withAlgorithmID:[self loadAlg]
                                                andOCoords:origin
                                                   andDest:punInt];
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Bus execution time: %.16f",dif);
    
    return retPath;
}

/**
 *  Function that computes the subway path from the origin location to the destination point
 *
 *  @param origin Origin coordinates
 *  @param punInt Destination point
 *
 *  @return An MVAPath object with the subway path
 *
 *  @since version 1.0
 */
-(MVAPath *)pathForSubwayGraphWithOrigin:(CLLocationCoordinate2D)origin andDestination:(MVAPunInt *)punInt
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    NSMutableArray *originA = [[NSMutableArray alloc] init];
    NSMutableDictionary *destA = [[NSMutableDictionary alloc] initWithCapacity:5];
    self.subwayError = nil;
    for (int i = 0; i < [self.subwayGraph.nodes count]; ++i) {
        MVANode *node = [self.subwayGraph.nodes objectAtIndex:i];
        CLLocationCoordinate2D stopCords = CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude);
        double distO = [self.subwayGraph distanceForCoordinates:origin andCoordinates:stopCords];
        double distD = [self.subwayGraph distanceForCoordinates:punInt.coordinates andCoordinates:stopCords];
        if ((distO <= [self loadWalkingDist]) && (node.stop.routes != nil)) {
            [originA addObject:[NSNumber numberWithInt:node.identificador]];
        }
        else if ((distD <= [self loadWalkingDist])  && (node.stop.routes != nil)) {
            [destA setObject:[node.stop.routes firstObject] forKeyedSubscript:[NSNumber numberWithInt:node.identificador]];
        }
        
    }
    
    if ([originA count] == 0 || [[destA allKeys] count] == 0) {
        self.subwayError = @"DEMASIADO LEJOS";
        return nil;
    }
    
    MVAPath *retPath = [self.subwayGraph computePathFromNodes:originA
                                                       toNode:destA
                                              withAlgorithmID:[self loadAlg]
                                                   andOCoords:origin
                                                      andDest:punInt];
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Subway execution time: %.16f",dif);
    
    return retPath;
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

/**
 *  Function that loads the algorithm chosen by the user ( 0 = Dijkstra, 1 = A*, Default = 1).
 *
 *  @return The algorithm's identifier
 *
 *  @since version 1.0
 */
-(int)loadAlg
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSString *nom = @"VisitBCNAlgorithm";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setInteger:0 forKey:nom];
        return 0;
    }
    else {
        return (int)[defaults integerForKey:nom];
    }
}

/**
 *  This function loads the walking distance indicated by the user. (The default value is 5 km)
 *
 *  @return The distance in meters
 *
 *  @since version 1.0
 */
-(double)loadWalkingDist
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSString *nom = @"VisitBCNWalkingDist";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setDouble:2000.0 forKey:nom];
        return 2000.0;
    }
    else {
        return [defaults doubleForKey:nom];
    }
}


@end