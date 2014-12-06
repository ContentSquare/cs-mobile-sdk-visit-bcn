//
//  MVAPunIntViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPunIntViewController.h"
#import "Reachability.h"
#import "MVAGraphs.h"
#import "MVADetailsViewController.h"

@interface MVAPunIntViewController ()

@property MVAPath *subwayPath;
@property MVAPath *busPath;

@property UIView *pathsView;
@property UIActivityIndicatorView *activityIndicator;
@property UILabel *pathsResume;

@property double walkDist;
@property double walkSpeed;
@property double walkTime;

@property double carDist;
@property double carTime;
@property double carSpeed;

@property double initTime;

@end

@implementation MVAPunIntViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.punto != nil) self.navigationItem.title = self.punto.nombre;
    else self.navigationItem.title = self.customlocation.name;
    [self createParallax];
    [self calcularPaths];
    self.stop = NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.stop = YES;
}

-(void)createParallax
{
    NSMutableDictionary* views = [NSMutableDictionary new];
    views[@"super"] = self.view;
    views[@"topGuide"] = self.topLayoutGuide; // The bottom of the navigation bar, if a navigation bar is visible. The bottom of the status bar, if only a status bar is visible .. etc...
    
    CGFloat textSize;
    if (self.punto != nil) {
        textSize = [self heightForView:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]
                                  text:self.punto.descr
                               andSize:(self.view.frame.size.width - 16)];
    }
    else textSize = (self.view.frame.size.height - 500);
    
    if (textSize < (self.view.frame.size.height - 340)) textSize = (self.view.frame.size.height - 500);
    
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
    UIImage *img;
    if (self.punto != nil) img = [UIImage imageNamed:self.punto.fotoGr];
    else img = self.customlocation.foto;
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
    format = [NSString stringWithFormat:@"V:|-imageHeight-[subContentView(%.2f)]-0-|",(textSize + 340)];
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
    
    //Optional stuff, Add The A view
    UITextView *aView = [UITextView new];
    [aView setEditable:NO];
    if (self.punto != nil) aView.text = self.punto.descr;
    else aView.text = @"Custom location";
    aView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    aView.backgroundColor = [UIColor clearColor];
    [aView setFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    aView.textColor = [UIColor blackColor];
    aView.textAlignment = NSTextAlignmentJustified;
    [subContentView addSubview:aView];
    views[@"aView"] = aView;
    format = @"|-8-[aView]-8-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    format = @"V:|-60-[aView]-8-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    
    //Optional stuff, Add The B view
    self.pathsView = [UIView new];
    self.pathsView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    self.pathsView.backgroundColor = [UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f];
    [self.pathsView.layer setCornerRadius:50];
    [self.pathsView setClipsToBounds:YES];
    [subContentView addSubview:self.pathsView];
    views[@"bView"] = self.pathsView;
    CGRect f = self.view.frame;
    float s = (f.size.width - 100) / 2;
    format = [NSString stringWithFormat:@"|-%.2f-[bView]-%.2f-|",s,s];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    format = [NSString stringWithFormat:@"V:|-(-50)-[bView]-%.2f-|",(textSize + 290)];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    
    //Optional stuff, Add The C view
    UILabel* cView = [UILabel new];
    if (self.punto != nil) cView.text = [NSString stringWithFormat:@"(%.4f , %.4f)",self.punto.coordinates.latitude,self.punto.coordinates.longitude];
    else cView.text = [NSString stringWithFormat:@"(%.4f , %.4f)",self.customlocation.coordinates.latitude,self.customlocation.coordinates.longitude];
    cView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    cView.backgroundColor = [UIColor clearColor];
    [cView setFont: [UIFont systemFontOfSize:13]];
    [cView setAdjustsFontSizeToFitWidth:YES];
    cView.textColor = [UIColor blackColor];
    cView.textAlignment = NSTextAlignmentLeft;
    [cView setNumberOfLines:1];
    [subContentView addSubview:cView];
    views[@"cView"] = cView;
    format = [NSString stringWithFormat:@"|-8-[cView]-%.2f-|",(s + 108)];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    format = [NSString stringWithFormat:@"V:|-5-[cView]-%.2f-|",(textSize + 290)];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    
    //Optional stuff, Add The D view
    UILabel* dView = [UILabel new];
    if (self.punto != nil) dView.text = self.punto.street;
    else dView.text = @"";
    dView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    dView.backgroundColor = [UIColor clearColor];
    [dView setFont: [UIFont systemFontOfSize:13]];
    [dView setAdjustsFontSizeToFitWidth:YES];
    dView.textColor = [UIColor blackColor];
    dView.textAlignment = NSTextAlignmentRight;
    [dView setNumberOfLines:0];
    [subContentView addSubview:dView];
    views[@"dView"] = dView;
    
    format = [NSString stringWithFormat:@"|-%.2f-[dView]-8-|",(s + 108)];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    format = [NSString stringWithFormat:@"V:|-5-[dView]-%.2f-|",(textSize + 290)];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(void)calcularPaths
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.alpha = 1.0;
    self.activityIndicator.center = CGPointMake(50, 45);
    self.activityIndicator.hidesWhenStopped = YES;
    [self.pathsView addSubview: self.activityIndicator];
    [self.activityIndicator startAnimating];
    self.pathsResume = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 60, 30)];
    self.pathsResume.text = @"Loading";
    [self.pathsResume setAdjustsFontSizeToFitWidth:YES];
    [self.pathsResume setTextAlignment:NSTextAlignmentCenter];
    self.pathsResume.textColor = [UIColor whiteColor];
    self.pathsResume.font = [UIFont fontWithName:@"Helveticaneue-Bold" size:11.0f];
    [self.pathsView addSubview:self.pathsResume];
    self.initTime = [self initalTime];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
        MVAGraphs *graphs = [[MVAGraphs alloc] init];
        [graphs generateGraphsWithBUSDB:delegate.dataBus andTMBDB:delegate.dataTMB andFGCDB:delegate.dataFGC];
        graphs.viewController = self;
        
        if (self.punto != nil) {
            if ([self distanceForCoordinates:[self getCoordinates] andCoordinates:self.punto.coordinates] > [self loadWalkingDist]) {
                [graphs computePathsWithOrigin:[self getCoordinates] andDestination:self.punto];
            }
        }
        else {
            if ([self distanceForCoordinates:[self getCoordinates] andCoordinates:self.customlocation.coordinates] > [self loadWalkingDist]) {
                MVAPunInt *punto = [[MVAPunInt alloc] init];
                punto.nombre = self.customlocation.name;
                punto.coordinates = self.customlocation.coordinates;
                [graphs computePathsWithOrigin:[self getCoordinates] andDestination:punto];
            }
        }
        
        [self calculateWalkAndCar];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.subwayPath = graphs.subwayPath;
            self.busPath = graphs.busPath;
            [self.activityIndicator stopAnimating];
            UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(30, 20, 40, 40)];
            if ((self.subwayPath == nil) && (self.busPath == nil)) {
                if (self.walkDist < [self loadWalkingDist]) {
                    double ref = self.initTime + self.walkTime;
                    int second = (ref - (floor(ref/60) * 60.0f)) ;
                    double ref2 = (ref / 60.0);
                    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                    int hora   = floor(ref / 3600);
                    self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                    logo.image = [UIImage imageNamed:@"walking-white"];
                }
                else {
                    logo.image = [UIImage imageNamed:@"taxi-white"];
                    double ref = self.initTime + self.carTime;
                    int second = (ref - (floor(ref/60) * 60.0f)) ;
                    double ref2 = (ref / 60.0);
                    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                    int hora   = floor(ref / 3600);
                    self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                }
            }
            else if (self.subwayPath == nil && self.busPath != nil) {
                if (self.walkDist < [self loadWalkingDist]) {
                    double ref = self.initTime + self.walkTime;
                    int second = (ref - (floor(ref/60) * 60.0f)) ;
                    double ref2 = (ref / 60.0);
                    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                    int hora   = floor(ref / 3600);
                    self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                    logo.image = [UIImage imageNamed:@"walking-white"];
                }
                else {
                    double ref = self.busPath.totalWeight;
                    int second = (ref - (floor(ref/60) * 60.0f)) ;
                    double ref2 = (ref / 60.0);
                    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                    int hora   = floor(ref / 3600);
                    self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                    logo.image = [UIImage imageNamed:@"bus-white"];
                }
            }
            else if (self.subwayPath != nil && self.busPath == nil) {
                if (self.walkDist < [self loadWalkingDist]) {
                    double ref = self.initTime + self.walkTime;
                    int second = (ref - (floor(ref/60) * 60.0f)) ;
                    double ref2 = (ref / 60.0);
                    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                    int hora   = floor(ref / 3600);
                    self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                    logo.image = [UIImage imageNamed:@"walking-white"];
                }
                else {
                    double ref = self.subwayPath.totalWeight;
                    int second = (ref - (floor(ref/60) * 60.0f)) ;
                    double ref2 = (ref / 60.0);
                    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                    int hora   = floor(ref / 3600);
                    self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                    logo.image = [UIImage imageNamed:@"train-white"];
                }
            }
            else {
                if (self.subwayPath.totalWeight <= self.busPath.totalWeight) {
                    if (self.walkDist < [self loadWalkingDist]) {
                        double ref = self.initTime + self.walkTime;
                        int second = (ref - (floor(ref/60) * 60.0f)) ;
                        double ref2 = (ref / 60.0);
                        int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                        int hora   = floor(ref / 3600);
                        self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                        logo.image = [UIImage imageNamed:@"walking-white"];
                    }
                    else {
                        double ref = self.subwayPath.totalWeight;
                        int second = (ref - (floor(ref/60) * 60.0f)) ;
                        double ref2 = (ref / 60.0);
                        int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                        int hora   = floor(ref / 3600);
                        self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                        logo.image = [UIImage imageNamed:@"train-white"];
                    }
                    
                }
                else {
                    if (self.walkDist < [self loadWalkingDist]) {
                        double ref = self.initTime + self.walkTime;
                        int second = (ref - (floor(ref/60) * 60.0f)) ;
                        double ref2 = (ref / 60.0);
                        int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                        int hora   = floor(ref / 3600);
                        self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                        logo.image = [UIImage imageNamed:@"walking-white"];
                    }
                    else {
                        double ref = self.busPath.totalWeight;
                        int second = (ref - (floor(ref/60) * 60.0f)) ;
                        double ref2 = (ref / 60.0);
                        int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
                        int hora   = floor(ref / 3600);
                        self.pathsResume.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second];
                        logo.image = [UIImage imageNamed:@"bus-white"];
                    }
                }
            }
            [self.pathsView addSubview:logo];
            
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            
            singleTap.numberOfTapsRequired = 1;
            singleTap.numberOfTouchesRequired = 1;
            [self.pathsView addGestureRecognizer: singleTap];
        });
    });
}

