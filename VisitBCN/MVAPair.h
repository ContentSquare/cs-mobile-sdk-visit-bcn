//
//  MVAPair.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 25/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class creates a pair of elements
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>

@interface MVAPair : NSObject

/**
 *  The first element
 *
 *  @since version 1.0
 */
@property double first;

/**
 *  The second element
 *
 *  @since version 1.0
 */
@property int second;

/**
 *  This function compares the first elements of the two pares and returns a boolean indicating if one is bigger than the other
 *
 *  @param p The second pair of the comparison
 *
 *  @return A boolean indicating if the current MVAPair object is bigger than the given
 *
 *  @since version 1.0
 */
-(BOOL)bigger:(MVAPair *)p;

/**
 *  This function compares the first elements of the two pares and returns a boolean indicating if one is smaller or equal than the other
 *
 *  @param p The second pair of the comparison
 *
 *  @return A boolean indicating if the current MVAPair object is smaller or equal than the given
 *
 *  @since version 1.0
 */
-(BOOL)lessOrEqual:(MVAPair *)p;

@end
