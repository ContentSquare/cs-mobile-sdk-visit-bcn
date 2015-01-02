//
//  MVAAppDelegate.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 02/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAAppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "MVAPunInt.h"
#import <Parse/Parse.h>

@interface MVAAppDelegate() <CLLocationManagerDelegate>

@end

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation MVAAppDelegate

/**
 *  Tells the delegate that the launch process is almost done and the app is almost ready to run.
 *
 *  @param application   The singleton app object.
 *  @param launchOptions A dictionary indicating the reason the app was launched (if any). The contents of this dictionary may be empty in situations where the user launched the app directly. For information about the possible keys in this dictionary and how to handle them, see Launch Options Keys.
 *
 *  @return NO if the app cannot handle the URL resource or continue a user activity, otherwise return YES. The return value is ignored if the app is launched as a result of a remote notification.
 *
 *  @since version 1.0
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"NzwtEWhQpaIT9ocg0hZwxNt1d4qz871nAYX2AZQY"
                  clientKey:@"QlTkAr6JAbSQCWcJlvuvcLSzIiq8TpezhCiHKAWP"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil]];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeBadge |
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeSound];
    }
    
    self.coordinates = CLLocationCoordinate2DMake(0.0, 0.0);
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    [self.locationManager startUpdatingHeading];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:18],
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSBackgroundColorAttributeName: [UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    return YES;
}

/**
 *  Tells the delegate that the app successfully registered with Apple Push Service (APS).
 *
 *  @param application The app object that initiated the remote-notification registration process.
 *  @param deviceToken A token that identifies the device to APS. The token is an opaque data type because that is the form that the provider needs to submit to the APS servers when it sends a notification to a device. The APS servers require a binary format for performance reasons. The size of a device token is 32 bytes. Note that the device token is different from the uniqueIdentifier property of UIDevice because, for security and privacy reasons, it must change when the device is wiped.
 *
 *  @since version 1.0
 */
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

/**
 *  Tells the delegate that the running app received a remote notification.
 *
 *  @param application The app object that received the remote notification.
 *  @param userInfo    A dictionary that contains information related to the remote notification, potentially including a badge number for the app icon, an alert sound, an alert message to display to the user, a notification identifier, and custom data. The provider originates it as a JSON-defined dictionary that iOS converts to an NSDictionary object; the dictionary may contain only property-list objects plus NSNull.
 *
 *  @since version 1.0
 */
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}

/**
 *  Tells the delegate that the app is about to become inactive.
 *
 *  @param application The singleton app object.
 *
 *  @since version 1.0
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 *  Tells the delegate that the app is now in the background.
 *
 *  @param application The singleton app object.
 *
 *  @since version 1.0
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

/**
 *  Tells the delegate that the app is about to enter the foreground.
 *
 *  @param application The singleton app object.
 *
 *  @since version 1.0
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

/**
 *  Tells the delegate that the app has become active.
 *
 *  @param application The singleton app object.
 *
 *  @since version 1.0
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

/**
 *  Tells the delegate when the app is about to terminate.
 *
 *  @param application The singleton app object.
 *
 *  @since version 1.0
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)loadAllTheInformation
{
    /* BUSES */
    self.dataBus = [[MVADataBus alloc] init];
    [self loadBuses];
    
    /* FGC */
    self.dataFGC = [[MVADataFGC alloc] init];
    [self loadFGC];
    
    /* METRO */
    self.dataTMB = [[MVADataTMB alloc] init];
    [self loadTMB];
    
    /* POINTS OF INTEREST */
    [self loadPI];
}

/**
 *  Function that loads all the landmarks.
 *
 *  @since version 1.0
 */
-(void)loadPI
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    NSString *filePathTMB = [[NSBundle mainBundle] pathForResource:@"pointsofinterest" ofType:@"json"];
    NSData *responseData = [NSData dataWithContentsOfFile:filePathTMB];
    
    if(!responseData){
        NSLog (@"HOLA");
    }
    else {
        NSError *e = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options: NSJSONReadingMutableContainers error: &e];
        
        if (!dict) {
            NSLog(@"Error parsing JSON: %@", e);
        }
        else {
            NSArray *array = [dict objectForKey:@"points-of-interest"];
            self.puntos = [[NSMutableArray alloc] init];
            for (int i = 0; i < [array count]; ++i) {
                NSDictionary *dic = [array objectAtIndex:i];
                MVAPunInt *punto = [[MVAPunInt alloc] init];
                punto.nombre = [dic objectForKey:@"name"];
                punto.descr = [dic objectForKey:@"description"];
                NSNumber *lat = [dic objectForKey:@"latitude"];
                NSNumber *lon = [dic objectForKey:@"longitude"];
                punto.coordinates = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
                punto.fotoPeq = [dic objectForKey:@"foto-peq"];
                punto.fotoGr = [dic objectForKey:@"foto-gran"];
                punto.street = [dic objectForKey:@"street"];
                punto.color = [dic objectForKey:@"color"];
                NSNumber *x = [dic objectForKey:@"squareX"];
                NSNumber *y = [dic objectForKey:@"squareY"];
                punto.squareX = [x floatValue];
                punto.squareY = [y floatValue];
                NSNumber *o = [dic objectForKey:@"offset"];
                punto.offset = [o floatValue];
                [self.puntos addObject:punto];
            }
        }
    }

    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"nombre" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    self.puntos = [[self.puntos sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];

    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Load PIs time: %.16f",dif);
}

