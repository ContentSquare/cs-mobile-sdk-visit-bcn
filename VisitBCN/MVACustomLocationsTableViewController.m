//
//  MVACustomLocationsTableViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 3/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVACustomLocationsTableViewController.h"
#import "MVACustomLocation.h"
#import "MVACustomElementTableViewCell.h"
#import "MVAAppDelegate.h"
#import "MVAPunIntViewController.h"

@interface MVACustomLocationsTableViewController () <UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

@property NSMutableArray *customLocations;
@property NSString *customName;
@property UIImage *customImage;
@property MVACustomLocation *destLoc;
@property UITextField *textField;

@end

@implementation MVACustomLocationsTableViewController

/**
 *  Function that gets called when the view controller has loaded the view
 *
 *  @since version 1.0
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.customImage = nil;
    [self loadCustomLocations];
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.custom = self;
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
 *  Function that loads the custom locations created by the user
 *
 *  @since version 1.0
 */
- (void)loadCustomLocations
{
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    NSData *savedArray = [defaults objectForKey:@"VisitBCNCustomLocations"];
    if (savedArray != nil) {
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        self.customLocations = [[NSMutableArray alloc] initWithArray:oldArray];
    }
    else {
        self.customLocations = [[NSMutableArray alloc] init];
    }
}

/**
 *  Function that saves the custom locations created by the user
 *
 *  @since version 1.0
 */
- (void)guardar
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    [sharedDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.customLocations] forKey:@"VisitBCNCustomLocations"];
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
    return ([self.customLocations count] + 1);
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
    MVACustomElementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"elementCell" forIndexPath:indexPath];
    [cell.nombre setAdjustsFontSizeToFitWidth:YES];
    [cell.coords setAdjustsFontSizeToFitWidth:YES];
    int pos = [self loadCustom];
    if (pos == indexPath.row) [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else [cell setAccessoryType:UITableViewCellAccessoryNone];
    if (indexPath.row == 0) {
        MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
        cell.foto.image = [UIImage imageNamed:@"radar"];
        cell.nombre.text = @"Current location";
        if (delegate.coordinates.latitude == 0) {
            [cell.coords setText:@"NO GPS DATA"];
        }
        else {
            cell.coords.text = [NSString stringWithFormat:@"(%.4f,%.4f)",delegate.coordinates.latitude,delegate.coordinates.longitude];
        }
        return cell;
    }
    MVACustomLocation *location = [self.customLocations objectAtIndex:(indexPath.row - 1)];
    if (location.foto == nil) cell.foto.image = [UIImage imageNamed:@"customPlace"];
    else cell.foto.image = location.foto;
    [cell.foto.layer setCornerRadius:25.0f];
    [cell.foto setClipsToBounds:YES];
    [cell.foto.layer setBorderWidth:1.0f];
    [cell.foto.layer setBorderColor:[[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor]];
    cell.nombre.text = location.name;
    cell.coords.text = [NSString stringWithFormat:@"(%.4f,%.4f)",location.coordinates.latitude,location.coordinates.longitude];
    return cell;
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
    return 160;
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
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 160)];
    [v setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *imV = [[UIImageView alloc] initWithFrame:CGRectMake(8, 28, 102, 102)];
    if (self.customImage == nil) imV.image = [UIImage imageNamed:@"customPlace"];
    else imV.image = self.customImage;
    [imV.layer setCornerRadius:51.0];
    [imV setClipsToBounds:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fotoTapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [imV addGestureRecognizer:tapGestureRecognizer];
    [imV  setUserInteractionEnabled:YES];
    [imV.layer setBorderWidth:2.0f];
    [imV.layer setBorderColor:[[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f] CGColor]];
    [v addSubview:imV];
    
    UITextField *nom = [[UITextField alloc] initWithFrame:CGRectMake(120, 28, (w - 128), 33)];
    [nom setTextColor:[UIColor blackColor]];
    UIColor *color = [UIColor lightGrayColor];
    nom.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Location name" attributes:@{NSForegroundColorAttributeName: color}];
    [nom setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
    [nom setReturnKeyType:UIReturnKeyDone];
    [nom setDelegate:self];
    if (self.customName != nil) [nom setText:self.customName];
    else [nom setText:@""];
    [v addSubview:nom];
    
    UILabel *coords = [[UILabel alloc] initWithFrame:CGRectMake(120, 70, (w - 128), 23)];
    [coords setTextColor:[UIColor blackColor]];
    [coords setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0]];
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.coordinates.latitude == 0) {
        [coords setText:@"No GPS data"];
    }
    else {
        [coords setText:[NSString stringWithFormat:@"(%.4f,%.4f)",delegate.coordinates.latitude,delegate.coordinates.longitude]];
    }
    [v addSubview:coords];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(120, 100, (w - 128), 30)];
    [addButton setBackgroundColor:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0]];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setTitle:@"Add place" forState:UIControlStateNormal];
    [addButton.layer setCornerRadius:10.0f];
    [addButton addTarget:self action:@selector(addSel:) forControlEvents:UIControlEventTouchDown];
    [v addSubview:addButton];
    
    return v;
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
    [self saveCustom:(int)indexPath.row];
    [self.tableView reloadData];
}

