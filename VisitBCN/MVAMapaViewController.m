//
//  MVAViewController.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 02/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVAMapaViewController.h"
#import <StoreKit/StoreKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MVAPunInt.h"
#import "Mapbox.h"
#import "MVAAppDelegate.h"
#import <math.h>
#import <QuartzCore/QuartzCore.h>
#import "MVAPunIntViewController.h"

@interface MVAMapaViewController () <CLLocationManagerDelegate,MKMapViewDelegate,RMMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property MVAPunInt *selectedPoint;
@property RMMapView *mapView;

@end

@implementation MVAMapaViewController

/**
 *  <#Description#>
 *
 *  @param animated <#animated description#>
 *
 *  @since version 1.0
 */
-(void)viewDidLoad:(BOOL)animated
{
    self.mapView = nil;
    
}

/**
 *  <#Description#>
 *
 *  @param animated <#animated description#>
 *
 *  @since version 1.0
 */
-(void)viewDidAppear:(BOOL)animated
{
    if (self.mapView == nil) {
        RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"visitBCN" ofType:@"mbtiles"];
        
        RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
        
        mapView.zoom = 12.1;
        
        mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        mapView.adjustTilesForRetinaDisplay = YES; // these tiles aren't designed specifically for retina, so make them legible
        mapView.delegate = self;
        [mapView setMaxZoom:offlineSource.maxZoom];
        [mapView setMinZoom:12];
        [mapView setBouncingEnabled:YES];
        RMSphericalTrapezium trap = offlineSource.latitudeLongitudeBoundingBox;
        [mapView setConstraintsSouthWest:trap.southWest northEast:trap.northEast];
        [mapView setCenterCoordinate: offlineSource.centerCoordinate];
        [mapView setShowsUserLocation:YES];
        self.mapView = mapView;
        [self.detailView addSubview:mapView];
        
        MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        for (int i = 0; i < [delegate.puntos count]; ++i) {
            MVAPunInt *punto = [delegate.puntos objectAtIndex:i];
            RMAnnotation *annotation1 = [[RMAnnotation alloc] initWithMapView:mapView
                                                                   coordinate:punto.coordinates
                                                                     andTitle:punto.nombre];
            annotation1.userInfo = [NSNumber numberWithInt:i];
            [mapView addAnnotation:annotation1];
        }
        if ([self loadCustom] > 0) {
            MVACustomLocation *loc = [self loadCustomLocation];
            RMAnnotation *annotation1 = [[RMAnnotation alloc] initWithMapView:mapView
                                                                   coordinate:loc.coordinates
                                                                     andTitle:loc.name];
            annotation1.userInfo = [NSNumber numberWithInt:(-1)];
            [mapView addAnnotation:annotation1];
        }
    }
}

/**
 *  <#Description#>
 *
 *  @param mapView <#mapView description#>
 *  @param overlay <#overlay description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}

/**
 *  <#Description#>
 *
 *  @param mapView    <#mapView description#>
 *  @param annotation <#annotation description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation) return nil;
    
    double tam = 50;
    
    RMMarker *marker;
    NSNumber *i = annotation.userInfo;
    int pos = [i intValue];
    
    UIColor *selColor;
    UIImage *orig;
    MVAPunInt *punto;
    
    if (pos == -1) {
        selColor = [UIColor redColor];
        MVACustomLocation *loc = [self loadCustomLocation];
        orig = loc.foto;
        punto = [[MVAPunInt alloc] init];
        punto.squareX = 0.0f;
        punto.squareY = 0.0f;
    }
    else {
        MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
        punto = [delegate.puntos objectAtIndex:pos];
        selColor = [UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f];
        orig = [UIImage imageNamed:punto.fotoGr];
    }
    
    CGSize resize;
    if (orig.size.width < orig.size.height) {
        CGFloat scaleFactor = (orig.size.width / tam);
        CGFloat newHeight = (orig.size.height / scaleFactor);
        resize = CGSizeMake(tam, newHeight);
    }
    else if (orig.size.width > orig.size.height) {
        CGFloat scaleFactor = (orig.size.height / tam);
        CGFloat newWidth = (orig.size.width / scaleFactor);
        resize = CGSizeMake(newWidth, tam);
    }
    else {
        resize = CGSizeMake(tam, tam);
    }
    UIImage *resized = [self imageWithImage:orig scaledToSize:resize];
    CGSize sqTam = CGSizeMake(tam, tam);
    UIImage *croped = [self imageByCroppingImage:resized toSize:sqTam andPunto:punto];
    UIImageView *redonda = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tam, tam)];
    redonda.image = croped;
    [redonda.layer setCornerRadius:(tam / 2.0)];
    [redonda setClipsToBounds:YES];
    [redonda.layer setBorderColor:[selColor CGColor]];
    [redonda.layer setBorderWidth:2.0];
    marker = [[RMMarker alloc] initWithUIImage:[self imageWithView:redonda]];
    
    marker.canShowCallout = YES;
    
    marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return marker;
}

/**
 *  <#Description#>
 *
 *  @param control    <#control description#>
 *  @param annotation <#annotation description#>
 *  @param map        <#map description#>
 *
 *  @since version 1.0
 */
- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    NSNumber *i = annotation.userInfo;
    if ([i intValue] == -1) {
        [self performSegueWithIdentifier:@"customSegue" sender:self];
    }
    else {
        MVAAppDelegate *delegate = (MVAAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.selectedPoint = [delegate.puntos objectAtIndex:[i intValue]];
        [self performSegueWithIdentifier:@"punIntSegue" sender:self];
    }
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
    if ([segue.identifier isEqualToString:@"punIntSegue"]) {
        MVAPunIntViewController *vc = (MVAPunIntViewController *) [segue destinationViewController];
        vc.punto = self.selectedPoint;
    }
}

/**
 *  <#Description#>
 *
 *  @param image <#image description#>
 *  @param size  <#size description#>
 *  @param punto <#punto description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (UIImage *)imageByCroppingImage:(UIImage *)image toSize:(CGSize)size andPunto:(MVAPunInt *)punto
{
    CGRect rect = CGRectMake(punto.squareX, punto.squareY, size.height, size.width);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    return img;
}

/**
 *  <#Description#>
 *
 *  @param image   <#image description#>
 *  @param newSize <#newSize description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0f);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  <#Description#>
 *
 *  @param view <#view description#>
 *
 *  @return <#return value description#>
 *
 *  @since version 1.0
 */
- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
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
 *  @return <#return value description#>
 *
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

@end