-(void)calculateWalkAndCar
{
    double realDist;
    if (self.punto != nil) realDist = [self distanceForCoordinates:[self getCoordinates] andCoordinates:self.punto.coordinates];
    else realDist = [self distanceForCoordinates:[self getCoordinates] andCoordinates:self.customlocation.coordinates];
    self.walkDist = (1.25 * realDist);
    self.walkSpeed = [self loadWalkingSpeed];
    self.walkTime = (self.walkDist / self.walkSpeed);
    self.carDist = (1.4 * realDist);
    self.carSpeed = (195.0 / 36.0);
    if ([self loadRain]) self.carSpeed /= 1.2;
    self.carTime = self.carDist / self.carSpeed;
}

-(double)distanceForCoordinates:(CLLocationCoordinate2D)cordA andCoordinates:(CLLocationCoordinate2D)cordB
{
    double R = 6372797.560856;
    double dLat = ((cordB.latitude - cordA.latitude) * M_PI) / 180.0;
    double dLon = ((cordB.longitude - cordA.longitude) * M_PI) / 180.0;
    double lat1 = (cordA.latitude * M_PI) / 180.0;
    double lat2 = (cordB.latitude * M_PI) / 180.0;
    
    double a = (sin(dLat/2.0) * sin(dLat/2.0)) + (sin(dLon/2.0) * sin(dLon/2.0) * cos(lat1) * cos(lat2));
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    
    return (R * c);
}

