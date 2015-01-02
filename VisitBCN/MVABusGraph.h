//
//  MVABusGraph.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of the MVAGraph class
 *
 *  @see MVAGraph class
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVAGraph.h"

@interface MVABusGraph : MVAGraph

/**
 *  This function creates the bus graph
 *
 *  @param dataBase An object containing the bus data base
 *
 *  @since version 1.0
 */
-(void)createBusGraphWithDB:(MVADataBus *)dataBase;

@end