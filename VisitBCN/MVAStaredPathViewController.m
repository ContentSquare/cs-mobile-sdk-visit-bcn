//
//  MVAStaredPathViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 23/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAStaredPathViewController.h"
#import "MVATaxis.h"
#import "MVARoute.h"
#import "Reachability.h"
#import "MVAPathViewController.h"

@interface MVAStaredPathViewController () <UIAlertViewDelegate>

@property MVATaxis *taxis;
@property UIView *taxiView;
@property BOOL created;
@property BOOL subway;

@end

@implementation MVAStaredPathViewController

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
    // Dispose of any resources that can be recreated.
}

/**
 *  Function that gets called before the view appears on the screen
 *
 *  @param animated A bool that indicates if the view appears animated or not
 *
 *  @since version 1.0
 */
-(void)viewWillAppear:(BOOL)animated
{
    if (!self.created) {
        [self createParallax];
    }
    
    self.created= YES;
}

/**
 *  Function that create the parallax effect
 *
 *  @since version 1.0
 */
-(void)createParallax
{
    NSMutableDictionary* views = [NSMutableDictionary new];
    views[@"super"] = self.view;
    views[@"topGuide"] = self.topLayoutGuide; // The bottom of the navigation bar, if a navigation bar is visible. The bottom of the status bar, if only a status bar is visible .. etc...
    
    double tam = fmax((self.view.frame.size.height - 200), 470);
    
    //Create the ScrollView
    UIScrollView* scrollView = [UIScrollView new];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:scrollView];
    views[@"scrollView"] = scrollView;
    
    //Create the scrollview contentview
    UIView* contentView = [UIView new];
    contentView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    [scrollView addSubview:contentView];
    views[@"contentView"] = contentView;
    
    //Add the image view and other addtional views to the content view
    UIImage *img = [UIImage imageNamed:@"mapHeader"];
    UIImageView* topImageView = [[UIImageView alloc] initWithImage:img];
    topImageView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    topImageView.contentMode = UIViewContentModeScaleAspectFill;
    topImageView.clipsToBounds = YES;
    [contentView addSubview:topImageView];
    views[@"topImageView"] = topImageView;
    
    //Add other content to the scrollable view
    UIView* subContentView = [UIView new];
    subContentView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    [contentView addSubview:subContentView];
    views[@"subContentView"] = subContentView;
    
    
    //Now Let's do the layout
    NSArray* constraints;
    NSString* format;
    NSDictionary* metrics = @{@"imageHeight" : @150.0};
    
    //======== ScrollView should take all available space ========
    
    format = @"|-0-[scrollView]-0-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.view addConstraints:constraints];
    
    format = @"V:[topGuide]-0-[scrollView]-0-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.view addConstraints:constraints];
    
    
    
    //======== ScrollView Content should tie to all four edges of the scrollview ========
    
    format = @"|-0-[contentView]-0-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [scrollView addConstraints:constraints];
    
    format = @"V:|-0-[contentView]-0-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [scrollView addConstraints:constraints];
    
    
    
    // ========== Layout the image horizontally
    
    format = @"|-0-[topImageView(==super)]-0-|"; // with trick to force content width
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.view addConstraints:constraints];
    
    
    
    // ========== Put the sub view height, and leave room for image
    
    format = @"|-0-[subContentView]-0-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [scrollView addConstraints:constraints];
    
    
    // we leave some space between the top for the image view
    format = [NSString stringWithFormat:@"V:|-imageHeight-[subContentView(%.2f)]-0-|",tam];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:metrics views:views];
    [scrollView addConstraints:constraints];
    
    
    
    // Start of the magic
    
    format = @"V:[topImageView]-0-[subContentView]"; // image view bottom is subcontent top
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [contentView addConstraints:constraints];
    
    // image view top is the top layout
    // But we lower the priority to let it break if you scroll enough to have the imageViewBottom higher than the top layout guide
    format = @"V:[topGuide]-0@750-[topImageView]";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.view addConstraints:constraints];
    
    // so add a lower than rule with higher priority (1000) to let the previous rule break;
    format = @"V:[topGuide]-<=0-[topImageView]";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [self.view addConstraints:constraints];
    
    UIView *insetView = [self insetView];
    [subContentView addSubview:insetView];
    
    //Optional stuff, Add The FirstCell view
    UIView *firstCell = [self subwayView];
    [subContentView addSubview:firstCell];
    
    //Optional stuff, Add The SecondCell view
    UIView *secondCell = [self busView];
    [subContentView addSubview:secondCell];
    
    
    //Optional stuff, Add The ThirdCell
    UIView *thirdCell = [self taxiCellView];
    [subContentView addSubview:thirdCell];
    
    //Optional stuff, Add The Fourth
    UIView *fourthCell = [self walkingView];
    [subContentView addSubview:fourthCell];
    
    //Optional stuff, Add footer
    UIView *footerView = [self footerView];
    [subContentView addSubview:footerView];
    
}

