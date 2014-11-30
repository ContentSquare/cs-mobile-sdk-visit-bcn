//
//  MVAFrequencies.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 13/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAFrequencies.h"

@implementation MVAFrequencies


-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index
{
    if (index == 0) self.tripID = elem;
    else if (index == 1) self.startTime = elem;
    else if (index == 2) self.endTime = elem;
    else if (index == 3) self.headway = elem;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.tripID forKey:@"tripID"];
    [coder encodeObject:self.startTime forKey:@"startTime"];
    [coder encodeObject:self.endTime forKey:@"endTime"];
    [coder encodeObject:self.headway forKey:@"headway"];
}

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