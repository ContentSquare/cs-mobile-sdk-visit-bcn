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
 *  We can represent this class as a table:
 *
 *  |  Name  | Coordinates |  Foto   |
 *  |:------:|:-----------:|:-------:|
 *  | String | Coordinates | UIImage |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MVACustomLocation : NSObject

/**
 *  The name given by the user to this location
 *
 *  @since version 1.0
 */
@property NSString *name;

/**
 *  The coordinates of the custom location
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D coordinates;

/**
 *  A photo that represents the location and makes it easy to remember
 *
 *  @since version 1.0
 */
@property UIImage *foto;

@end
