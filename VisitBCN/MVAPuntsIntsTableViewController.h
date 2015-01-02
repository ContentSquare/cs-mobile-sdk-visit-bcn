//
//  MVAPuntsIntsTableViewController.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is a subclass of UIViewController and is used to display the list of points of interest of the app
 *
 *  @since version 1.0
 */

#import <UIKit/UIKit.h>

@interface MVAPuntsIntsTableViewController : UIViewController

/**
 * The table view that needs to be controlled by this view controller
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 * The home button that aopens the menu of the app
 *
 *  @since version 1.0
 */
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@end
