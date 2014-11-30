//
//  MVAStop.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 03/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVACustomModifications.h"

@interface MVAStop : NSObject

@property NSString *stopID;
@property int code;
@property NSString *name;
@property double latitude;
@property double longitude;
@property NSMutableArray *times;
@property NSMutableArray *routes;

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index isFGC:(BOOL)isFGC;
-(void)insertInBus:(NSMutableArray *)busStops metro:(NSMutableArray *)subwayStops isFGC:(BOOL)isFGC;
-(BOOL)isEqualToStop:(MVAStop *)stop;

@end