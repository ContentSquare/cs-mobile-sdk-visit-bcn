//
//  MVACalendar.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVACalendar : NSObject

@property NSString *serviceID;
@property NSMutableArray *days;
@property NSString *startDate;
@property NSString *endDate;
@property NSMutableArray *exceptions;

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index;

@end