//
//  MVAPair.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 11/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVATriple.h"

@implementation MVATriple

-(id)initWithFirst:(id)first second:(id)second third:(id)third
{
    self = [super init];
    self.elem1 = first;
    self.elem2 = second;
    self.elem3 = third;
    return self;
}

@end