//
//  MVADataBus.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVADataBus.h"
#import <CoreLocation/CoreLocation.h>

@interface MVADataBus () <CHCSVParserDelegate>

@property NSString *docName;
@property int line;
@property int indexRouteIda;
@property int indexRouteVuelta;
@property MVABusSeq *busSeq;
@property BOOL ida;
@property MVARoute *route;
@property MVAStop *stop;
@property MVAFrequencies *freq;

@end

@implementation MVADataBus

- (void)parseDataBase
{
    self.busStops = [[NSMutableArray alloc] init];
    self.busHash = [[NSMutableDictionary alloc] init];
    self.docName = @"stopBuses.txt";
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"/Buses/stopBuses.txt"];
    NSStringEncoding encoding = 0;
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:filePath];
    CHCSVParser * p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
    [p setRecognizesBackslashesAsEscapes:YES];
    [p setSanitizesFields:YES];
    [p setDelegate:self];
    [p parse];
    
    self.busRoutes = [[NSMutableArray alloc] init];
    self.busRoutesHash = [[NSMutableDictionary alloc] init];
    self.docName = @"routeBuses.txt";
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingPathComponent:@"/Buses/routeBuses.txt"];
    encoding = 0;
    stream = [NSInputStream inputStreamWithFileAtPath:filePath];
    p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
    [p setRecognizesBackslashesAsEscapes:YES];
    [p setSanitizesFields:YES];
    [p setDelegate:self];
    [p parse];
    
    self.docName = @"tripBuses.txt";
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingPathComponent:@"/Buses/tripBuses.txt"];
    encoding = 0;
    stream = [NSInputStream inputStreamWithFileAtPath:filePath];
    p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
    [p setRecognizesBackslashesAsEscapes:YES];
    [p setSanitizesFields:YES];
    [p setDelegate:self];
    [p parse];
    
    self.docName = @"frequencies.txt";
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingPathComponent:@"/Buses/frequencies.txt"];
    encoding = 0;
    stream = [NSInputStream inputStreamWithFileAtPath:filePath];
    p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
    [p setRecognizesBackslashesAsEscapes:YES];
    [p setSanitizesFields:YES];
    [p setDelegate:self];
    [p parse];
    
    for (int i = 0; i < [self.busRoutes count]; ++i) {
        MVARoute *route = [self.busRoutes objectAtIndex:i];
        NSNumber *numIda = [self.tripsHashIda objectForKey:route.routeID];
        NSNumber *numVuelta = [self.tripsHashVuelta objectForKey:route.routeID];
        NSArray *trip = [self.tripsIda objectAtIndex:[numIda intValue]];
        for (int j = 0; j < [trip count]; ++j) {
            NSString *stopID1 = [trip objectAtIndex:j];
            NSNumber *numStop1 = [self.busHash objectForKey:stopID1];
            MVAStop *stop =[self.busStops objectAtIndex:[numStop1 intValue]];
            if (stop.routes == nil) stop.routes = [[NSMutableArray alloc] init];
            if (![stop.routes containsObject:route.routeID]) [stop.routes addObject:route.routeID];
        }
        trip = [self.tripsVuelta objectAtIndex:[numVuelta intValue]];
        for (int j = 0; j < [trip count]; ++j) {
            NSString *stopID1 = [trip objectAtIndex:j];
            NSNumber *numStop1 = [self.busHash objectForKey:stopID1];
            MVAStop *stop =[self.busStops objectAtIndex:[numStop1 intValue]];
            if (stop.routes == nil) stop.routes = [[NSMutableArray alloc] init];
            if (![stop.routes containsObject:route.routeID]) [stop.routes addObject:route.routeID];
        }
    }
    int numStops = (int)[self.busStops count];
    for (int i = 0; i < numStops; ++i) {
        MVAStop *stop = [self.busStops objectAtIndex:i];
        if ([stop.routes count] > 1) {
            for (int j = 1; j < [stop.routes count]; ++j) {
                NSString *routeID = [stop.routes objectAtIndex:j];
                NSNumber *pos = [self.busRoutesHash objectForKey:routeID];
                MVARoute *route = [self.busRoutes objectAtIndex:[pos intValue]];
                MVAStop *stopCopy = [[MVAStop alloc] init];
                stopCopy = [stop copy];
                stopCopy.stopID = [stop.stopID stringByAppendingString:[@"+" stringByAppendingString:route.routeID]];
                stopCopy.routes = [[NSMutableArray alloc] initWithObjects:route.routeID,nil];
                NSNumber *numIda = [self.tripsHashIda objectForKey:route.routeID];
                NSNumber *numVuelta = [self.tripsHashVuelta objectForKey:route.routeID];
                NSMutableArray *trip = [[self.tripsIda objectAtIndex:[numIda intValue]] mutableCopy];
                for (int k = 0; k < [trip count]; ++k) {
                    NSString *stopID1 = [trip objectAtIndex:k];
                    if ([stopID1 isEqualToString:stop.stopID]) {
                        [trip setObject:stopCopy.stopID atIndexedSubscript:k];
                    }
                }
                [self.tripsIda setObject:trip atIndexedSubscript:[numIda intValue]];
                trip = [[self.tripsVuelta objectAtIndex:[numVuelta intValue]] mutableCopy];
                for (int k = 0; k < [trip count]; ++k) {
                    NSString *stopID1 = [trip objectAtIndex:k];
                    if ([stopID1 isEqualToString:stop.stopID]) {
                        [trip setObject:stopCopy.stopID atIndexedSubscript:k];
                    }
                }
                [self.tripsVuelta setObject:trip atIndexedSubscript:[numVuelta intValue]];
                [self.busHash setObject:[NSNumber numberWithInt:(int)[self.busStops count]] forKey:stopCopy.stopID];
                [self.busStops addObject:stopCopy];
            }
            NSString *routeID = [stop.routes objectAtIndex:0];
            stop.routes = [[NSMutableArray alloc] initWithObjects:routeID,nil];
        }
    }
}

