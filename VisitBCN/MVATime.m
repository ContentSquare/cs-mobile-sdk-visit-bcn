//
//  MVATime.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVATime.h"

@implementation MVATime

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index
{
    if (index == 0) self.tripID = elem;
    else if (index == 1) self.arrivalTime = elem;
    else if (index == 2) self.departureTime = elem;
    else if (index == 3) self.stopID = elem;
    else if (index == 4) self.sequence = [elem intValue];
}

-(void)insertInMetro:(NSMutableArray *)subways isFGC:(BOOL)isFGC  andHash:(NSMutableDictionary *)hash andRoute:(NSString *)route
{
    NSNumber *num;
    MVAStop *stop;
    num = [hash objectForKey:self.stopID];
    stop = [subways objectAtIndex:[num intValue]];
    if (stop.times == nil) stop.times = [[NSMutableArray alloc] init];
    [stop.times addObject:self];
    if(stop.routes == nil) stop.routes = [[NSMutableArray alloc] init];
    if (![stop.routes containsObject:route]) [stop.routes addObject:route];
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
    [coder encodeObject:self.tripID forKey:@"tripID"];
    [coder encodeObject:self.arrivalTime forKey:@"arrivalTime"];
    [coder encodeObject:self.departureTime forKey:@"departureTime"];
    [coder encodeObject:self.stopID forKey:@"stopID"];
    [coder encodeInt:self.sequence forKey:@"sequence"];
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
    self = [[MVATime alloc] init];
    if (self != nil) {
        self.tripID = (NSString *)[coder decodeObjectForKey:@"tripID"];
        self.arrivalTime = (NSString *)[coder decodeObjectForKey:@"arrivalTime"];
        self.departureTime = (NSString *)[coder decodeObjectForKey:@"departureTime"];
        self.stopID = (NSString *)[coder decodeObjectForKey:@"stopID"];
        self.sequence = [coder decodeIntForKey:@"sequence"];
    }
    return self;
}

@end