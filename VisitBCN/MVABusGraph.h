//
//  MVABusGraph.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 14/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVAGraph.h"

@interface MVABusGraph : MVAGraph

/**
 *  <#Description#>
 *
 *  @param dataBase <#dataBase description#>
 *
 *  @since version 1.0
 */
-(void)createBusGraphWithDB:(MVADataBus *)dataBase;

@end