-(void)handleSingleTap:(UITapGestureRecognizer *)gr
{
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

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

-(double)loadWalkingSpeed
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSString *nom = @"VisitBCNWalkingSpeed";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setDouble:(5000.0/3600) forKey:nom];
        if ([self loadRain]) return ((5000.0/3600) / 1.2);
        return (5000.0/3600);
    }
    else {
        if ([self loadRain]) return ([defaults doubleForKey:nom] / 1.2);
        return [defaults doubleForKey:nom];
    }
}

-(BOOL)loadRain
{
    int alg = 0;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [defaults objectForKey:@"VisitBCNRain"];
    if(data == nil){
        [defaults setInteger:0 forKey:@"VisitBCNRain"];
    }
    else {
        alg = (int)[defaults integerForKey:@"VisitBCNRain"];
    }
    if (alg == 1) return YES;
    return NO;
}

-(int)loadUberOrHailo
{
    int alg = 1;
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [defaults objectForKey:@"VisitBCNTaxi"];
    if(data == nil){
        [defaults setInteger:1 forKey:@"VisitBCNTaxi"];
    }
    else {
        alg = (int)[defaults integerForKey:@"VisitBCNTaxi"];
    }
    return alg;
}

-(double)loadWalkingDist
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSString *nom = @"VisitBCNWalkingDist";
    NSData *data = [defaults objectForKey:nom];
    if(data == nil){
        [defaults setDouble:1000.0 forKey:nom];
        return 1000.0;
    }
    else {
        return [defaults doubleForKey:nom];
    }
}

