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

@interface MVAMapaViewController () <CLLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *detailView;

@end

@implementation MVAMapaViewController

-(void)viewDidAppear:(BOOL)animated
{
    RMMBTilesSource *offlineSource = [[RMMBTilesSource alloc] initWithTileSetResource:@"visitBCN" ofType:@"mbtiles"];
    
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:offlineSource];
    
    mapView.zoom = 12.1;
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    mapView.adjustTilesForRetinaDisplay = YES; // these tiles aren't designed specifically for retina, so make them legible
    
    [mapView setMaxZoom:offlineSource.maxZoom];
    [mapView setMinZoom:12];
    [mapView setBouncingEnabled:YES];
    RMSphericalTrapezium trap = offlineSource.latitudeLongitudeBoundingBox;
    [mapView setConstraintsSouthWest:trap.southWest northEast:trap.northEast];
    [mapView setCenterCoordinate: offlineSource.centerCoordinate];
    [mapView setShowsUserLocation:YES];
    [self.detailView addSubview:mapView];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    return nil;
}

@end