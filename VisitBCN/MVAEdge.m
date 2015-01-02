//
//  MVAEdge.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAEdge.h"

@implementation MVAEdge

/**
 *  This function is overriden from NSObject. Returns a copy of self
 *
 *  @return A MVAEdge object with the same data than the original object
 *
 *  @since version 1.0
 */
-(id)copy
{
    MVAEdge *edge = [[MVAEdge alloc] init];
    edge.destini  = [self.destini copy];
    edge.weight = self.weight;
    edge.tripID = self.tripID;
    edge.change = self.change;
    return edge;
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
    [coder encodeObject:self.destini forKey:@"destini"];
    [coder encodeObject:self.weight forKey:@"weight"];
    [coder encodeObject:self.tripID forKey:@"trip"];
    [coder encodeBool:self.change forKey:@"change"];
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
    self = [[MVAEdge alloc] init];
    if (self) {
        self.destini = [coder decodeObjectForKey:@"destini"];
        self.weight = [coder decodeObjectForKey:@"weight"];
        self.tripID = [coder decodeObjectForKey:@"trip"];
        self.change = [coder decodeBoolForKey:@"change"];
    }
    return self;
}



@end