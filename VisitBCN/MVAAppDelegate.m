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
    [self loadAllTheInformation];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:18],
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSBackgroundColorAttributeName: [UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

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


-(BOOL)hasGPS
{
    CTTelephonyNetworkInfo *myNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [myNetworkInfo subscriberCellularProvider];
    NSString *code = carrier.isoCountryCode;
    if (code == nil) return NO;
    return YES;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    self.coordinates = newLocation.coordinate;
    if (self.table != nil) [self.table.tableView reloadData];
    if (self.custom != nil) [self.custom.tableView reloadData];
}

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

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    // Use the true heading if it is valid.
    self.degrees = newHeading.magneticHeading;
    if (self.table != nil) [self.table.tableView reloadData];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // MOSTRAR PORFAVOR ACEPTAR LOS DATOS
        NSLog (@"");
    }
    else if (error.code == kCLErrorGeocodeFoundNoResult) {
        // PROBLEMA !!!!
        NSLog (@"");
    }
}

@end