/**
 *  Function that creates the insets
 *
 *  @return The insets view
 *
 *  @since version 1.0
 */
-(UIView *)insetView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 403)];
    [v setBackgroundColor:[UIColor whiteColor]];
    return v;
}

/**
 *  Function that creates the subway view
 *
 *  @return The subway view
 *
 *  @since version 1.0
 */
-(UIView *)subwayView
{
    CGFloat w = self.view.frame.size.width;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 100)];
    [v setBackgroundColor:[UIColor whiteColor]];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 80, 20)];
    [name setText:@"Subway"];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
    [name setAdjustsFontSizeToFitWidth:YES];
    [name setTextAlignment:NSTextAlignmentLeft];
    [name setTextColor:[UIColor darkGrayColor]];
    [v addSubview:name];
    if (self.savedPath.subwayPath == nil) {
        UILabel *error = [[UILabel alloc] initWithFrame:CGRectMake(8, 40, (w - 16), 40)];
        [error setText:@"We can't find any combination of subway trains for the date and time desired."];
        [error setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
        [error setAdjustsFontSizeToFitWidth:YES];
        [error setTextAlignment:NSTextAlignmentCenter];
        [error setTextColor:[UIColor darkGrayColor]];
        [error setNumberOfLines:0];
        [v addSubview:error];
    }
    else {
        MVANode *nodeA = [self.savedPath.subwayPath.nodes firstObject];
        MVANode *nodeB = [self.savedPath.subwayPath.nodes objectAtIndex:([self.savedPath.subwayPath.nodes count] - 2)];
        MVANode *landmark = [self.savedPath.subwayPath.nodes lastObject];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(97, 8, (w - (8 + 97)), 20)];
        
        double ref = self.savedPath.initTime;
        int second = (ref - (floor(ref/60) * 60.0f)) ;
        double ref2 = (ref / 60.0);
        int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
        int hora   = floor(ref / 3600);
        if (hora >= 24) hora -= 24;
        double refT = [landmark.distance doubleValue] - self.savedPath.initTime;
        int secondT = (refT - (floor(refT/60) * 60.0f)) ;
        double refT2 = (refT / 60.0);
        int minuteT = (refT2 - (floor(refT2/60) * 60.0f)) ;
        int horaT   = floor(refT / 3600);
        double refF = [landmark.distance doubleValue];
        int secondF = (refF - (floor(refF/60) * 60.0f)) ;
        double refF2 = (refF / 60.0);
        int minuteF = (refF2 - (floor(refF2/60) * 60.0f)) ;
        int horaF   = floor(refF / 3600);
        if (horaF >= 24) horaF -= 24;
        
        [time setText:[NSString stringWithFormat:@"%02d:%02d:%02d - %02dh %02dm %02ds - %02d:%02d:%02d",hora,minute,second,horaT,minuteT,secondT,horaF,minuteF,secondF]];
        
        [time setFont:[UIFont systemFontOfSize:17.0f]];
        [time setAdjustsFontSizeToFitWidth:YES];
        [time setTextAlignment:NSTextAlignmentCenter];
        [time setTextColor:[UIColor darkGrayColor]];
        [v addSubview:time];
        
        UILabel *resumen = [[UILabel alloc] initWithFrame:CGRectMake(8, 77, (w - 16), 20)];
        [resumen setText:[[[@"from " stringByAppendingString:nodeA.stop.name] stringByAppendingString:@" to "] stringByAppendingString:nodeB.stop.name]];
        [resumen setFont:[UIFont systemFontOfSize:12.0f]];
        [resumen setAdjustsFontSizeToFitWidth:YES];
        [resumen setTextAlignment:NSTextAlignmentLeft];
        [resumen setTextColor:[UIColor darkGrayColor]];
        [v addSubview:resumen];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 35, (w - 16), 32.5)];
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 30, 30)];
        [imV setImage:[UIImage imageNamed:@"walking-blue"]];
        [scrollView addSubview:imV];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(38, 16.25)];
        [path addLineToPoint:CGPointMake(88, 16.25)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setPath:[path CGPath]];
        shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        [scrollView.layer addSublayer:shapeLayer];
        
        UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake(48, 2.5, 30, 30)];
        [nombreR setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
        [nombreR.layer setCornerRadius:15.0f];
        [nombreR setClipsToBounds:YES];
        [scrollView addSubview:nombreR];
        
        UIImageView *changeIm = [[UIImageView alloc] initWithFrame:CGRectMake(53, 7.5, 20, 20)];
        changeIm.image = [UIImage imageNamed:@"walking-white-small"];
        [scrollView  addSubview:changeIm];
        
        UIImageView *imV2 = [[UIImageView alloc] initWithFrame:CGRectMake(96, 2.5, 30, 30)];
        [imV2 setImage:[UIImage imageNamed:@"train-purple"]];
        [scrollView addSubview:imV2];
        
        int x = 134;
        
        NSString *prevRouteID = @"";
        
        for (int i = 0; i < [self.savedPath.subwayPath.edges count]; ++i) {
            MVAEdge *edge = [self.savedPath.subwayPath.edges objectAtIndex:i];
            MVANode *dest = edge.destini;
            
            NSString *routeID = [dest.stop.routes firstObject];
            
            if (![prevRouteID isEqualToString:routeID]) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(x, 16.25)];
                [path addLineToPoint:CGPointMake((x + 50), 16.25)];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                [shapeLayer setPath:[path CGPath]];
                if (edge.tripID == nil || [edge.tripID isEqualToString:@"landmark"]) {
                    shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
                    shapeLayer.lineWidth = 3.0;
                    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
                    [scrollView.layer addSublayer:shapeLayer];
                    
                    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake((x + 10), 2.5, 30, 30)];
                    [nombreR setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
                    [nombreR.layer setCornerRadius:15.0f];
                    [nombreR setClipsToBounds:YES];
                    [scrollView addSubview:nombreR];
                    
                    UIImageView *changeIm = [[UIImageView alloc] initWithFrame:CGRectMake((x + 15), 7.5, 20, 20)];
                    if (edge.tripID == nil) changeIm.image = [UIImage imageNamed:@"change-directions"];
                    else changeIm.image = [UIImage imageNamed:@"walking-white-small"];
                    [scrollView  addSubview:changeIm];
                }
                else {
                    MVARoute *route = [self findRoute:[dest.stop.routes firstObject] subway:YES];
                    
                    [self.savedPath.subwayRoutes addObject:route];
                    
                    shapeLayer.strokeColor = [route.color CGColor];
                    shapeLayer.lineWidth = 3.0;
                    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
                    [scrollView.layer addSublayer:shapeLayer];
                    
                    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake((x + 10), 2.5, 30, 30)];
                    [nombreR setBackgroundColor:route.color];
                    [nombreR setText:routeID];
                    [nombreR setTextColor:route.textColor];
                    [nombreR setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f]];
                    [nombreR setAdjustsFontSizeToFitWidth:YES];
                    [nombreR.layer setCornerRadius:15.0f];
                    [nombreR setClipsToBounds:YES];
                    [nombreR setTextAlignment:NSTextAlignmentCenter];
                    [scrollView addSubview:nombreR];
                    prevRouteID = routeID;
                }
                if ([edge.tripID isEqualToString:@"landmark"]) {
                    UIImageView *destIm = [[UIImageView alloc] initWithFrame:CGRectMake((x + 58), 2.5, 30, 30)];
                    [destIm setImage:[UIImage imageNamed:@"sagrada_familia"]];
                    [scrollView addSubview:destIm];
                }
                else {
                    UIImageView *destIm = [[UIImageView alloc] initWithFrame:CGRectMake((x + 58), 2.5, 30, 30)];
                    [destIm setImage:[UIImage imageNamed:@"train-purple"]];
                    [scrollView addSubview:destIm];
                }
                x += 96;
            }
            
        }
        [scrollView setShowsHorizontalScrollIndicator:NO];
        scrollView.contentSize = CGSizeMake((x + 10), scrollView.frame.size.height);
        scrollView.backgroundColor = [UIColor clearColor];
        
        [v addSubview:scrollView];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subwayPathView:)];
        
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [v addGestureRecognizer: singleTap];
    }
    
    return v;
}

