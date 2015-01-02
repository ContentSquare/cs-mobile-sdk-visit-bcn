//
//  MVAStaredTableViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 22/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAStaredTableViewController.h"
#import "MVASavedPath.h"
#import "MVAStaredTableViewCell.h"
#import "MVAStaredPathViewController.h"

@interface MVAStaredTableViewController ()

@property NSMutableArray *savedPaths;
@property MVASavedPath *savedPath;

@end

@implementation MVAStaredTableViewController

/**
 *  Function that gets called when the view controller has loaded the view
 *
 *  @since version 1.0
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadSavedPaths];
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
 *  Function that loads the saved paths by the user
 *
 *  @since version 1.0
 */
- (void) loadSavedPaths
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *savedArray = [defaults objectForKey:@"VisitBCNSavedPaths"];
    if (savedArray != nil) {
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        self.savedPaths = [[NSMutableArray alloc] initWithArray:oldArray];
    }
    else {
        self.savedPaths = [[NSMutableArray alloc] init];
    }
}

#pragma mark - Table view data source

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
    return [self.savedPaths count];
}

/**
 *  Asks the delegate for the estimated height of a row in a specified location.
 *
 *  @param tableView The table-view object requesting this information.
 *  @param indexPath An index path that locates a row in tableView.
 *
 *  @return A nonnegative floating-point value that estimates the height (in points) that row should be. Return UITableViewAutomaticDimension if you have no estimate.
 */
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0f;
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
    MVAStaredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellStared" forIndexPath:indexPath];
    MVASavedPath *savedPath = [self.savedPaths objectAtIndex:indexPath.row];
    UIImage *orig = [UIImage imageNamed:savedPath.punto.fotoGr];
    if (orig == nil) orig = savedPath.destImage;
    cell.origFoto.image = savedPath.customlocation.foto;
    if (![savedPath.customlocation.name isEqualToString:@"Current location"]) {
        [cell.origFoto.layer setCornerRadius:30.0f];
        [cell.origFoto setClipsToBounds:YES];
        [cell.origFoto.layer setBorderWidth:2.0f];
        [cell.origFoto.layer setBorderColor:[[UIColor redColor] CGColor]];
    }
    else cell.origFoto.image = [UIImage imageNamed:@"walking_black"];
    cell.destFoto.image = orig;
    [cell.destFoto.layer setCornerRadius:30.0f];
    [cell.destFoto setClipsToBounds:YES];
    [cell.destFoto.layer setBorderWidth:2.0f];
    [cell.destFoto.layer setBorderColor:[[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor]];
    long day = [self dayOfWeek:savedPath.date];
    NSString *dayName = [self nameForDay:day];
    NSString *dayForm = [self formatDate:savedPath.date];
    cell.dayLabel.text = [dayName stringByAppendingString:[@" " stringByAppendingString:dayForm]];
    CGFloat w = self.view.bounds.size.width;
    UIView *raya = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, cell.frame.size.height)];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(cell.origFoto.frame.origin.x + cell.origFoto.frame.size.width + 5, 67)];
    [path addLineToPoint:CGPointMake(w - 108, 67)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setPath:[path CGPath]];
    shapeLayer.strokeColor = [[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor];
    shapeLayer.lineWidth = 5.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [raya.layer addSublayer:shapeLayer];
    [cell addSubview:raya];
    CGFloat refW = (cell.origFoto.frame.origin.x + cell.origFoto.frame.size.width + 8) + (w - 108);
    UILabel *bestLabel = [[UILabel alloc] initWithFrame:CGRectMake(((refW - 60) / 2.0f), 37.0f, 60.0f, 60.0f)];
    [bestLabel setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
    [bestLabel.layer setCornerRadius:30.0f];
    [bestLabel setClipsToBounds:YES];
    [cell addSubview:bestLabel];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(((refW - 40) / 2.0f), 47, 40, 40)];
    if ((savedPath.subwayPath == nil) && (savedPath.busPath == nil)) logo.image = [UIImage imageNamed:@"taxi-white"];
    else if (savedPath.subwayPath == nil && savedPath.busPath != nil) logo.image = [UIImage imageNamed:@"bus-white"];
    else if (savedPath.subwayPath != nil && savedPath.busPath == nil) logo.image = [UIImage imageNamed:@"train-white"];
    else {
        if (savedPath.subwayPath.totalWeight <= savedPath.busPath.totalWeight) logo.image = [UIImage imageNamed:@"train-white"];
        else logo.image = [UIImage imageNamed:@"bus-white"];
    }
    [cell addSubview:logo];
    [cell bringSubviewToFront:logo];
    double ref = savedPath.initTime;
    int second = (ref - (floor(ref/60) * 60.0f)) ;
    double ref2 = (ref / 60.0);
    int minute = (ref2 - (floor(ref2/60) * 60.0f)) ;
    int hora   = floor(ref / 3600);
    if (hora >= 24) hora -= 24;
    [cell.hourLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hora,minute,second]];
    return cell;
}

/**
 *  Asks the data source to verify that the given row is editable.
 *
 *  @param tableView The table-view object requesting this information.
 *  @param indexPath An index path locating a row in tableView.
 *
 *  @return YES if the row indicated by indexPath is editable; otherwise, NO.
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/**
 *  Asks the data source to commit the insertion or deletion of a specified row in the receiver.
 *
 *  @param tableView    The table-view object requesting the insertion or deletion.
 *  @param editingStyle The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath. Possible editing styles are UITableViewCellEditingStyleInsert or UITableViewCellEditingStyleDelete.
 *  @param indexPath    An index path locating the row in tableView.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.savedPaths removeObjectAtIndex:indexPath.row];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
            [sharedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.savedPaths] forKey:@"VisitBCNSavedPaths"];
        });
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

/**
 *  Tells the delegate that the specified row is now selected.
 *
 *  @param tableView A table-view object informing the delegate about the new row selection.
 *  @param indexPath An index path locating the new selected row in tableView.
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.savedPath = [self.savedPaths objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"segueViewPath" sender:self];
}

/**
 *  Function that formats a date into dd/MM/yyyy
 *
 *  @param date The date to be formated
 *
 *  @return The formated string
 */
-(NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    return [dateFormatter stringFromDate:date];
}

/**
 *  Function that returns the name of the day of the week
 *
 *  @param day The number of the day in the week
 *
 *  @return The day's name
 */
-(NSString *)nameForDay:(long)day
{
    if (day == 0) return @"Monday";
    if (day == 1) return @"Tuesday";
    if (day == 2) return @"Wednesday";
    if (day == 3) return @"Thursday";
    if (day == 4) return @"Friday";
    if (day == 5) return @"Saturday";
    return @"Sunday";
}

/**
 *  Returns the day of the week for a given date
 *
 *  @param anyDate A NSDate object
 *
 *  @return The day of the week in European mode
 *
 *  @since version 1.0
 */
-(long)dayOfWeek:(NSDate *)anyDate
{
    NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setLocale:frLocale];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:anyDate];
    int weekday = (int)[comps weekday];
    int europeanWeekday = ((weekday + 5) % 7) + 1;
    return (europeanWeekday - 1);
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
    if ([segue.identifier isEqualToString:@"segueViewPath"]) {
        MVAStaredPathViewController *vc = (MVAStaredPathViewController *)segue.destinationViewController;
        vc.savedPath = self.savedPath;
    }
}


@end
