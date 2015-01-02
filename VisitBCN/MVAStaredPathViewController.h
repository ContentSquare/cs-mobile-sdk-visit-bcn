//
//  MVAStaredPathViewController.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 23/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class displays a MVASavedPath object using the parallax effect and simulating a table view
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>
#import "MVASavedPath.h"

@interface MVAStaredPathViewController : UIViewController

/**
 *  The saved path that needs to be displayed
 *
 *  @see MVASavedPath class
 *  @since version 1.0
 */
@property MVASavedPath *savedPath;

@end
