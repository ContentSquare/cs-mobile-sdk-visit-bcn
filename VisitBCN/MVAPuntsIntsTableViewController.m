//
//  MVAPuntsIntsTableViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAPuntsIntsTableViewController.h"
#import "MVAAppDelegate.h"
#import "MVAPunIntTableViewCell.h"
#import "UIViewController+ScrollingNavbar.h"
#import "MVAPunIntViewController.h"
#import "ALRadialMenu.h"
#import "MVAPunInt.h"
#import "MVACustomLocation.h"

@interface MVAPuntsIntsTableViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,ALRadialMenuDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property MVAPunInt *selectedPoint;
@property (strong, nonatomic) ALRadialMenu *socialMenu;
@property BOOL menuON;
@property NSArray *customLocations;

@end

@implementation MVAPuntsIntsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.table = self;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Just call this line to enable the scrolling navbar
    [self followScrollView:self.tableView usingTopConstraint:self.topConstraint withDelay:65];
    [self setShouldScrollWhenContentFits:YES];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head"]];
}

-(void)viewWillAppear:(BOOL)animated
{
    CGFloat w = self.view.frame.size.width;
    CGFloat h = self.view.frame.size.height;
    w = ((w/2.0f)-25.0);
    
    self.homeButton.translatesAutoresizingMaskIntoConstraints = YES;
    [self.homeButton setFrame:CGRectMake(w, (h - 64), 50, 50)];
    
    [self.homeButton setTitle:@"" forState:UIControlStateNormal];
    [self.homeButton setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.homeButton setContentMode:UIViewContentModeCenter];
    [self.homeButton setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    [self.homeButton.layer setCornerRadius:25.0f];
    [self.homeButton setClipsToBounds:YES];
    
    self.socialMenu = [[ALRadialMenu alloc] init];
    self.socialMenu.delegate = self;
    [self.view bringSubviewToFront:self.homeButton];
    
    self.menuON = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self showNavBarAnimated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self showNavBarAnimated:NO];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self showNavbar];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    double realDist = (R * c);
    
    return (realDist * 1.1);
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

- (void) loadCustomLocations
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *savedArray = [defaults objectForKey:@"VisitBCNCustomLocations"];
    if (savedArray != nil) {
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        self.customLocations = [[NSArray alloc] initWithArray:oldArray];
    }
    else {
        self.customLocations = [[NSArray alloc] init];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int pos = [self loadCustom];
    if (pos == 0) return 0.1f;
    return 180.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat w = self.view.frame.size.width;
    int pos = [self loadCustom];
    if (pos > 0) {
        [self loadCustomLocations];
        MVACustomLocation *loc = [self.customLocations objectAtIndex:(pos - 1)];
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 180)];
        CGFloat w = self.view.frame.size.width;
        
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(((w / 2.0) - 51.0), 10, 102, 102)];
        if (loc.foto != nil) imV.image = loc.foto;
        else imV.image = [UIImage imageNamed:@"customPlace"];
        [imV.layer setCornerRadius:51.0];
        [imV setClipsToBounds:YES];
        [imV.layer setBorderWidth:2.0f];
        [imV.layer setBorderColor:[[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor]];
        [v addSubview:imV];
        
        UILabel *nom = [[UILabel alloc] initWithFrame:CGRectMake(8, 120, w - 16, 20)];
        nom.text = loc.name;
        [nom setTextAlignment:NSTextAlignmentCenter];
        [nom setTextColor:[UIColor blackColor]];
        [nom setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
        [nom setAdjustsFontSizeToFitWidth:YES];
        [v addSubview:nom];
        
        UILabel *coord = [[UILabel alloc] initWithFrame:CGRectMake(8, 150, w - 16, 20)];
        NSString *cords = [NSString stringWithFormat:@"(%.4f,%.4f)",loc.coordinates.latitude,loc.coordinates.longitude];
        coord.text = cords;
        [coord setTextAlignment:NSTextAlignmentCenter];
        [coord setTextColor:[UIColor blackColor]];
        [coord setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        [coord setAdjustsFontSizeToFitWidth:YES];
        [v addSubview:coord];
        
        UIView *headerView = [[UIView alloc] initWithFrame:v.frame];
        [headerView setBackgroundColor:[UIColor clearColor]];
        
        UISwipeGestureRecognizer *tapGestureRecognizer;
        tapGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)];
        tapGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [headerView addGestureRecognizer:tapGestureRecognizer];
        
        [v addSubview:headerView];
        
        return v;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, w, 0.1f)];
}

