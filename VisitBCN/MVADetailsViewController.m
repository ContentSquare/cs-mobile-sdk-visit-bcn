//
//  MVADetailsTableViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 2/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVADetailsViewController.h"
#import "MVAPathTableViewCell.h"
#import "MVATaxiTableViewCell.h"
#import "MVATaxis.h"

@interface MVADetailsViewController ()

@property MVATaxis *taxis;

@end

@implementation MVADetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self createParallax];
}

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
    UIView *thirdCell = [self taxiView];
    [subContentView addSubview:thirdCell];
    
    //Optional stuff, Add The Fourth
    UIView *fourthCell = [self walkingView];
    [subContentView addSubview:fourthCell];
    
    //Optional stuff, Add footer
    UIView *footerView = [self footerView];
    [subContentView addSubview:footerView];
    
}

-(UIView *)insetView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 403)];
    [v setBackgroundColor:[UIColor whiteColor]];
    return v;
}

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
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(97, 8, (w - (8 + 97)), 20)];
    [time setText:@"HH:MM:SS - HHh MMm SSs - HH:MM:SS"];
    [time setFont:[UIFont fontWithName:@"HelveticaNeue-Regular" size:13.0f]];
    [time setAdjustsFontSizeToFitWidth:YES];
    [time setTextAlignment:NSTextAlignmentCenter];
    [time setTextColor:[UIColor darkGrayColor]];
    [v addSubview:time];
    UILabel *resumen = [[UILabel alloc] initWithFrame:CGRectMake(8, 77, (w - 16), 15)];
    [resumen setText:@"form XXXXXXXXX to YYYYYYYYYYYYY"];
    [resumen setFont:[UIFont fontWithName:@"HelveticaNeue-Regular" size:13.0f]];
    [resumen setAdjustsFontSizeToFitWidth:YES];
    [resumen setTextAlignment:NSTextAlignmentLeft];
    [resumen setTextColor:[UIColor darkGrayColor]];
    [v addSubview:resumen];
    
    UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 37.5, 30, 30)];
    [imV setImage:[UIImage imageNamed:@"walking-blue"]];
    [v addSubview:imV];
    
    return v;
}

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
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(97, 8, (w - (8 + 97)), 20)];
    [time setText:@"HH:MM:SS - HHh MMm SSs - HH:MM:SS"];
    [time setFont:[UIFont fontWithName:@"HelveticaNeue-Regular" size:13.0f]];
    [time setAdjustsFontSizeToFitWidth:YES];
    [time setTextAlignment:NSTextAlignmentCenter];
    [time setTextColor:[UIColor darkGrayColor]];
    [v addSubview:time];
    UILabel *resumen = [[UILabel alloc] initWithFrame:CGRectMake(8, 77, (w - 16), 15)];
    [resumen setText:@"form XXXXXXXXX to YYYYYYYYYYYYY"];
    [resumen setFont:[UIFont fontWithName:@"HelveticaNeue-Regular" size:13.0f]];
    [resumen setAdjustsFontSizeToFitWidth:YES];
    [resumen setTextAlignment:NSTextAlignmentLeft];
    [resumen setTextColor:[UIColor darkGrayColor]];
    [v addSubview:resumen];
    return v;
}

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
    
    double ref = self.initTime;
    int second = (ref - (floor(ref/60) * 60.0f)) ;
    double ref2 = (ref / 60.0);
    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
    int hora   = floor(ref / 3600);
    double refT = self.walkTime;
    int secondT = (refT - (floor(refT/60) * 60.0f)) ;
    double refT2 = (refT / 60.0);
    int minuteT = (refT2 - (floor(refT2/60) * 60.0f)) ;
    int horaT   = floor(refT / 3600);
    double refF = self.initTime + self.walkTime;
    int secondF = (refF - (floor(refF/60) * 60.0f)) ;
    double refF2 = (refF / 60.0);
    int minuteF = (refF2 - (floor(refF2/60) * 60.0f)) ;
    int horaF   = floor(refF / 3600);
    
    [time setText:[NSString stringWithFormat:@"%02d:%02d:%02d - %02dh %02dm %02ds - %02d:%02d:%02d",hora,minute,second,horaT,minuteT,secondT,horaF,minuteF,secondF]];
    [time setFont:[UIFont fontWithName:@"HelveticaNeue-Regular" size:13.0f]];
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
    dist.text = [[formatter stringFromNumber:[NSNumber numberWithDouble:(self.walkDist/1000)]] stringByAppendingString:@" Kms "];
    [dist setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
    [dist setAdjustsFontSizeToFitWidth:YES];
    [dist setTextAlignment:NSTextAlignmentCenter];
    [dist setTextColor:[UIColor darkGrayColor]];
    [dist setBackgroundColor:[UIColor whiteColor]];
    [v addSubview:dist];
    
    return v;
}

