//
//  MVAEdge.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVANode.h"

@interface MVAEdge : NSObject

@property MVANode *destini;
@property NSNumber *weight;
@property NSString *tripID;
@property BOOL change;

@end