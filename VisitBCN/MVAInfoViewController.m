//
//  MVAInfoViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 28/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAInfoViewController.h"

@interface MVAInfoViewController ()

@property BOOL created;

@end

@implementation MVAInfoViewController

/**
 *  Function that gets called when the view controller has loaded the view
 *
 *  @since version 1.0
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.created = NO;
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
 *  Notifies the view controller that its view is about to be added to a view hierarchy.
 *
 *  @param animated If YES, the view is being added to the window using an animation.
 *
 *  @since version 1.0
 */
-(void)viewWillAppear:(BOOL)animated
{
    if (!self.created) [self createScrollView];
}

/**
 *  Function that creates the scroll view with all the information
 *
 *  @since version 1.0
 */
-(void)createScrollView
{
    self.created = YES;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    CGFloat w = self.view.bounds.size.width;
    CGFloat alt = 10.0f;
    
    UILabel *nota = [[UILabel alloc] initWithFrame:CGRectMake(8, alt, (w - 16), 25)];
    [nota setText:@"Public transport information"];
    [nota setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]];
    [nota setTextAlignment:NSTextAlignmentCenter];
    [nota setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:nota];
    alt += (25 + 10);
    
    UITextView *cuerpo = [[UITextView alloc] initWithFrame:CGRectMake(8, alt, (w - 16), 100)];
    [cuerpo setText:@"All the public transport information provided in this app is provided by the competent governmental institutions.\n\nThe fares of the public transports of Barcelona are:\n · Single ticket (2.15€) [one trip ticket]\n · T-10 (9.95€) [ten trips ticket]\n · T-dia (7.60€) [unlimited trips in one day]\n · 2 day Barcelona travel card (14.00€) [unlimited trips during 2 consecutive days]\n · 3 day Barcelona travel card (20.50€) [unlimited trips during 3 consecutive days]\n · 4 day Barcelona travel card (26.50€) [unlimited trips during 4 consecutive days]\n · 5 day Barcelona travel card (32€) [unlimited trips during 5 consecutive days].\n\nIt's also important to comment that:\n · This app calculates itineraries for the main bus and subway services in Barcelona. It doesn't include the regional train services, the tram and the cable cars.\n · All the bus itineraries calculated, are for the daytime services. The night services such as 'BusNit' aren't included in this app.\n\nThe two agencies that provide all the transport services are:\n · Transports Metropolitans de Barcelona (TMB).\n · Ferrocarrils de la Generalitat de Catalunya (FGC)."];
    [cuerpo setTextAlignment:NSTextAlignmentJustified];
    [cuerpo setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    [cuerpo setUserInteractionEnabled:NO];
    [cuerpo setScrollEnabled:NO];
    [cuerpo setBackgroundColor:[UIColor clearColor]];
    [cuerpo sizeToFit];
    [scrollView addSubview:cuerpo];
    alt += (cuerpo.frame.size.height + 30);
    
    UILabel *nota2 = [[UILabel alloc] initWithFrame:CGRectMake(8, alt, (w - 16), 25)];
    [nota2 setText:@"Taxi services information"];
    [nota2 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]];
    [nota2 setTextAlignment:NSTextAlignmentCenter];
    [nota2 setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:nota2];
    alt += (25 + 10);
    
    UITextView *cuerpo2 = [[UITextView alloc] initWithFrame:CGRectMake(8, alt, (w - 16), 100)];
    [cuerpo2 setText:@"This app uses the API provided by Hailo™ to ask for a taxi and uses a simple algorithm to calculate an estimated fare for the trip. This algorithm, uses the fares published by the taxi association of Barcelona. The fares are:\n\nWorking days from 8 to 20 (T1):\n · Initial fare: 2.10€\n · Price per kilometer: 1.07€\n · Airport minimum fare: 20€\n · Luggage: 1€ (each)\n\nWorking days from 20 to 8, Saturdays and holidays from 8 to 20 (T2):\n · Initial fare: 2.10€\n · Price per kilometer: 1.30€\n · Airport minimum fare: 20€\n · Luggage: 1€ (each)\n\nSaturdays and holidays from 20 to 8 (T3):\n · Initial fare: 2.30€\n · Price per kilometer: 1.40€\n · Airport minimum fare: 20€\n · Luggage: 1€ (each)"];
    [cuerpo2 setTextAlignment:NSTextAlignmentJustified];
    [cuerpo2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    [cuerpo2 setUserInteractionEnabled:NO];
    [cuerpo2 setScrollEnabled:NO];
    [cuerpo2 setBackgroundColor:[UIColor clearColor]];
    [cuerpo2 sizeToFit];
    [scrollView addSubview:cuerpo2];
    alt += (cuerpo2.frame.size.height + 30);
    
    UILabel *nota3 = [[UILabel alloc] initWithFrame:CGRectMake(8, alt, (w - 16), 25)];
    [nota3 setText:@"App information"];
    [nota3 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]];
    [nota3 setTextAlignment:NSTextAlignmentCenter];
    [nota3 setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:nota3];
    alt += (25 + 15);
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((w - 125)/2.0, alt, 125, 125)];
    [logo setImage:[UIImage imageNamed:@"logo"]];
    [scrollView addSubview:logo];
    alt += (125 + 15);
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(8, alt, (w - 16), 20)];
    [version setText:@"Version 1.2"];
    [version setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
    [version setTextAlignment:NSTextAlignmentCenter];
    [version setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:version];
    alt += (20 + 15);
    
    UITextView *cuerpo3 = [[UITextView alloc] initWithFrame:CGRectMake(8, alt, (w - 16), 90)];
    [cuerpo3 setText:@"Developed and designed by Mauro Vime Castillo. Thanks to Ònia Sancho Riaza and Guillem Godoy Balil for all the assistance they offered me during the development and design tasks."];
    [cuerpo3 setTextAlignment:NSTextAlignmentJustified];
    [cuerpo3 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
    [cuerpo3 setUserInteractionEnabled:NO];
    [cuerpo3 setScrollEnabled:NO];
    [cuerpo3 setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:cuerpo3];
    alt += (90 + 10);
    
    UILabel *copy = [[UILabel alloc] initWithFrame:CGRectMake(8, alt, (w - 16), 20)];
    [copy setText:@"Copyright © 2015 Mauro Vime Castillo. All rights reserved."];
    [copy setFont:[UIFont fontWithName:@"HelveticaNeue-Regular" size:15.0f]];
    [copy setTextAlignment:NSTextAlignmentCenter];
    [copy setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:copy];
    alt += (20 + 10);
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, alt);
    [self.view addSubview:scrollView];
}

@end
