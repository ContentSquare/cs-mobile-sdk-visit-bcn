//
//  MVAAppDelegate.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 02/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  App's delegate.
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
 *  The window object.
 *
 *  @since version 1.0
 */
@property (strong, nonatomic) UIWindow *window;

/**
 *  The TMB subway data base object.
 *
 *  @since version 1.0
 */
@property MVADataTMB *dataTMB;

/**
 *  The FGC data base object.
 *
 *  @since version 1.0
 */
@property MVADataFGC *dataFGC;

/**
 *  The bus datat abse object.
 *
 *  @since version 1.0
 */
@property MVADataBus *dataBus;

/**
 *  The array that will contain the Barcelona landmarks.
 *
 *  @since version 1.0
 */
@property NSMutableArray *puntos;

/**
 *  The location manager object that will control the location notifications.
 *
 *  @since version 1.0
 */
@property CLLocationManager *locationManager;

/**
 *  The last coordinates detected for this device.
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D coordinates;

/**
 *  The degrees of the device's heading.
 *
 *  @since version 1.0
 */
@property CGFloat degrees;

/**
 *  This property is used to handle the interaction between this delegate and the landmarks view controller.
 *
 *  @since version 1.0
 */
@property MVAPuntsIntsTableViewController *table;

/**
 *  This property is used to handle the interaction between this delegate and the custom locations view controller.
 *
 *  @since version 1.0
 */
@property MVACustomLocationsTableViewController *custom;

/**
 *  Function that loads all the information needed by the app.
 *
 *  @since version 1.0
 */
-(void)loadAllTheInformation;

@end