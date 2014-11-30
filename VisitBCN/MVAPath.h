//
//  MVAPath.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVANode.h"
#import "MVAEdge.h"

@interface MVAPath : NSObject

@property NSMutableArray *nodes;
@property NSMutableArray *edges;
@property double totalWeight;

@end