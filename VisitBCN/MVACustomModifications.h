//
//  MVACustomModifications.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 11/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is used to add custom modifications to the given data like, for example, connections between stops or the documents that the parser should read
 *
 *  We can represent this class as a table:
 *
 *  | TMB connections | FGC connections | Exceptions |
 *  |:---------------:|:---------------:|:----------:|
 *  |     NSArray     |     NSArray     |   NSArray  |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVATriple.h"

@interface MVACustomModifications : NSObject

/**
 *  This array contains the connections between the TMB subway stops
 *
 *  @since version 1.0
 */
@property NSMutableArray *tmbEdgeConnections;

/**
 *  This array contains the connections between the TMB and FGC subway stops
 *
 *  @since version 1.0
 */
@property NSMutableArray *fgcEdgeConnections;

/**
 *  This array contains the name of the archives that need to be parsed
 *
 *  @since version 1.0
 */
@property NSArray *documentExceptions;

@end