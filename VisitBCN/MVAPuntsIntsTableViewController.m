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
#import "UIImage+ImageEffects.h"

@interface MVAPuntsIntsTableViewController () <CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,ALRadialMenuDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property MVAPunInt *selectedPoint;
@property (strong, nonatomic) ALRadialMenu *socialMenu;
@property BOOL menuON;
@property MVACustomLocation *customLoc;
@property UISearchBar *searchBar;
@property UISearchDisplayController *searchDisplay;
@property NSMutableArray *filteredContentList;
@property BOOL isSearching;

@end

@implementation MVAPuntsIntsTableViewController

/**
 *  Function that gets called when the view controller has loaded the view
 *
 *  @since version 1.0
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    self.filteredContentList = [[NSMutableArray alloc] init];
    // Just call this line to enable the scrolling navbar
    [self followScrollView:self.tableView usingTopConstraint:self.topConstraint withDelay:65];
    [self setShouldScrollWhenContentFits:YES];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"head"]];
    [self.navigationController.navigationBar setTranslucent:NO];
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
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0,delegate.window.bounds.size.width, 20)];
    [v setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    [delegate.window.rootViewController.view addSubview:v];
    
    int pos = [self loadCustom];
    if (pos == 0) {
        delegate.table = self;
        self.customLoc = nil;
    }
    else {
        self.customLoc = [self loadCustomLocation];
        delegate.table = nil;
    }
    
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
 *  Notifies the view controller that its view is about to be removed from a view hierarchy.
 *
 *  @param animated If YES, the disappearance of the view is being animated.
 *
 *  @since version 1.0
 */
- (void)viewWillDisappear:(BOOL)animated
{
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.table = nil;
    [self showNavBarAnimated:NO];
}

/**
 *  Notifies the view controller that its view was removed from a view hierarchy.
 *
 *  @param animated If YES, the disappearance of the view was animated.
 *
 *  @since version 1.0
 */
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self showNavBarAnimated:NO];
}

/**
 *  Asks the delegate if the scroll view should scroll to the top of the content.
 *
 *  @param scrollView The scroll-view object requesting this information.
 *
 *  @return YES to permit scrolling to the top of the content, NO to disallow it.
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
    
    return (realDist * 1.2);
}

/**
 *  Function that loads the index of the custom location chosen
 *
 *  @return The index of the custom location inside the custom locations array
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
 *  Function that loads the custom location selected by the user
 *
 *  @return The MVACustomLocation object
 *
 *  @see MVACustomLocation class
 *  @since version 1.0
 */
- (MVACustomLocation *) loadCustomLocation
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *savedArray = [defaults objectForKey:@"VisitBCNCustomLocations"];
    NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
    NSArray *customLocations = [[NSArray alloc] initWithArray:oldArray];
    return [customLocations objectAtIndex:([self loadCustom] - 1)];
}

#pragma mark - Search bar delegate

/**
 *  Tells the delegate that the controller has loaded its table view.
 *
 *  @param controller The search display controller for which the receiver is the delegate.
 *  @param tableView  The search display controller’s table view.
 *
 *  @since version 1.0
 */
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    tableView.rowHeight = 125.0f;
}

/**
 *  Delegate function that gets called when the user starts entering text
 *
 *  @param searchBar The search bar object
 *
 *  @since version 1.0
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.isSearching = YES;
    [self.tableView reloadData];
}

/**
 *  Delegate function that gets called when the user begins a search
 *
 *  @param searchBar The search bar object
 *
 *  @since version 1.0
 */
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.isSearching = YES;
    [self searchTableList];
}

