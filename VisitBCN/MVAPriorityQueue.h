//
//  MVAPriorityQueue.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 25/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVAPair.h"

@interface MVAPriorityQueue : NSObject

-(id)init;
-(id)initWithCapacity:(NSUInteger)numItems;
-(void)insertar:(MVAPair *)pair;
-(BOOL)isEmpty;
-(MVAPair *)firstObject;
-(void)removeFirst;

@end
