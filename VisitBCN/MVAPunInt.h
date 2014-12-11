//
//  MVAPunInt.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 23/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is used to store and represent the points of interest of Barcelona that are given in the app's data base
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MVAPunInt : NSObject

/**
 *  The name of this point of interest
 *
 *  @since version 1.0
 */
@property NSString *nombre;

/**
 *  The address of this point of interest
 *
 *  @since version 1.0
 */
@property NSString *street;

/**
 *  The description of this point of interest
 *
 *  @since version 1.0
 */
@property NSString *descr;

/**
 *  The name of the small image provided for this point of interest
 *
 *  @since version 1.0
 */
@property NSString *fotoPeq;

/**
 *  The name of the big image provided for this point of interest
 */
@property NSString *fotoGr;

/**
 *  Coordinates of this point of interest
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D coordinates;

/**
 *  This color property is used to create the list that appears in the main window of the app
 *
 *  @since version 1.0
 */
@property NSString *color;

/**
 *  This property tells the application the X coordinate of the origin point that will be used to crop the small image and get a thumbnail for the map
 *
 *  @since version 1.0
 */
@property CGFloat squareX;

/**
 *  This property tells the application the Y coordinate of the origin point that will be used to crop the small image and get a thumbnail for the map
 *
 *  @since version 1.0
 */
@property CGFloat squareY;

@end