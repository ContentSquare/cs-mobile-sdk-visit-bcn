//
//  MVASavedPath.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 17/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVASavedPath.h"

@implementation MVASavedPath

/**
 *  This function is overriden from NSObject. Returns self initialized
 *
 *  @return self, initialized object
 *
 *  @since version 1.0
 */
-(id)init
{
    self.busPath = nil;
    self.subwayPath = nil;
    self.busRoutes = [[NSMutableArray alloc] init];
    self.subwayRoutes = [[NSMutableArray alloc] init];
    self.initTime = -1;
    self.initCords = CLLocationCoordinate2DMake(0, 0);
    self.customlocation = [[MVACustomLocation alloc] init];
    self.punto = [[MVAPunInt alloc] init];
    self.date = [[NSDate alloc] init];
    self.identificador = -1;
    self.walkTime = 0.0;
    self.walkDist = 0.0;
    self.carDist = 0.0;
    self.carTime = 0.0;
    return self;
}

/**
 *  This function is overriden from NSObject. Returns a MVASavedPath copy of self
 *
 *  @return The new MVASavedPath copied object
 *
 *  @since version 1.0
 */
-(id)copy
{
    MVASavedPath *copyElem = [[MVASavedPath alloc] init];
    copyElem.busPath = [self.busPath copy];
    copyElem.subwayPath = [self.subwayPath copy];
    copyElem.busRoutes = [self.subwayRoutes copy];
    copyElem.subwayRoutes = [self.subwayRoutes copy];
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
    [coder encodeObject:self.subwayPath forKey:@"subwayPath"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.subwayRoutes] forKey:@"subwayRoutes"];
    [coder encodeObject:self.busPath forKey:@"busPath"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.busRoutes] forKey:@"busRoutes"];
    [coder encodeObject:[NSNumber numberWithInt:self.initTime] forKey:@"initTime"];
    [coder encodeObject:[NSNumber numberWithDouble:self.initCords.latitude] forKey:@"coordsLatitude"];
    [coder encodeObject:[NSNumber numberWithDouble:self.initCords.longitude] forKey:@"coordsLongitude"];
    [coder encodeObject:self.customlocation forKey:@"customlocation"];
    [coder encodeObject:self.punto forKey:@"punto"];
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeDouble:self.walkTime forKey:@"walkTime"];
    [coder encodeDouble:self.walkDist forKey:@"walkDist"];
    [coder encodeDouble:self.carTime forKey:@"carTime"];
    [coder encodeDouble:self.carDist forKey:@"carDist"];
    if (self.destImage != nil) [coder encodeObject:UIImagePNGRepresentation(self.destImage) forKey:@"destImage"];
    [coder encodeObject:[NSNumber numberWithInt:self.identificador] forKey:@"identificador"];
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
    self = [[MVASavedPath alloc] init];
    if (self != nil) {
        self.subwayPath = (MVAPath *)[coder decodeObjectForKey:@"subwayPath"];
        self.subwayRoutes = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"subwayRoutes"]] mutableCopy];
        self.busPath = (MVAPath *)[coder decodeObjectForKey:@"busPath"];
        self.busRoutes = [[NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"busRoutes"]] mutableCopy];
        NSNumber *init = (NSNumber *)[coder decodeObjectForKey:@"initTime"];
        self.initTime = [init intValue];
        NSNumber *lat = [coder decodeObjectForKey:@"coordsLatitude"];
        NSNumber *lon = [coder decodeObjectForKey:@"coordsLongitude"];
        self.initCords = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
        self.customlocation = [coder decodeObjectForKey:@"customlocation"];
        self.punto = [coder decodeObjectForKey:@"punto"];
        self.date = (NSDate *)[coder decodeObjectForKey:@"date"];
        self.walkTime = [coder decodeDoubleForKey:@"walkTime"];
        self.walkDist = [coder decodeDoubleForKey:@"walkDist"];
        self.carTime = [coder decodeDoubleForKey:@"carTime"];
        self.carDist = [coder decodeDoubleForKey:@"carDist"];
        NSData *destIm = [coder decodeObjectForKey:@"destImage"];
        if (destIm != nil) self.destImage = [UIImage imageWithData:destIm];
        NSNumber *ident = (NSNumber *)[coder decodeObjectForKey:@"identificador"];
        if (ident != nil) {
            self.identificador = [ident intValue];
        }
    }
    return self;
}

@end