-(double)frequencieForStop:(MVAStop *)stop andTime:(double)currentTime andCalendar:(NSString *)serviceID
{
    NSNumber *posIda = [self.tripsHashIda objectForKey:[stop.routes firstObject]];
    NSArray *seq = nil;
    NSArray *freqs = nil;
    if (posIda == nil) {
        NSNumber *posVuelta = [self.tripsHashVuelta objectForKey:[stop.routes firstObject]];
        NSNumber *pos = [self.busRoutesHash objectForKey:[stop.routes firstObject]];
        if ((posVuelta != nil) && (pos != nil)) {
            seq = [self.tripsVuelta objectAtIndex:[posVuelta intValue]];
            freqs = [self.frequencies objectAtIndex:[pos intValue]];
        }
    }
    else {
        NSNumber *pos = [self.busRoutesHash objectForKey:[stop.routes firstObject]];
        if (pos != nil) {
            seq = [self.tripsIda objectAtIndex:[posIda intValue]];
            freqs = [self.frequencies objectAtIndex:[pos intValue]];
        }
    }
    
    NSString *firstStop = [seq firstObject];
    NSNumber *firstPos = [self.busHash objectForKey:firstStop];
    MVAStop *stopA = [self.busStops objectAtIndex:[firstPos intValue]];
    double dist = [self distanceForCoordinates:CLLocationCoordinate2DMake(stopA.latitude, stopA.longitude)
                                andCoordinates:CLLocationCoordinate2DMake(stop.latitude, stop.longitude)];
    double busSpeed = (197.0 / 36.0);
    double time = currentTime - (dist / busSpeed);
    for (int i = 0; i < [freqs count]; ++i) {
        MVAFrequencies *f = [freqs objectAtIndex:i];
        double ini = [self timeToInt:f.startTime];
        double fin = [self timeToInt:f.endTime];
        if ((ini <= time) && (time <= fin) && ([f.tripID hasSuffix:serviceID])) {
            return [f.headway doubleValue];
        }
    }
    
    return DBL_MAX;
}

/**
 *  Returns an integer with the time given respresented in seconds
 *
 *  @param time The time ins NSString
 *
 *  @return The integer with the time in seconds
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
 *  Haversine distance between two coordinates
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
    
    return (R * c);
}

#pragma mark - parser methods

/**
 *  CHCSVParserDelegate method. Indicates when the parser has begun a new document
 *
 *  @param parser A CHCSVParser object
 *
 *  @since version 1.0
 */
