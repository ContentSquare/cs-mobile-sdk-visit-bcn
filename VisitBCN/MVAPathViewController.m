//
//  MVAPathViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 17/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPathViewController.h"
#import "MVARoute.h"
#import <CoreLocation/CoreLocation.h>
#import "MVADetailMapViewController.h"

@interface MVAPathViewController ()

@end

@implementation MVAPathViewController

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
    // Dispose of any resources that can be recreated.
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
    [[self.view viewWithTag:123] removeFromSuperview];
    [self createDescription];
}

/**
 *  Function that creates the description of the path.
 *
 *  @since version 1.0
 */
-(void)createDescription
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.tag = 123;
    if (self.subway) [self addSubwayDescription:scrollView];
    else [self addBusDescription:scrollView];
    [self.view addSubview:scrollView];
}

/**
 *  Function that adds all the subway content to the scroll view.
 *
 *  @param scrollView The scrollView that will host the content.
 *
 *  @since version 1.0
 */
-(void)addSubwayDescription:(UIScrollView *)scrollView
{
    
    self.navigationItem.title = @"Subway path";
    double y = 58.0;
    
    double ref = self.savedPath.initTime;
    int second = (ref - (floor(ref/60) * 60.0f)) ;
    double ref2 = (ref / 60.0);
    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
    int hora   = floor(ref / 3600);
    if (hora >= 24) hora -= 24;
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(8, 20, 70, 30)];
    [time setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second]];
    [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0f]];
    [scrollView addSubview:time];
    
    UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, (self.view.bounds.size.width - 98), 30)];
    [loc setText:self.savedPath.customlocation.name];
    [loc setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
    [scrollView addSubview:loc];
    
    UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(55, 20, 30, 30)];
    [imV setImage:[UIImage imageNamed:@"walking-blue"]];
    [scrollView addSubview:imV];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(70, y)];
    [path addLineToPoint:CGPointMake(70, (y + 100))];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:[path CGPath]];
    shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [scrollView.layer addSublayer:shapeLayer];
    
    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake(55, (y + 35), 30, 30)];
    [nombreR setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    [nombreR.layer setCornerRadius:15.0f];
    [nombreR setClipsToBounds:YES];
    [scrollView addSubview:nombreR];
    
    UIImageView *changeIm = [[UIImageView alloc] initWithFrame:CGRectMake(60, (y + 40), 20, 20)];
    changeIm.image = [UIImage imageNamed:@"walking-white-small"];
    [scrollView  addSubview:changeIm];
    
    UILabel *descr = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 30), (self.view.bounds.size.width - 103), 20)];
    [descr setText:@"Walking"];
    [descr setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
    [descr setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:descr];
    
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 50), (self.view.bounds.size.width - 103), 20)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:3];
    [formatter setMaximumFractionDigits:3];
    [formatter setMinimumIntegerDigits:2];
    [formatter setPaddingCharacter:@"0"];
    [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
    MVANode *node = [self.savedPath.subwayPath.nodes firstObject];
    detail.text = [[formatter stringFromNumber:[NSNumber numberWithDouble:([self distanceForCoordinates:self.savedPath.initCords andCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude)]/1000)]] stringByAppendingString:@" kms "];
    [detail setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    [detail setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:detail];
    
    UIImageView *imV2 = [[UIImageView alloc] initWithFrame:CGRectMake(55, (y + 108), 30, 30)];
    [imV2 setImage:[UIImage imageNamed:@"train-purple"]];
    [scrollView addSubview:imV2];
    
    y += 145;
    
    [self addSubwayDetails:scrollView andY:&y];
    
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, (y + 20));
    scrollView.backgroundColor = [UIColor clearColor];
}

/**
 *  Function that iterates over all the path stops that need to be displayed.
 *
 *  @param scrollView The scrollView that will host the content.
 *  @param y          The origin.y value for creating the content.
 *
 *  @since version 1.0
 */
