//
//  MVAAlgorithms.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 22/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAAlgorithms.h"

@interface MVAAlgorithms ()

@property CLLocationCoordinate2D piCoord;

@end

@implementation MVAAlgorithms

-(MVAPath *)dijkstraPathFrom:(MVANode *)nodeA toNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    self.piCoord = crds;
    
    MVAPair *p = [self.openNodes firstObject];
    [self.openNodes removeFirst];
    MVANode *currentNode = [self.nodes objectAtIndex:p.second];
    
    while ((currentNode != nil) && (currentNode.identificador != nodeB.identificador) && !self.viewController.stop) {
        [self updateNodesForNode:currentNode];
        MVAPair *p = [self.openNodes firstObject];
        if (p == nil)  currentNode = nil;
        else {
            [self.openNodes removeFirst];
            currentNode = [self.nodes objectAtIndex:p.second];
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

-(void)updateNodesForNode:(MVANode *)node
{
    NSArray *conectados = [self.edgeList objectAtIndex:node.identificador];
    for (int i = 0; i < [conectados count]; ++i) {
        MVAEdge *edge = [conectados objectAtIndex:i];
        MVANode *destNode = edge.destini;
        if (self.type == 1) {
            double nextTrain;
            if (edge.change) {
                nextTrain = [node.distance doubleValue] + [edge.weight doubleValue];
            }
            else if ([edge.tripID isEqualToString:@"landmark"]) {
                double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude) andCoordinates:self.piCoord];
                double walkingSpeed = [self loadWalkingSpeed];
                double expecTime = (dist / walkingSpeed);
                nextTrain += expecTime;
            }
            else nextTrain = [self getNextTrainForNode:destNode edge:edge andTime:[node.distance doubleValue]];
            if (nextTrain < [destNode.distance doubleValue]) {
                if (!destNode.open) {
                    MVAPair *p = [[MVAPair alloc] init];
                    p.first = nextTrain;
                    p.second = destNode.identificador;
                    destNode.open = YES;
                    [self.openNodes insertar:p];
                }
                else {
                    int pos = [self.openNodes posOfElement:destNode.identificador];
                    if (pos >= 0) {
                        MVAPair *p = [self.openNodes objectAtIndex:pos];
                        p.first = nextTrain;
                        [self.openNodes setObject:p atIndex:pos];
                    }
                }
                destNode.distance = [NSNumber numberWithDouble:nextTrain];
                destNode.pathNodes = [node.pathNodes mutableCopy];
                [destNode.pathNodes addObject:node];
                destNode.pathEdges = [node.pathEdges mutableCopy];
                [destNode.pathEdges addObject:edge];
            }
        }
        else {
            double time = [node.distance doubleValue];
            if ([edge.tripID isEqualToString:@"walking"] || [edge.tripID isEqualToString:@"change"]) {
                time += [edge.weight doubleValue];
                MVACalendar *cal = [self.dataTMB getCurrentCalendarforSubway:NO];
                time += [self.dataBus frequencieForStop:edge.destini.stop andTime:time andCalendar:cal.serviceID];
            }
            else if ([edge.tripID isEqualToString:@"landmark"]) {
                double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude) andCoordinates:self.piCoord];
                double walkingSpeed = [self loadWalkingSpeed];
                double expecTime = (dist / walkingSpeed);
                time += expecTime;
            }
            else {
                time += [self timeInBusFromNodeA:node toNodeB:destNode];
            }
            if (time < [destNode.distance doubleValue]) {
                if (!destNode.open) {
                    MVAPair *p = [[MVAPair alloc] init];
                    p.first = time;
                    p.second = destNode.identificador;
                    destNode.open = YES;
                    [self.openNodes insertar:p];
                }
                else {
                    int pos = [self.openNodes posOfElement:destNode.identificador];
                    if (pos >= 0) {
                        MVAPair *p = [self.openNodes objectAtIndex:pos];
                        p.first = time;
                        [self.openNodes setObject:p atIndex:pos];
                    }
                }
                destNode.distance = [NSNumber numberWithDouble:time];
                destNode.pathNodes = [node.pathNodes mutableCopy];
                [destNode.pathNodes addObject:node];
                destNode.pathEdges = [node.pathEdges mutableCopy];
                [destNode.pathEdges addObject:edge];
            }
        }
    }
}

