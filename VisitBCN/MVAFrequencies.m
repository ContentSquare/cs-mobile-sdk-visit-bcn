//
//  MVAFrequencies.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 13/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAFrequencies.h"

@implementation MVAFrequencies

/**
 *  This function is overriden from NSObject. Returns a MVAFrequencies copy of self.
 *
 *  @return The new MVAFrequencies copied object
 *
 *  @since version 1.0
 */
-(id)copy
{
    MVAFrequencies *copyElem = [[MVAFrequencies alloc] init];
    copyElem.tripID = [self.tripID copy];
    copyElem.startTime = [self.startTime copy];
    copyElem.endTime = [self.endTime copy];
    copyElem.headway = [self.headway copy];
    return copyElem;
}

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index
{
    if (index == 0) self.tripID = elem;
    else if (index == 1) self.startTime = elem;
    else if (index == 2) self.endTime = elem;
    else if (index == 3) self.headway = elem;
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
    [coder encodeObject:self.startTime forKey:@"startTime"];
    [coder encodeObject:self.endTime forKey:@"endTime"];
    [coder encodeObject:self.headway forKey:@"headway"];
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
    self = [[MVAFrequencies alloc] init];
    if (self != nil) {
        self.tripID = (NSString *)[coder decodeObjectForKey:@"tripID"];
        self.startTime = (NSString *)[coder decodeObjectForKey:@"startTime"];
        self.endTime = (NSString *)[coder decodeObjectForKey:@"endTime"];
        self.headway = (NSString *)[coder decodeObjectForKey:@"headway"];
    }
    return self;
}

@end