/**
 *  Function that creates the bus view
 *
 *  @return The bus view
 *
 *  @since version 1.0
 */
-(UIView *)busView
{
    CGFloat w = self.view.frame.size.width;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 101.5, w, 100)];
    [v setBackgroundColor:[UIColor whiteColor]];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 80, 20)];
    [name setText:@"Bus"];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
    [name setAdjustsFontSizeToFitWidth:YES];
    [name setTextAlignment:NSTextAlignmentLeft];
    [name setTextColor:[UIColor darkGrayColor]];
    [v addSubview:name];
    if (self.savedPath.busPath == nil) {
        UILabel *error = [[UILabel alloc] initWithFrame:CGRectMake(8, 40, (w - 16), 40)];
        [error setText:@"We can't find any combination of buses for the date and time desired."];
        [error setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
        [error setAdjustsFontSizeToFitWidth:YES];
        [error setTextAlignment:NSTextAlignmentCenter];
        [error setTextColor:[UIColor darkGrayColor]];
        [error setNumberOfLines:0];
        [v addSubview:error];
    }
    else {
        MVANode *nodeA = [self.savedPath.busPath.nodes firstObject];
        MVAEdge *edge = [self.savedPath.busPath.edges lastObject];
        int lastS = 0;
        while ([edge.tripID isEqualToString:@"landmark"] || [edge.tripID isEqualToString:@"walking"]) {
            ++lastS;
            edge = [self.savedPath.busPath.edges objectAtIndex:([self.savedPath.busPath.edges count] - (1 + lastS))];
        }
        MVANode *nodeB = edge.destini;
        MVANode *landmark = [self.savedPath.busPath.nodes lastObject];
        
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(97, 8, (w - (8 + 97)), 20)];
        
        double ref = self.savedPath.initTime;
        int second = (ref - (floor(ref/60) * 60.0f)) ;
        double ref2 = (ref / 60.0);
        int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
        int hora   = floor(ref / 3600);
        if (hora >= 24) hora -= 24;
        double refT = [landmark.distance doubleValue] - self.savedPath.initTime;
        if ([landmark.distance doubleValue] < self.savedPath.initTime) refT = ([landmark.distance doubleValue] + 86400) - self.savedPath.initTime;
        int secondT = (refT - (floor(refT/60) * 60.0f)) ;
        double refT2 = (refT / 60.0);
        int minuteT = (refT2 - (floor(refT2/60) * 60.0f)) ;
        int horaT   = floor(refT / 3600);
        double refF = [landmark.distance doubleValue];
        int secondF = (refF - (floor(refF/60) * 60.0f)) ;
        double refF2 = (refF / 60.0);
        int minuteF = (refF2 - (floor(refF2/60) * 60.0f)) ;
        int horaF   = floor(refF / 3600);
        if (horaF >= 24) horaF -= 24;
        
        [time setText:[NSString stringWithFormat:@"%02d:%02d:%02d - %02dh %02dm %02ds - %02d:%02d:%02d",hora,minute,second,horaT,minuteT,secondT,horaF,minuteF,secondF]];
        [time setFont:[UIFont systemFontOfSize:17.0f]];
        [time setAdjustsFontSizeToFitWidth:YES];
        [time setTextAlignment:NSTextAlignmentCenter];
        [time setTextColor:[UIColor darkGrayColor]];
        [v addSubview:time];
        
        UILabel *resumen = [[UILabel alloc] initWithFrame:CGRectMake(8, 77, (w - 16), 20)];
        [resumen setText:[[[@"from " stringByAppendingString:nodeA.stop.name] stringByAppendingString:@" to "] stringByAppendingString:nodeB.stop.name]];
        [resumen setFont:[UIFont systemFontOfSize:12.0f]];
        [resumen setAdjustsFontSizeToFitWidth:YES];
        [resumen setTextAlignment:NSTextAlignmentLeft];
        [resumen setTextColor:[UIColor darkGrayColor]];
        [v addSubview:resumen];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(8, 35, (w - 16), 32.5)];
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2.5, 30, 30)];
        [imV setImage:[UIImage imageNamed:@"walking-blue"]];
        [scrollView addSubview:imV];
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(38, 16.25)];
        [path addLineToPoint:CGPointMake(88, 16.25)];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setPath:[path CGPath]];
        shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        [scrollView.layer addSublayer:shapeLayer];
        
        UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake(48, 2.5, 30, 30)];
        [nombreR setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
        [nombreR.layer setCornerRadius:15.0f];
        [nombreR setClipsToBounds:YES];
        [scrollView addSubview:nombreR];
        
        UIImageView *changeIm = [[UIImageView alloc] initWithFrame:CGRectMake(53, 7.5, 20, 20)];
        changeIm.image = [UIImage imageNamed:@"walking-white-small"];
        [scrollView  addSubview:changeIm];
        
        UIImageView *imV2 = [[UIImageView alloc] initWithFrame:CGRectMake(96, 2.5, 30, 30)];
        [imV2 setImage:[UIImage imageNamed:@"bus-red"]];
        [scrollView addSubview:imV2];
        
        int x = 134;
        
        NSString *prevTripID = @"";
        
        for (int i = 0; i < [self.savedPath.busPath.edges count]; ++i) {
            MVAEdge *edge = [self.savedPath.busPath.edges objectAtIndex:i];
            
            NSString *tripID = edge.tripID;
            
            if ([edge.tripID isEqualToString:@"walking"] || [edge.tripID isEqualToString:@"change"] || [edge.tripID isEqualToString:@"landmark"]) {
                tripID = @"special";
            }
            
            if (![prevTripID isEqualToString:tripID]) {
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake(x, 16.25)];
                [path addLineToPoint:CGPointMake((x + 50), 16.25)];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                [shapeLayer setPath:[path CGPath]];
                if ([edge.tripID isEqualToString:@"walking"] || [edge.tripID isEqualToString:@"change"] || [edge.tripID isEqualToString:@"landmark"]) {
                    shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
                    shapeLayer.lineWidth = 3.0;
                    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
                    [scrollView.layer addSublayer:shapeLayer];
                    
                    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake((x + 10), 2.5, 30, 30)];
                    [nombreR setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
                    [nombreR.layer setCornerRadius:15.0f];
                    [nombreR setClipsToBounds:YES];
                    [scrollView addSubview:nombreR];
                    
                    UIImageView *changeIm = [[UIImageView alloc] initWithFrame:CGRectMake((x + 15), 7.5, 20, 20)];
                    if ([edge.tripID isEqualToString:@"change"]) changeIm.image = [UIImage imageNamed:@"change-directions"];
                    else changeIm.image = [UIImage imageNamed:@"walking-white-small"];
                    [scrollView  addSubview:changeIm];
                    prevTripID = @"special";
                }
                else {
                    MVARoute *route = [self findRoute:tripID subway:NO];
                    
                    [self.savedPath.busRoutes addObject:route];
                    
                    shapeLayer.strokeColor = [route.color CGColor];
                    shapeLayer.lineWidth = 3.0;
                    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
                    [scrollView.layer addSublayer:shapeLayer];
                    
                    UILabel *nombreR = [[UILabel alloc] initWithFrame:CGRectMake((x + 10), 2.5, 30, 30)];
                    [nombreR setBackgroundColor:route.color];
                    [nombreR setText:tripID];
                    [nombreR setTextColor:route.textColor];
                    [nombreR setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0f]];
                    [nombreR setAdjustsFontSizeToFitWidth:YES];
                    [nombreR.layer setCornerRadius:15.0f];
                    [nombreR setClipsToBounds:YES];
                    [nombreR setTextAlignment:NSTextAlignmentCenter];
                    [scrollView addSubview:nombreR];
                    prevTripID = tripID;
                }
                if ([edge.tripID isEqualToString:@"landmark"]) {
                    UIImageView *destIm = [[UIImageView alloc] initWithFrame:CGRectMake((x + 58), 2.5, 30, 30)];
                    [destIm setImage:[UIImage imageNamed:@"sagrada_familia"]];
                    [scrollView addSubview:destIm];
                }
                else {
                    UIImageView *destIm = [[UIImageView alloc] initWithFrame:CGRectMake((x + 58), 2.5, 30, 30)];
                    [destIm setImage:[UIImage imageNamed:@"bus-red"]];
                    [scrollView addSubview:destIm];
                }
                x += 96;
            }
            
        }
        [scrollView setShowsHorizontalScrollIndicator:NO];
        scrollView.contentSize = CGSizeMake((x + 10), scrollView.frame.size.height);
        scrollView.backgroundColor = [UIColor clearColor];
        
        [v addSubview:scrollView];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(busPathView:)];
        
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [v addGestureRecognizer: singleTap];
    }
    
    return v;
}