-(void)addSubwayDetails:(UIScrollView *)scrollView andY:(double *)y
{
    int pos = 0;
    NSString *prevRouteID = @"";
    MVANode *antNode = nil;
    int numStops = 1;
    
    for (int i = 0; i < [self.savedPath.subwayPath.edges count]; ++i) {
        MVAEdge *edge = [self.savedPath.subwayPath.edges objectAtIndex:i];
        MVANode *dest = edge.destini;
        MVANode *node = [self.savedPath.subwayPath.nodes objectAtIndex:i];
        
        NSString *routeID = [dest.stop.routes firstObject];
        if (![prevRouteID isEqualToString:routeID]) {
            [self addSubwayRoute:routeID
                   previousRoute:&prevRouteID
                          inView:scrollView
                            andY:*y
                         andEdge:edge
                         andNode:node
                          andAnt:&antNode
                        andStops:&numStops
                     andPosition:&pos];
            *y += 145;
        }
        else ++numStops;
        
    }
}

/**
 *  Function that computes the body of the for loop of addSubwayDetails:andY: function.
 *
 *  @param routeID     The route identifier.
 *  @param prevRouteID The previous route identifier.
 *  @param scrollView  The scrollView where the content will be added.
 *  @param y           The origin.y value for creating the content.
 *  @param edge        The edge that is being computed.
 *  @param node        The node that is being computed.
 *  @param antNode     The previous node computed.
 *  @param numStops    The number of stops that haven't been added because don't need to be displayed.
 *  @param pos         The position inside the routes array.
 *
 *  @since version 1.0
 */
-(void)addSubwayRoute:(NSString *)routeID previousRoute:(NSString **)prevRouteID inView:(UIScrollView *)scrollView andY:(double)y andEdge:(MVAEdge *)edge andNode:(MVANode *)node andAnt:(MVANode **)antNode andStops:(int *)numStops andPosition:(int *)pos
{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(70, y)];
    [path addLineToPoint:CGPointMake(70, (y + 100))];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:[path CGPath]];
    if (edge.tripID == nil || [edge.tripID isEqualToString:@"landmark"]) [self addSubwayPathIn:scrollView inShape:shapeLayer andY:y andNode:node andEdge:edge andAnt:*antNode andStops:numStops];
    else [self addSubwayPathForStopsIn:scrollView andNode:node andDestination:edge.destini andAnt:antNode andRoute:routeID previousRoute:prevRouteID andShape:shapeLayer andStops:numStops andPosition:pos andY:y];
    
    double ref = [node.distance doubleValue];
    int second = (ref - (floor(ref/60) * 60.0f)) ;
    double ref2 = (ref / 60.0);
    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
    int hora   = floor(ref / 3600);
    if (hora >= 24) hora -= 24;
    
    UILabel *timeFS = [[UILabel alloc] initWithFrame:CGRectMake(8, (y - 37), 70, 30)];
    [timeFS setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second]];
    [timeFS setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0f]];
    [scrollView addSubview:timeFS];
    
    UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(90, (y - 37), (self.view.bounds.size.width - 98), 30)];
    [loc setText:node.stop.name];
    [loc setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
    [loc setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:loc];
    
    if ([edge.tripID isEqualToString:@"landmark"]) [self addSubwayLandmarkInView:scrollView andY:y andNode:node andDestination:edge.destini];
    else {
        UIImageView *destIm = [[UIImageView alloc] initWithFrame:CGRectMake(55, (y + 108), 30, 30)];
        [destIm setImage:[UIImage imageNamed:@"train-purple"]];
        [scrollView addSubview:destIm];
    }
}

/**
 *  Function that adds the path for a change or a walking edge.
 *
 *  @param scrollView The scrollView that will host the content.
 *  @param shapeLayer The layer where some content will be drawn.
 *  @param y          The origin.y value for creating the content.
 *  @param node       The node that is being computed.
 *  @param edge       The edge that is being computed.
 *  @param antNode    The previous node computed.
 *  @param numStops   The number of stops that haven't been added because don't need to be displayed.
 *
 *  @since version 1.0
 */
