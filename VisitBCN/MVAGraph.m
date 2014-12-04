//
//  MVAGraph.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAGraph.h"
#import <float.h>
#import <math.h>
#import "MVAAlgorithms.h"

@interface MVAGraph ()

@property MVAPath *path;
@property int count;

@end

@implementation MVAGraph


-(MVAPath *)computePathFromNodes:(NSArray *)originNodes toNode:(NSMutableDictionary *)destiniNodes withAlgorithmID:(int)identifier andOCoords:(CLLocationCoordinate2D)oCoords andDest:(MVAPunInt *)punInt
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    self.count = 0;
    self.path = nil;
    if (identifier == 1) { // DIJKSTRA
        NSNumber *infinity = [NSNumber numberWithDouble:DBL_MAX];
        MVAAlgorithms *alg = [[MVAAlgorithms alloc] init];
        alg.viewController = self.viewController;
        alg.nodes = [self.nodes mutableCopy];
        NSNumber *posA = [originNodes firstObject];
        MVANode *nodeA = [alg.nodes objectAtIndex:[posA intValue]];
        alg.edgeList = self.edgeList;
        alg.type = self.type;
        alg.dataBus = self.dataBus;
        alg.dataFGC = self.dataFGC;
        alg.dataTMB = self.dataTMB;
        alg.openNodes = [[MVAPriorityQueue alloc] initWithCapacity:[self.nodes count]];
        alg.cal = self.cal;
        for (MVANode *node in self.nodes) {
            node.open = NO;
            node.pathEdges = [[NSMutableArray alloc] init];
            node.pathNodes = [[NSMutableArray alloc] init];
            if ([originNodes containsObject:[NSNumber numberWithInt:node.identificador]]) {
                node.open = YES;
                double sec_rep = [self initTime];
                double dist = [self distanceForCoordinates:oCoords
                                            andCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude)];
                double walkingSpeed = [self loadWalkingSpeed];
                sec_rep += (dist / walkingSpeed);
                
                if (self.type == 1) {
                    node.pathNodes = [[NSMutableArray alloc] init];
                    node.pathEdges = [[NSMutableArray alloc] init];
                    node.distance = [NSNumber numberWithDouble:sec_rep];
                }
                else {
                    node.pathNodes = [[NSMutableArray alloc] init];
                    node.pathEdges = [[NSMutableArray alloc] init];
                    MVACalendar *cal = [self.dataTMB getCurrentCalendarforSubway:NO];
                    double freq = [self.dataBus frequencieForStop:node.stop andTime:sec_rep andCalendar:cal.serviceID];
                    node.distance = [NSNumber numberWithDouble:(sec_rep + freq)];
                }
                MVAPair *p = [[MVAPair alloc] init];
                p.first = [node.distance doubleValue];
                p.second = node.identificador;
                [alg.openNodes insertar:p];
            }
            else {
                node.pathNodes = [[NSMutableArray alloc] init];
                node.pathEdges = [[NSMutableArray alloc] init];
                node.distance = infinity;
            }
        }
        
        MVAStop *stop = [[MVAStop alloc] init];
        stop.name = punInt.nombre;
        stop.latitude = punInt.coordinates.latitude;
        stop.longitude = punInt.coordinates.longitude;
        MVANode *node = [[MVANode alloc] init];
        node.distance = infinity;
        node.stop = stop;
        node.open = NO;
        node.identificador = (int)[self.nodes count];
        node.pathEdges = [[NSMutableArray alloc] init];
        node.pathNodes = [[NSMutableArray alloc] init];
        [alg.nodes addObject:node];
        MVAEdge *edge = [[MVAEdge alloc] init];
        edge.destini = node;
        edge.tripID = @"landmark";
        NSArray *keys = [destiniNodes allKeys];
        for (int i = 0; i < [keys count]; ++i) {
            NSNumber *key = [keys objectAtIndex:i];
            NSMutableArray *edges = [alg.edgeList objectAtIndex:[key intValue]];
            [edges addObject:edge];
            [alg.edgeList setObject:edges atIndexedSubscript:[key intValue]];
        }
        
        self.path = [alg dijkstraPathFrom:nodeA
                                   toNode:node
                                  withCoo:punInt.coordinates];
    }
    else { // A*
        
        NSNumber *infinity = [NSNumber numberWithDouble:DBL_MAX];
        MVAAlgorithms *alg = [[MVAAlgorithms alloc] init];
        alg.viewController = self.viewController;
        alg.nodes = [self.nodes mutableCopy];
        NSNumber *posA = [originNodes firstObject];
        MVANode *nodeA = [alg.nodes objectAtIndex:[posA intValue]];
        alg.edgeList = self.edgeList;
        alg.type = self.type;
        alg.dataBus = self.dataBus;
        alg.dataFGC = self.dataFGC;
        alg.dataTMB = self.dataTMB;
        alg.openNodes = [[MVAPriorityQueue alloc] initWithCapacity:[self.nodes count]];
        alg.cal = self.cal;
        for (MVANode *node in self.nodes) {
            node.open = NO;
            node.pathEdges = [[NSMutableArray alloc] init];
            node.pathNodes = [[NSMutableArray alloc] init];
            if ([originNodes containsObject:[NSNumber numberWithInt:node.identificador]]) {
                double sec_rep = [self initTime];
                double dist = [self distanceForCoordinates:oCoords
                                            andCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude)];
                double walkingSpeed = [self loadWalkingSpeed];
                sec_rep += (dist / walkingSpeed);
                
                CLLocationCoordinate2D cordA = CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude);
                node.previous = nil;
                node.open = YES;
                
                if (self.type == 1) {
                    double next = sec_rep;
                    node.distance = [NSNumber numberWithDouble:(next)];
                    node.score = [NSNumber numberWithDouble:(next + [self distanceForCoordinates:cordA andCoordinates:punInt.coordinates])];
                }
                else {
                    MVACalendar *cal = [self.dataTMB getCurrentCalendarforSubway:NO];
                    double freq = [self.dataBus frequencieForStop:node.stop andTime:sec_rep andCalendar:cal.serviceID];
                    node.distance = [NSNumber numberWithDouble:(sec_rep + freq)];
                    double dist = [self distanceForCoordinates:cordA andCoordinates:punInt.coordinates];
                    double busSpeed = (176.0 / 36.0);
                    if ([self loadRain]) busSpeed /= 1.2;
                    node.score = [NSNumber numberWithDouble:((sec_rep + freq) + (dist / busSpeed))];
                }
                MVAPair *p = [[MVAPair alloc] init];
                p.first = [node.score doubleValue];
                p.second = node.identificador;
                [alg.openNodes insertar:p];
            }
            else {
                node.score = infinity;
                node.previous = nil;
                node.distance = infinity;
            }
        }
        
        MVAStop *stop = [[MVAStop alloc] init];
        stop.name = punInt.nombre;
        stop.latitude = punInt.coordinates.latitude;
        stop.longitude = punInt.coordinates.longitude;
        MVANode *node = [[MVANode alloc] init];
        node.distance = infinity;
        node.score = infinity;
        node.stop = stop;
        node.open = NO;
        node.identificador = (int)[self.nodes count];
        node.pathEdges = [[NSMutableArray alloc] init];
        node.pathNodes = [[NSMutableArray alloc] init];
        [alg.nodes addObject:node];
        MVAEdge *edge = [[MVAEdge alloc] init];
        edge.destini = node;
        edge.tripID = @"landmark";
        NSArray *keys = [destiniNodes allKeys];
        for (int i = 0; i < [keys count]; ++i) {
            NSNumber *key = [keys objectAtIndex:i];
            NSMutableArray *edges = [alg.edgeList objectAtIndex:[key intValue]];
            [edges addObject:edge];
            [alg.edgeList setObject:edges atIndexedSubscript:[key intValue]];
        }
        
        self.path = [alg astarPathFrom:nodeA
                                toNode:node
                               withCoo:punInt.coordinates];
    }
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    if (self.type == 1) NSLog(@"Subway execution time: %.16f",dif);
    else NSLog(@"Bus execution time: %.16f",dif);
    
    return self.path;
}

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

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.nodes forKey:@"nodes"];
    [coder encodeObject:self.edgeList forKey:@"edges"];
    [coder encodeObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[MVAGraph alloc] init];
    if (self) {
        self.nodes = [coder decodeObjectForKey:@"nodes"];
        self.edgeList = [[coder decodeObjectForKey:@"edges"] mutableCopy];
        self.type = [[coder decodeObjectForKey:@"type"] intValue];
    }
    return self;
}

-(double)loadWalkingSpeed
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSString *nom = @"VisitBCNWalkingSpeed";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setDouble:(5000.0/3600.0) forKey:nom];
        if ([self loadRain]) return ((5000.0/3600.0) / 1.2);
        return (5000.0/3600.0);
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

-(double)initTime
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self loadCustomDate]];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger seconds = [components second];
    double sec_rep = (hour * 3600) + (minute * 60) + seconds;
    return sec_rep;
}

-(BOOL)customDate
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [defaults objectForKey:@"VisitBCNCustomDateEnabled"];
    if (data == nil) {
        [defaults setObject:@"NO" forKey:@"VisitBCNCustomDateEnabled"];
        return NO;
    }
    NSString *string = [defaults objectForKey:@"VisitBCNCustomDateEnabled"];
    if ([string isEqualToString:@"NO"]) return NO;
    return YES;
}

-(NSDate *)loadCustomDate
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    if (![self customDate]) return [NSDate date];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSDate *date = [defaults objectForKey:@"VisitBCNCustomDate"];
    if (!date) return [NSDate date];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    date = [NSDate dateWithTimeInterval:seconds sinceDate: date];
    return date;
}

@end