//
//  MVACustomLocation.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 3/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVACustomLocation.h"

@implementation MVACustomLocation

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:self.name] forKey:@"name"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithDouble:self.coordinates.latitude]] forKey:@"coordsLatitude"];
    [coder encodeObject:(NSData *)[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithDouble:self.coordinates.longitude]] forKey:@"coordsLongitude"];
    
    if(self.foto != nil) {
        NSData *data =  UIImageJPEGRepresentation(self.foto, 1.0f);
        [coder encodeObject:data forKey:@"imagen"];
    }
    
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[MVACustomLocation alloc] init];
    if (self != nil) {
        self.name = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"name"]];
        NSNumber *lat = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"coordsLatitude"]];
        NSNumber *lon = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)[coder decodeObjectForKey:@"coordsLongitude"]];
        self.coordinates = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
        NSData *data = [coder decodeObjectForKey:@"imagen"];
        self.foto = [UIImage imageWithData:data];
    }
    return self;
}
@end
