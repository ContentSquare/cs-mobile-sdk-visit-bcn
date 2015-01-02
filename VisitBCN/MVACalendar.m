//
//  MVACalendar.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVACalendar.h"

@implementation MVACalendar

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index
{
    if (index == 0) {
        self.serviceID = elem;
        self.days = [[NSMutableArray alloc] init];
    }
    else if ((index >= 1) && (index <= 7)) [self.days addObject:elem];
    else if (index == 8) self.startDate = elem;
    else if (index == 9) self.endDate = elem;
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
    [coder encodeObject:self.serviceID forKey:@"serviceID"];
    [coder encodeObject:self.days forKey:@"days"];
    [coder encodeObject:self.startDate forKey:@"startDate"];
    [coder encodeObject:self.endDate forKey:@"endDate"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.exceptions] forKey:@"exceptions"];
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
    self = [[MVACalendar alloc] init];
    if (self != nil) {
        self.serviceID = (NSString *)[coder decodeObjectForKey:@"serviceID"];
        self.days = [coder decodeObjectForKey:@"days"];
        self.startDate = (NSString *)[coder decodeObjectForKey:@"startDate"];
        self.endDate = (NSString *)[coder decodeObjectForKey:@"endDate"];
        self.exceptions = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"exceptions"]] mutableCopy];
    }
    return self;
}

@end