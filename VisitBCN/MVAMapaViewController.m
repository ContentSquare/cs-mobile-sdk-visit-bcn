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
 *  Function that gets called when the view controller has loaded the view
 *
 *  @since version 1.0
 */
-(void)viewDidLoad
{
    self.mapView = nil;
    
}

/**
 *  Notifies the view controller that its view was added to a view hierarchy.
 *
 *  @param animated If YES, the view was added to the window using an animation.
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
        [mapView setMinZoom:12.1];
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
    else {
        BOOL tro = NO;
        NSArray *ann = self.mapView.annotations;
        for (int i = 0; i < [ann count] && !tro; ++i) {
            RMAnnotation *annot = [ann objectAtIndex:i];
            NSNumber *num = annot.userInfo;
            if ([num intValue] == -1) {
                [self.mapView removeAnnotation:annot];
                tro = YES;
                if ([self loadCustom] > 0) {
                    MVACustomLocation *loc = [self loadCustomLocation];
                    RMAnnotation *annotation1 = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                                           coordinate:loc.coordinates
                                                                             andTitle:loc.name];
                    annotation1.userInfo = [NSNumber numberWithInt:(-1)];
                    [self.mapView addAnnotation:annotation1];
                }
            }
        }
        if (!tro && ([self loadCustom] > 0)) {
            MVACustomLocation *loc = [self loadCustomLocation];
            RMAnnotation *annotation1 = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                                   coordinate:loc.coordinates
                                                                     andTitle:loc.name];
            annotation1.userInfo = [NSNumber numberWithInt:(-1)];
            [self.mapView addAnnotation:annotation1];
        }
    }
}

/**
 *  Asks the delegate for a renderer object to use when drawing the specified overlay.
 *
 *  @param mapView The map view that requested the renderer object.
 *  @param overlay The overlay object that is about to be displayed.
 *
 *  @return The renderer to use when presenting the specified overlay on the map. If you return nil, no content is drawn for the specified overlay object.
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
 *  Asks the delegate to return the layer for a created annotation.
 *
 *  @param mapView    The map object.
 *  @param annotation The annotation created.
 *
 *  @return The layer that represents the annotation.
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
 *  Tells the delegate that the user taped on the call out of one of the annotations.
 *
 *  @param control    The control object.
 *  @param annotation The annotation that contains the call out.
 *  @param map        The map object.
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
 *  Function that gets called when the user selects the custom location button.
 *
 *  @param sender The button that triggers this function.
 *
 *  @since version 1.0
 */
- (IBAction)customSel:(id)sender
{
    [self performSegueWithIdentifier:@"customSegue" sender:self];
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
    if ([segue.identifier isEqualToString:@"punIntSegue"]) {
        MVAPunIntViewController *vc = (MVAPunIntViewController *) [segue destinationViewController];
        vc.punto = self.selectedPoint;
    }
}

/**
 *  Function that crops a given image to fit a new size.
 *
 *  @param image The original image.
 *  @param size  The new size.
 *  @param punto MVAPunInt class object that indicates the origin coordinates of the new image.
 *
 *  @return The new image.
 *
 *  @see MVAPunInt class
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
 *  Function that scales a given image to ft a new size.
 *
 *  @param image   The original image.
 *  @param newSize The new size.
 *
 *  @return The scaled image.
 *
 *  @since version 1.0
 */
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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

@end