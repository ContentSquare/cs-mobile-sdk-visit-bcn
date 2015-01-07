//
//  MVAAlgorithms.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 22/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAAlgorithms.h"
#import "MVAPair.h"

@interface MVAAlgorithms ()

@property CLLocationCoordinate2D piCoord;
@property MVACalendar *nextTMBCalendar;
@property MVACalendar *currentCal;

@end

@implementation MVAAlgorithms

-(MVAPath *)dijkstraPathtoNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    self.piCoord = crds;
    
    if (self.type == 1) self.nextTMBCalendar = [self.dataTMB getNextCalendarforSubway:YES]; // Cost: O(D)
    else  self.currentCal = [self.dataTMB getCurrentCalendarforSubway:NO]; // Cost: O(D)
    
    MVANode *currentNode = nil;
    BOOL para = NO;
    
    while (![self.openNodes isEmpty] && !para && !self.viewController.stop) { // Cost: O(N * ((E * (T + F + log N)) + logN)), where N is the number of nodes, T the number of times and F the number of frequencies.
        MVAPair *p = [self.openNodes firstObject]; // Cost: O(1)
        [self.openNodes removeFirst]; // Cost: O(log N)
        currentNode = [self.nodes objectAtIndex:p.second];
        if (([currentNode.distance doubleValue] == p.first)) {
            if (currentNode.identificador == nodeB.identificador) para = YES;
            else {
                [self updateNodesForNode:currentNode]; // Cost: O(E * (T + F + log N))
                currentNode.open = YES;
            }
        }
    }
    if (self.viewController.stop) {
        NSLog(@"STOP");
        return nil;
    }
    if (currentNode.identificador != nodeB.identificador) return nil;
    if ([currentNode.distance doubleValue] == DBL_MAX) return nil;
    MVAPath *path = [[MVAPath alloc] init];
    path.nodes = currentNode.pathNodes;
    [path.nodes addObject:currentNode];
    path.edges = currentNode.pathEdges;
    path.totalWeight = [currentNode.distance doubleValue];
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Dijkstra execution time: %.16f",dif);
    
    return path;
}

/**
 *  Function that updates all the adjacent nodes of the given one. Cost: O(E * (T + F + log N)).
 *
 *  @param node An object representing the current node
 *
 *  @see MVANode class
 *  @see MVAEdge class
 *
 *  @since version 1.0
 */
