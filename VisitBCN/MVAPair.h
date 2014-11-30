//
//  MVAPair.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 25/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVAPair : NSObject

@property double first;
@property int second;

-(BOOL)bigger:(MVAPair *)p;
-(BOOL)lessOrEqual:(MVAPair *)p;

@end
