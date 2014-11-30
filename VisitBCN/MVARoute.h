//
//  MVARoute.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVARoute : NSObject

@property NSString* routeID;
@property int agencyID;
@property NSString* shortName;
@property NSString* longName;
@property int type;
@property NSURL* url;
@property UIColor* color;
@property UIColor* textColor;
@property NSMutableArray *trips;

-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index isFGC:(BOOL)isFGC;

@end