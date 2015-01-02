//
//  MVADetailsTableViewController.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 2/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UIViewController and is used to display the details of the paths.
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>
#import "MVAPath.h"
#import "MVAPunInt.h"
#import <CoreLocation/CoreLocation.h>
#import "MVAGraphs.h"
#import "MVACustomLocation.h"

@interface MVADetailsViewController : UIViewController

/**
 *  The point to be displayed and that will be used to calculate the itineraries.
 *
 *  @see MVAPunInt class
 *  @since version 1.0
 */
@property MVAPunInt *punto;


/**
 *  A custom location selected by the user. The default value is nil.
 *
 *  @see MVACustomLocation class
 *  @since version 1.0
 */
@property MVACustomLocation *customlocation;

/**
 *  The origin's coordinates.
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D orig;

/**
 *  A MVAPath object that contains the subway path
 *
 *  @see MVAPath class
 *  @since version 1.0
 */
@property MVAPath *subwayPath;

/**
 *  A MVAPath object that contains the bus path
 *
 *  @see MVAPath class
 *  @since version 1.0
 */
@property MVAPath *busPath;

/**
 *  The graphs that will be used to compute the subway and bus paths.
 *
 *  @see MVAGraphs class
 *  @since version 1.0
 */
@property MVAGraphs *graphs;

/**
 *  The distance walking distance from the origin to the destination
 *
 *  @since version 1.0
 */
@property double walkDist;

/**
 *  The time needed to walk from the origin to the destination
 *
 *  @since version 1.0
 */
@property double walkTime;

/**
 *  The distance in car from the origin to the destination
 *
 *  @since version 1.0
 */
@property double carDist;

/**
 *  The travel time in car from the origin to the destination
 *
 *  @since version 1.0
 */
@property double carTime;

/**
 *  The initial time of the paths in seconds
 *
 *  @since version 1.0
 */
@property double initTime;

@end
