//
//  MVACustomModifications.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 11/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVACustomModifications.h"

@implementation MVACustomModifications

-(id)init
{
    self.tmbEdgeConnections = [[NSMutableArray alloc] initWithCapacity:24];
    self.fgcEdgeConnections = [[NSMutableArray alloc] initWithCapacity:7];
    
    //Catalunya <-> Catalunya
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0126" second:@"001-0326" third:[NSNumber numberWithDouble:120.0]]];
    
    //Catalunya <-> Pl. Catalunya
    [self.fgcEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0126" second:@"1" third:[NSNumber numberWithDouble:120.0]]];
    
    [self.fgcEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0326" second:@"1" third:[NSNumber numberWithDouble:120.0]]];
    
    //Diagonal <-> Diagonal
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0328" second:@"001-0521" third:[NSNumber numberWithDouble:60.0]]];
    
    //Diagonal <-> Provença
    [self.fgcEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0328" second:@"2" third:[NSNumber numberWithDouble:60.0]]];
    
    [self.fgcEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0521" second:@"2" third:[NSNumber numberWithDouble:120.0]]];
    
    //Pg. de Gràcia <-> Pg. de Gràcia
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0213" second:@"001-0327" third:[NSNumber numberWithDouble:120.0]]];
    
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0213" second:@"001-0425" third:[NSNumber numberWithDouble:120.0]]];
    
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0327" second:@"001-0425" third:[NSNumber numberWithDouble:120.0]]];
    
    //Av. Carrilet <-> L'Hospitalet - Av. Carrilet
    [self.fgcEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0113" second:@"36" third:[NSNumber numberWithDouble:120.0]]];
    
    //Pl. Sants <-> Pl. Sants
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0120" second:@"001-0517" third:[NSNumber numberWithDouble:120.0]]];
    
    //Espanya <-> Espanya
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0122" second:@"001-0321" third:[NSNumber numberWithDouble:120.0]]];
    
    //Espanya <-> Pl. Espanya
    [self.fgcEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0122" second:@"31" third:[NSNumber numberWithDouble:120.0]]];
    
    [self.fgcEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0321" second:@"31" third:[NSNumber numberWithDouble:120.0]]];
    
    //Sants Estació <-> Sants Estació
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0319" second:@"001-0518" third:[NSNumber numberWithDouble:120.0]]];
    
    //Paral·lel <-> Paral·lel
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0323" second:@"001-0210" third:[NSNumber numberWithDouble:120.0]]];
    
    //Universitat <-> Universitat
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0125" second:@"001-0212" third:[NSNumber numberWithDouble:120.0]]];
    
    //Vall d'Hebron <-> Vall d'Hebron
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0333" second:@"001-0534" third:[NSNumber numberWithDouble:120.0]]];
    
    //Trinitat Nova <-> Trinitat Nova
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0339" second:@"001-0434" third:[NSNumber numberWithDouble:120.0]]];
    
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0339" second:@"001-0436" third:[NSNumber numberWithDouble:120.0]]];
    
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0434" second:@"001-0436" third:[NSNumber numberWithDouble:120.0]]];
    
    //Maragall <-> Maragall
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0431" second:@"001-0528" third:[NSNumber numberWithDouble:120.0]]];
    
    //Urquinaona <-> Urquinaona
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0127" second:@"001-0424" third:[NSNumber numberWithDouble:120.0]]];
    
    //Verdaguer <-> Verdaguer
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0427" second:@"001-0522" third:[NSNumber numberWithDouble:120.0]]];
    
    //Sagrada Família <-> Sagrada Família
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0216" second:@"001-0523" third:[NSNumber numberWithDouble:120.0]]];
    
    //La Sagrera <-> La Sagrera
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0133" second:@"001-0526" third:[NSNumber numberWithDouble:120.0]]];
    
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0133" second:@"001-0930" third:[NSNumber numberWithDouble:120.0]]];
    
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0526" second:@"001-0930" third:[NSNumber numberWithDouble:120.0]]];
    
    //La Pau <-> La Pau
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0221" second:@"001-0413" third:[NSNumber numberWithDouble:120.0]]];
    
    //Fondo <-> Fondo
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0140" second:@"001-0942" third:[NSNumber numberWithDouble:120.0]]];
    
    //Gorg <-> Gorg
    [self.tmbEdgeConnections addObject:[[MVATriple alloc] initWithFirst:@"001-0225" second:@"001-0936" third:[NSNumber numberWithDouble:120.0]]];
    
    self.documentExceptions = @[@"agency.txt",@"shapes.txt",@".DS_Store"];
    
    return self;
}

@end