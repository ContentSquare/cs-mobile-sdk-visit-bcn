//
//  MVAPuntsIntsTableViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 * <#Description#>
 */

#import "MVAPuntsIntsTableViewController.h"
#import "MVAAppDelegate.h"
#import "MVAPunIntTableViewCell.h"
#import "UIViewController+ScrollingNavbar.h"
#import "MVAPunIntViewController.h"
#import "ALRadialMenu.h"
#import "MVAPunInt.h"
#import "MVACustomLocation.h"

@interface MVAPuntsIntsTableViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,ALRadialMenuDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property MVAPunInt *selectedPoint;
@property (strong, nonatomic) ALRadialMenu *socialMenu;
@property BOOL menuON;
@property NSArray *customLocations;
@property UISearchBar *searchBar;
@property UISearchDisplayController *searchDisplay;
@property NSMutableArray *filteredContentList;
@property BOOL isSearching;

@end

@implementation MVAPuntsIntsTableViewController

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.table = self;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.filteredContentList = [[NSMutableArray alloc] init];
    // Just call this line to enable the scrolling navbar
    [self followScrollView:self.tableView usingTopConstraint:self.topConstraint withDelay:65];
    [self setShouldScrollWhenContentFits:YES];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head"]];
}

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 *  <#Description#>
 *
 *  @param animated <#animated description#>
 *
 *  @since version 1.0
 */
-(void)viewWillAppear:(BOOL)animated
{
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    w = ((w/2.0f)-25.0);
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [self.searchBar setDelegate:self];
    self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplay.delegate = self;
    self.searchDisplay.searchResultsDataSource = self;
    [self.searchDisplay setSearchResultsDelegate:self];
    self.tableView.tableHeaderView = self.searchBar;
    self.isSearching = NO;
    
    self.menuON = NO;
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
    
    [self.tableView reloadData];
}

/**
 *  <#Description#>
 *
 *  @param animated <#animated description#>
 *
 *  @since version 1.0
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [self showNavBarAnimated:NO];
}

/**
 *  <#Description#>
 *
 *  @param animated <#animated description#>
 *
 *  @since version 1.0
 */
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self showNavBarAnimated:NO];
}

/**
 *  <#Description#>
 *
 *  @param scrollView <#scrollView description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self showNavbar];
    return YES;
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
    
    return realDist;
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
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

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
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

#pragma mark - Search bar delegate

/**
 *  <#Description#>
 *
 *  @param controller <#controller description#>
 *  @param tableView  <#tableView description#>
 *
 *  @since version 1.0
 */
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 125.0f;
}

/**
 *  <#Description#>
 *
 *  @param searchBar <#searchBar description#>
 *
 *  @since version 1.0
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.isSearching = YES;
    [self.tableView reloadData];
}

/**
 *  <#Description#>
 *
 *  @param searchBar <#searchBar description#>
 *
 *  @since version 1.0
 */
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.isSearching = YES;
    [self searchTableList];
}

/**
 *  <#Description#>
 *
 *  @param searchBar  <#searchBar description#>
 *  @param searchText <#searchText description#>
 *
 *  @since version 1.0
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Text change - %d",self.isSearching);
    
    //Remove all objects first.
    [self.filteredContentList removeAllObjects];
    
    if([searchText length] != 0) {
        self.isSearching = YES;
        [self searchTableList];
    }
    else {
        self.isSearching = NO;
    }
}

/**
 *  <#Description#>
 *
 *  @param searchBar <#searchBar description#>
 *
 *  @since version 1.0
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Cancel clicked");
    self.isSearching = NO;
    [self.tableView reloadData];
}

/**
 *  <#Description#>
 *
 *  @since version 1.0
 */
- (void)searchTableList
{
    NSString *searchString = self.searchBar.text;
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    for (MVAPunInt* punto in delegate.puntos) {
        NSComparisonResult result = [punto.nombre compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [self.filteredContentList addObject:punto];
        }
    }
}

#pragma mark - Table view data source

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.0f;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int pos = [self loadCustom];
    if (pos == 0 || self.isSearching) return 0.1f;
    return 180.0f;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.customLocations = [[NSArray alloc] init];
    CGFloat w = self.view.frame.size.width;
    if (!self.isSearching) {
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
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, w, 0.1f)];
    
}

