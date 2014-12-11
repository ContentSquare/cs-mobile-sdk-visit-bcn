//
//  MVAPriorityQueue.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 25/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class creates a priority queue for the given class MVAPair
 *
 *  @see MVAPair class
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVAPair.h"

@interface MVAPriorityQueue : NSObject

/**
 *  Predefined constructor
 *
 *  @return The MVAPriorityQueue object created
 *
 *  @since version 1.0
 */
-(id)init;

/**
 *  Constructor with capacity
 *
 *  @return The MVAPriorityQueue object created with the given capacity
 *
 *  @since version 1.0
 */
-(id)initWithCapacity:(NSUInteger)numItems;

/**
 *  Function to insert an element in the priority queue
 *
 *  @param pair MVAPair object that needs to be inserted in the priority queue
 *
 *  @see MVAPair class
 *  @since version 1.0
 */
-(void)insertar:(MVAPair *)pair;

/**
 *  Function that returns if the priority que is empty
 *
 *  @return Boolean that indicates if the priority queue is empty or not
 *
 *  @since version 1.0
 */
-(BOOL)isEmpty;

/**
 *  Function that returns the first object of the priority queue
 *
 *  @return The first object of the priority queue
 *
 *  @see MVAPair class
 *  @since version 1.0
 */
-(MVAPair *)firstObject;

/**
 *  Function that removes the first object
 *
 *  @since version 1.0
 */
-(void)removeFirst;

/**
 *  Function that returns the position of an object inside the priority queue. The objects are analised by the second element
 *
 *  @param identificador The identifier of the object that wants to be found
 *
 *  @return The position of the desired object. If the object doesn't exist in the priority queue the function returns -1
 *
 *  @since version 1.0
 */
-(int)posOfElement:(int)identificador;

/**
 *  This functions returns the MVAPAir object stored at the given position
 *
 *  @param index The position of the object that needs to be retreived
 *
 *  @return The object that is stored in the position 'index' inside the priority queue
 *
 *  @see MVAPair class
 *  @since version 1.0
 */
-(MVAPair *)objectAtIndex:(int)index;

/**
 *  This functions sets the MVAPair object stored at the given position
 *
 *  @param p     The MVAPair object that needs to be stored
 *  @param index The position where the object needs to be stored
 *
 *  @see MVAPair class
 *  @since version 1.0
 */
-(void)setObject:(MVAPair *)p atIndex:(int)index;

@end