/**
 *  Delegate function that gets called when the user edits the text in the search bar
 *
 *  @param searchBar  The search bar object
 *  @param searchText The text
 *
 *  @since version 1.0
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
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
 *  Delegate function that gets called when the user exits the search bar
 *
 *  @param searchBar The search bar object
 *
 *  @since version 1.0
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // Call this after a small delay, or it won't work
    self.isSearching = NO;
    [self.tableView reloadData];
    [self performSelector:@selector(showNavbar) withObject:nil afterDelay:0.2];
}

/**
 *  Function that filters the list to fit the search.
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
 *  Asks the delegate for the height to use for a row in a specified location.
 *
 *  @param tableView The table-view object requesting this information.
 *  @param indexPath An index path that locates a row in tableView.
 *
 *  @return A nonnegative floating-point value that specifies the height (in points) that row should be.
 *
 *  @since version 1.0
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.0f;
}

/**
 *  Asks the delegate for the height to use for the header of a particular section.
 *
 *  @param tableView The table-view object requesting this information.
 *  @param section   An index number identifying a section of tableView .
 *
 *  @return A nonnegative floating-point value that specifies the height (in points) of the header for section.
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
 *  Asks the delegate for the height to use for the footer of a particular section.
 *
 *  @param tableView The table-view object requesting this information.
 *  @param section   An index number identifying a section of tableView .
 *
 *  @return A nonnegative floating-point value that specifies the height (in points) of the footer for section.
 *
 *  @since version 1.0
 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

/**
 *  Asks the delegate for a view object to display in the header of the specified section of the table view.
 *
 *  @param tableView The table-view object asking for the view object.
 *  @param section   An index number identifying a section of tableView.
 *
 *  @return A view object to be displayed in the header of section.
 *
 *  @since version 1.0
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat w = self.view.frame.size.width;
    if (!self.isSearching) {
        if (self.customLoc != nil) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 180)];
            CGFloat w = self.view.frame.size.width;
            
            UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(((w / 2.0) - 51.0), 10, 102, 102)];
            if (self.customLoc.foto != nil) imV.image = self.customLoc.foto;
            else imV.image = [UIImage imageNamed:@"customPlace"];
            [imV.layer setCornerRadius:51.0];
            [imV setClipsToBounds:YES];
            [imV.layer setBorderWidth:2.0f];
            [imV.layer setBorderColor:[[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor]];
            [v addSubview:imV];
            
            UILabel *nom = [[UILabel alloc] initWithFrame:CGRectMake(8, 120, w - 16, 20)];
            nom.text = self.customLoc.name;
            [nom setTextAlignment:NSTextAlignmentCenter];
            [nom setTextColor:[UIColor blackColor]];
            [nom setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
            [nom setAdjustsFontSizeToFitWidth:YES];
            [v addSubview:nom];
            
            UILabel *coord = [[UILabel alloc] initWithFrame:CGRectMake(8, 150, w - 16, 20)];
            NSString *cords = [NSString stringWithFormat:@"(%.4f,%.4f)",self.customLoc.coordinates.latitude,self.customLoc.coordinates.longitude];
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
            
            UITapGestureRecognizer *tapGestureRecognizer2;
            tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)];
            tapGestureRecognizer2.numberOfTapsRequired = 1;
            tapGestureRecognizer2.numberOfTouchesRequired = 1;
            [headerView addGestureRecognizer:tapGestureRecognizer2];
            
            [v addSubview:headerView];
            
            return v;
        }
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, w, 0.1f)];
    
}

/**
 *  Tells the data source to return the number of rows in a given section of a table view. (required)
 *
 *  @param tableView The table-view object requesting this information.
 *  @param section   An index number identifying a section in tableView.
 *
 *  @return The number of rows in section.
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
 *  Asks the data source for a cell to insert in a particular location of the table view. (required)
 *
 *  @param tableView A table-view object requesting the cell.
 *  @param indexPath An index path locating a row in tableView.
 *
 *  @return An object inheriting from UITableViewCell that the table view can use for the specified row. An assertion is raised if you return nil.
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
        if (self.customLoc != nil) {
            double distance = [self distanceForCoordinates:self.customLoc.coordinates andCoordinates:punInt.coordinates];
            cell.distance.text = [[NSString stringWithFormat:@"%.3f",(distance / 1000.0)] stringByAppendingString:@"km"];
        }
        else {
            cell.distance.text = @"No GPS";
        }
    }

    return cell;
}

/**
 *  Tells the delegate that the specified row is now selected.
 *
 *  @param tableView A table-view object informing the delegate about the new row selection.
 *  @param indexPath An index path locating the new selected row in tableView.
 *
 *  @since version 1.0
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearching) {
        self.selectedPoint = [self.filteredContentList objectAtIndex:indexPath.row];
    }
    else {
        MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.selectedPoint = [delegate.puntos objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"punIntSegue" sender:self];
}

/**
 *  Function that gets called when the user taps/swipes inside the header view.
 *
 *  @param onetap The tap gesture recognizer object that calls this function.
 *
 *  @since version 1.0
 */
-(void)headerTapped:(UITapGestureRecognizer *)onetap
{
    [self performSegueWithIdentifier:@"customSegue" sender:self];
}

/**
 *  Function that creates a UIImage from a UIView given
 *
 *  @param view The UIView that needs to be converted into an image
 *
 *  @return The UIImage created
 *
 *  @since version 1.0
 */
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