-(void)addSubwayPathIn:(UIScrollView *)scrollView inShape:(CAShapeLayer *)shapeLayer andY:(double)y andNode:(MVANode *)node andEdge:(MVAEdge *)edge andAnt:(MVANode *)antNode andStops:(int *)numStops
{
    
    shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [scrollView.layer addSublayer:shapeLayer];
    
    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake(55, (y + 35), 30, 30)];
    [nombreR setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    [nombreR.layer setCornerRadius:15.0f];
    [nombreR setClipsToBounds:YES];
    [scrollView addSubview:nombreR];
    
    if (antNode != nil) {
        NSString *text = [[[[[@"Take the " stringByAppendingString:[antNode.stop.routes firstObject]] stringByAppendingString:@" line from "] stringByAppendingString:antNode.stop.name] stringByAppendingString:@" to "] stringByAppendingString:node.stop.name];
        double h = [self heightForView:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f] text:text andSize:(self.view.bounds.size.width - 103)];
        UILabel *descr = [[UILabel alloc] initWithFrame:CGRectMake(95, (y - (95 + h)), (self.view.bounds.size.width - 103), h)];
        [descr setText:text];
        [descr setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
        [descr setAdjustsFontSizeToFitWidth:YES];
        [descr setNumberOfLines:0];
        [scrollView addSubview:descr];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(95, (y - 95), (self.view.bounds.size.width - 103), 20)];
        detail.text = [NSString stringWithFormat:@"%d stops",*numStops];
        [detail setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [detail setAdjustsFontSizeToFitWidth:YES];
        [scrollView addSubview:detail];
    }
    
    UIImageView *changeIm = [[UIImageView alloc] initWithFrame:CGRectMake(60, (y + 40), 20, 20)];
    if (edge.tripID == nil) {
        UILabel *descr = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 30), (self.view.bounds.size.width - 103), 20)];
        [descr setText:@"Change"];
        [descr setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
        [descr setAdjustsFontSizeToFitWidth:YES];
        [scrollView addSubview:descr];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 50), (self.view.bounds.size.width - 103), 20)];
        detail.text = [[[@"From line " stringByAppendingString:(NSString *)[node.stop.routes firstObject]] stringByAppendingString:@" to line "] stringByAppendingString:(NSString *)[edge.destini.stop.routes firstObject]];
        [detail setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [detail setAdjustsFontSizeToFitWidth:YES];
        [scrollView addSubview:detail];
        
        changeIm.image = [UIImage imageNamed:@"change-directions"];
    }
    else changeIm.image = [UIImage imageNamed:@"walking-white-small"];
    [scrollView  addSubview:changeIm];
    
}

/**
 *  Function that adds the path between objects.
 *
 *  @param scrollView  The scrollView that will host the content.
 *  @param node        The node that is being computed.
 *  @param dest        The destination node that is being computed.
 *  @param antNode     The previous node computed.
 *  @param routeID     The route identifier.
 *  @param prevRouteID The previous route identifier.
 *  @param shapeLayer  The layer where some content will be drawn.
 *  @param numStops    The number of stops that haven't been added because don't need to be displayed.
 *  @param pos         The position inside the routes array.
 *  @param y           The origin.y value for creating the content.
 *
 *  @since version 1.0
 */
-(void)addSubwayPathForStopsIn:(UIScrollView *)scrollView andNode:(MVANode *)node andDestination:(MVANode *)dest andAnt:(MVANode **)antNode andRoute:(NSString *)routeID previousRoute:(NSString **)prevRouteID andShape:(CAShapeLayer *)shapeLayer andStops:(int *)numStops andPosition:(int *)pos andY:(double)y
{
    *antNode = node;
    *numStops = 1;
    
    MVARoute *route = [self.savedPath.subwayRoutes objectAtIndex:*pos];
    
    [self.savedPath.subwayRoutes addObject:route];
    
    shapeLayer.strokeColor = [route.color CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [scrollView.layer addSublayer:shapeLayer];
    
    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake(55, (y + 35), 30, 30)];
    [nombreR setBackgroundColor:route.color];
    [nombreR setText:routeID];
    [nombreR setTextColor:route.textColor];
    [nombreR setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f]];
    [nombreR setAdjustsFontSizeToFitWidth:YES];
    [nombreR.layer setCornerRadius:15.0f];
    [nombreR setClipsToBounds:YES];
    [nombreR setTextAlignment:NSTextAlignmentCenter];
    [scrollView addSubview:nombreR];
    *prevRouteID = routeID;
    
    if ([dest.stop.stopID hasPrefix:@"001-"]) { // TMB
        UIImageView *agencyView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, (y + 35), 30, 30)];
        agencyView.image = [UIImage imageNamed:@"tmb_small"];
        [scrollView addSubview:agencyView];
    }
    else { // FGC
        UIImageView *agencyView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, (y + 35), 30, 30)];
        agencyView.image = [UIImage imageNamed:@"fgc_small"];
        [scrollView addSubview:agencyView];
    }
    
    *pos += 1;
}

