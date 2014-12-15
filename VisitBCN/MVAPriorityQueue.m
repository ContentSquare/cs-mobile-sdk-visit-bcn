//
//  MVAPriorityQueue.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 25/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPriorityQueue.h"

@interface MVAPriorityQueue()

@property int topemaxim;
@property int tope;
@property NSMutableArray *v;

@end

@implementation MVAPriorityQueue

-(id)init
{
    self = [super init];
    self.topemaxim = 11;
    self.v = [[NSMutableArray alloc] initWithCapacity:11];
    for (int i = 0; i < 11; ++i) {
        [self.v addObject:[[MVAPair alloc] init]];
    }
    self.tope = 1;
    return self;
}

-(id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    self.topemaxim = ((int)numItems + 1);
    self.v = [[NSMutableArray alloc] initWithCapacity:self.topemaxim];
    for (int i = 0; i < self.topemaxim; ++i) {
        [self.v addObject:[[MVAPair alloc] init]];
    }
    self.tope = 1;
    return self;
}

-(void)addObject:(MVAPair *)pair
{
    if (self.tope == self.topemaxim) {
        NSLog(@"Error: Inserting in a full queue");
        return;
    }
    [self.v setObject:pair atIndexedSubscript:self.tope];
    int pos = self.tope;
    self.tope += 1;
    while (pos > 1 && [[self.v objectAtIndex:(pos/2)] bigger:[self.v objectAtIndex:pos]]) {
        [self swap:(pos/2) and:pos];
        pos /= 2;
    }
}

/**
 *  This function swaps the position of two objects in the priority queue
 *
 *  @param pos1 The first position
 *  @param pos2 The second position
 */
-(void)swap:(int)pos1 and:(int)pos2
{
    MVAPair *elem = [self.v objectAtIndex:pos1];
    MVAPair *elem2 = [self.v objectAtIndex:pos2];
    [self.v setObject:elem atIndexedSubscript:pos2];
    [self.v setObject:elem2 atIndexedSubscript:pos1];
}

-(BOOL)isEmpty
{
    return (self.tope == 1);
}

-(MVAPair *)firstObject
{
    if (self.tope == 1) {
        NSLog(@"Error: The queue is empty");
        return nil;
    }
    return [self.v objectAtIndex:1];
}

-(void)removeFirst
{
    if (self.tope == 1) {
        NSLog(@"Error: The queue is empty");
        return;
    }
    [self.v setObject:[self.v objectAtIndex:(self.tope - 1)] atIndexedSubscript:1];
    [self.v setObject:[[MVAPair alloc] init] atIndexedSubscript:(self.tope - 1)];
    int pos = 1;
    self.tope -= 1;
    for (;;) {
        if (((2 * pos) + 1) < self.tope) {
            if ([[self.v objectAtIndex:(2 * pos)] lessOrEqual:[self.v objectAtIndex:((2 * pos) + 1)]]) {
                if ([[self.v objectAtIndex:pos] bigger:[self.v objectAtIndex:(2 * pos)]]) {
                    [self swap:pos and:(2 * pos)];
                    pos *= 2;
                }
                else break;
            }
            else {
                if ([[self.v objectAtIndex:pos] bigger:[self.v objectAtIndex:((2 * pos) + 1)]]) {
                    [self swap:pos and:((2 * pos) + 1)];
                    pos = ((2 * pos) + 1);
                }
                else break;
            }
        }
        else if ((2 * pos) < self.tope) {
            if ([[self.v objectAtIndex:pos] bigger:[self.v objectAtIndex:(2 * pos)]]) {
                [self swap:pos and:(2 * pos)];
                pos *= 2;
            }
            else break;
        }
        else break;
    }
}

@end