-(void)updateNodesForNode:(MVANode *)node
{
    NSArray *conectados = [self.edgeList objectAtIndex:node.identificador];
    for (int i = 0; i < [conectados count]; ++i) { // Cost: O(E * (T + F + log N))
        MVAEdge *edge = [conectados objectAtIndex:i];
        MVANode *destNode = edge.destini;
        if (!destNode.open) {
            CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(destNode.stop.latitude, destNode.stop.longitude);
            if (self.type == 1) { // Cost: O(T + F + log N)
                double nextTrain;
                if (edge.change) { // Cost: O(1)
                    nextTrain = [node.distance doubleValue] + [edge.weight doubleValue];
                    if ([node.pathEdges count] > 0) {
                        MVAEdge *test = [node.pathEdges lastObject];
                        if ([test.tripID isEqualToString:@"walking"]) nextTrain = DBL_MAX;
                    }
                    else if ([node.pathEdges count] == 0) {
                        nextTrain = DBL_MAX;
                    }
                }
                else if ([edge.tripID isEqualToString:@"landmark"]) { // Cost: O(1)
                    double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude) andCoordinates:self.piCoord];
                    double walkingSpeed = [self loadWalkingSpeed];
                    double expecTime = ((dist * 1.2) / walkingSpeed);
                    nextTrain = [node.distance doubleValue] + expecTime;
                }
                else nextTrain = [self getNextTrainForEdge:edge andTime:[node.distance doubleValue]]; // Cost: O(T + F)
                if (nextTrain < [destNode.distance doubleValue]) { // Cost: O(log N)
                    MVAPair *p = [[MVAPair alloc] init];
                    p.first = nextTrain;
                    p.second = destNode.identificador;
                    [self.openNodes addObject:p];
                    destNode.distance = [NSNumber numberWithDouble:nextTrain];
                    destNode.pathNodes = [node.pathNodes mutableCopy];
                    [destNode.pathNodes addObject:node];
                    destNode.pathEdges = [node.pathEdges mutableCopy];
                    [destNode.pathEdges addObject:edge];
                }
            }
            else { // Cost: O(F + log N)
                double time = [node.distance doubleValue];
                if ([edge.tripID isEqualToString:@"walking"] || [edge.tripID isEqualToString:@"change"]) { // Cost: O(F)
                    double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude) andCoordinates:cord];
                    double walkingSpeed = [self loadWalkingSpeed];
                    double expecTime = ((dist * 1.2) / walkingSpeed);
                    time += expecTime;
                    time += [self.dataBus frequencieForStop:edge.destini.stop andTime:time andCalendar:self.currentCal.serviceID];
                    if ([node.pathEdges count] > 0) {
                        MVAEdge *test = [node.pathEdges lastObject];
                        if ([test.tripID isEqualToString:@"walking"]) time = DBL_MAX;
                    }
                }
                else if ([edge.tripID isEqualToString:@"landmark"]) { // Cost: O(1)
                    double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude) andCoordinates:cord];
                    double walkingSpeed = [self loadWalkingSpeed];
                    double expecTime = ((dist * 1.2) / walkingSpeed);
                    time += expecTime;
                }
                else { // Cost: O(1)
                    time += [self timeInBusFromNodeA:node toNodeB:destNode];
                }
                if (time < [destNode.distance doubleValue]) { // Cost: O(log N)
                    destNode.pathNodes = [node.pathNodes mutableCopy];
                    [destNode.pathNodes addObject:node];
                    destNode.pathEdges = [node.pathEdges mutableCopy];
                    [destNode.pathEdges addObject:edge];
                    destNode.distance = [NSNumber numberWithDouble:time];
                    MVAPair *p = [[MVAPair alloc] init];
                    p.first = time;
                    p.second = destNode.identificador;
                    [self.openNodes addObject:p];
                }
            }
        }
    }
}

/**
 *  Function that calculates the next train that arrives to a certain stop at a certain time and from the current location. The given time, is used to find the next train that arrives to that stop after that time. In an execution, this will be used to travell around the graph in the same train or for changing of line. Cost: O(T + F), where T are the number of times and F are the number of frequencies.
 *
 *  @param edge       The edge that contains the destination node and the identifier of the trip
 *  @param actualTime The time for the query
 *
 *  @return The time of the next train
 *
 *  @see MVAEdge class
 *
 *  @since version 1.0
 */