/**
 *  Function that adds the information when we arrive to the landmark.
 *
 *  @param scrollView The scrollView that will host the content.
 *  @param y          The origin.y value for creating the content.
 *  @param node       The node that is being computed.
 *  @param dest       The destination node that is being computed.
 *
 *  @since version 1.0
 */
-(void)addSubwayLandmarkInView:(UIScrollView *)scrollView andY:(double)y andNode:(MVANode *)node andDestination:(MVANode *)dest
{
    UIImageView *destIm = [[UIImageView alloc] initWithFrame:CGRectMake(55, (y + 108), 30, 30)];
    [destIm setImage:[UIImage imageNamed:@"sagrada_familia"]];
    [scrollView addSubview:destIm];
    
    double ref = [dest.distance doubleValue];
    int second = (ref - (floor(ref/60) * 60.0f)) ;
    double ref2 = (ref / 60.0);
    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
    int hora   = floor(ref / 3600);
    if (hora >= 24) hora -= 24;
    
    UILabel *timeFS = [[UILabel alloc] initWithFrame:CGRectMake(8, (y + 108), 70, 30)];
    [timeFS setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second]];
    [timeFS setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0f]];
    [scrollView addSubview:timeFS];
    
    UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(90, (y + 108), (self.view.bounds.size.width - 98), 30)];
    [loc setText:dest.stop.name];
    [loc setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
    [loc setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:loc];
    
    UILabel *descr = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 30), (self.view.bounds.size.width - 103), 20)];
    [descr setText:@"Walking"];
    [descr setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
    [descr setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:descr];
    
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 50), (self.view.bounds.size.width - 103), 20)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:3];
    [formatter setMaximumFractionDigits:3];
    [formatter setMinimumIntegerDigits:2];
    [formatter setPaddingCharacter:@"0"];
    [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
    detail.text = [[formatter stringFromNumber:[NSNumber numberWithDouble:([self distanceForCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude) andCoordinates:CLLocationCoordinate2DMake(dest.stop.latitude, dest.stop.longitude)]/1000)]] stringByAppendingString:@" kms "];
    [detail setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    [detail setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:detail];
}

/**
 *  Function that adds all the bus content to the scroll view.
 *
 *  @param scrollView The scrollView that will host the content.
 *
 *  @since version 1.0
 */
-(void)addBusDescription:(UIScrollView *)scrollView
{
    self.navigationItem.title = @"Bus path";
    double y = 58.0;
    
    double ref = self.savedPath.initTime;
    int second = (ref - (floor(ref/60) * 60.0f)) ;
    double ref2 = (ref / 60.0);
    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
    int hora   = floor(ref / 3600);
    if (hora >= 24) hora -= 24;
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(8, 20, 70, 30)];
    [time setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second]];
    [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0f]];
    [scrollView addSubview:time];
    
    [self addOriginalBusInfo:scrollView andY:y];
    
    [self addFirstBusStop:scrollView andY:y];
    
    [self addBusDetails:scrollView andY:&y];
    
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, (y + 20));
    scrollView.backgroundColor = [UIColor clearColor];
}

/**
 *  Function that adds all the information displayed on the top of the scroll view.
 *
 *  @param scrollView The scrollView that will host the content.
 *  @param y          The origin.y value for creating the content.
 *
 *  @since version 1.0
 */
