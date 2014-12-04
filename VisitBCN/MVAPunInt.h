//
//  MVAPunInt.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 23/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MVAPunInt : NSObject

@property NSString *nombre;
@property NSString *street;
@property NSString *descr;
@property NSString *fotoPeq;
@property NSString *fotoGr;
@property CLLocationCoordinate2D coordinates;
@property NSString *color;
@property CGFloat squareX;
@property CGFloat squareY;

@end