-(double)getNextTrainForEdge:(MVAEdge *)edge andTime:(double)actualTime
{
    MVAStop *stop = edge.destini.stop;
    if ([stop.stopID hasPrefix:@"001-"]) {
        BOOL nextDay = NO;
        if (actualTime >= 86400) {
            nextDay = YES;
        }
        
        NSString *tripID = edge.tripID;
        NSNumber *tripPos = [self.dataTMB.tripsHash objectForKey:tripID];
        MVATrip *trip = [self.dataTMB.trips objectAtIndex:[tripPos intValue]];
        NSString *firstID = [trip.sequence firstObject];
        NSNumber *originPos = [self.dataTMB.stopsHash objectForKey:firstID];
        MVAStop *firstStop = [self.dataTMB.stops objectAtIndex:[originPos intValue]];
        
        MVATime *exampleTimeStop = nil;
        BOOL para = NO;
        for (int i = 0; i < [stop.times count] && !para; ++i) {
            MVATime *tiempo = [stop.times objectAtIndex:i];
            if ([tiempo.tripID isEqualToString:tripID]) {
                para = YES;
                exampleTimeStop = tiempo;
            }
        } // Cost: O(T), where T are the number of times.
        MVATime *exampleTimeOrigin = nil;
        para = NO;
        for (int i = 0; i < [firstStop.times count] && !para; ++i) {
            MVATime *tiempo = [firstStop.times objectAtIndex:i];
            if ([tiempo.tripID isEqualToString:tripID]) {
                para = YES;
                exampleTimeOrigin = tiempo;
            }
        } // Cost: O(T), where T are the number of times.
        para = NO;
        double originTime = [self timeToInt:exampleTimeOrigin.departureTime];
        double destiniTime = [self timeToInt:exampleTimeStop.arrivalTime];
        double dif = destiniTime - originTime;
        MVAFrequencies *actualFreq = nil;
        for (int i = 0; i < [trip.freqs count] && !para; ++i) {
            NSNumber *freqPos = [trip.freqs objectAtIndex:i];
            MVAFrequencies *freq = [self.dataTMB.freqs objectAtIndex:[freqPos intValue]];
            int initTime = [self timeToInt:freq.startTime];
            if (initTime <= 60) initTime = 0;
            int endTime = [self timeToInt:freq.endTime];
            double numTrains = floor((endTime - initTime)/[freq.headway doubleValue]);
            double lastTrain = ((numTrains * [freq.headway doubleValue]) + dif + initTime);
            if ((initTime <= actualTime) && (lastTrain >= actualTime)) {
                para = YES;
                actualFreq = freq;
            }
        } // Cost: O(F), where F are the number of frequencies.
        if (actualFreq == nil) {
            actualTime -= 86400;
            NSArray *array = [tripID componentsSeparatedByString:@"-"];
            NSString *route = [array firstObject];
            NSString *way = [array objectAtIndex:1];
            tripID = [route stringByAppendingString:[@"-" stringByAppendingString:[way stringByAppendingString:[@"-" stringByAppendingString:self.nextTMBCalendar.serviceID]]]];
            if (nextDay && ![tripID hasSuffix:self.nextTMBCalendar.serviceID]) {
                NSNumber *tripPos = [self.dataTMB.tripsHash objectForKey:tripID];
                MVATrip *trip = [self.dataTMB.trips objectAtIndex:[tripPos intValue]];
                MVAFrequencies *actualFreqN = nil;
                for (int i = 0; i < [trip.freqs count] && !para; ++i) {
                    NSNumber *freqPos = [trip.freqs objectAtIndex:i];
                    MVAFrequencies *freq = [self.dataTMB.freqs objectAtIndex:[freqPos intValue]];
                    int initTime = [self timeToInt:freq.startTime];
                    if (initTime <= 60) initTime = 0;
                    int endTime = [self timeToInt:freq.endTime];
                    double numTrains = floor((endTime - initTime)/[freq.headway doubleValue]);
                    double lastTrain = ((numTrains * [freq.headway doubleValue]) + dif + initTime);
                    if ((initTime <= actualTime) && (lastTrain >= actualTime)) {
                        para = YES;
                        actualFreqN = freq;
                    }
                } // Cost: O(F), where F are the number of frequencies.
                if (actualFreqN != nil) {
                    para = NO;
                    double arrivalTime = 0;
                    int initTime = [self timeToInt:actualFreqN.startTime];
                    if (initTime <= 60) initTime = 0;
                    int endTime = [self timeToInt:actualFreq.endTime];
                    int headWayTime = [actualFreq.headway intValue];
                    double difTime = endTime - initTime;
                    double numOfTrains = (difTime / headWayTime);
                    double myDif = (actualTime - dif) - initTime;
                    double perc = (myDif / difTime) * 100.0;
                    double rep = (100.0 / numOfTrains);
                    int train = ceil(perc/rep);
                    arrivalTime = initTime + (headWayTime * train) + dif;
                    return arrivalTime;
                } // Cost: O(1)
            }
            return DBL_MAX;
        } // Cost: O(F), where F are the number of frequencies.
        para = NO;
        double arrivalTime = 0;
        int initTime = [self timeToInt:actualFreq.startTime];
        if (initTime <= 60) initTime = 0;
        int endTime = [self timeToInt:actualFreq.endTime];
        int headWayTime = [actualFreq.headway intValue];
        double difTime = endTime - initTime;
        double numOfTrains = (difTime / headWayTime);
        double myDif = (actualTime - dif) - initTime;
        double perc = (myDif / difTime) * 100.0;
        double rep = (100.0 / numOfTrains);
        int train = ceil(perc/rep);
        arrivalTime = initTime + (headWayTime * train) + dif;
        return arrivalTime;
    } // Cost: O(T + F), where T are the number of times and F are the number of frequencies.
    else {
        double arrivalTime = DBL_MAX;
        double dif = DBL_MAX;
        for (int i = 0; i < [stop.times count]; ++i) { // Cost: O(T), where T is the number of times of the stops.
            MVATime *time = [stop.times objectAtIndex:i];
            NSString *tripID = time.tripID;
            NSNumber *tripPos = [self.dataFGC.tripsHash objectForKey:tripID];
            MVATrip *trip = [self.dataFGC.trips objectAtIndex:[tripPos intValue]];
            if ([edge.tripID hasSuffix:@"UP"] && trip.direcUP) {
                double arrive = [self timeToInt:time.arrivalTime];
                double espera = arrive - actualTime;
                if (arrive > actualTime && espera < dif && espera < 3600) {
                    arrivalTime = arrive;
                    dif = arrive - actualTime;
                }
            }
            else if ([edge.tripID hasSuffix:@"DOWN"] && !trip.direcUP) {
                double arrive = [self timeToInt:time.arrivalTime];
                double espera = arrive - actualTime;
                if (arrive > actualTime && espera < dif && espera < 3600) {
                    arrivalTime = arrive;
                    dif = arrive - actualTime;
                }
            }
        }
        return arrivalTime;
    } // Cost: O(T)
}

