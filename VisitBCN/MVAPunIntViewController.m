//
//  MVAPunIntViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPunIntViewController.h"

@interface MVAPunIntViewController ()

@end

@implementation MVAPunIntViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.punto.nombre;
    [self createParallax];
}

-(void)createParallax
{
    NSMutableDictionary* views = [NSMutableDictionary new];
    views[@"super"] = self.view;
    views[@"topGuide"] = self.topLayoutGuide; // The bottom of the navigation bar, if a navigation bar is visible. The bottom of the status bar, if only a status bar is visible .. etc...
    
    CGFloat textSize = [self heightForView:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]
                                      text:self.punto.descr
                                   andSize:(self.view.frame.size.width - 16)];
    
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
    UIImage *img = [UIImage imageNamed:self.punto.fotoGr];
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
    aView.text = self.punto.descr;
    aView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    aView.backgroundColor = [UIColor clearColor];
    [aView setFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
    aView.textColor = [UIColor whiteColor];
    aView.textAlignment = NSTextAlignmentJustified;
    [subContentView addSubview:aView];
    [aView setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    views[@"aView"] = aView;
    format = @"|-8-[aView]-8-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    format = @"V:|-60-[aView]-8-|";
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
    [subContentView addConstraints:constraints];
    
    //Optional stuff, Add The B view
    UILabel* bView = [UILabel new];
    bView.text = @"B";
    bView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    bView.backgroundColor = [UIColor colorWithRed:(52.0/255.0) green:(94.0/255.0) blue:(242.0/255.0) alpha:1];
    [bView setFont: [UIFont systemFontOfSize:40]];
    bView.textColor = [UIColor whiteColor];
    bView.textAlignment = NSTextAlignmentCenter;
    [bView.layer setCornerRadius:50];
    [bView setClipsToBounds:YES];
    [subContentView addSubview:bView];
    views[@"bView"] = bView;
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
    cView.text = [NSString stringWithFormat:@"(%.4f , %.4f)",self.punto.coordinates.latitude,self.punto.coordinates.longitude];
    cView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    cView.backgroundColor = [UIColor clearColor];
    [cView setFont: [UIFont systemFontOfSize:13]];
    [cView setAdjustsFontSizeToFitWidth:YES];
    cView.textColor = [UIColor whiteColor];
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
    dView.text = self.punto.street;
    dView.translatesAutoresizingMaskIntoConstraints = NO; //we are using auto layout
    dView.backgroundColor = [UIColor clearColor];
    [dView setFont: [UIFont systemFontOfSize:13]];
    [dView setAdjustsFontSizeToFitWidth:YES];
    dView.textColor = [UIColor whiteColor];
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
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.graphs generateGraphsWithBUSDB:delegate.dataBus andTMBDB:delegate.dataTMB andFGCDB:delegate.dataFGC];
    [delegate.graphs computePathsWithOrigin:self.coordinates andDestination:self.punto];
    MVAPath *subwayPath = delegate.graphs.subwayPath;
    MVAPath *busPath = delegate.graphs.busPath;
    
    /*if (subwayPath != nil) {
        double ref = subwayPath.totalWeight;
        int second = (ref - (floor(ref/60) * 60.0f)) ;
        ref = (subwayPath.totalWeight / 60.0);
        int minute = (ref - (floor(ref/60) * 60.0f)) ;
        int hora   = ((subwayPath.totalWeight / 60) / 60);
    }
    if (busPath != nil) {
        double ref = busPath.totalWeight;
        int second = (ref - (floor(ref/60) * 60.0f)) ;
        ref = (subwayPath.totalWeight / 60.0);
        int minute = (ref - (floor(ref/60) * 60.0f)) ;
        int hora   = ((subwayPath.totalWeight / 60) / 60);
    }*/
}

@end
