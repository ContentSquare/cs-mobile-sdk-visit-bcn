//
//  MVAAppDelegate.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 02/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVADataTMB.h"
#import "MVADataBus.h"
#import "MVADataFGC.h"
#import "MVAPuntsIntsTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MVACustomLocationsTableViewController.h"

@interface MVAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property MVADataTMB *dataTMB;
@property MVADataFGC *dataFGC;
@property MVADataBus *dataBus;
@property NSMutableArray *puntos;
@property CLLocationManager *locationManager;
@property CLLocationCoordinate2D coordinates;
@property CGFloat degrees;
@property MVAPuntsIntsTableViewController *table;
@property MVACustomLocationsTableViewController *custom;

@end
