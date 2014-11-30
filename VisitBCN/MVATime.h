//
//  MVATime.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVAStop.h"

@interface MVATime : NSObject

@property NSString *tripID;
@property NSString *arrivalTime;
@property NSString *departureTime;
@property NSString *stopID;
@property int sequence;

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index;
-(void)insertInMetro:(NSMutableArray *)subways isFGC:(BOOL)isFGC andHash:(NSMutableDictionary *)hash andRoute:(NSString *)route;

@end