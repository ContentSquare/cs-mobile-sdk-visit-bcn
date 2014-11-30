//
//  MVAPair.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 25/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPair.h"

@implementation MVAPair

-(BOOL)bigger:(MVAPair *)p
{
    return (self.first > p.first);
}

-(BOOL)lessOrEqual:(MVAPair *)p
{
    return (self.first <= p.first);
}

@end