-(double)getNextTrainForNode:(MVANode *)node edge:(MVAEdge *)edge andTime:(double)actualTime
{
    BOOL nextDay = NO;
    if (actualTime >= 86400) {
        actualTime -= 86400;
        nextDay = YES;
    }
    MVAStop *stop = node.stop;
    if ([stop.stopID hasPrefix:@"001-"]) {
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
        }
        MVATime *exampleTimeOrigin = nil;
        para = NO;
        for (int i = 0; i < [firstStop.times count] && !para; ++i) {
            MVATime *tiempo = [firstStop.times objectAtIndex:i];
            if ([tiempo.tripID isEqualToString:tripID]) {
                para = YES;
                exampleTimeOrigin = tiempo;
            }
        }
        para = NO;
        double originTime = [self timeToInt:exampleTimeOrigin.departureTime];
        double destiniTime = [self timeToInt:exampleTimeStop.arrivalTime];
        double dif = destiniTime - originTime;
        MVAFrequencies *actualFreq = nil;
        for (int i = 0; i < [trip.freqs count] && !para; ++i) {
            NSNumber *freqPos = [trip.freqs objectAtIndex:i];
            MVAFrequencies *freq = [self.dataTMB.freqs objectAtIndex:[freqPos intValue]];
            int initTime = [self timeToInt:freq.startTime];
            int endTime = [self timeToInt:freq.endTime];
            if ((initTime <= actualTime) && (endTime >= actualTime)) {
                para = YES;
                actualFreq = freq;
            }
        }
        if (actualFreq == nil) {
            return DBL_MAX;
        }
        para = NO;
        int trainCount = 0;
        double arrivalTime = 0;
        while (!para) {
            double newTime = ([self timeToInt:actualFreq.startTime]) + (trainCount * [actualFreq.headway intValue]) + dif;
            
            if (newTime > actualTime) {
                arrivalTime = newTime;
                para = YES;
            }
            ++trainCount;
        }
        if (nextDay) return arrivalTime + 86400;
        return arrivalTime;
    }
    else {
        double arrivalTime = DBL_MAX;
        double dif = DBL_MAX;
        for (int i = 0; i < [node.stop.times count]; ++i) {
            MVATime *time = [node.stop.times objectAtIndex:i];
            NSString *tripID = time.tripID;
            NSNumber *tripPos = [self.dataFGC.tripsHash objectForKey:tripID];
            MVATrip *trip = [self.dataFGC.trips objectAtIndex:[tripPos intValue]];
            if ([edge.tripID hasSuffix:@"UP"] && trip.direcUP) {
               // NSLog(@"ARRIBA");
                double arrive = [self timeToInt:time.arrivalTime];
                double espera = arrive - actualTime;
                if (arrive > actualTime && espera < dif && espera < 3600) {
                    arrivalTime = arrive;
                    dif = arrive - actualTime;
                }
            }
            else if ([edge.tripID hasSuffix:@"DOWN"] && !trip.direcUP) {
                //NSLog(@"ABAJO");
                double arrive = [self timeToInt:time.arrivalTime];
                double espera = arrive - actualTime;
                if (arrive > actualTime && espera < dif && espera < 3600) {
                    arrivalTime = arrive;
                    dif = arrive - actualTime;
                }
            }
        }
        if (nextDay) return arrivalTime + 86400;
        return arrivalTime;
    }
}