-(void)addOriginalBusInfo:(UIScrollView *)scrollView andY:(double)y
{
    UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, (self.view.bounds.size.width - 98), 30)];
    [loc setText:self.savedPath.customlocation.name];
    [loc setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
    [scrollView addSubview:loc];
    
    UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(55, 20, 30, 30)];
    [imV setImage:[UIImage imageNamed:@"walking-blue"]];
    [scrollView addSubview:imV];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(70, y)];
    [path addLineToPoint:CGPointMake(70, (y + 100))];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:[path CGPath]];
    shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [scrollView.layer addSublayer:shapeLayer];
    
    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake(55, (y + 35), 30, 30)];
    [nombreR setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    [nombreR.layer setCornerRadius:15.0f];
    [nombreR setClipsToBounds:YES];
    [scrollView addSubview:nombreR];
}

/**
 *  Function that adds the information for the first stop.
 *
 *  @param scrollView The scrollView that will host the content.
 *  @param y          The origin.y value for creating the content.
 *
 *  @since version 1.0
 */
-(void)addFirstBusStop:(UIScrollView *)scrollView andY:(double)y
{
    UIImageView *changeIm = [[UIImageView alloc] initWithFrame:CGRectMake(60, (y + 40), 20, 20)];
    changeIm.image = [UIImage imageNamed:@"walking-white-small"];
    [scrollView  addSubview:changeIm];
    
    UILabel *descr = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 30), (self.view.bounds.size.width - 103), 20)];
    [descr setText:@"Walking"];
    [descr setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
    [descr setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:descr];
    
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 50), (self.view.bounds.size.width - 103), 20)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:3];
    [formatter setMaximumFractionDigits:3];
    [formatter setMinimumIntegerDigits:2];
    [formatter setPaddingCharacter:@"0"];
    [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
    MVANode *node = [self.savedPath.busPath.nodes firstObject];
    detail.text = [[formatter stringFromNumber:[NSNumber numberWithDouble:([self distanceForCoordinates:self.savedPath.initCords andCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude)]/1000)]] stringByAppendingString:@" kms "];
    [detail setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    [detail setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:detail];
    
    UIImageView *imV2 = [[UIImageView alloc] initWithFrame:CGRectMake(55, (y + 108), 30, 30)];
    [imV2 setImage:[UIImage imageNamed:@"bus-red"]];
    [scrollView addSubview:imV2];
}

/**
 *  Function that iterates over all the path stops that need to be displayed.
 *
 *  @param scrollView The scrollView that will host the content.
 *  @param y          The origin.y value for creating the content.
 *
 *  @since version 1.0
 */
-(void)addBusDetails:(UIScrollView *)scrollView andY:(double *)y
{
    NSString *prevTripID = @"";
    
    *y += 145;
    
    int pos = 0;
    
    MVANode *antNode = nil;
    int numStops = 1;
    
    for (int i = 0; i < [self.savedPath.busPath.edges count]; ++i) {
        MVAEdge *edge = [self.savedPath.busPath.edges objectAtIndex:i];
        MVANode *node = [self.savedPath.busPath.nodes objectAtIndex:i];
        NSString *tripID = edge.tripID;
        [self addBusTrip:tripID previousTrip:&prevTripID inView:scrollView andY:y andEdge:edge andNode:node andAnt:&antNode andStops:&numStops andPosition:&pos];
    }
}

/**
 *  Function that computes the body of the for loop of addBusDetails:andY: function.
 *
 *  @param tripID     The trip identifier.
 *  @param prevTripID The previous trip identifier.
 *  @param scrollView The scrollView that will host the content.
 *  @param y          The origin.y value for creating the content.
 *  @param edge       The edge that is being computed.
 *  @param node       The node that is being computed.
 *  @param antNode    The previous node computed.
 *  @param numStops   The number of stops that haven't been added because don't need to be displayed.
 *  @param pos        The position inside the routes array.
 *
 *  @since version 1.0
 */