/**
 *  Function that transforms a time in HH:MM:SS into an integer in seconds. Cost: O(1)
 *
 *  @param time The time as a string
 *
 *  @return The time in seconds
 *
 *  @since version 1.0
 */
-(int)timeToInt:(NSString *)time
{
    NSArray *myArray = [time componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
    NSString *horaStr = [myArray objectAtIndex:0];
    NSString *minutStr = [myArray objectAtIndex:1];
    NSString *anoStr = [myArray objectAtIndex:2];
    int hora = (int)[horaStr intValue];
    int minute = (int) [minutStr intValue];
    int seconds = (int)[anoStr intValue];
    return (seconds + (60 * minute) + (3600 * hora));
}

/**
 *  Function that calculates the travel time in bus from one stop to the next one. The bus speed used, is an estimation given by TMB (19.7 km/h). This function uses the parameter 'rain' given by the user. If the user indicates that is raining, the bus speed is reduced 1.2 times. Cost: O(1)
 *
 *  @param nodeA The origin node
 *  @param nodeB The destination node
 *
 *  @return The time in bus from the origin to the destination
 *
 *  @see MVANode class
 *  @since version 1.0
 */
-(double)timeInBusFromNodeA:(MVANode *)nodeA toNodeB:(MVANode *)nodeB
{
    CLLocationCoordinate2D cordA = CLLocationCoordinate2DMake(nodeA.stop.latitude, nodeA.stop.longitude);
    CLLocationCoordinate2D cordB = CLLocationCoordinate2DMake(nodeB.stop.latitude, nodeB.stop.longitude);
    double distance = [self distanceForCoordinates:cordA andCoordinates:cordB];
    double busSpeed = (197.0 / 36.0);
    if ([self loadRain]) busSpeed /= 1.2;
    return ((distance / busSpeed) + 30);
}

/**
 *  Function that updates the destination node of an edge from the current node. Cost: O(T + F + log N).
 *
 *  @param edge        The edge object
 *  @param currentNode The current node object
 *
 *  @see MVAEdge class
 *  @see MVANode class
 *
 *  @since version 1.0
 */
-(void)updateNodeForEdge:(MVAEdge *)edge andNode:(MVANode *)currentNode
{
    MVANode *dest = edge.destini;
    CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(dest.stop.latitude, dest.stop.longitude);
    double newDist = DBL_MAX;
    double tentative = DBL_MAX;
    
    if (self.type == 1) { // Cost: O(T + F), where T are the number of times and F are the number of frequencies.
        if (edge.change) { // Cost: O(1)
            newDist = [currentNode.distance doubleValue] + [edge.weight doubleValue];
            if ([currentNode.pathEdges count] > 0) {
                MVAEdge *test = [currentNode.pathEdges lastObject];
                if ([test.tripID isEqualToString:@"walking"]) newDist = DBL_MAX;
            }
            else if ([currentNode.pathEdges count] == 0) {
                newDist = DBL_MAX;
            }
        }
        else if ([edge.tripID isEqualToString:@"landmark"]) { // Cost: O(1)
            double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(currentNode.stop.latitude, currentNode.stop.longitude) andCoordinates:self.piCoord];
            double walkingSpeed = [self loadWalkingSpeed];
            double expecTime = ((dist * 1.2) / walkingSpeed);
            newDist = [currentNode.distance doubleValue] + expecTime;
        }
        else newDist = [self getNextTrainForEdge:edge andTime:[currentNode.distance doubleValue]]; // Cost: O(T + F), where T are the number of times and F are the number of frequencies.
        tentative = (newDist + [self heuristicForCoords:cord]);
    }
    else { // Cost: O(F + log N)
        double time = [currentNode.distance doubleValue];
        if ([edge.tripID isEqualToString:@"walking"] || [edge.tripID isEqualToString:@"change"]) { // Cost: O(F)
            double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(currentNode.stop.latitude, currentNode.stop.longitude) andCoordinates:cord];
            double walkingSpeed = [self loadWalkingSpeed];
            double expecTime = ((dist * 1.2) / walkingSpeed);
            time += expecTime;
            time += 240.0;
            time += [self.dataBus frequencieForStop:edge.destini.stop andTime:time andCalendar:self.currentCal.serviceID];
            newDist = time;
            if ([currentNode.pathEdges count] > 0) {
                MVAEdge *test = [currentNode.pathEdges lastObject];
                if ([test.tripID isEqualToString:@"walking"]) newDist = DBL_MAX;
            }
            tentative = (newDist + [self heuristicForCoords:cord]);
        }
        else if ([edge.tripID isEqualToString:@"landmark"]) { // Cost: O(1)
            double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(currentNode.stop.latitude, currentNode.stop.longitude) andCoordinates:cord];
            double walkingSpeed = [self loadWalkingSpeed];
            double expecTime = ((dist * 1.2) / walkingSpeed);
            time += expecTime;
            newDist = time;
            tentative = newDist;
        }
        else { // Cost: O(1)
            time += [self timeInBusFromNodeA:currentNode toNodeB:dest];
            newDist = time;
            tentative = (newDist + [self heuristicForCoords:cord]);
        }
    }
    if (tentative < [dest.score doubleValue]) {// Cost: O(log N)
        dest.previous = currentNode;
        dest.distance = [NSNumber numberWithDouble:newDist];
        dest.score = [NSNumber numberWithDouble:tentative];
        dest.pathEdges = [[[NSArray alloc] initWithObjects:edge, nil] mutableCopy];
        MVAPair *p = [[MVAPair alloc] init];
        p.first = tentative;
        p.second = dest.identificador;
        [self.openNodes addObject:p];
    }
}

