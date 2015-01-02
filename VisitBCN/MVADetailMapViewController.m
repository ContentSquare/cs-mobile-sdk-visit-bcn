//
//  MVADetailMap.m
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 18/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

#import "MVADetailMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Mapbox.h"
#import <MapKit/MapKit.h>
#import "MVARoute.h"

@interface MVADetailMapViewController () <CLLocationManagerDelegate,MKMapViewDelegate,RMMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property RMMapView *mapView;
@property NSMutableArray *locations;
@property NSMutableArray *colors;
@property NSMutableArray *colorRoutes;

@end

@implementation MVADetailMapViewController

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
        self.locations = [[NSMutableArray alloc] init];
        self.colors = [[NSMutableArray alloc] init];
        self.colorRoutes = [[NSMutableArray alloc] init];
        
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
        
        RMAnnotation *annotation1 = [[RMAnnotation alloc] initWithMapView:mapView
                                                               coordinate:self.savedPath.punto.coordinates
                                                                 andTitle:self.savedPath.punto.nombre];
        annotation1.userInfo = [NSNumber numberWithInt:-1];
        [mapView addAnnotation:annotation1];
        
        RMAnnotation *annotation2 = [[RMAnnotation alloc] initWithMapView:mapView
                                                               coordinate:self.savedPath.customlocation.coordinates
                                                                 andTitle:self.savedPath.customlocation.name];
        annotation2.userInfo = [NSNumber numberWithInt:-2];
        [mapView addAnnotation:annotation2];
        
        NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:2];
        [locations addObject:[[CLLocation alloc] initWithLatitude:self.savedPath.customlocation.coordinates.latitude longitude:self.savedPath.customlocation.coordinates.longitude]];
        MVANode *firstNode;
        if (self.subway) firstNode = [self.savedPath.subwayPath.nodes firstObject];
        else firstNode = [self.savedPath.busPath.nodes firstObject];
        [locations addObject:[[CLLocation alloc] initWithLatitude:firstNode.stop.latitude longitude:firstNode.stop.longitude]];
        [self.locations addObject:locations];
        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                              coordinate:((CLLocation *)[locations objectAtIndex:0]).coordinate
                                                                andTitle:@"arrow"];
        [self.colors addObject:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
        [annotation setBoundingBoxFromLocations:locations];
        annotation.userInfo = @"arrow";
        [mapView addAnnotation:annotation];
        
        if (self.subway) {
            for (int i = 0; i < [self.savedPath.subwayPath.edges count]; ++i) {
                MVAEdge *edge = [self.savedPath.subwayPath.edges objectAtIndex:i];
                MVANode *node = [self.savedPath.subwayPath.nodes objectAtIndex:i];
                NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:2];
                [locations addObject:[[CLLocation alloc] initWithLatitude:node.stop.latitude longitude:node.stop.longitude]];
                [locations addObject:[[CLLocation alloc] initWithLatitude:edge.destini.stop.latitude longitude:edge.destini.stop.longitude]];
                [self.locations addObject:locations];
                RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                                      coordinate:((CLLocation *)[locations objectAtIndex:0]).coordinate
                                                                        andTitle:@"arrow"];
                if (edge.tripID == nil || [edge.tripID isEqualToString:@"landmark"]) {
                    [self.colors addObject:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
                }
                else {
                    [self.colors addObject:[self colorForRoute:[node.stop.routes firstObject]]];
                }
                [annotation setBoundingBoxFromLocations:locations];
                annotation.userInfo = [NSNumber numberWithInt:(i + 1)];
                [mapView addAnnotation:annotation];
            }
            for (int i = 0; i < ([self.savedPath.subwayPath.nodes count] - 1); ++i) {
                MVANode *node = [self.savedPath.subwayPath.nodes objectAtIndex:i];
                RMAnnotation *annotationS = [[RMAnnotation alloc] initWithMapView:mapView
                 coordinate:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude)
                 andTitle:node.stop.name];
                 annotationS.userInfo = [NSNumber numberWithInt:i];
                 [self.colorRoutes addObject:[self colorForRoute:[node.stop.routes firstObject]]];
                 [mapView addAnnotation:annotationS];
            }
        }
        else {
            for (int i = 0; i < [self.savedPath.busPath.edges count]; ++i) {
                MVAEdge *edge = [self.savedPath.busPath.edges objectAtIndex:i];
                MVANode *node = [self.savedPath.busPath.nodes objectAtIndex:i];
                NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:2];
                [locations addObject:[[CLLocation alloc] initWithLatitude:node.stop.latitude longitude:node.stop.longitude]];
                [locations addObject:[[CLLocation alloc] initWithLatitude:edge.destini.stop.latitude longitude:edge.destini.stop.longitude]];
                [self.locations addObject:locations];
                RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                                      coordinate:((CLLocation *)[locations objectAtIndex:0]).coordinate
                                                                        andTitle:@"arrow"];
                if ([edge.tripID isEqualToString:@"change"] || [edge.tripID isEqualToString:@"walking"] || [edge.tripID isEqualToString:@"landmark"]) {
                    [self.colors addObject:[UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f]];
                }
                else {
                    [self.colors addObject:[self colorForRoute:[node.stop.routes firstObject]]];
                }
                [annotation setBoundingBoxFromLocations:locations];
                annotation.userInfo = [NSNumber numberWithInt:(i + 1)];
                [mapView addAnnotation:annotation];
            }
            for (int i = 0; i < ([self.savedPath.busPath.nodes count] - 1); ++i) {
                MVANode *node = [self.savedPath.busPath.nodes objectAtIndex:i];
                RMAnnotation *annotationS = [[RMAnnotation alloc] initWithMapView:mapView
                                                                       coordinate:CLLocationCoordinate2DMake(node.stop.latitude, node.stop.longitude)
                                                                         andTitle:node.stop.name];
                annotationS.userInfo = [NSNumber numberWithInt:i];
                [self.colorRoutes addObject:[self colorForRoute:[node.stop.routes firstObject]]];
                [mapView addAnnotation:annotationS];
            }
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
    
    if ([annotation.userInfo isKindOfClass:[NSNumber class]] && ![annotation.title isEqualToString:@"arrow"]) {
        double tam = 50;
        RMMarker *marker;
        NSNumber *i = annotation.userInfo;
        if ([i intValue] == -1) {
            UIColor *selColor;
            UIImage *orig;
            
            selColor = [UIColor colorWithRed:(123.0f/255.0f) green:(168.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f];
            orig = [UIImage imageNamed:self.savedPath.punto.fotoGr];
            
            if (orig == nil) orig = self.savedPath.destImage;
            
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
            UIImage *croped = [self imageByCroppingImage:resized toSize:sqTam andPunto:self.savedPath.punto];
            UIImageView *redonda = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tam, tam)];
            redonda.image = croped;
            [redonda.layer setCornerRadius:(tam / 2.0)];
            [redonda setClipsToBounds:YES];
            [redonda.layer setBorderColor:[selColor CGColor]];
            [redonda.layer setBorderWidth:2.0];
            marker = [[RMMarker alloc] initWithUIImage:[self imageWithView:redonda]];
            
            marker.canShowCallout = YES;
        }
        else if ([i intValue] == -2) {
            UIColor *selColor;
            UIImage *orig;
            
            if ([annotation.title isEqualToString:@"Custom location"]) selColor = [UIColor clearColor];
            else selColor = [UIColor redColor];
            orig = self.savedPath.customlocation.foto;
            
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
            MVAPunInt *punto = [[MVAPunInt alloc] init];
            punto.squareX = 0.0f;
            punto.squareY = 0.0f;
            UIImage *croped = [self imageByCroppingImage:resized toSize:sqTam andPunto:punto];
            UIImageView *redonda = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tam, tam)];
            redonda.image = croped;
            [redonda.layer setCornerRadius:(tam / 2.0)];
            [redonda setClipsToBounds:YES];
            [redonda.layer setBorderColor:[selColor CGColor]];
            [redonda.layer setBorderWidth:2.0];
            marker = [[RMMarker alloc] initWithUIImage:[self imageWithView:redonda]];
            
            marker.canShowCallout = YES;
        }
        else {
            UIView *redonda;
            UIImageView *imV;
            if (self.subway) {
                redonda = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
                imV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
                imV.image = [UIImage imageNamed:@"train-white"];
            }
            else {
                redonda = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
                imV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
                imV.image = [UIImage imageNamed:@"bus-white"];
            }
            [redonda setBackgroundColor:[self.colorRoutes objectAtIndex:[i intValue]]];
            [redonda addSubview:imV];
            UIImage *im = [self imageWithView:redonda];
            im = [self imageWithImage:im scaledToSize:CGSizeMake(30, 30)];
            UIImageView *final = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            final.image = im;
            [final.layer setCornerRadius:15.0f];
            [final setClipsToBounds:YES];
            marker = [[RMMarker alloc] initWithUIImage:[self imageWithView:final]];
            marker.canShowCallout = YES;
        }
        return marker;
    }
    
    RMShape *shape = [[RMShape alloc] initWithView:mapView];
    NSNumber *pos = (NSNumber *)annotation.userInfo;
    shape.lineColor = [self.colors objectAtIndex:[pos intValue]];
    shape.lineWidth = 5.0;
    for (CLLocation *location in [self.locations objectAtIndex:[pos intValue]]) {
        [shape addLineToCoordinate:location.coordinate];
    }
    return shape;
}

/**
 *  Function that searches for the desired route and returns its color.
 *
 *  @param routeID The route's identifier.
 *
 *  @return The color of the desired route.
 *
 *  @since version 1.0
 */
-(UIColor *)colorForRoute:(NSString *)routeID
{
    if (self.subway) {
        for (int i = 0; i < [self.savedPath.subwayRoutes count]; ++i) {
            MVARoute *route = [self.savedPath.subwayRoutes objectAtIndex:i];
            if ([route.routeID isEqualToString:routeID]) return route.color;
        }
    }
    else {
        for (int i = 0; i < [self.savedPath.busRoutes count]; ++i) {
            MVARoute *route = [self.savedPath.busRoutes objectAtIndex:i];
            if ([route.routeID isEqualToString:routeID]) return route.color;
        }
    }
    return nil;
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

@end