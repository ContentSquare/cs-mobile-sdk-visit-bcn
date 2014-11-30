//
//  MVATrip.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVATrip : NSObject

@property NSString *routeID;
@property NSString* serviceID;
@property NSString* tripID;
@property NSString* directionID;
@property NSString* tripName;
@property BOOL direcUP;
@property NSMutableArray *sequence;
@property NSMutableArray *freqs;

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index isFGC:(BOOL)isFGC;

@end