/**
 *  Called when a segue is about to be performed. (required)
 *
 *  @param segue  The segue object containing information about the view controllers involved in the segue.
 *  @param sender The object that initiated the segue. You might use this parameter to perform different actions based on which control (or other object) initiated the segue.
 *
 *  @since version 1.0
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.searchDisplay.active = NO;
    self.isSearching = NO;
    [self.tableView reloadData];
    if (self.menuON) {
        UIView *view = [self.view viewWithTag:1234567];
        [UIView animateWithDuration: 1.0
                         animations:^{
                             view.alpha = 0.0f;
                             self.tableView.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             [view removeFromSuperview];
                         }];
        [self.socialMenu buttonsWillAnimateFromButton:self.homeButton withFrame:self.homeButton.frame inView:self.view];
    }
    if ([segue.identifier isEqualToString:@"punIntSegue"]) {
        MVAPunIntViewController *vc = (MVAPunIntViewController *) [segue destinationViewController];
        vc.punto = self.selectedPoint;
    }
}

/**
 *  Function that gets called when the user opens/closes the menu
 *
 *  @param sender The home menu button
 *
 *  @since version 1.0
 */
- (IBAction)menuSelected:(id)sender
{
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
    
    self.menuON = !self.menuON;
    
    [self.homeButton setUserInteractionEnabled:NO];
    if (self.menuON) {
        UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        UIColor *tintColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        imV.image = [[self imageWithView:self.view] applyBlurWithRadius:8 tintColor:tintColor saturationDeltaFactor:1.0 maskImage:nil];
        imV.tag = 1234567;
        imV.alpha = 0.0f;
        [self.view addSubview:imV];
        [UIView animateWithDuration: 0.5
                         animations:^{
                             imV.alpha = 1.0;
                             self.tableView.alpha = 0.0;
                             [self.homeButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                             [self.homeButton setBackgroundColor:[UIColor redColor]];
                         }
                         completion:^(BOOL finished) {
                             [self.homeButton setUserInteractionEnabled:YES];
                         }];
        [self.view bringSubviewToFront:sender];
        [self showNavBarAnimated:YES];
    }
    else {
        UIView *view = [self.view viewWithTag:1234567];
        [UIView animateWithDuration: 0.5
                         animations:^{
                             view.alpha = 0.0f;
                             self.tableView.alpha = 1.0;
                             [self.homeButton setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
                             [self.homeButton setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
                         }
                         completion:^(BOOL finished) {
                             [view removeFromSuperview];
                             [self.homeButton setUserInteractionEnabled:YES];
                         }];
    }
    
    [self.socialMenu buttonsWillAnimateFromButton:sender withFrame:self.homeButton.frame inView:self.view];
}

/**
 *  Function that caclualtes the angle between the current location and another given location. This function doesn't work with a custom location. This function uses the head of the device to calculate the angle.
 *
 *  @param location The coordinates of the other location
 *
 *  @return The angle between the two coordinates
 *
 *  @since version 1.0
 */
-(CGFloat)calculateUserAngle:(CLLocationCoordinate2D)location
{
    double x = 0, y = 0;
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    y = location.longitude - delegate.coordinates.longitude;
    x = location.latitude - delegate.coordinates.latitude;
    CGFloat deg = (atan2(y, x) * (180. / M_PI));
    return deg;
}

#pragma mark - radial menu delegate methods

/**
 *  ALRadialMenuDelegate function that indicates the number of items in the menu.
 *
 *  @param radialMenu The radial menu that calls this delegate function
 *
 *  @return The number of items in the menu
 *
 *  @since version 1.0
 */
- (NSInteger) numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu
{
    return 8;
}

/**
 *  ALRadialMenuDelegate function that gets called to indicate the arc radius (distance between the button and objects final resting spot)
 *
 *  @param radialMenu The radial menu that calls this delegate function
 *
 *  @return The arc radius
 *
 *  @since version 1.0
 */
- (NSInteger) arcSizeForRadialMenu:(ALRadialMenu *)radialMenu
{
    return 360;
}

/**
 *  ALRadialMenuDelegate function that gets called to indicate the radius of the menu
 *
 *  @param radialMenu The radial menu that calls this delegate function
 *
 *  @return The radius
 *
 *  @since version 1.0
 */
- (NSInteger) arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu
{
    return 80;
}

/**
 *  ALRadialMenuDelegate function that gets called for the creaton of the button for each item of the menu.
 *
 *  @param radialMenu The radial menu that calls this delegate function
 *  @param index      The index of the button that needs to be created
 *
 *  @return The ALRadialButton used for th given item
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
 *  ALRadialMenuDelegate function called when the user thaps one of the items
 *
 *  @param radialMenu The radial menu that calls this delegate function
 *  @param index      The index of the item selected
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
