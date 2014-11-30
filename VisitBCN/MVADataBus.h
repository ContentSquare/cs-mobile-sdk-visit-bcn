//
//  MVADataBus.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCSVParser.h"
#import "MVABusSeq.h"
#import "MVAStop.h"
#import "MVARoute.h"
#import "MVAFrequencies.h"

@interface MVADataBus : NSObject

@property NSMutableArray *busStops;
@property NSMutableDictionary *busHash;
@property NSMutableArray *busRoutes;
@property NSMutableDictionary *busRoutesHash;
@property NSMutableArray *tripsIda;
@property NSMutableDictionary *tripsHashIda;
@property NSMutableArray *tripsVuelta;
@property NSMutableDictionary *tripsHashVuelta;
@property NSMutableArray *frequencies;

- (void)parseDataBase;

-(double)frequencieForStop:(MVAStop *)stop andTime:(double)currentTime andCalendar:(NSString *)serviceID;

@end