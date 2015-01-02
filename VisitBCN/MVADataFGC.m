//
//  MVADataFGC.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVADataFGC.h"

@interface MVADataFGC () <SSZipArchiveDelegate,CHCSVParserDelegate>

@property MVAStop *parada;
@property MVARoute *route;
@property MVATrip *trip;
@property MVADate *date;
@property MVATime *time;
@property NSString *filePathFGC;
@property NSString *outputPathFGC;
@property NSString *docName;
@property int line;

@end

@implementation MVADataFGC

/**
 *  This function is overriden from NSObject. Returns self initialized
 *
 *  @return self, initialized object
 *
 *  @since version 1.0
 */
-(id)init
{
    self.stops = [[NSMutableArray alloc] init];
    self.routes = [[NSMutableArray alloc] init];
    self.trips = [[NSMutableArray alloc] init];
    self.dates = [[NSMutableArray alloc] init];
    self.services = [[NSMutableArray alloc] init];
    self.stopsHash  = [[NSMutableDictionary alloc] init];
    self.tripsHash  = [[NSMutableDictionary alloc] init];
    self.routesHash  = [[NSMutableDictionary alloc] init];

    return self;
}

-(void)parseDataBase
{
    NSString *filePathFGC = [[NSBundle mainBundle] pathForResource:@"google_transit" ofType:@"zip"];
    NSData *dataFGC = [NSData dataWithContentsOfFile:filePathFGC];
    if (dataFGC) {
        NSString *fileNameFGC = @"google_transit.zip";
        self.filePathFGC = [NSTemporaryDirectory() stringByAppendingPathComponent:fileNameFGC];
        [dataFGC writeToFile:self.filePathFGC atomically:YES];
        [self unZip:self.filePathFGC at:@"/FGC_GTFS_ZIP"];
        //self.outputPathFGC = [self.outputPathFGC stringByAppendingString:@"/FGC"];
        [self parseGTFSAtPath:self.outputPathFGC];
    }
}

/**
 *  Function that extracts the ziped folder
 *
 *  @param filePath The path of the zip file
 *  @param folder   The name of the folder where the extracted data should be stored
 *
 *  @since version 1.0
 */
-(void)unZip:(NSString *)filePath at:(NSString *)folder
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self.outputPathFGC = [documentsDirectory stringByAppendingPathComponent:folder];
    [SSZipArchive unzipFileAtPath:filePath toDestination:self.outputPathFGC delegate:self];
}

/**
 *  This function parses the files at a given path
 *
 *  @param filesPath The path of the files that need to be parsed
 *
 *  @since version 1.0
 */
