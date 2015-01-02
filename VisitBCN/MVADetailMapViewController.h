//
//  MVADetailMap.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 18/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UIViewController and is used to display the given path on a map.
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import "MVASavedPath.h"
#import "MVAPunInt.h"

@interface MVADetailMapViewController: UIViewController

/**
 *  The path to be displayed.
 *
 *  @see MVASavedPath class
 *  @since version 1.0
 */
@property MVASavedPath *savedPath;

/**
 *  A bool tha tindicates if the path given is for the subway or the bus network.
 *
 *  @since version 1.0
 */
@property BOOL subway;

@end
