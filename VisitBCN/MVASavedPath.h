//
//  MVASavedPath.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 17/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is used to save the paths that the user wants
 *
 *  We can represent this class as a table:
 *
 * | Id  | SubwayP | SubwayR |  BusP   | BusR  | Walk time | Walk dist | Car time | Car dist | Init time | Init coords |  Custom location  |   Punto   | Dest image | Date |
 * |:---:|:-------:|:-------:|:-------:|:-----:|:---------:|:---------:|:--------:|:--------:|:---------:|:-----------:|:-----------------:|:---------:|:----------:|:----:|
 * | Int | MVAPath |  Array  | MVAPath | Array |  Double   |  Double   |  Double  |  Double  |    Int    |   Coords    | MVACustomLocation | MVAPunint |   Image    | Date |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVAPath.h"
#import <CoreLocation/CoreLocation.h>
#import "MVACustomLocation.h"
#import "MVAPunInt.h"

@interface MVASavedPath : NSObject

/**
 *  The identifier of this object
 *
 *  @since version 1.0
 */
@property int identificador;

/**
 *  A MVAPath object that contains the subway path
 *
 *  @see MVAPath class
 *  @since version 1.0
 */
@property MVAPath *subwayPath;

/**
 *  An array with the routes that are used by the subway path
 *
 *  @since version 1.0
 */
@property NSMutableArray *subwayRoutes;

/**
 *  A MVAPath object that contains the bus path
 *
 *  @see MVAPath class
 *  @since version 1.0
 */
@property MVAPath *busPath;

/**
 *  An array with the routes that are used by the subway path
 *
 *  @since version 1.0
 */
@property NSMutableArray *busRoutes;

/**
 *  The time needed to walk from the origin to the destination
 *
 *  @since version 1.0
 */
@property double walkTime;

/**
 *  The distance walking distance from the origin to the destination
 *
 *  @since version 1.0
 */
@property double walkDist;

/**
 *  The travel time in car from the origin to the destination
 *
 *  @since version 1.0
 */
@property double carTime;

/**
 *  The distance in car from the origin to the destination
 *
 *  @since version 1.0
 */
@property double carDist;

/**
 *  The initial time of the paths in seconds
 *
 *  @since version 1.0
 */
@property int initTime;

/**
 *  The initial coordinates of the paths in seconds
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D initCords;

/**
 *  The name of the initial location of the paths in seconds
 *
 *  @see MVACustomLocation class
 *  @since version 1.0
 */
@property MVACustomLocation *customlocation;

/**
 *  The name of the initial location of the paths in seconds
 *
 *  @see MVAPunInt class
 *  @since version 1.0
 */
@property MVAPunInt *punto;

/**
 *  An image that represents the destination
 *
 *  @since version 1.0
 */
@property UIImage *destImage;

/**
 *  The date of the paths
 *
 *  @since version 1.0
 */
@property NSDate *date;

@end
