//
//  MVANode.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVANode.h"

@implementation MVANode

/**
 *  <#Description#>
 *
 *  @param object <#object description#>
 *
 *  @return <#return value description#>
 */
-(BOOL)isEqual:(id)object
{
    MVANode *nodeB = (MVANode *)object;
    return [self.stop isEqual:nodeB.stop];
}

/**
 *  This function is overriden from NSObject. Returns a copy of self
 *
 *  @return A MVANode object witht he same data than the original object
 *
 *  @since version 1.0
 */
-(id)copy
{
    MVANode *copia = [[MVANode alloc] init];
    copia.stop = [self.stop copy];
    copia.distance = [self.distance copy];
    copia.score = [self.score copy];
    copia.pathNodes = [self.pathNodes mutableCopy];
    copia.pathEdges = [self.pathEdges mutableCopy];
    copia.identificador = self.identificador;
    copia.previous = [self.previous copy];
    copia.type = self.type;
    return copia;
}

/**
 *  Encodes the receiver using a given archiver. (required)
 *
 *  @param coder An archiver object
 *
 *  @since version 1.0
 */
- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.stop forKey:@"stop"];
    [coder encodeObject:[NSNumber numberWithInt:self.identificador] forKey:@"identificador"];
    [coder encodeObject:[NSNumber numberWithInt:self.type] forKey:@"type"];
}

/**
 *  Returns an object initialized from data in a given unarchiver. (required)
 *
 *  @param An unarchiver object
 *
 *  @return self, initialized using the data in decoder.
 *
 *  @since version 1.0
 */
- (id)initWithCoder:(NSCoder *)coder;
{
    self = [[MVANode alloc] init];
    if (self) {
        self.stop = [coder decodeObjectForKey:@"stop"];
        self.identificador = [[coder decodeObjectForKey:@"identificador"] intValue];
        self.type = [[coder decodeObjectForKey:@"type"] intValue];
    }
    return self;
}

@end