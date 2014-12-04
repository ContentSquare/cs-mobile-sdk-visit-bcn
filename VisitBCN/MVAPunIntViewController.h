//
//  MVAPunIntViewController.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVAAppDelegate.h"
#import "Reachability.h"
#import "MVAPunInt.h"
#import "MVACustomLocation.h"

@interface MVAPunIntViewController : UIViewController

@property MVAPunInt *punto;
@property CLLocationCoordinate2D coordinates;
@property BOOL stop;
@property MVACustomLocation *customlocation;

@end