/**
 *  Function that gets called after the subway path view has been selected
 *
 *  @param gr The tap gesture recognizer object
 *
 *  @since version 1.0
 */
-(void)subwayPathView:(UITapGestureRecognizer *)gr
{
    self.subway = YES;
    [self performSegueWithIdentifier:@"seguePathView" sender:self];
}

/**
 *  Function that gets called after the bus path view has been selected
 *
 *  @param gr The tap gesture recognizer object
 *
 *  @since version 1.0
 */
-(void)busPathView:(UITapGestureRecognizer *)gr
{
    self.subway = NO;
    [self performSegueWithIdentifier:@"seguePathView" sender:self];
}

/**
 *  Function that creates the walking view
 *
 *  @return The walking view
 *
 *  @since version 1.0
 */
-(UIView *)walkingView
{
    CGFloat w = self.view.frame.size.width;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 203, w, 100)];
    [v setBackgroundColor:[UIColor whiteColor]];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 80, 20)];
    [name setText:@"Walking"];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
    [name setAdjustsFontSizeToFitWidth:YES];
    [name setTextAlignment:NSTextAlignmentLeft];
    [name setTextColor:[UIColor darkGrayColor]];
    [v addSubview:name];
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(97, 8, (w - (8 + 97)), 20)];
    
    double ref = self.savedPath.initTime;
    int second = (ref - (floor(ref/60) * 60.0f)) ;
    double ref2 = (ref / 60.0);
    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
    int hora   = floor(ref / 3600);
    if (hora >= 24) hora -= 24;
    double refT = self.savedPath.walkTime;
    int secondT = (refT - (floor(refT/60) * 60.0f)) ;
    double refT2 = (refT / 60.0);
    int minuteT = (refT2 - (floor(refT2/60) * 60.0f)) ;
    int horaT   = floor(refT / 3600);
    double refF = self.savedPath.initTime + self.savedPath.walkTime;
    int secondF = (refF - (floor(refF/60) * 60.0f)) ;
    double refF2 = (refF / 60.0);
    int minuteF = (refF2 - (floor(refF2/60) * 60.0f)) ;
    int horaF   = floor(refF / 3600);
    if (horaF >= 24) horaF -= 24;
    
    [time setText:[NSString stringWithFormat:@"%02d:%02d:%02d - %02dh %02dm %02ds - %02d:%02d:%02d",hora,minute,second,horaT,minuteT,secondT,horaF,minuteF,secondF]];
    [time setFont:[UIFont systemFontOfSize:17.0f]];
    [time setAdjustsFontSizeToFitWidth:YES];
    [time setTextAlignment:NSTextAlignmentCenter];
    [time setTextColor:[UIColor darkGrayColor]];
    [v addSubview:time];
    
    UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 49, 30, 30)];
    [imV setImage:[UIImage imageNamed:@"walking-blue"]];
    [v addSubview:imV];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(46.0, 64.0)];
    [path addLineToPoint:CGPointMake((w - 46.0), 64.0)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:[path CGPath]];
    shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [v.layer addSublayer:shapeLayer];
    
    UIImageView *imV2 = [[UIImageView alloc] initWithFrame:CGRectMake((w - 38), 49, 30, 30)];
    [imV2 setImage:[UIImage imageNamed:@"sagrada_familia"]];
    [v addSubview:imV2];
    
    UILabel *dist = [[UILabel alloc] initWithFrame:CGRectMake((w - 110.0)/2.0, 54, 110, 20)];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumFractionDigits:3];
    [formatter setMaximumFractionDigits:3];
    [formatter setMinimumIntegerDigits:2];
    [formatter setPaddingCharacter:@"0"];
    [formatter setPaddingPosition:NSNumberFormatterPadBeforePrefix];
    dist.text = [[formatter stringFromNumber:[NSNumber numberWithDouble:(self.savedPath.walkDist/1000)]] stringByAppendingString:@" kms "];
    [dist setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
    [dist setAdjustsFontSizeToFitWidth:YES];
    [dist setTextAlignment:NSTextAlignmentCenter];
    [dist setTextColor:[UIColor darkGrayColor]];
    [dist setBackgroundColor:[UIColor whiteColor]];
    [v addSubview:dist];
    
    return v;
}

