//
//  MVALoadViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 2/1/15.
//  Copyright (c) 2015 Mauro Vime Castillo. All rights reserved.
//

#import "MVALoadViewController.h"
#import "MBProgressHUD.h"
#import "MVAAppDelegate.h"

@interface MVALoadViewController () <MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
    int num;
}

@end

@implementation MVALoadViewController

/**
 *  Function that gets called when the view controller has loaded the view
 *
 *  @since version 1.0
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/**
 *  Function that gets called when there's a memory leak or warning
 *
 *  @since version 1.0
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  Notifies the view controller that its view was added to a view hierarchy.
 *
 *  @param animated If YES, the view was added to the window using an animation.
 *
 *  @since version 1.0
 */
-(void)viewDidAppear:(BOOL)animated
{
    num = 1;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"airplane.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = @"Flying to Barcelona   ";
    [HUD setColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:0.75f]];
    [HUD show:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(actualizar:)
                                   userInfo:nil
                                    repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.001
                                     target:self
                                   selector:@selector(load:)
                                   userInfo:nil
                                    repeats:NO];
    
}

/**
 *  Notifies the view controller that its view was removed from a view hierarchy.
 *
 *  @param animated If YES, the disappearance of the view was animated.
 *
 *  @since version 1.0
 */
-(void)viewDidDisappear:(BOOL)animated
{
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, delegate.window.bounds.size.width, 20)];
    [v setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    [delegate.window.rootViewController.view addSubview:v];
}

/**
 *  Function that gets called to begin the loading process of all the data.
 *
 *  @param timer The timer used to trigger this function.
 *
 *  @since version 1.0
 */
- (void)load:(NSTimer*)timer
{
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [delegate loadAllTheInformation];
        dispatch_async( dispatch_get_main_queue(), ^{
            [HUD hide:YES];
            [self performSegueWithIdentifier:@"cargadoSegue" sender:self];
        });
    });
}

/**
 *  Function that gets called to create the loading animation
 *
 *  @param timer The timer used to trigger this function.
 *
 *  @since version 1.0
 */
- (void)actualizar:(NSTimer*)timer
{
    if (num == 0) {
        HUD.labelText = @"Flying to Barcelona   ";
        num = 1;
    }
    else if (num == 1) {
        HUD.labelText = @"Flying to Barcelona.  ";
        num = 2;
    }
    else if (num == 2) {
        HUD.labelText = @"Flying to Barcelona.. ";
        num = 3;
    }
    else {
        HUD.labelText = @"Flying to Barcelona...";
        num = 0;
    }
}

@end