-(void)headerTapped:(UITapGestureRecognizer *)onetap
{
    [self performSegueWithIdentifier:@"customSegue" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    return [delegate.puntos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MVAPunIntTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PunIntCell" forIndexPath:indexPath];
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    MVAPunInt *punInt = [delegate.puntos objectAtIndex:indexPath.row];
    cell.fondo.image = [UIImage imageNamed:punInt.fotoPeq];
    CGFloat difDeg = 360 - delegate.degrees;
    CGFloat deg = difDeg + [self calculateUserAngle:punInt.coordinates] + 45;
    CGFloat rad = deg  * M_PI / 180;
    cell.gps.transform = CGAffineTransformMakeRotation(rad);
    cell.name.text = punInt.nombre;
    cell.street.text = punInt.street;
    [cell.distance setAdjustsFontSizeToFitWidth:YES];
    if ([punInt.color isEqualToString:@"black"]) {
        cell.name.textColor = [UIColor blackColor];
        [cell.name setShadowColor:[UIColor clearColor]];
        cell.street.textColor = [UIColor blackColor];
        [cell.street setShadowColor:[UIColor clearColor]];
        cell.distance.textColor = [UIColor blackColor];
        [cell.distance setShadowColor:[UIColor clearColor]];
    }
    else {
        cell.name.textColor = [UIColor whiteColor];
        [cell.name setShadowColor:[UIColor blackColor]];
        cell.street.textColor = [UIColor whiteColor];
        [cell.street setShadowColor:[UIColor blackColor]];
        cell.distance.textColor = [UIColor whiteColor];
        [cell.distance setShadowColor:[UIColor blackColor]];
    }
    if (delegate.coordinates.latitude != 0.0) {
        double distance = [self distanceForCoordinates:delegate.coordinates andCoordinates:punInt.coordinates];
        cell.distance.text = [[NSString stringWithFormat:@"%.3f",(distance / 1000.0)] stringByAppendingString:@"km"];
    }
    else {
        cell.distance.text = @"No GPS";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.selectedPoint = [delegate.puntos objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"punIntSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (self.menuON) [self.socialMenu buttonsWillAnimateFromButton:self.homeButton withFrame:self.homeButton.frame inView:self.view];
    if ([segue.identifier isEqualToString:@"punIntSegue"]) {
        MVAPunIntViewController *vc = (MVAPunIntViewController *) [segue destinationViewController];
        vc.punto = self.selectedPoint;
    }
}

- (IBAction)menuSelected:(id)sender {
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
    [self.socialMenu buttonsWillAnimateFromButton:sender withFrame:self.homeButton.frame inView:self.view];
    self.menuON = !self.menuON;
}


-(CGFloat) calculateUserAngle:(CLLocationCoordinate2D)current {
    double x = 0, y = 0;
    
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];

    y = current.longitude - delegate.coordinates.longitude;
    x = current.latitude - delegate.coordinates.latitude;
    CGFloat deg = (atan2(y, x) * (180. / M_PI));
    return deg;
}

#pragma mark - radial menu delegate methods
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu {
    return 8;
}


- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu {
    return 360;
}


- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu {
    return 80;
}


- (ALRadialButton *) radialMenu:(ALRadialMenu *)radialMenu buttonForIndex:(NSInteger)index {
    ALRadialButton *button = [[ALRadialButton alloc] init];
    if (index == 1) {
        [button setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    } else if (index == 5) {
        [button setImage:[UIImage imageNamed:@"mapa"] forState:UIControlStateNormal];
    } else if (index == 7) {
        [button setImage:[UIImage imageNamed:@"tuerca"] forState:UIControlStateNormal];
    } else {
        [button setImage:nil forState:UIControlStateNormal];
    }
    return button;
}


- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index {
    if (index == 1) {
        NSLog(@"Info");
        [self performSegueWithIdentifier:@"segueInfo" sender:self];
    }
    else if (index == 5) {
        NSLog(@"Mapa");
        [self performSegueWithIdentifier:@"segueMap" sender:self];
    }
    else if (index == 7) {
        NSLog(@"Config");
        [self performSegueWithIdentifier:@"segueConfig" sender:self];
    }
}

@end