-(UIView *)taxiView
{
    CGFloat w = self.view.frame.size.width;
    
    int alg = 0;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [defaults objectForKey:@"VisitBCNTaxi"];
    if(data == nil){
        [defaults setInteger:1 forKey:@"VisitBCNTaxi"];
        alg = 1;
    }
    else {
        alg = (int)[defaults integerForKey:@"VisitBCNTaxi"];
    }
    if(alg == 0) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 304.5, w, 100)];
        [v setBackgroundColor:[UIColor colorWithRed:(243.0f/255.0f) green:(181.0f/255.0f) blue:(59.0f/255.0f) alpha:1.0f]];
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 34, 34)];
        [imV setImage:[UIImage imageNamed:@"logoHailo"]];
        [v addSubview:imV];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 104, 34)];
        [name setText:@"Hailo"];
        [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
        [name setAdjustsFontSizeToFitWidth:YES];
        [name setTextAlignment:NSTextAlignmentLeft];
        [name setTextColor:[UIColor whiteColor]];
        [v addSubview:name];
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake((w - (8 + 150)), 8, 150, 34)];
        [time setText:@"XX minutes"];
        [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
        [time setAdjustsFontSizeToFitWidth:YES];
        [time setTextAlignment:NSTextAlignmentRight];
        [time setTextColor:[UIColor whiteColor]];
        [v addSubview:time];
        UILabel *pickUp = [[UILabel alloc] initWithFrame:CGRectMake(8, 72, 154, 20)];
        [pickUp setText:@"Pick up in XX minutes"];
        [pickUp setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        [pickUp setAdjustsFontSizeToFitWidth:YES];
        [pickUp setTextAlignment:NSTextAlignmentLeft];
        [pickUp setTextColor:[UIColor whiteColor]];
        [v addSubview:pickUp];
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake((w - 8 - 90), 72, 90, 20)];
        [price setText:@"XX - XX €"];
        [price setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        [price setAdjustsFontSizeToFitWidth:YES];
        [price setTextAlignment:NSTextAlignmentRight];
        [price setTextColor:[UIColor whiteColor]];
        [v addSubview:price];
        return v;
    }
    else {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 304.5, w, 100)];
        [v setBackgroundColor:[UIColor colorWithRed:(16.0f/255.0f) green:(17.0f/255.0f) blue:(36.0f/255.0f) alpha:1.0f]];
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 34, 34)];
        [imV setImage:[UIImage imageNamed:@"logoUber"]];
        [v addSubview:imV];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 104, 34)];
        [name setText:@"Uber"];
        [name setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
        [name setAdjustsFontSizeToFitWidth:YES];
        [name setTextAlignment:NSTextAlignmentLeft];
        [name setTextColor:[UIColor whiteColor]];
        [v addSubview:name];
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake((w - (8 + 150)), 8, 150, 34)];
        [time setText:@"XX minutes"];
        [time setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.0f]];
        [time setAdjustsFontSizeToFitWidth:YES];
        [time setTextAlignment:NSTextAlignmentRight];
        [time setTextColor:[UIColor whiteColor]];
        [v addSubview:time];
        UILabel *pickUp = [[UILabel alloc] initWithFrame:CGRectMake(8, 72, 154, 20)];
        [pickUp setText:@"Pick up in XX minutes"];
        [pickUp setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        [pickUp setAdjustsFontSizeToFitWidth:YES];
        [pickUp setTextAlignment:NSTextAlignmentLeft];
        [pickUp setTextColor:[UIColor whiteColor]];
        [v addSubview:pickUp];
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake((w - 8 - 90), 72, 90, 20)];
        [price setText:@"XX - XX €"];
        [price setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f]];
        [price setAdjustsFontSizeToFitWidth:YES];
        [price setTextAlignment:NSTextAlignmentRight];
        [price setTextColor:[UIColor whiteColor]];
        [v addSubview:price];
        return v;
    }
}

-(UIView *)footerView
{
    CGFloat w = self.view.frame.size.width;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 404.5, w, 40)];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, (w - 16), 40)];
    myLabel.numberOfLines = 0;
    [myLabel setFont:[UIFont systemFontOfSize:10.0f]];
    myLabel.text = @"All the times and itineraries calculated are an estimation and can be subject of variation due to unexpected events.";
    [v addSubview:myLabel];
    return v;
}

@end