-(void)addBusTrip:(NSString *)tripID previousTrip:(NSString **)prevTripID inView:(UIScrollView *)scrollView andY:(double *)y andEdge:(MVAEdge *)edge andNode:(MVANode *)node andAnt:(MVANode **)antNode andStops:(int *)numStops andPosition:(int *)pos
{
    if ([edge.tripID isEqualToString:@"walking"] || [edge.tripID isEqualToString:@"change"] || [edge.tripID isEqualToString:@"landmark"]) {
        tripID = @"special";
    }
    
    if (![*prevTripID isEqualToString:tripID]) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(70, *y)];
        [path addLineToPoint:CGPointMake(70, (*y + 100))];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setPath:[path CGPath]];
        if ([edge.tripID isEqualToString:@"walking"] || [edge.tripID isEqualToString:@"change"] || [edge.tripID isEqualToString:@"landmark"]) [self addBusPathForStopsIn:scrollView andNode:node andEdge:edge andAnt:antNode previousTrip:prevTripID andShape:shapeLayer andStops:numStops andY:*y];
        else [self addBusRouteIn:scrollView andShape:shapeLayer andNode:node andAnt:antNode andStops:numStops andPosition:pos andTrip:tripID andPrevious:prevTripID andY:y];
        double ref = [node.distance doubleValue];
        int second = (ref - (floor(ref/60) * 60.0f)) ;
        double ref2 = (ref / 60.0);
        int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
        int hora   = floor(ref / 3600);
        if (hora >= 24) hora -= 24;
        
        UILabel *timeFS = [[UILabel alloc] initWithFrame:CGRectMake(8, (*y - 37), 70, 30)];
        [timeFS setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second]];
        [timeFS setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0f]];
        [scrollView addSubview:timeFS];
        
        UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(90, (*y - 37), (self.view.bounds.size.width - 98), 30)];
        [loc setText:node.stop.name];
        [loc setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
        [loc setAdjustsFontSizeToFitWidth:YES];
        [scrollView addSubview:loc];
        
        if ([edge.tripID isEqualToString:@"landmark"]) [self addBusLandmarkInView:scrollView andY:*y andNode:node andEdge:edge];
        else {
            UIImageView *destIm = [[UIImageView alloc] initWithFrame:CGRectMake(55, (*y + 108), 30, 30)];
            [destIm setImage:[UIImage imageNamed:@"bus-red"]];
            [scrollView addSubview:destIm];
        }
        
        *y += 145;
    }
    else *numStops += 1;
}

/**
 *  Function that adds the path for a change or a walking edge.
 *
 *  @param scrollView The scrollView that will host the content.
 *  @param shapeLayer The layer where some content will be drawn.
 *  @param node       The node that is being computed.
 *  @param antNode    The previous node computed.
 *  @param numStops   The number of stops that haven't been added because don't need to be displayed.
 *  @param pos        The position inside the routes array.
 *  @param tripID     The trip identifier.
 *  @param prevTripID The previous trip identifier.
 *  @param y          The origin.y value for creating the content.
 *
 *  @since version 1.0
 */
-(void)addBusRouteIn:(UIScrollView *)scrollView andShape:(CAShapeLayer *)shapeLayer andNode:(MVANode *)node andAnt:(MVANode **)antNode andStops:(int *)numStops andPosition:(int *)pos andTrip:(NSString *)tripID andPrevious:(NSString **)prevTripID andY:(double *)y
{
    *antNode = node;
    *numStops = 1;
    
    MVARoute *route = [self.savedPath.busRoutes objectAtIndex:*pos];
    
    shapeLayer.strokeColor = [route.color CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [scrollView.layer addSublayer:shapeLayer];
    
    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake(55, (*y + 35), 30, 30)];
    [nombreR setBackgroundColor:route.color];
    [nombreR setText:tripID];
    [nombreR setTextColor:route.textColor];
    [nombreR setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f]];
    [nombreR setAdjustsFontSizeToFitWidth:YES];
    [nombreR.layer setCornerRadius:15.0f];
    [nombreR setClipsToBounds:YES];
    [nombreR setTextAlignment:NSTextAlignmentCenter];
    [scrollView addSubview:nombreR];
    *prevTripID = tripID;
    
    UIImageView *agencyView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, (*y + 35), 30, 30)];
    agencyView.image = [UIImage imageNamed:@"tmb_small"];
    [scrollView addSubview:agencyView];
    
    *pos += 1;
}