-(void)parseGTFSAtPath:(NSString *)filesPath
{
    NSError *error = nil;
    NSArray *filePathsArray = @[@"calendar_dates.txt",@"routes.txt",@"trips.txt",@"stops.txt",@"stop_times.txt",];
    double total = 0;
    if (!error) {
        MVACustomModifications *modi = [[MVACustomModifications alloc] init];
        
        for(int i = 0; i < [filePathsArray count]; ++i) {
            NSString *doc = [filePathsArray objectAtIndex:i];
            if (![modi.documentExceptions containsObject:doc]) {
                NSString *filePath = [filesPath stringByAppendingString:[@"/" stringByAppendingString:doc]];
                NSStringEncoding encoding = 0;
                NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:filePath];
                CHCSVParser * p = [[CHCSVParser alloc] initWithInputStream:stream usedEncoding:&encoding delimiter:','];
                [p setRecognizesBackslashesAsEscapes:YES];
                [p setSanitizesFields:YES];
                [p setDelegate:self];
                self.docName = (NSString *)[filePathsArray objectAtIndex:i];
                NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
                [p parse];
                NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
                double dif = (end-start);
                total += dif;
                //NSLog(@"iteration: %f", dif);
            }
        }
        //long falta = EXPECTED_TIME_TMB - total;
        //if (falta > 0) sleep(falta);
    }
    
    // LIMPIAR PARADAS AISLADAS
    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    int numStops = (int)[self.stops count];
    for (int i = 0; i < numStops; ++i) {
        MVAStop *stop = [self.stops objectAtIndex:i];
        if (stop.routes == nil) {
            [indexSet addIndex:i];
            //[self.stopsHash removeObjectForKey:stop.stopID];
        }
        else if([stop.routes count] > 1) {
            for(int j = 1; j < [stop.routes count]; ++j) {
                NSString *routeID = [stop.routes objectAtIndex:j];
                int posRoute = [[self.routesHash objectForKey:routeID] intValue];
                MVARoute *route =  [self.routes objectAtIndex:posRoute];
                MVAStop *stopCopy = [[MVAStop alloc] init];
                stopCopy = [stop copy];
                stopCopy.stopID = [stopCopy.stopID stringByAppendingString:[@"-" stringByAppendingString:route.routeID]];
                stopCopy.routes = [[NSMutableArray alloc] init];
                [stopCopy.routes addObject:route.routeID];
                stopCopy.times = [[NSMutableArray alloc] init];
                
                for (int k = 0; k < [route.trips count]; ++k) {
                    NSString *tripID = [route.trips objectAtIndex:k];
                    int posTrip = [[self.tripsHash objectForKey:tripID] intValue];
                    MVATrip *trip = [self.trips objectAtIndex:posTrip];
                    int pos = (int)[trip.sequence indexOfObject:stop.stopID];
                    if (pos >= 0) {
                        [trip.sequence setObject:stopCopy.stopID atIndexedSubscript:pos];
                        for (int k = 0; k < [stop.times count]; ++k) {
                            MVATime *time = [stop.times objectAtIndex:k];
                            if ([time.tripID isEqualToString:trip.tripID]) {
                                time.stopID = stopCopy.stopID;
                                [stopCopy.times addObject:time];
                                [stop.times removeObjectAtIndex:k];
                            }
                        }
                    }
                }
                [self.stops addObject:stopCopy];
            }
            NSString *routeID = [stop.routes objectAtIndex:0];
            stop.routes = [[NSMutableArray alloc] init];
            [stop.routes addObject:routeID];
        }
    }
    [self.stops removeObjectsAtIndexes:indexSet];
    self.stopsHash = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < [self.stops count]; ++i) {
        MVAStop *stop = [self.stops objectAtIndex:i];
        [self.stopsHash setObject:[NSNumber numberWithInt:i] forKey:stop.stopID];
    }
    NSLog(@"total difference: %.16f", total);
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
    if ([self.docName isEqualToString:@"stops.txt"]) self.parada = [[MVAStop alloc] init];
    else if ([self.docName isEqualToString:@"routes.txt"]) self.route = [[MVARoute alloc] init];
    else if ([self.docName isEqualToString:@"trips.txt"]) self.trip = [[MVATrip alloc] init];
    else if ([self.docName isEqualToString:@"calendar_dates.txt"]) self.date = [[MVADate alloc] init];
    else if ([self.docName isEqualToString:@"stop_times.txt"]) self.time = [[MVATime alloc] init];
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
    if ([self.docName isEqualToString:@"stops.txt"]) {
        if (self.line > 0) [self.parada insertElement:field atIndex:fieldIndex isFGC:YES];
    }
    else if ([self.docName isEqualToString:@"routes.txt"]) {
        if (self.line > 0) [self.route insertElement:field atIndex:fieldIndex isFGC:YES];
    }
    else if ([self.docName isEqualToString:@"trips.txt"]) {
        if (self.line > 0) [self.trip insertElement:field atIndex:fieldIndex isFGC:YES];
    }
    else if ([self.docName isEqualToString:@"calendar_dates.txt"]) {
        if (self.line > 0) [self.date insertElement:field atIndex:fieldIndex];
    }
    else if ([self.docName isEqualToString:@"stop_times.txt"]) {
        if (self.line > 0) [self.time insertElement:field atIndex:fieldIndex];
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
    if ([self.docName isEqualToString:@"stops.txt"]) {
        if (self.line > 0) {
            [self.stopsHash setObject:[NSNumber numberWithInt:(int)[self.stops count]]
                                forKey:self.parada.stopID];
            [self.stops addObject:self.parada];
        }
        self.parada = nil;
    }
    else if ([self.docName isEqualToString:@"routes.txt"]) {
        if (self.line > 0) {
            [self.routesHash setObject:[NSNumber numberWithInteger:[self.routes count]]
                                      forKey:self.route.routeID];
            [self.routes addObject:self.route];
        }
        self.route = nil;
    }
    else if ([self.docName isEqualToString:@"trips.txt"]) {
        if (self.line > 0) {
            if (([self.trip.routeID hasPrefix:@"L"] || [self.trip.routeID hasPrefix:@"S"])  && ([self.services containsObject:self.trip.serviceID])) {
                if ([self.routesHash objectForKey:self.trip.routeID] != nil) {
                    NSNumber *num = [self.routesHash objectForKey:self.trip.routeID];
                    MVARoute *route = [self.routes objectAtIndex:[num intValue]];
                    if (route.trips == nil) route.trips = [[NSMutableArray alloc] init];
                    [route.trips addObject:self.trip.tripID];
                    
                    [self.tripsHash setObject:[NSNumber numberWithInteger:[self.trips count]] forKey:self.trip.tripID];
                    [self.trips addObject:self.trip];
                }
            }
            else {
                //NSLog(@"NO QUEREMOS ESTE TRIP");
            }
        }
        self.trip = nil;
    }
    else if ([self.docName isEqualToString:@"calendar_dates.txt"]) {
        if (self.line > 0) {
            if (![self.services containsObject:self.date.serviceID]) [self.services addObject:self.date.serviceID];
            [self.dates addObject:self.date];
        }
        self.date = nil;
    }
    else if ([self.docName isEqualToString:@"stop_times.txt"]) {
        if (self.line > 0) {
            NSNumber *num = [self.tripsHash objectForKey:self.time.tripID];
            if (num != nil) {
                MVATrip *trip = [self.trips objectAtIndex:[num intValue]];
                if (trip.sequence == nil) trip.sequence = [[NSMutableArray alloc] init];
                [trip.sequence addObject:self.time.stopID];
                
                [self.time insertInMetro:self.stops isFGC:YES andHash:self.stopsHash andRoute:trip.routeID];
                
            }
            else {
               // NSLog(@"NO QUEREMOS ESTE TIME");
            }
            
        }
        self.time = nil;
    }
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

#pragma mark - Consulting functions

/**
 *  Returns the day of the week for a given date
 *
 *  @param anyDate A NSDate object
 *
 *  @return The day of the week in European mode
 *
 *  @since version 1.0
 */
-(long)dayOfWeek:(NSDate *)anyDate
{
    NSTimeInterval interval = [anyDate timeIntervalSinceReferenceDate]/(60.0*60.0*24.0);
    long dayix=((long)interval) % 7;
    return dayix;
}

#pragma mark - Saving/Loading functions

/**
 *  Encodes the receiver using a given archiver. (required)
 *
 *  @param coder An archiver object
 *
 *  @since version 1.0
 */
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.stops] forKey:@"subwayStops"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.stopsHash] forKey:@"subwayHash"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.routes] forKey:@"subRoutes"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.routesHash] forKey:@"subRoutesHash"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.trips] forKey:@"trips"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.tripsHash] forKey:@"tripsHash"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.dates] forKey:@"dates"];
}

/**
 *  Returns an object initialized from data in a given unarchiver. (required)
 *
 *  @param coder An unarchiver object
 *
 *  @return self, initialized using the data in decoder.
 *
 *  @since version 1.0
 */
- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[MVADataFGC alloc] init];
    if (self != nil) {
        self.stops = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"subwayStops"]] mutableCopy];
        self.stopsHash = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"subwayHash"]] mutableCopy];
        self.routes = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"subRoutes"]] mutableCopy];
        self.routesHash = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"subRoutesHash"]] mutableCopy];
        self.trips = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"trips"]] mutableCopy];
        self.tripsHash = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"tripsHash"]] mutableCopy];
        self.dates = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"dates"]] mutableCopy];
    }
    return self;
}

@end