-(double)initalTime
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[self loadCustomDate]];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger seconds = [components second];
    double sec_rep = (hour * 3600) + (minute * 60) + seconds;
    return sec_rep;
}

-(BOOL)customDate
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [defaults objectForKey:@"VisitBCNCustomDateEnabled"];
    if (data == nil) {
        [defaults setObject:@"NO" forKey:@"VisitBCNCustomDateEnabled"];
        return NO;
    }
    NSString *string = [defaults objectForKey:@"VisitBCNCustomDateEnabled"];
    if ([string isEqualToString:@"NO"]) return NO;
    return YES;
}

-(NSDate *)loadCustomDate
{
    [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
    if (![self customDate]) return [NSDate date];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSDate *date = [defaults objectForKey:@"VisitBCNCustomDate"];
    if (!date) return [NSDate date];
    NSTimeZone *tz = [NSTimeZone timeZoneWithName:@"Europe/Madrid"];
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    date = [NSDate dateWithTimeInterval:seconds sinceDate: date];
    return date;
}

-(CLLocationCoordinate2D)getCoordinates
{
    int custom = [self loadCustom];
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (custom == 0) return delegate.coordinates;
    else {
        MVACustomLocation *loc = [self loadCustomLocation];
        return loc.coordinates;
    }
}

-(int)loadCustom
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *data = [sharedDefaults objectForKey:@"VisitBCNIsCustom"];
    if (data == nil) {
        [sharedDefaults setObject:[NSNumber numberWithInt:0] forKey:@"VisitBCNIsCustom"];
        return 0;
    }
    NSNumber *num = [sharedDefaults objectForKey:@"VisitBCNIsCustom"];
    return [num intValue];
}

- (MVACustomLocation *) loadCustomLocation
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *savedArray = [defaults objectForKey:@"VisitBCNCustomLocations"];
    NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
    NSArray *customLocations = [[NSArray alloc] initWithArray:oldArray];
    return [customLocations objectAtIndex:([self loadCustom] - 1)];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        MVADetailsViewController *vc = (MVADetailsViewController *)segue.destinationViewController;
        vc.subwayPath = self.subwayPath;
        vc.busPath = self.busPath;
        vc.walkDist = self.walkDist;
        vc.walkTime = self.walkTime;
        vc.carDist = self.carDist;
        vc.carTime = self.carTime;
        vc.punto = self.punto;
        vc.orig = [self getCoordinates];
        vc.initTime = self.initTime;
    }
}

@end
