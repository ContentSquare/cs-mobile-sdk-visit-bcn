//
//  MVAPunIntViewController.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
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
@property CLLocationCoordinate2D coordinates;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property BOOL stop;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVACustomLocation *customlocation;

@end