/**
 *  Asks the data source to verify that the given row is editable.
 *
 *  @param tableView The table-view object requesting this information.
 *  @param indexPath An index path locating a row in tableView.
 *
 *  @return YES if the row indicated by indexPath is editable; otherwise, NO.
 *
 *  @since version 1.0
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return NO;
    return YES;
}

/**
 *  Asks the data source to commit the insertion or deletion of a specified row in the receiver.
 *
 *  @param tableView    The table-view object requesting the insertion or deletion.
 *  @param editingStyle The cell editing style corresponding to a insertion or deletion requested for the row specified by indexPath. Possible editing styles are UITableViewCellEditingStyleInsert or UITableViewCellEditingStyleDelete.
 *  @param indexPath    An index path locating the row in tableView.
 *
 *  @since version 1.0
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            if (indexPath.row == [self loadCustom]) {
                [self saveCustom:0];
            }
            [self.customLocations removeObjectAtIndex:(indexPath.row - 1)];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self guardar];
        [self.tableView reloadData];
    }
}

/**
 *  Asks the delegate the title for the accessory button of a specified row.
 *
 *  @param tableView The table-view object requesting the insertion or deletion.
 *  @param indexPath An index path locating the row in tableView.
 *
 *  @return The title of the button
 *
 *  @since version 1.0
 */
-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Take me here  ";
}

/**
 *  Tells the delegate that the accessory button has been selected
 *
 *  @param tableView The table-view object requesting the insertion or deletion.
 *  @param indexPath An index path locating the row in tableView.
 *
 *  @since version 1.0
 */
-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.destLoc = [self.customLocations objectAtIndex:(indexPath.row - 1)];
    [self performSegueWithIdentifier:@"segueDest" sender:self];
}

/**
 *  Tells the delegate that the table view is about to go into editing mode.
 *
 *  @param tableView The table-view object providing this information.
 *  @param indexPath An index path locating the row in tableView.
 *
 *  @since version 1.0
 */
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.custom = nil;
}

/**
 *  Tells the delegate that the table view has left editing mode.
 *
 *  @param tableView The table-view object providing this information.
 *  @param indexPath An index path locating the row in tableView.
 *
 *  @since version 1.0
 */
-(void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.custom = self;
}

/**
 *  Asks the delegate if the text field should return and exit the editing mode
 *
 *  @param textField The text field object
 *
 *  @return A bool that answers the query
 *
 *  @since version 1.0
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.custom = self;
    return YES;
}

/**
 *  Tells the delegate that the user has begun the editing of the text field
 *
 *  @param textField The text field object
 *
 *  @since version 1.0
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textField = textField;
    [textField becomeFirstResponder];
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.custom = nil;
}

/**
 *  Tells the delegate that the use rhas ended editing the text field
 *
 *  @param textField The text field object
 *
 *  @since version 1.0
 */
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.customName = textField.text;
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.custom = self;
}

