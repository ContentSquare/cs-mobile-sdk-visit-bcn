//
//  MVADetailsTableViewController.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 2/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>
#import "MVAPath.h"
#import "MVAPunInt.h"
#import <CoreLocation/CoreLocation.h>
#import "MVAGraphs.h"

@interface MVADetailsViewController : UIViewController

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVAPunInt *punto;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D orig;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVAPath *subwayPath;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVAPath *busPath;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVAGraphs *graphs;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property double walkDist;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property double walkTime;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property double carDist;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property double carTime;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property double initTime;

@end
