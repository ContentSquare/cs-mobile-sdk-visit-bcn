//
//  MVASubwayGraph.h
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

@interface MVASubwayGraph : MVAGraph


/**
 *  This function creates the subway graph
 *
 *  @param dataTMB An object with the TMB data base
 *  @param dataFGC An object with the FGC data base
 *
 *  @since version 1.0
 */
-(void)createSubwayGraphWithDBTMB:(MVADataTMB *)dataTMB andFGC:(MVADataFGC *)dataFGC;

@end