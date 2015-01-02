//
//  MVAPunInt.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 23/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPunInt.h"

@implementation MVAPunInt

/**
 *  Encodes the receiver using a given archiver. (required)
 *
 *  @param coder An archiver object
 *
 *  @since version 1.0
 */
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.nombre forKey:@"nombre"];
    [coder encodeObject:self.street forKey:@"street"];
    [coder encodeObject:self.descr forKey:@"descr"];
    [coder encodeObject:self.fotoPeq forKey:@"fotoPeq"];
    [coder encodeObject:self.fotoGr forKey:@"fotoGr"];
    [coder encodeDouble:self.coordinates.latitude forKey:@"latitude"];
    [coder encodeDouble:self.coordinates.longitude forKey:@"longitude"];
    [coder encodeObject:self.color forKey:@"color"];
    [coder encodeFloat:self.squareX forKey:@"squareX"];
    [coder encodeFloat:self.squareY forKey:@"squareY"];
    [coder encodeFloat:self.offset forKey:@"offset"];
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
    self = [[MVAPunInt alloc] init];
    if (self != nil) {
        self.nombre = [coder decodeObjectForKey:@"nombre"];
        self.street = [coder decodeObjectForKey:@"street"];
        self.descr = [coder decodeObjectForKey:@"descr"];
        self.fotoPeq = [coder decodeObjectForKey:@"fotoPeq"];
        self.fotoGr = [coder decodeObjectForKey:@"fotoGr"];
        self.coordinates = CLLocationCoordinate2DMake([coder decodeDoubleForKey:@"latitude"], [coder decodeDoubleForKey:@"longitude"]);
        self.color = [coder decodeObjectForKey:@"color"];
        self.squareX = [coder decodeDoubleForKey:@"squareX"];
        self.squareY = [coder decodeDoubleForKey:@"squareY"];
        self.offset = [coder decodeDoubleForKey:@"offset"];
    }
    return self;
}

@end