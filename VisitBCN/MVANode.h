//
//  MVANode.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVAStop.h"

@interface MVANode : NSObject

@property MVAStop *stop;
@property NSNumber *distance;
@property NSNumber *score;
@property NSMutableArray *pathNodes;
@property NSMutableArray *pathEdges;
@property int identificador;
@property BOOL open;
@property MVANode *previous;
@property int type;

@end