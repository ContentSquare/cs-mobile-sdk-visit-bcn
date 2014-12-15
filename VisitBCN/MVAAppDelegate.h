//
//  MVAAppDelegate.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 02/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>
#import "MVADataTMB.h"
#import "MVADataBus.h"
#import "MVADataFGC.h"
#import "MVAPuntsIntsTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MVACustomLocationsTableViewController.h"

@interface MVAAppDelegate : UIResponder <UIApplicationDelegate>

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property (strong, nonatomic) UIWindow *window;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVADataTMB *dataTMB;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVADataFGC *dataFGC;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVADataBus *dataBus;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property NSMutableArray *puntos;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property CLLocationManager *locationManager;

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
@property CGFloat degrees;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVAPuntsIntsTableViewController *table;

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
@property MVACustomLocationsTableViewController *custom;

@end