/**
 *  Heuristic function. This function calculates the heuristic for a certain location. Cost: O(1).
 *
 *  @param cord The location coordinates
 *
 *  @return The heuristic value
 *
 *  @since version 1.0
 */
-(double)heuristicForCoords:(CLLocationCoordinate2D)cord
{
    double dist = [self distanceForCoordinates:cord andCoordinates:self.piCoord];
    return (dist / [self loadWalkingSpeed]);
}

-(MVAPath *)astarPathtoNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds
{
    if (self.type == 1) self.nextTMBCalendar = [self.dataTMB getNextCalendarforSubway:YES]; // Cost: O(D)
    else  self.currentCal = [self.dataTMB getCurrentCalendarforSubway:NO]; // Cost: O(D)
    
    self.piCoord = crds;
    MVANode *currentNode = nil;
    BOOL para = NO;
    while (![self.openNodes isEmpty] && !para && !self.viewController.stop) { // Cost: O(N * ((E * (T + F + log N)) + logN)), where N is the number of nodes, T the number of times and F the number of frequencies.
        MVAPair *p = [self.openNodes firstObject]; // Cost: O(1)
        [self.openNodes removeFirst]; // Cost: O(log N)
        currentNode = [self.nodes objectAtIndex:p.second];
        if (p.first == [currentNode.score doubleValue]) {
            if (currentNode.identificador == nodeB.identificador) para = YES;
            else {
                NSArray *edges = [self.edgeList objectAtIndex:currentNode.identificador];
                for (MVAEdge *edge in edges) { // Cost: O(E * (T + F + log N)).
                    if (!edge.destini.open) [self updateNodeForEdge:edge andNode:currentNode]; // Cost: O(T + F + log N).
                }
                currentNode.open = YES;
            }
        }
    }
    if (self.viewController.stop) {
        NSLog(@"STOP");
        return nil;
    }
    if (currentNode.identificador != nodeB.identificador) return nil;
    MVAPath *path = [[MVAPath alloc] init];
    [self pathwithGoal:currentNode andPath:path];
    path.totalWeight = [currentNode.distance doubleValue];
    return path;
}

