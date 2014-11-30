//
//  MVANode.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 19/10/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVANode.h"

@implementation MVANode

-(BOOL)isEqual:(id)object
{
    MVANode *nodeB = (MVANode *)object;
    return [self.stop isEqualToStop:nodeB.stop];
}

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

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.stop forKey:@"stop"];
    [coder encodeObject:[NSNumber numberWithInt:self.identificador] forKey:@"identificador"];
    [coder encodeObject:[NSNumber numberWithInt:self.type] forKey:@"type"];
}

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