/**
 *  Function that adds the path between objects.
 *
 *  @param scrollView The scrollView that will host the content.
 *  @param node       The node that is being computed.
 *  @param edge       The edge that is being computed.
 *  @param antNode    The previous node computed.
 *  @param prevTripID The previous trip identifier.
 *  @param shapeLayer The layer where some content will be drawn.
 *  @param numStops   The number of stops that haven't been added because don't need to be displayed.
 *  @param y          The origin.y value for creating the content.
 *
 *  @since version 1.0
 */
-(void)addBusPathForStopsIn:(UIScrollView *)scrollView andNode:(MVANode *)node andEdge:(MVAEdge *)edge andAnt:(MVANode **)antNode previousTrip:(NSString **)prevTripID andShape:(CAShapeLayer *)shapeLayer andStops:(int *)numStops andY:(double)y
{
    shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [scrollView.layer addSublayer:shapeLayer];
    
    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake(55, (y + 35), 30, 30)];
    [nombreR setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    [nombreR.layer setCornerRadius:15.0f];
    [nombreR setClipsToBounds:YES];
    [scrollView addSubview:nombreR];
    
    if (antNode != nil) {
        NSString *text = [[[[[@"Take the " stringByAppendingString:[(*antNode).stop.routes firstObject]] stringByAppendingString:@" line from "] stringByAppendingString:(*antNode).stop.name] stringByAppendingString:@" to "] stringByAppendingString:node.stop.name];
        double h = [self heightForView:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f] text:text andSize:(self.view.bounds.size.width - 103)];
        UILabel *descr = [[UILabel alloc] initWithFrame:CGRectMake(95, (y - (95 + h)), (self.view.bounds.size.width - 103), h)];
        [descr setText:text];
        [descr setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
        [descr setAdjustsFontSizeToFitWidth:YES];
        [descr setNumberOfLines:0];
        [scrollView addSubview:descr];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(95, (y - 95), (self.view.bounds.size.width - 103), 20)];
        detail.text = [NSString stringWithFormat:@"%d stops",*numStops];
        [detail setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
        [detail setAdjustsFontSizeToFitWidth:YES];
        [scrollView addSubview:detail];
    }
    
    NSString *titleText = @"";
    NSString *displayText = @"";
    UIImageView *changeIm = [[UIImageView alloc] initWithFrame:CGRectMake(60, (y + 40), 20, 20)];
    if ([edge.tripID isEqualToString:@"change"]) {
        titleText = @"Change";
        displayText = [[[@"From line " stringByAppendingString:(NSString *)[node.stop.routes firstObject]] stringByAppendingString:@" to line "] stringByAppendingString:(NSString *)[edge.destini.stop.routes firstObject]];
        changeIm.image = [UIImage imageNamed:@"change-directions"];
    }
    else {
        titleText = @"Walking";
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMinimumFractionDigits:3];
        [formatter setMaximumFractionDigits:3];
        [formatter setMinimumIntegerDigits:2];
        [formatter setPaddingCharacter:@"0"];
        [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
        displayText = [[formatter stringFromNumber:[NSNumber numberWithDouble:([self distanceForCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude) andCoordinates:CLLocationCoordinate2DMake(edge.destini.stop.latitude, edge.destini.stop.longitude)]/1000)]] stringByAppendingString:@" kms "];
        changeIm.image = [UIImage imageNamed:@"walking-white-small"];
    }
    
    UILabel *descr = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 30), (self.view.bounds.size.width - 103), 20)];
    [descr setText:titleText];
    [descr setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
    [descr setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:descr];
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 50), (self.view.bounds.size.width - 103), 20)];
    detail.text = displayText;
    [detail setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    [detail setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:detail];
    [scrollView  addSubview:changeIm];
    *prevTripID = @"special";
}

/**
 *  Function that adds the information when we arrive to the landmark.
 *
 *  @param scrollView The scrollView that will host the content.
 *  @param y          The origin.y value for creating the content.
 *  @param node       The node that is being computed.
 *  @param edge       The edge that is being computed.
 *
 *  @since version 1.0
 */
