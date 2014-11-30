//
//  MVADataFGC.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSZipArchive.h"
#import "CHCSVParser.h"
#import "MVAStop.h"
#import "MVARoute.h"
#import "MVATrip.h"
#import "MVADate.h"
#import "MVATime.h"

@interface MVADataFGC : NSObject

@property NSMutableArray *dates;
@property NSMutableArray *services;
@property NSMutableArray *stops;
@property NSMutableDictionary *stopsHash;
@property NSMutableArray *routes;
@property NSMutableDictionary *routesHash;
@property NSMutableArray *trips;
@property NSMutableDictionary *tripsHash;

-(void)parseDataBase;

@end