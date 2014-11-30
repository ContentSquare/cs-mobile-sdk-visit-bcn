//
//  MVAFrequencies.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 13/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVAFrequencies : NSObject

@property NSString *tripID;
@property NSString *startTime;
@property NSString *endTime;
@property NSString *headway;

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index;

@end