-(void)addBusLandmarkInView:(UIScrollView *)scrollView andY:(double)y andNode:(MVANode *)node andEdge:(MVAEdge *)edge
{
    UIImageView *destIm = [[UIImageView alloc] initWithFrame:CGRectMake(55, (y + 108), 30, 30)];
    [destIm setImage:[UIImage imageNamed:@"sagrada_familia"]];
    [scrollView addSubview:destIm];
    
    double ref = [edge.destini.distance doubleValue];
    int second = (ref - (floor(ref/60) * 60.0f)) ;
    double ref2 = (ref / 60.0);
    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
    int hora   = floor(ref / 3600);
    if (hora >= 24) hora -= 24;
    
    UILabel *timeFS = [[UILabel alloc] initWithFrame:CGRectMake(8, (y + 108), 70, 30)];
    [timeFS setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second]];
    [timeFS setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0f]];
    [scrollView addSubview:timeFS];
    
    UILabel *loc = [[UILabel alloc] initWithFrame:CGRectMake(90, (y + 108), (self.view.bounds.size.width - 98), 30)];
    [loc setText:edge.destini.stop.name];
    [loc setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]];
    [loc setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:loc];
    
    UILabel *descr = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 30), (self.view.bounds.size.width - 103), 20)];
    [descr setText:@"Walking"];
    [descr setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
    [descr setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:descr];
    
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(95, (y + 50), (self.view.bounds.size.width - 103), 20)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:3];
    [formatter setMaximumFractionDigits:3];
    [formatter setMinimumIntegerDigits:2];
    [formatter setPaddingCharacter:@"0"];
    [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
    detail.text = [[formatter stringFromNumber:[NSNumber numberWithDouble:([self distanceForCoordinates:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude) andCoordinates:CLLocationCoordinate2DMake(edge.destini.stop.latitude, edge.destini.stop.longitude)]/1000)]] stringByAppendingString:@" kms "];
    [detail setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    [detail setAdjustsFontSizeToFitWidth:YES];
    [scrollView addSubview:detail];
}

/**
 *  Function that calculates the height of a view that will contain a given text with an specific font and text size.
 *
 *  @param font  The font used
 *  @param text  The text
 *  @param width The width of the view
 *
 *  @return The height needed to display the text
 *
 *  @since version 1.0
 */
-(CGFloat)heightForView:(UIFont *)font text:(NSString *)text andSize:(CGFloat)width
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, CGFLOAT_MAX)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = font;
    label.text = text;
    [label sizeToFit];
    return label.frame.size.height;
}

/**
 *  Haversine distance between two coordinates
 *
 *  @param cordA The first coordinate
 *  @param cordB The second coordinate
 *
 *  @return The distance in meters
 *
 *  @see http://www.movable-type.co.uk/scripts/latlong.html
 *  @since version 1.0
 */
-(double)distanceForCoordinates:(CLLocationCoordinate2D)cordA andCoordinates:(CLLocationCoordinate2D)cordB
{
    double R = 6372797.560856;
    double dLat = ((cordB.latitude - cordA.latitude) * M_PI) / 180.0;
    double dLon = ((cordB.longitude - cordA.longitude) * M_PI) / 180.0;
    double lat1 = (cordA.latitude * M_PI) / 180.0;
    double lat2 = (cordB.latitude * M_PI) / 180.0;
    
    double a = (sin(dLat/2.0) * sin(dLat/2.0)) + (sin(dLon/2.0) * sin(dLon/2.0) * cos(lat1) * cos(lat2));
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double realDist = (R * c);
    
    return (realDist * 1.2);
}

/**
 *  Called when a segue is about to be performed. (required)
 *
 *  @param segue  The segue object containing information about the view controllers involved in the segue.
 *  @param sender The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
 *
 *  @since version 1.0
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mapDetailSegue"]) {
        MVADetailMapViewController *vc = (MVADetailMapViewController *)segue.destinationViewController;
        vc.savedPath = self.savedPath;
        vc.subway = self.subway;
    }
}

@end