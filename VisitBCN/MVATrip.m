//
//  MVATrip.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVATrip.h"

@implementation MVATrip

/**
 *  This function is overriden from NSObject. Returns a MVATrip copy of self.
 *
 *  @return The new MVATrip copied object
 *
 *  @since version 1.0
 */
-(id)copy
{
    MVATrip *copyElem = [[MVATrip alloc] init];
    copyElem.routeID = [self.routeID copy];
    copyElem.serviceID = [self.serviceID copy];
    copyElem.tripID = [self.tripID copy];
    copyElem.directionID = [self.directionID copy];
    copyElem.tripName = [self.tripName copy];
    copyElem.direcUP = self.direcUP;
    copyElem.sequence = [self.sequence copy];
    copyElem.freqs = [self.freqs copy];
    return copyElem;
}

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index isFGC:(BOOL)isFGC
{
    if (isFGC) {
        self.directionID = @"";
        if (index == 0) self.routeID = elem;
        else if (index == 1) self.serviceID = elem;
        else if (index == 2) self.tripID = elem;
        else if (index == 3) self.tripName = elem;
        else if (index == 4) {
            if ([elem hasSuffix:@"asc"]) self.direcUP = YES;
            else self.direcUP = NO;
        }
    }
    else {
        self.tripName = @"";
        if (index == 0) self.routeID = elem;
        else if (index == 1) self.serviceID = elem;
        else if (index == 2) self.tripID = elem;
        else if (index == 3) {
            self.directionID = elem;
        }
        else if (index == 4) {
            self.direcUP = [elem boolValue];
        }
    }
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
    [coder encodeObject:self.routeID forKey:@"routeID"];
    [coder encodeObject:self.serviceID forKey:@"serviceID"];
    [coder encodeObject:self.tripID forKey:@"tripID"];
    [coder encodeObject:self.directionID forKey:@"directionID"];
    [coder encodeObject:self.tripName forKey:@"tripName"];
    [coder encodeBool:self.direcUP forKey:@"direcUP"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.sequence] forKey:@"sequence"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.freqs] forKey:@"freqs"];
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
    self = [[MVATrip alloc] init];
    if (self != nil) {
        self.routeID = (NSString *)[coder decodeObjectForKey:@"routeID"];
        self.serviceID = (NSString *)[coder decodeObjectForKey:@"serviceID"];
        self.tripID = (NSString *)[coder decodeObjectForKey:@"tripID"];
        self.directionID = (NSString *)[coder decodeObjectForKey:@"directionID"];
        self.tripName = (NSString *)[coder decodeObjectForKey:@"tripName"];
        self.direcUP = [coder decodeBoolForKey:@"direcUP"];
        self.sequence = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"sequence"]] mutableCopy];
        self.freqs = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"freqs"]] mutableCopy];
    }
    return self;
}

@end
