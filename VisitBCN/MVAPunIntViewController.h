//
//  MVAPunIntViewController.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UIViewController and is used to display the information of a point.
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>
#import "MVAAppDelegate.h"
#import "Reachability.h"
#import "MVAPunInt.h"
#import "MVACustomLocation.h"

@interface MVAPunIntViewController : UIViewController

/**
 *  The point to be displayed.
 *
 *  @see MVAPunInt class
 *  @since version 1.0
 */
@property MVAPunInt *punto;

/**
 *  The coordinates that will be used for the computations.
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D coordinates;

/**
 *  This bool is used to indicate the algorithm to stop the execution.
 *
 *  @since version 1.0
 */
@property BOOL stop;

/**
 *  The custom location selected by the user, the default value is nil.
 *
 *  @see MVACustomLocation class
 *  @since version 1.0
 */
@property MVACustomLocation *customlocation;

@end