/**
 *  Function that recursively construct the path coputed by the A* algorithm.
 *
 *  @param node The first node of the path
 *  @param path The path object
 *
 *  @see MVANode class
 *  @since version 1.0
 */
-(void)pathwithGoal:(MVANode *)node andPath:(MVAPath *)path
{
    if(node.previous != nil) {
        [self pathwithGoal:node.previous andPath:path];
        [path.edges addObject:[self edgeFromNode:node.previous toNode:node]];
        [path.nodes addObject:node];
    }
    else {
        path.nodes = [[NSMutableArray alloc] init];
        [path.nodes addObject:node];
        path.edges = [[NSMutableArray alloc] init];
    }
}

/**
 *  Haversine distance between two coordinates. Cost: O(1).
 *
 *  @param cordA The first coordinate
 *  @param cordB The second coordinate
 *
 *  @return The distance in meters
 *
 *  @see http://www.movable-type.co.uk/scripts/latlong.html
 *  @since version 1.0
 */
-(double)distanceForCoordinates:(CLLocationCoordinate2D)cordA andCoordinates:(CLLocationCoordinate2D)cordB
{
    double R = 6372797.560856;
    double dLat = ((cordB.latitude - cordA.latitude) * M_PI) / 180.0;
    double dLon = ((cordB.longitude - cordA.longitude) * M_PI) / 180.0;
    double lat1 = (cordA.latitude * M_PI) / 180.0;
    double lat2 = (cordB.latitude * M_PI) / 180.0;
    
    double a = (sin(dLat/2.0) * sin(dLat/2.0)) + (sin(dLon/2.0) * sin(dLon/2.0) * cos(lat1) * cos(lat2));
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double realDist = (R * c);
    
    return realDist;
}

/**
 *  Function that returns the edge that connects the first node with the second. Cost: O(E), where E is the number of Edges of the given node.
 *
 *  @param nodeA The first node
 *  @param nodeB The second node
 *
 *  @return The MVAEdge object that represents the edge
 *
 *  @since version 1.0
 */
-(MVAEdge *)edgeFromNode:(MVANode *)nodeA toNode:(MVANode *)nodeB
{
    NSMutableArray *edges = [self.edgeList objectAtIndex:nodeA.identificador];
    for (MVAEdge *edge in edges) {
        if ([nodeB isEqual:edge.destini]) return edge;
    }
    return nil;
}

/**
 *  This function loads the walking speed indicated by the user. (The default value is 5km/h)
 *
 *  @return The speed in m/s
 *
 *  @since version 1.0
 */
-(double)loadWalkingSpeed
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSString *nom = @"VisitBCNWalkingSpeed";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setDouble:5000.0 forKey:nom];
        if ([self loadRain]) return (5000.0 / 1.2);
        return 5000.0;
    }
    else {
        if ([self loadRain]) return ([defaults doubleForKey:nom] / 1.2);
        return [defaults doubleForKey:nom];
    }
}

/**
 *  Function that loads if is raining in Barcelona or not.
 *
 *  @return A bool with the answer to the query
 *
 *  @since version 1.0
 */
-(BOOL)loadRain
{
    int alg = 0;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [defaults objectForKey:@"VisitBCNRain"];
    if(data == nil){
        [defaults setInteger:0 forKey:@"VisitBCNRain"];
    }
    else {
        alg = (int)[defaults integerForKey:@"VisitBCNRain"];
    }
    if (alg == 1) return YES;
    return NO;
}

@end