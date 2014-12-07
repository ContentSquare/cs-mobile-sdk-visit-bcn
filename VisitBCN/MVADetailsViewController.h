//
//  MVADetailsTableViewController.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 2/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVAPath.h"
#import "MVAPunInt.h"
#import <CoreLocation/CoreLocation.h>
#import "MVAGraphs.h"

@interface MVADetailsViewController : UIViewController

@property MVAPunInt *punto;
@property CLLocationCoordinate2D orig;

@property MVAPath *subwayPath;
@property MVAPath *busPath;
@property MVAGraphs *graphs;

@property double walkDist;
@property double walkTime;

@property double carDist;
@property double carTime;

@property double initTime;

@end
