//
//  MVADataBase.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
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
#import "MVACalendar.h"
#import "MVAFrequencies.h"

@interface MVADataTMB : NSObject

@property NSMutableArray *stops;
@property NSMutableDictionary *stopsHash;
@property NSMutableArray *calendars;
@property NSMutableArray *routes;
@property NSMutableDictionary *routesHash;
@property NSMutableArray *trips;
@property NSMutableDictionary *tripsHash;
@property NSMutableArray *freqs;
@property NSMutableArray *dates;

-(MVACalendar *)getCurrentCalendarforSubway:(BOOL)subway;
-(void)parseDataBase;

@end