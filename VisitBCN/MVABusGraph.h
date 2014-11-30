//
//  MVABusGraph.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVAGraph.h"

@interface MVABusGraph : MVAGraph

-(void)createBusGraphWithDB:(MVADataBus *)dataBase;

@end