/**
 *  Function that gets called when the user whants to add a new custom location
 *
 *  @param sender The button selected
 *
 *  @since version 1.0
 */
-(IBAction)addSel:(id)sender
{
    MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.coordinates.latitude == 0 || [self.textField.text isEqualToString:@""]) {
        // MOSTRAR ERROR
    }
    else {
        MVACustomLocation *loc = [[MVACustomLocation alloc] init];
        if (self.customImage != nil) loc.foto = self.customImage;
        loc.name = self.textField.text;
        MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
        loc.coordinates = delegate.coordinates;
        [self.customLocations addObject:loc];
        [self guardar];
        self.textField.text = @"";
        self.customImage = nil;
        self.customName = nil;
        [self.tableView reloadData];
    }
}

/**
 *  Function that gets called when the user whants to select a picture for a custom location
 *
 *  @since version 1.0
 */
-(void)chooseFoto
{
    if (nil != NSClassFromString(@"UIAlertController")) {
        //show alertcontroller
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Profile picture"
                                      message:@"Select picture source:"
                                      preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Take a picture"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                                 if ([UIImagePickerController isSourceTypeAvailable:
                                      UIImagePickerControllerSourceTypeCamera] == YES){
                                     // Create image picker controller
                                     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                     
                                     // Set source to the camera
                                     imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                                     
                                     // Delegate is self
                                     imagePicker.delegate = self;
                                     
                                     [imagePicker setAllowsEditing:YES];
                                     
                                     imagePicker.showsCameraControls = YES;
                                     [imagePicker setShowsCameraControls:YES];
                                     
                                     imagePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
                                     imagePicker.navigationBar.tintColor = [UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f];
                                     
                                     // Show image picker
                                     [self presentViewController:imagePicker animated:YES completion:nil];
                                     //[self presentModalViewController:imagePicker animated:YES];
                                 }
                                 
                             }];
        [alert addAction:ok]; // add action to uialertcontroller
        
        
        UIAlertAction* ok2 = [UIAlertAction
                              actionWithTitle:@"Choose from library"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  //Do some thing here
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                  
                                  if ([UIImagePickerController isSourceTypeAvailable:
                                       UIImagePickerControllerSourceTypePhotoLibrary] == YES){
                                      // Create image picker controller
                                      UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                      
                                      // Set source to the camera
                                      imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                                      
                                      // Delegate is self
                                      imagePicker.delegate = self;
                                      
                                      [imagePicker setAllowsEditing:YES];
                                      
                                      imagePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
                                      imagePicker.navigationBar.tintColor = [UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f];
                                      
                                      // Show image picker
                                      [self presentViewController:imagePicker animated:YES completion:nil];
                                      //[self presentModalViewController:imagePicker animated:YES];
                                  }
                                  
                              }];
        [alert addAction:ok2]; // add action to uialertcontroller
        
        UIAlertAction* ok4 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleDestructive
                              handler:^(UIAlertAction * action)
                              {
                                  //Do some thing here
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                  [self.tableView reloadData];
                              }];
        [alert addAction:ok4]; // add action to uialertcontroller
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Picture Source:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Take a picture",
                                @"Choose from library",
                                nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
    
}

/**
 *  Delegate function that receives the selectio of a UIActionSheet (iOS 7.0)
 *
 *  @param popup       The action sheet
 *  @param buttonIndex The index of the button selected
 *
 *  @since version 1.0
 */
- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    if ([UIImagePickerController isSourceTypeAvailable:
                         UIImagePickerControllerSourceTypeCamera] == YES){
                        // Create image picker controller
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                        
                        // Set source to the camera
                        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                        
                        // Delegate is self
                        imagePicker.delegate = self;
                        
                        [imagePicker setAllowsEditing:YES];
                        
                        imagePicker.showsCameraControls = YES;
                        [imagePicker setShowsCameraControls:YES];
                        
                        imagePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
                        imagePicker.navigationBar.tintColor = [UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f];
                        
                        // Show image picker
                        [self presentViewController:imagePicker animated:YES completion:nil];
                        //[self presentModalViewController:imagePicker animated:YES];
                    }
                    break;
                case 1:
                    if ([UIImagePickerController isSourceTypeAvailable:
                         UIImagePickerControllerSourceTypePhotoLibrary] == YES){
                        // Create image picker controller
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                        
                        // Set source to the camera
                        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                        
                        // Delegate is self
                        imagePicker.delegate = self;
                        
                        [imagePicker setAllowsEditing:YES];
                        
                        imagePicker.navigationBar.barStyle = UIBarStyleBlackOpaque;
                        imagePicker.navigationBar.tintColor = [UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f];
                        
                        // Show image picker
                        [self presentViewController:imagePicker animated:YES completion:nil];
                        //[self presentModalViewController:imagePicker animated:YES];
                    }
                    break;
                case 2:
                    [self.tableView reloadData];
                    break;
            }
            break;
        }
        default:
            break;
    }
}

/**
 *  Tells the delegate that the user has canceled picking the media
 *
 *  @param picker The picker controller used
 *
 *  @since version 1.0
 */
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

/**
 *  Tells the delegate that the user has finished picking up the media from the device.
 *
 *  @param picker The picker controller used
 *  @param info   The information of the media selected
 *
 *  @since version 1.0
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *Bimage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
        [Bimage drawInRect: CGRectMake(0, 0, 200, 200)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        if (image != nil)
        {
            self.customImage = image;
            [self.tableView reloadData];
        }
    }];
}

/**
 *  Called just before the navigation controller displays a view controller’s view and navigation item properties.
 *
 *  @param navigationController The navigation controller that is showing the view and properties of a view controller.
 *  @param viewController       The view controller whose view and navigation item properties are being shown.
 *  @param animated             YES to animate the transition; otherwise, NO.
 *
 *  @since version 1.0
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([navigationController.viewControllers count] == 3)
    {
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        
        UIView *plCropOverlay = [[[viewController.view.subviews objectAtIndex:1]subviews] objectAtIndex:0];
        
        plCropOverlay.hidden = YES;
        
        int position = 0;
        
        if (screenHeight == 568) {
            position = 124;
        }
        else {
            position = 80;
        }
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        
        CGFloat w = self.view.frame.size.width;
        
        UIBezierPath *path2 = [UIBezierPath bezierPathWithOvalInRect:
                               CGRectMake(0.0f, position, w, w)];
        [path2 setUsesEvenOddFillRule:YES];
        
        [circleLayer setPath:[path2 CGPath]];
        
        [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, w, screenHeight-72) cornerRadius:0];
        
        [path appendPath:path2];
        [path setUsesEvenOddFillRule:YES];
        
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.path = path.CGPath;
        fillLayer.fillRule = kCAFillRuleEvenOdd;
        fillLayer.fillColor = [UIColor blackColor].CGColor;
        fillLayer.opacity = 0.8;
        [viewController.view.layer addSublayer:fillLayer];
        
        UILabel *moveLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, w, 50)];
        [moveLabel setText:@"Move and Scale"];
        [moveLabel setTextAlignment:NSTextAlignmentCenter];
        [moveLabel setTextColor:[UIColor whiteColor]];
        
        [viewController.view addSubview:moveLabel];
    }
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
 *  Function that saves the index of the custom location chosen
 *
 *  @param index <#index description#>
 *
 *  @since version 1.0
 */
-(void)saveCustom:(int)index
{
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.visitBCN.com"];
    [sharedDefaults setObject:[NSNumber numberWithInt:index] forKey:@"VisitBCNIsCustom"];
}

/**
 *  Function that gets called when the user taps into the new custom location picutre
 *
 *  @param onetap The tap gesture recognizer object
 *
 *  @since version 1.0
 */
-(void)fotoTapped:(UITapGestureRecognizer *)onetap
{
    [self chooseFoto];
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
    if ([segue.identifier isEqualToString:@"segueDest"]) {
        MVAPunIntViewController *vc = (MVAPunIntViewController *) [segue destinationViewController];
        vc.customlocation = self.destLoc;
    }
}

@end