/**
 *  Function that creates the taxi view
 *
 *  @return The taxi view
 *
 *  @since version 1.0
 */
-(UIView *)taxiCellView
{
    CGFloat w = self.view.frame.size.width;
    self.taxis = [[MVATaxis alloc] init];
    self.taxis.orig = self.savedPath.initCords;
    self.taxis.dest = self.savedPath.punto.coordinates;
    
    if ([self connectedToInternet]) {
        self.taxiView = [[UIView alloc] initWithFrame:CGRectMake(0, 304.5, w, 100)];
        [self.taxiView setBackgroundColor:[UIColor colorWithRed:(243.0f/255.0f) green:(181.0f/255.0f) blue:(59.0f/255.0f) alpha:1.0f]];
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 34, 34)];
        [imV setImage:[UIImage imageNamed:@"logoHailo"]];
        [self.taxiView addSubview:imV];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 104, 34)];
        [name setText:@"Hailo"];
        [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
        [name setAdjustsFontSizeToFitWidth:YES];
        [name setTextAlignment:NSTextAlignmentLeft];
        [name setTextColor:[UIColor whiteColor]];
        [self.taxiView addSubview:name];
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.alpha = 1.0;
        indicator.center = CGPointMake((w/2.0), 50);
        indicator.hidesWhenStopped = YES;
        [self.taxiView addSubview: indicator];
        [indicator startAnimating];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            [self.taxis loadHailoTime];
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hailoTap:)];
                
                singleTap.numberOfTapsRequired = 1;
                singleTap.numberOfTouchesRequired = 1;
                [self.taxiView addGestureRecognizer: singleTap];
                
                [indicator stopAnimating];
                NSDictionary *error = [self.taxis.hailoTimes objectForKey:@"error"];
                NSArray *etas = [self.taxis.hailoTimes objectForKey:@"etas"];
                if (error != nil) {
                    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake((w - (8 + 150)), 8, 150, 34)];
                    [time setText:[NSString stringWithFormat:@"%d minutes",(int)floor(self.savedPath.carTime/60.0)]];
                    [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
                    [time setAdjustsFontSizeToFitWidth:YES];
                    [time setTextAlignment:NSTextAlignmentRight];
                    [time setTextColor:[UIColor whiteColor]];
                    [self.taxiView addSubview:time];
                    UILabel *pickUp = [[UILabel alloc] initWithFrame:CGRectMake(8, 72,((w - 92) - 12), 20)];
                    [pickUp setText:@"The Hailo server returned an error. Data is estimated."];
                    [pickUp setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
                    [pickUp setAdjustsFontSizeToFitWidth:YES];
                    [pickUp setTextAlignment:NSTextAlignmentLeft];
                    [pickUp setTextColor:[UIColor whiteColor]];
                    [self.taxiView addSubview:pickUp];
                    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake((w - 92), 72, 84, 20)];
                    double est = [self.taxis taxiFareWithDistance:self.savedPath.carDist andDate:self.savedPath.date];
                    [price setText:[NSString stringWithFormat:@"%.2f€",est]];
                    [price setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
                    [price setAdjustsFontSizeToFitWidth:YES];
                    [price setTextAlignment:NSTextAlignmentRight];
                    [price setTextColor:[UIColor whiteColor]];
                    [self.taxiView addSubview:price];
                }
                else if ([etas count] == 0) {
                    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake((w - (8 + 150)), 8, 150, 34)];
                    [time setText:[NSString stringWithFormat:@"%d minutes",(int)floor(self.savedPath.carTime/60.0)]];
                    [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
                    [time setAdjustsFontSizeToFitWidth:YES];
                    [time setTextAlignment:NSTextAlignmentRight];
                    [time setTextColor:[UIColor whiteColor]];
                    [self.taxiView addSubview:time];
                    UILabel *pickUp = [[UILabel alloc] initWithFrame:CGRectMake(8, 72, ((w - 92) - 12), 20)];
                    [pickUp setText:@"The Hailo server didn't return any taxi. Data is estimated."];
                    [pickUp setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
                    [pickUp setAdjustsFontSizeToFitWidth:YES];
                    [pickUp setTextAlignment:NSTextAlignmentLeft];
                    [pickUp setTextColor:[UIColor whiteColor]];
                    [self.taxiView addSubview:pickUp];
                    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake((w - 8 - 90), 72, 90, 20)];
                    double est = [self.taxis taxiFareWithDistance:self.savedPath.carDist andDate:self.savedPath.date];
                    [price setText:[NSString stringWithFormat:@"%.2f€",est]];
                    [price setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
                    [price setAdjustsFontSizeToFitWidth:YES];
                    [price setTextAlignment:NSTextAlignmentRight];
                    [price setTextColor:[UIColor whiteColor]];
                    [self.taxiView addSubview:price];
                }
                else {
                    NSMutableDictionary *estTime = [etas firstObject];
                    NSNumber *travelTime = [estTime objectForKey:@"eta"];
                    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake((w - (8 + 150)), 8, 150, 34)];
                    [time setText:[NSString stringWithFormat:@"%d minutes",[travelTime intValue]]];
                    [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
                    [time setAdjustsFontSizeToFitWidth:YES];
                    [time setTextAlignment:NSTextAlignmentRight];
                    [time setTextColor:[UIColor whiteColor]];
                    [self.taxiView addSubview:time];
                    UILabel *pickUp = [[UILabel alloc] initWithFrame:CGRectMake(8, 72, 154, 20)];
                    [pickUp setText:[@"Taxi service: " stringByAppendingString:[estTime objectForKey:@"service_type"]]];
                    [pickUp setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
                    [pickUp setAdjustsFontSizeToFitWidth:YES];
                    [pickUp setTextAlignment:NSTextAlignmentLeft];
                    [pickUp setTextColor:[UIColor whiteColor]];
                    [self.taxiView addSubview:pickUp];
                    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake((w - 8 - 90), 72, 90, 20)];
                    double est = [self.taxis taxiFareWithDistance:self.savedPath.carDist andDate:self.savedPath.date];
                    [price setText:[NSString stringWithFormat:@"%.2f€",est]];
                    [price setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
                    [price setAdjustsFontSizeToFitWidth:YES];
                    [price setTextAlignment:NSTextAlignmentRight];
                    [price setTextColor:[UIColor whiteColor]];
                    [self.taxiView addSubview:price];
                }
            });
        });
        
        return self.taxiView;
        
    }
    else {
        self.taxiView = [[UIView alloc] initWithFrame:CGRectMake(0, 304.5, w, 100)];
        [self.taxiView setBackgroundColor:[UIColor colorWithRed:(243.0f/255.0f) green:(181.0f/255.0f) blue:(59.0f/255.0f) alpha:1.0f]];
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 34, 34)];
        [imV setImage:[UIImage imageNamed:@"taxi-color"]];
        [imV setBackgroundColor:[UIColor whiteColor]];
        [imV.layer setCornerRadius:5.0f];
        [imV setClipsToBounds:YES];
        [self.taxiView addSubview:imV];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 104, 34)];
        [name setText:@"Taxi"];
        [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
        [name setAdjustsFontSizeToFitWidth:YES];
        [name setTextAlignment:NSTextAlignmentLeft];
        [name setTextColor:[UIColor whiteColor]];
        [self.taxiView addSubview:name];
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake((w - (8 + 150)), 8, 150, 34)];
        [time setText:[NSString stringWithFormat:@"%d minutes",(int)floor(self.savedPath.carTime/60.0)]];
        [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
        [time setAdjustsFontSizeToFitWidth:YES];
        [time setTextAlignment:NSTextAlignmentRight];
        [time setTextColor:[UIColor whiteColor]];
        [self.taxiView addSubview:time];
        UILabel *pickUp = [[UILabel alloc] initWithFrame:CGRectMake(8, 72, (w - 108), 20)];
        [pickUp setText:@"Price and times estimated for a regular service."];
        [pickUp setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        [pickUp setAdjustsFontSizeToFitWidth:YES];
        [pickUp setTextAlignment:NSTextAlignmentLeft];
        [pickUp setTextColor:[UIColor whiteColor]];
        [self.taxiView addSubview:pickUp];
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake((w - 98), 72, 90, 20)];
        double est = [self.taxis taxiFareWithDistance:self.savedPath.carDist andDate:self.savedPath.date];
        [price setText:[NSString stringWithFormat:@"%.2f€",est]];
        [price setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        [price setAdjustsFontSizeToFitWidth:YES];
        [price setTextAlignment:NSTextAlignmentRight];
        [price setTextColor:[UIColor whiteColor]];
        [self.taxiView addSubview:price];
        return self.taxiView;
    }
}

