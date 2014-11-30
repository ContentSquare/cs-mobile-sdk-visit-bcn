//
//  MVADate.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVADate.h"

@implementation MVADate

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index
{
    if (index == 0) self.serviceID = elem;
    else if (index == 1) self.date = [elem intValue];
    else if (index == 2) self.type = [elem intValue];
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.serviceID forKey:@"serviceID"];
    [coder encodeInt:self.date forKey:@"date"];
    [coder encodeInt:self.type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[MVADate alloc] init];
    if (self != nil) {
        self.serviceID = (NSString *)[coder decodeObjectForKey:@"serviceID"];
        self.date = [coder decodeIntForKey:@"date"];
        self.type = [coder decodeIntForKey:@"type"];
    }
    return self;
}

@end