//
//  MVAPath.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPath.h"

@implementation MVAPath

/**
 *  This function is overriden from NSObject. Returns a copy of self
 *
 *  @return A MVAPath object with the same data than the original object
 *
 *  @since version 1.0
 */
-(id)copy
{
    MVAPath *copyElem = [[MVAPath alloc] init];
    copyElem.nodes = [self.nodes copy];
    copyElem.edges = [self.edges copy];
    copyElem.totalWeight = self.totalWeight;
    return copyElem;
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
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.nodes] forKey:@"pathNodes"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.edges] forKey:@"pathEdges"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithDouble:self.totalWeight]] forKey:@"totalWeight"];
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
    self = [[MVAPath alloc] init];
    if (self != nil) {
        self.nodes = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"pathNodes"]] mutableCopy];
        self.edges = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"pathEdges"]] mutableCopy];
        NSNumber *w = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"totalWeight"]];
        self.totalWeight = [w doubleValue];
    }
    return self;
}

@end