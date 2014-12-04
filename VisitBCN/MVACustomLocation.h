//
//  MVACustomLocation.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 3/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MVACustomLocation : NSObject

@property NSString *name;
@property CLLocationCoordinate2D coordinates;
@property UIImage *foto;

@end