/**
 *  Function that loads the subway TMB data abse.
 *
 *  @since version 1.0
 */
-(void)loadTMB
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    NSString *filePathTMB = [[NSBundle mainBundle] pathForResource:@"tmbDataBase" ofType:@"plist"];
    MVADataTMB* retreivedADogObjs = [NSKeyedUnarchiver unarchiveObjectWithFile:filePathTMB];
    if (retreivedADogObjs != nil) {
        self.dataTMB = retreivedADogObjs;
    }
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Load TMB time: %.16f",dif);
}

/**
 *  Function that loads the FGC data base.
 *
 *  @since version 1.0
 */
-(void)loadFGC
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    NSString *filePathFGC = [[NSBundle mainBundle] pathForResource:@"fgcDataBase" ofType:@"plist"];
    NSData *dataFGC = [NSData dataWithContentsOfFile:filePathFGC];
    MVADataFGC *fgcDB = [NSKeyedUnarchiver unarchiveObjectWithData:dataFGC];
    if (fgcDB != nil) {
        self.dataFGC = fgcDB;
    }
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Load FGC time: %.16f",dif);
}

/**
 *  Function that loads the bus data base.
 *
 *  @since version 1.0
 */
-(void)loadBuses
{
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    
    NSString *filePathBuses = [[NSBundle mainBundle] pathForResource:@"busDataBase" ofType:@"plist"];
    NSData *dataBuses = [NSData dataWithContentsOfFile:filePathBuses];
    MVADataBus *busDB = [NSKeyedUnarchiver unarchiveObjectWithData:dataBuses];
    if (busDB != nil) {
        self.dataBus = busDB;
    }
    
    NSTimeInterval end = [NSDate timeIntervalSinceReferenceDate];
    double dif = (end-start);
    NSLog(@"Load buses time: %.16f",dif);
}

/**
 *  Function that checks if the device has GPS connection.
 *
 *  @return A bool that answers the query.
 *
 *  @since version 1.0
 */
-(BOOL)hasGPS
{
    CTTelephonyNetworkInfo *myNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [myNetworkInfo subscriberCellularProvider];
    NSString *code = carrier.isoCountryCode;
    if (code == nil) return NO;
    return YES;
}

#pragma mark - Location delegate functions

/**
 *  Tells the delegate that new location data is available.
 *
 *  @param manager   The location manager object that generated the update event.
 *  @param locations An array of CLLocation objects containing the location data. This array always contains at least one object representing the current location. If updates were deferred or if multiple locations arrived before they could be delivered, the array may contain additional entries. The objects in the array are organized in the order in which they occurred. Therefore, the most recent location update is at the end of the array.
 *
 *  @since version 1.0
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    self.coordinates = newLocation.coordinate;
    if (self.table != nil) [self.table.tableView reloadData];
    if (self.custom != nil) [self.custom.tableView reloadData];
}

/**
 *  Tells the delegate that the authorization status for the application changed.
 *
 *  @param manager The location manager object reporting the event.
 *  @param status  The new authorization status for the application.
 *
 *  @since version 1.0
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ((status == kCLAuthorizationStatusAuthorized) || (status == kCLAuthorizationStatusAuthorizedAlways)) {
        manager.delegate = self;
        if(IS_OS_8_OR_LATER) {
            [manager requestWhenInUseAuthorization];
            [manager requestAlwaysAuthorization];
        }
        
        [manager startUpdatingLocation];
    }
}

/**
 *  Tells the delegate that the location manager received updated heading information.
 *
 *  @param manager    The location manager object that generated the update event.
 *  @param newHeading The new heading data.
 *
 *  @since version 1.0
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    // Use the true heading if it is valid.
    self.degrees = newHeading.magneticHeading;
    if (self.table != nil) [self.table.tableView reloadData];
}

/**
 *  Asks the delegate whether the heading calibration alert should be displayed.
 *
 *  @param manager The location manager object coordinating the display of the heading calibration alert.
 *
 *  @return YES if you want to allow the heading calibration alert to be displayed; NO if you do not.
 *
 *  @since version 1.0
 */
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    if (self.table == nil) return NO;
    if( manager.heading.headingAccuracy < 0 ) return YES;
    return NO;
}

/**
 *  Tells the delegate that the location manager was unable to retrieve a location value.
 *
 *  @param manager The location manager object that was unable to retrieve the location.
 *  @param error   The error object containing the reason the location or heading could not be retrieved.
 *
 *  @since version 1.0
 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"This app needs GPS data"
                                          message:@"Please enable the location services for this app"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Settings"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                     //Do some thing here
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok]; // add action to uialertcontroller
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        else {
            //show alertview
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This app needs GPS data"
                                                            message:@"Please go to the settings of your device and enable the location services for this app"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        NSLog (@"");
    }
    else if (error.code == kCLErrorGeocodeFoundNoResult) {
        if (nil != NSClassFromString(@"UIAlertController")) {
            //show alertcontroller
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Ups!"
                                          message:@"Something is not working with the location services. Try again later please!"
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [alert addAction:ok]; // add action to uialertcontroller
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
        else {
            //show alertview
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ups!"
                                                            message:@"Something is not working with the location services. Try again later please!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        NSLog (@"");
    }
}

@end
