//
//  MVACustomLocation.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 3/12/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is used to save the custom locations created by the user
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MVACustomLocation : NSObject

/**
 *  The name given by the user to this location
 */
@property NSString *name;

/**
 *  The coordinates of the custom location
 */
@property CLLocationCoordinate2D coordinates;

/**
 *  A photo that represents the location and makes it easy to remember
 */
@property UIImage *foto;

@end
