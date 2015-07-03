//
//  MVAPair.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 11/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class creates a trio of elements
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>

@interface MVATriple : NSObject

/**
 *  The first element
 *
 *  @since version 1.0
 */
@property id elem1;

/**
 *  The second element
 *
 *  @since version 1.0
 */
@property id elem2;

/**
 *  The third element
 *
 *  @since version 1.0
 */
@property id elem3;

/**
 *  Constructor that initiates the MVATriple object with the 'first', 'second' and 'third' element
 *
 *  @param first  First element
 *  @param second Second element
 *  @param third  Third element
 *
 *  @return The MVATriple object created with the given data
 *
 *  @since version 1.0
 */
-(id)initWithFirst:(id)first second:(id)second third:(id)third;

@end