-(int)timeToInt:(NSString *)time
{
    NSArray *myArray = [time componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
    NSString *horaStr = [myArray objectAtIndex:0];
    if ([horaStr intValue] >= 24) horaStr = 0;
    NSString *minutStr = [myArray objectAtIndex:1];
    NSString *anoStr = [myArray objectAtIndex:2];
    int hora = (int)[horaStr intValue];
    int minute = (int) [minutStr intValue];
    int seconds = (int)[anoStr intValue];
    return (seconds + (60 * minute) + (3600 * hora));
}

-(double)timeInBusFromNodeA:(MVANode *)nodeA toNodeB:(MVANode *)nodeB
{
    CLLocationCoordinate2D cordA = CLLocationCoordinate2DMake(nodeA.stop.latitude, nodeA.stop.longitude);
    CLLocationCoordinate2D cordB = CLLocationCoordinate2DMake(nodeB.stop.latitude, nodeB.stop.longitude);
    double distance = [self distanceForCoordinates:cordA andCoordinates:cordB];
    double busSpeed = (197.0 / 36.0);
    if ([self loadRain]) busSpeed /= 1.2;
    return ((distance / busSpeed) + 30);
}

-(void)updateNodesForEdge:(MVAEdge *)edge andNode:(MVANode *)currentNode
{
    MVANode *dest = edge.destini;
    CLLocationCoordinate2D cord = CLLocationCoordinate2DMake(dest.stop.latitude, dest.stop.longitude);
    double newDist = DBL_MAX;
    double tentative = DBL_MAX;
    
    if (self.type == 1) {
        if (edge.change) {
            newDist = [currentNode.distance doubleValue] + [edge.weight doubleValue];
        }
        else if ([edge.tripID isEqualToString:@"landmark"]) {
            double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(currentNode.stop.latitude, currentNode.stop.longitude) andCoordinates:self.piCoord];
            double walkingSpeed = [self loadWalkingSpeed];
            double expecTime = (dist / walkingSpeed);
            newDist = [currentNode.distance doubleValue] + expecTime;
        }
        else newDist = [self getNextTrainForNode:dest edge:edge andTime:[currentNode.distance doubleValue]];
        tentative = (newDist + ([self distanceForCoordinates:cord andCoordinates:self.piCoord]));
    }
    else {
        double time = [currentNode.distance doubleValue];
        if ([edge.tripID isEqualToString:@"walking"] || [edge.tripID isEqualToString:@"change"]) {
            double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(currentNode.stop.latitude, currentNode.stop.longitude) andCoordinates:cord];
            double walkingSpeed = [self loadWalkingSpeed];
            double expecTime = (dist / walkingSpeed);
            time += expecTime;
            MVACalendar *cal = [self.dataTMB getCurrentCalendarforSubway:NO];
            time += [self.dataBus frequencieForStop:edge.destini.stop andTime:time andCalendar:cal.serviceID];
        }
        else if ([edge.tripID isEqualToString:@"landmark"]) {
            double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(currentNode.stop.latitude, currentNode.stop.longitude) andCoordinates:cord];
            double walkingSpeed = [self loadWalkingSpeed];
            double expecTime = (dist / walkingSpeed);
            time += expecTime;
        }
        else {
            time += [self timeInBusFromNodeA:currentNode toNodeB:dest];
        }
        newDist = time;
        tentative = (newDist + [self heuristicForCoords:cord]);
    }
    if (tentative < [dest.score doubleValue]) {
        dest.previous = currentNode;
        dest.distance = [NSNumber numberWithDouble:newDist];
        dest.score = [NSNumber numberWithDouble:tentative];
        if (!dest.open) {
            MVAPair *p = [[MVAPair alloc] init];
            p.first = tentative;
            p.second = dest.identificador;
            dest.open = YES;
            [self.openNodes insertar:p];
        }
        else {
            int pos = [self.openNodes posOfElement:dest.identificador];
            if (pos >= 0) {
                MVAPair *p = [self.openNodes objectAtIndex:pos];
                p.first = tentative;
                [self.openNodes setObject:p atIndex:pos];
            }
        }
    }
}

-(double)heuristicForCoords:(CLLocationCoordinate2D)cord
{
    double dist = [self distanceForCoordinates:cord andCoordinates:self.piCoord];
    double walkingSpeed = [self loadWalkingSpeed];
    return (dist / walkingSpeed);
}

-(MVAPath *)astarPathFrom:(MVANode *)nodeA toNode:(MVANode *)nodeB withCoo:(CLLocationCoordinate2D)crds
{
    self.piCoord = crds;
    MVANode *currentNode = nil;
    BOOL para = NO;
    while (![self.openNodes isEmpty] && !para && !self.viewController.stop) {
        MVAPair *p = [self.openNodes firstObject];
        currentNode = [self.nodes objectAtIndex:p.second];
        if (currentNode == nil || currentNode.identificador == nodeB.identificador) para = YES;
        if (!para) {
            [self.openNodes removeFirst];
            NSArray *edges = [self.edgeList objectAtIndex:currentNode.identificador];
            for (MVAEdge *edge in edges) {
                [self updateNodesForEdge:edge andNode:currentNode];
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

// Haversine -> http://en.wikipedia.org/wiki/Haversine_formula
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
    
    return (realDist * 1.25);
}

-(MVAEdge *)edgeFromNode:(MVANode *)nodeA toNode:(MVANode *)nodeB
{
    NSMutableArray *edges = [self.edgeList objectAtIndex:nodeA.identificador];
    for (MVAEdge *edge in edges) {
        if ([nodeB isEqual:edge.destini]) return edge;
    }
    return nil;
}

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