- (void)parserDidBeginDocument:(CHCSVParser *)parser
{
    self.line = 0;
    self.indexRouteIda = 0;
    self.indexRouteVuelta = 0;
    if (![self.docName isEqualToString:@"frequencies.txt"]) {
        self.tripsIda = [[NSMutableArray alloc] initWithCapacity:100];
        self.tripsHashIda = [[NSMutableDictionary alloc] initWithCapacity:100];
        self.tripsVuelta = [[NSMutableArray alloc] initWithCapacity:100];
        self.tripsHashVuelta = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    else {
        self.frequencies = [[NSMutableArray alloc] initWithCapacity:100];
        for (int i = 0; i < [self.busRoutes count]; ++i) {
            [self.frequencies addObject:[[NSMutableArray alloc] init]];
        }
        
    }
    self.ida = YES;
}

/**
 *  CHCSVParserDelegate method. Indicates when the parser has begun a new line of the document
 *
 *  @param parser       A CHCSVParser object
 *  @param recordNumber The number of the line being parsed
 *
 *  @since version 1.0
 */
- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
    self.busSeq = [[MVABusSeq alloc] init];
    self.route = [[MVARoute alloc] init];
    self.stop = [[MVAStop alloc] init];
    self.freq = [[MVAFrequencies alloc] init];
}

/**
 *  CHCSVParserDelegate method. Indicates when the parser has read a new field of the current line
 *
 *  @param parser     A CHCSVParser object
 *  @param field      The field that has been read
 *  @param fieldIndex The index of this field in the line
 *
 *  @since version 1.0
 */
- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
    if ([self.docName isEqualToString:@"tripBuses.txt"]) {
        if (fieldIndex == 0) {
            NSString *string = field;
            NSString *match = @"-";
            NSString *preTel;
            NSString *postTel;
            
            NSScanner *scanner = [NSScanner scannerWithString:string];
            [scanner scanUpToString:match intoString:&preTel];
            
            [scanner scanString:match intoString:nil];
            postTel = [string substringFromIndex:scanner.scanLocation];
            self.busSeq.routeID = preTel;
            if ([field hasPrefix:[preTel stringByAppendingString:@"-1"]]) self.ida = YES;
            else self.ida = NO;
        }
        else if (fieldIndex == 3) {
            self.busSeq.stopID = field;
        }
        else if (fieldIndex == 4) {
            self.busSeq.pos = field;
        }
    }
    else if ([self.docName isEqualToString:@"stopBuses.txt"]) {
        [self.stop insertElement:field atIndex:fieldIndex isFGC:NO];
    }
    else if ([self.docName isEqualToString:@"frequencies.txt"]) {
        [self.freq insertElement:field atIndex:fieldIndex];
    }
    else {
        [self.route insertElement:field atIndex:fieldIndex isFGC:NO];
    }
}

/**
 *  CHCSVParserDelegate method. Indicates when the aprser has finished reading a line
 *
 *  @param parser       A CHCSVParser object
 *  @param recordNumber The number of the line dad has been parsed
 *
 *  @since version 1.0
 */
- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber
{
    if ([self.docName isEqualToString:@"tripBuses.txt"]) {
        if (self.ida) {
            if ([self.tripsHashIda objectForKey:self.busSeq.routeID] == nil) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:self.busSeq.stopID];
                [self.tripsIda addObject:array];
                NSNumber *num = [NSNumber numberWithInt:self.indexRouteIda];
                [self.tripsHashIda setObject:num forKey:self.busSeq.routeID];
                ++self.indexRouteIda;
            }
            else {
                NSNumber *num = [self.tripsHashIda objectForKey:self.busSeq.routeID];
                NSMutableArray *seq = [self.tripsIda objectAtIndex:[num intValue]];
                if ([seq count] < [self.busSeq.pos intValue]) {
                    [seq addObject:self.busSeq.stopID];
                    [self.tripsIda setObject:seq atIndexedSubscript:[num intValue]];
                }
            }
        }
        else {
            if ([self.tripsHashVuelta objectForKey:self.busSeq.routeID] == nil) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:self.busSeq.stopID];
                [self.tripsVuelta addObject:array];
                NSNumber *num = [NSNumber numberWithInt:self.indexRouteVuelta];
                [self.tripsHashVuelta setObject:num forKey:self.busSeq.routeID];
                ++self.indexRouteVuelta;
            }
            else {
                NSNumber *num = [self.tripsHashVuelta objectForKey:self.busSeq.routeID];
                NSMutableArray *seq = [self.tripsVuelta objectAtIndex:[num intValue]];
                if ([seq count] < [self.busSeq.pos intValue]) {
                    [seq addObject:self.busSeq.stopID];
                    [self.tripsVuelta setObject:seq atIndexedSubscript:[num intValue]];
                }
            }
        }
    }
    else if ([self.docName isEqualToString:@"stopBuses.txt"]) {
        [self.busStops addObject:self.stop];
        [self.busHash setObject:[NSNumber numberWithInt:self.line] forKey:self.stop.stopID];
    }
    else if ([self.docName isEqualToString:@"frequencies.txt"]) {
        NSScanner *scanner = [NSScanner scannerWithString:self.freq.tripID];
        NSString *prefix;
        [scanner scanUpToString:@"-" intoString:&prefix];
        NSNumber *pos = [self.busRoutesHash objectForKey:prefix];
        if (pos == nil || [pos intValue] < 0) {
            // NO QUEREMOS ESTA FREQ
            NSLog(@"HOLA");
        }
        else {
            NSMutableArray *array = [self.frequencies objectAtIndex:[pos intValue]];
            [array addObject:self.freq];
            [self.frequencies setObject:array atIndexedSubscript:[pos intValue]];
        }
    }
    else {
        [self.busRoutes addObject:self.route];
        [self.busRoutesHash setObject:[NSNumber numberWithInt:self.line] forKey:self.route.routeID];
    }
    self.busSeq = nil;
    self.route = nil;
    self.stop = nil;
    ++self.line;
}

/**
 *  CHCSVParserDelegate method. Indicates when the parser has finished parsing a document
 *
 *  @param parser A CHCSVParser object
 *
 *  @since version 1.0
 */
- (void)parserDidEndDocument:(CHCSVParser *)parser
{
    // AÑADIR OBJETO A RECIPIENTE
}

/**
 *  CHCSVParserDelegate method. Indicates that an error ocurred while parsing the document
 *
 *  @param parser A CHCSVParser object
 *  @param error  The NSError indicating why the parsing ahs failed
 *
 *  @since version 1.0
 */
- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    NSLog(@"ERROR: %@", [error localizedDescription]);
}

/**
 *  Encodes the receiver using a given archiver. (required)
 *
 *  @param coder An archiver object
 *
 *  @since version 1.0
 */
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.busStops] forKey:@"busStops"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.busHash] forKey:@"busHash"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.busRoutes] forKey:@"busRoutes"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.busRoutesHash] forKey:@"busRoutesHash"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.tripsIda] forKey:@"tripsIda"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.tripsHashIda] forKey:@"tripsHashIda"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.tripsVuelta] forKey:@"tripsVuelta"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.tripsHashVuelta] forKey:@"tripsHashVuelta"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.frequencies] forKey:@"freqs"];
}

/**
 *  Returns an object initialized from data in a given unarchiver. (required)
 *
 *  @param An unarchiver object
 *
 *  @return self, initialized using the data in decoder.
 *
 *  @since version 1.0
 */
- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[MVADataBus alloc] init];
    if (self != nil) {
        self.busStops = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"busStops"]] mutableCopy];
        self.busHash = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"busHash"]] mutableCopy];
        self.busRoutes = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"busRoutes"]] mutableCopy];
        self.busRoutesHash = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"busRoutesHash"]] mutableCopy];
        self.tripsIda = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"tripsIda"]] mutableCopy];
        self.tripsHashIda = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"tripsHashIda"]] mutableCopy];
        self.tripsVuelta = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"tripsVuelta"]] mutableCopy];
        self.tripsHashVuelta = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"tripsHashVuelta"]] mutableCopy];
        self.frequencies = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"freqs"]] mutableCopy];
    }
    return self;
}

@end