/**
 *  Function that creates the footer view
 *
 *  @return The footer view
 *
 *  @since version 1.0
 */
-(UIView *)footerView
{
    CGFloat w = self.view.frame.size.width;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 404.5, w, 40)];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, (w - 16), 40)];
    myLabel.numberOfLines = 0;
    [myLabel setFont:[UIFont systemFontOfSize:10.0f]];
    myLabel.text = @"All the times, itineraries and taxi fares calculated, are an estimation and can be subject of variation due to unexpected events or special conditions.";
    [v addSubview:myLabel];
    return v;
}

/**
 *  Function that gets called after the taxi view has been selected
 *
 *  @param gr The tap gesture recognizer object
 *
 *  @since version 1.0
 */
-(void)hailoTap:(UITapGestureRecognizer *)gr
{
    if (![self.taxis openHailo]) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"You need the Hailo app"
                                          message:@"Visit the App Store and download it"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"App store"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/es/app/hailo/id468420446?mt=8"]];
                                     //Do some thing here
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok]; // add action to uialertcontroller
            
            UIAlertAction* ok2 = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok2];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            //show alertview
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You need the Hailo app"
                                                            message:@"Visit the App Store and download it"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"App store", nil];
            [alert show];
        }
    }
}

/**
 *  Sent to the delegate when the user clicks a button on an alert view.
 *
 *  @param alertView   The alert view containing the button.
 *  @param buttonIndex The index of the button that was clicked. The button indices start at 0.
 *
 *  @since version 1.0
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/es/app/hailo/id468420446?mt=8"]];
    }
}

/**
 *  Function that looks for the MVARoute object for a given routeID
 *
 *  @param routeID The identifier of the route
 *  @param subway  A bool that indicates if the query is performed for the subway or the bus network
 *
 *  @return The MVARoute object
 *
 *  @since version 1.0
 */
-(MVARoute *)findRoute:(NSString *)routeID subway:(BOOL)subway
{
    if (subway) {
        for (int i = 0; i < [self.savedPath.subwayRoutes count]; ++i) {
            MVARoute *route = [self.savedPath.subwayRoutes objectAtIndex:i];
            if ([route.routeID isEqualToString:routeID]) return route;
        }
    }
    else {
        for (int i = 0; i < [self.savedPath.busRoutes count]; ++i) {
            MVARoute *route = [self.savedPath.busRoutes objectAtIndex:i];
            if ([route.routeID isEqualToString:routeID]) return route;
        }
    }
    return nil;
}

/**
 *  Function that checks if there's internet connection
 *
 *  @return A bool answering the query
 *
 *  @since version 1.0
 */
- (BOOL)connectedToInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
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
    if ([segue.identifier isEqualToString:@"seguePathView"]) {
        MVAPathViewController *vc = (MVAPathViewController *)segue.destinationViewController;
        vc.subway = self.subway;
        vc.savedPath = self.savedPath;
    }
}

@end
