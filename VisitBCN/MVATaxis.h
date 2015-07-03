//
//  MVATaxis.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 27/11/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is used to make the calls to the Hailo API and retreive the taxi data
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MVATaxis : NSObject

/**
 *  The structure that stores the results of the query answer
 *
 *  @since version 1.0
 */
@property NSDictionary *hailoTimes;

/**
 *  The origin's coordinates (the pick up coordinates)
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D orig;

/**
 *  The destination's coordinates (the drop off coordinates)
 *
 *  @since version 1.0
 */
@property CLLocationCoordinate2D dest;

/**
 *  Function that opens the Hailo app using the URL scheme
 *
 *  @return A bool that indicates if the action was performed or not.
 *
 *  @since version 1.0
 */
-(BOOL)openHailo;

/**
 *  Function that downloads from the API the Hailo data
 *
 *  @since version 1.0
 */
-(void)loadHailoTime;

/**
 *  Function used when there's no internet connection. This function makes an estimation of the taxi fare
 *
 *  @param dist The distance between the two points
 *  @param date The date of the trip
 *
 *  @return The taxi fare estimated
 *
 *  @since version 1.0
 */
-(double)taxiFareWithDistance:(double)dist andDate:(NSDate *)date;

@end
