//
//  MVAStop.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 03/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAStop.h"

@implementation MVAStop

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index isFGC:(BOOL)isFGC
{
    if (index == 0) {
        if (isFGC) self.latitude = [elem doubleValue];
        else self.stopID = elem;
    }
    else if (index == 1) {
        if (isFGC) self.longitude = [elem doubleValue];
        else self.code = [elem intValue];
    }
    else if (index == 2) {
        self.name = elem;
    }
    else if (index == 3) {
        if (isFGC) self.stopID = elem;
        else self.latitude = [elem doubleValue];
    }
    else if (index == 4) {
        self.longitude = [elem doubleValue];
    }
}

-(void)insertInBus:(NSMutableArray *)busStops metro:(NSMutableArray *)subwayStops isFGC:(BOOL)isFGC
{
    if (isFGC) [subwayStops addObject:self];
    else if([self.stopID hasPrefix:@"001"]) [subwayStops addObject:self];
    else [busStops addObject:self];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToStop:other];
}

-(BOOL)isEqualToStop:(MVAStop *)stop
{
    return (self.code == stop.code);
}

-(id)copy
{
    MVAStop *copia = [[MVAStop alloc] init];
    copia.stopID = self.stopID;
    copia.code = self.code;
    copia.name = self.name;
    copia.latitude = self.latitude;
    copia.longitude = self.longitude;
    copia.times = self.times;
    copia.routes = self.routes;
    return copia;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.stopID forKey:@"stopID"];
    [coder encodeInt:self.code forKey:@"code"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeDouble:self.latitude forKey:@"latitude"];
    [coder encodeDouble:self.longitude forKey:@"longitude"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.times] forKey:@"times"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.routes] forKey:@"routes"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[MVAStop alloc] init];
    if (self != nil) {
        self.stopID = (NSString *) [coder decodeObjectForKey:@"stopID"];
        self.code = (int)[coder decodeIntForKey:@"code"];
        self.name = (NSString *) [coder decodeObjectForKey:@"name"];
        self.latitude = (double) [coder decodeDoubleForKey:@"latitude"];
        self.longitude = (double) [coder decodeDoubleForKey:@"longitude"];
        self.times = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"times"]] mutableCopy];
        self.routes = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"routes"]] mutableCopy];
    }
    return self;
}

@end