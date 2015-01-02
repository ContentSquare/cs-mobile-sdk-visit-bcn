//
//  MVAConfigurationTableViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 26/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAConfigurationTableViewController.h"
#import "MVAConfigTableViewCell.h"
#import "MVASliderTableViewCell.h"
#import "MVAHoraTableViewCell.h"
#import "MVACustomLocTableViewCell.h"

@interface MVAConfigurationTableViewController ()

@end

@implementation MVAConfigurationTableViewController

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

#pragma mark - Table view data source

/**
 *  Asks the data source to return the number of sections in the table view.
 *
 *  @param tableView An object representing the table view requesting this information.
 *
 *  @return The number of sections in tableView. The default value is 1.
 *
 *  @since version 1.0
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
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
    return 1;
}

/**
 *  Asks the data source for the title of the footer of the specified section of the table view.
 *
 *  @param tableView The table-view object asking for the title.
 *  @param section   An index number identifying a section of tableView .
 *
 *  @return A string to use as the title of the section footer. If you return nil , the section will have no title.
 *
 *  @since version 1.0
 */
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) return @"Changing the algorithm doesn't have any effect on the results and is used just as a case of study.";
    if (section == 1) return @"This will reduce the walking and driving speed.";
    //if (section == 2) return @"Choose between Uber or Hailo and get relevant information when asking for an itinerary with an internet connection.";
    if (section == 2) return @"Changing this value, will influence in the travelling and arrival time.";
    if (section == 3) return @"This will fix the maximum distance desired from the actual point to the nearest stops and from the arrival stops to the desired destination.";
    if (section == 4) return @"Select if you want a custom origin location or to find the way back home.";
    if (section == 5) return @"View all the stared paths.";
    if (section == 6) return @"This option permits to select a future date for calculating the itineraries.";
    return @"";
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
    CGFloat w = self.view.frame.size.width;
    NSString *text = [self tableView:tableView titleForFooterInSection:section];
    return ([self heightForView:[UIFont systemFontOfSize:10.0f] text:text andSize:(w - 16)] + 20);
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
 *  Asks the delegate for a view object to display in the footer of the specified section of the table view.
 *
 *  @param tableView The table-view object asking for the view object.
 *  @param section   An index number identifying a section of tableView .
 *
 *  @return A view object to be displayed in the footer of section .
 *
 *  @since version 1.0
 */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CGFloat w = self.view.frame.size.width;
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(8, 5, (w - 16), ([self tableView:tableView heightForFooterInSection:section] - 20));
    myLabel.numberOfLines = 0;
    [myLabel setFont:[UIFont systemFontOfSize:10.0f]];
    myLabel.text = [self tableView:tableView titleForFooterInSection:section];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section <= 1 || indexPath.section == 4 || indexPath.section == 5) return 55.0;
    if (indexPath.section <= 3) return 95.0;
    if ([self customDate]) return 255.0;
    return 50.0;
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
    if (indexPath.section == 0) {
        MVAConfigTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switchCell" forIndexPath:indexPath];
        switchCell.papi = self;
        switchCell.objectName = @"VisitBCNAlgorithm";
        switchCell.logo.image = [UIImage imageNamed:@"code-purple"];
        [switchCell.cellSwitch setBackgroundColor:[UIColor purpleColor]];
        [switchCell configSwitch];
        return switchCell;
    }
    else if (indexPath.section == 1) {
        MVAConfigTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switchCell" forIndexPath:indexPath];
        switchCell.papi = self;
        switchCell.objectName = @"VisitBCNRain";
        switchCell.logo.image = [UIImage imageNamed:@"rain-blue"];
        [switchCell.cellSwitch setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
        [switchCell configSwitch];
        return switchCell;
    }
    else if (indexPath.section == 2) {
        MVASliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:@"sliderCell" forIndexPath:indexPath];
        [sliderCell.speedSlider setMaximumValue:9000];
        [sliderCell.speedSlider setMinimumValue:1000];
        [sliderCell.text setText:@"Walking speed (km/h)"];
        sliderCell.objectName = @"VisitBCNWalkingSpeed";
        sliderCell.slowLogo.image = [UIImage imageNamed:@"old-red"];
        sliderCell.fastLogo.image = [UIImage imageNamed:@"running-green"];
        [sliderCell.speedSlider setMinimumTrackTintColor:[UIColor redColor]];
        [sliderCell initCell];
        return sliderCell;
    }
    else if (indexPath.section == 3) {
        MVASliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:@"sliderCell" forIndexPath:indexPath];
        [sliderCell.speedSlider setMaximumValue:3000];
        [sliderCell.speedSlider setMinimumValue:500];
        [sliderCell.text setText:@"Walking distance (km)"];
        sliderCell.objectName = @"VisitBCNWalkingDist";
        sliderCell.slowLogo.image = [UIImage imageNamed:@"car-black"];
        sliderCell.fastLogo.image = [UIImage imageNamed:@"trainer-yellow"];
        [sliderCell.speedSlider setMinimumTrackTintColor:[UIColor colorWithRed:(135.0f/255.0f) green:(193.0f/255.0f) blue:(87.0f/255.0f) alpha:1.0f]];
        [sliderCell initCell];
        return sliderCell;
    }
    else if (indexPath.section == 4) {
        MVACustomLocTableViewCell *customLocCell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        customLocCell.logo.image = [UIImage imageNamed:@"custom-green"];
        customLocCell.label.text = @"Custom locations";
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(custom:)];
        
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [customLocCell addGestureRecognizer: singleTap];
        return customLocCell;
    }
    else if (indexPath.section == 5) {
        MVACustomLocTableViewCell *customLocCell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        customLocCell.logo.image = [UIImage imageNamed:@"star-yellow"];
        customLocCell.label.text = @"Stared paths";
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stared:)];
        
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [customLocCell addGestureRecognizer: singleTap];
        return customLocCell;
    }
    else {
        MVAHoraTableViewCell *horaCell = [tableView dequeueReusableCellWithIdentifier:@"horaCell" forIndexPath:indexPath];
        horaCell.papi = self;
        return horaCell;
    }
}

/**
 *  Function that loads if the user has selected a custom date
 *
 *  @return A bool with the answer to the query
 *
 *  @since version 1.0
 */
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

/**
 *  Function that gets called when the user selects the stared cell
 *
 *  @param gr The tap gesture recognizer object
 *
 *  @since version 1.0
 */
-(void)stared:(UITapGestureRecognizer *)gr
{
    [self performSegueWithIdentifier:@"segueStar" sender:self];
}

/**
 *  Function that gets called when the user selects the custom locations cell
 *
 *  @param gr The tap gesture recognizer object
 *
 *  @since version 1.0
 */
-(void)custom:(UITapGestureRecognizer *)gr
{
    [self performSegueWithIdentifier:@"segueCustom" sender:self];
}

@end
