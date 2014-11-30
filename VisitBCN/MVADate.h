//
//  MVADate.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVADate : NSObject

@property NSString *serviceID;
@property int date;
@property int type;

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index;

@end