/**
 *  <#Description#>
 *
 *  @param onetap <#onetap description#>
 *
 *  @since version 1.0
 */
-(void)headerTapped:(UITapGestureRecognizer *)onetap
{
    [self performSegueWithIdentifier:@"customSegue" sender:self];
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param section   <#section description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearching) {
        return [self.filteredContentList count];
    }
    else {
        MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
        return [delegate.puntos count];
    }
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVAPunIntTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PunIntCell"];
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    MVAPunInt *punInt;
    if (!self.isSearching) punInt = [delegate.puntos objectAtIndex:indexPath.row];
    else punInt = [self.filteredContentList objectAtIndex:indexPath.row];
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
    int pos = [self loadCustom];
    if (pos == 0) {
        if (delegate.coordinates.latitude != 0.0) {
            double distance = [self distanceForCoordinates:delegate.coordinates andCoordinates:punInt.coordinates];
            cell.distance.text = [[NSString stringWithFormat:@"%.3f",(distance / 1000.0)] stringByAppendingString:@"km"];
        }
        else {
            cell.distance.text = @"No GPS";
        }
    }
    else {
        if ([self.customLocations count] > 0) {
            MVACustomLocation *loc = [self.customLocations objectAtIndex:(pos - 1)];
            double distance = [self distanceForCoordinates:loc.coordinates andCoordinates:punInt.coordinates];
            cell.distance.text = [[NSString stringWithFormat:@"%.3f",(distance / 1000.0)] stringByAppendingString:@"km"];
            
        }
        else {
            cell.distance.text = @"No GPS";
        }
    }
    return cell;
}

/**
 *  <#Description#>
 *
 *  @param tableView <#tableView description#>
 *  @param indexPath <#indexPath description#>
 *
 *  @since version 1.0
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.selectedPoint = [delegate.puntos objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"punIntSegue" sender:self];
}

/**
 *  <#Description#>
 *
 *  @param segue  <#segue description#>
 *  @param sender <#sender description#>
 *
 *  @since version 1.0
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.menuON) [self.socialMenu buttonsWillAnimateFromButton:self.homeButton withFrame:self.homeButton.frame inView:self.view];
    if ([segue.identifier isEqualToString:@"punIntSegue"]) {
        MVAPunIntViewController *vc = (MVAPunIntViewController *) [segue destinationViewController];
        vc.punto = self.selectedPoint;
    }
    self.searchDisplay.active = NO;
    self.isSearching = NO;
    [self.tableView reloadData];
}

/**
 *  <#Description#>
 *
 *  @param sender <#sender description#>
 *
 *  @since version 1.0
 */
- (IBAction)menuSelected:(id)sender
{
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
    [self.socialMenu buttonsWillAnimateFromButton:sender withFrame:self.homeButton.frame inView:self.view];
    self.menuON = !self.menuON;
}

/**
 *  <#Description#>
 *
 *  @param current <#current description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
-(CGFloat) calculateUserAngle:(CLLocationCoordinate2D)current
{
    double x = 0, y = 0;
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    y = current.longitude - delegate.coordinates.longitude;
    x = current.latitude - delegate.coordinates.latitude;
    CGFloat deg = (atan2(y, x) * (180. / M_PI));
    return deg;
}

#pragma mark - radial menu delegate methods
/**
 *  <#Description#>
 *
 *  @param radialMenu <#radialMenu description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu
{
    return 8;
}

/**
 *  <#Description#>
 *
 *  @param radialMenu <#radialMenu description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu
{
    return 360;
}

/**
 *  <#Description#>
 *
 *  @param radialMenu <#radialMenu description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu
{
    return 80;
}

/**
 *  <#Description#>
 *
 *  @param radialMenu <#radialMenu description#>
 *  @param index      <#index description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (ALRadialButton *) radialMenu:(ALRadialMenu *)radialMenu buttonForIndex:(NSInteger)index
{
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

/**
 *  <#Description#>
 *
 *  @param radialMenu <#radialMenu description#>
 *  @param index      <#index description#>
 *
 *  @since version 1.0
 */
- (void) radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index
{
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
