//
//  MVARoute.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVARoute.h"

@implementation MVARoute

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index isFGC:(BOOL)isFGC
{
    if (isFGC) {
        self.agencyID = 2;
        if (index == 0) self.routeID = elem;
        else if (index == 1) self.shortName = elem;
        else if (index == 2) self.longName = elem;
        else if (index == 3) self.type = [elem intValue];
        else if (index == 4) self.url = [NSURL URLWithString:elem];
        else if (index == 5) self.color = [self colorFromHexString:elem];
        else if (index == 6) self.textColor = [self colorFromHexString:elem];
    }
    else {
        if (index == 0) self.routeID = elem;
        else if (index == 1) self.agencyID = [elem intValue];
        else if (index == 2) self.shortName = elem;
        else if (index == 3) self.longName = elem;
        else if (index == 4) {/*NADA*/}
        else if (index == 5) self.type = [elem intValue];
        else if (index == 6) self.url = [NSURL URLWithString:elem];
        else if (index == 7) self.color = [self colorFromHexString:elem];
        else if (index == 8) self.textColor = [self colorFromHexString:elem];
    }
}

-(UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.routeID forKey:@"routeID"];
    [coder encodeInt:self.agencyID forKey:@"agencyID"];
    [coder encodeObject:self.shortName forKey:@"shortName"];
    [coder encodeObject:self.longName forKey:@"longName"];
    [coder encodeInt:self.type forKey:@"type"];
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.color forKey:@"color"];
    [coder encodeObject:self.textColor forKey:@"textColor"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.trips] forKey:@"trips"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[MVARoute alloc] init];
    if (self != nil) {
        self.routeID = (NSString *)[coder decodeObjectForKey:@"routeID"];
        self.agencyID = (int)[coder decodeIntForKey:@"agencyID"];
        self.shortName = (NSString *)[coder decodeObjectForKey:@"shortName"];
        self.longName = (NSString *)[coder decodeObjectForKey:@"longName"];
        self.type = (int)[coder decodeIntForKey:@"type"];
        self.url = (NSURL *)[coder decodeObjectForKey:@"url"];
        self.color = (UIColor *)[coder decodeObjectForKey:@"color"];
        self.textColor = (UIColor *)[coder decodeObjectForKey:@"textColor"];
        self.trips = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"trips"]] mutableCopy];
    }
    return self;
}

@end