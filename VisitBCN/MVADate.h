//
//  MVADate.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class is used to store the different calendar excepcional dates where the services operates.
 *
 *  We can represent this class as a table:
 *
 *  |    ServiceID   |  Date   |  Type   |
 *  |:--------------:|:-------:|:-------:|
 *  |    NSString    | Integer | Integer |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>

@interface MVADate : NSObject

/**
 *  The identifier of the service
 *
 *  @see MVACalendar class
 *  @see MVATrip class
 *  @since version 1.0
 */
@property NSString *serviceID;

/**
 *  The calendar date expressed in yyyyMMdd format
 *
 *  @since version 1.0
 */
@property int date;

/**
 *  The type of the date. If the value is equal to 1 it indicates we are adding this service to the given date, if it's 2 it indicates we are erasing this service for the given date
 *
 *  @since version 1.0
 */
@property int type;

/**
 *  This function is used to insert a given data to the correct field
 *
 *  @param elem  The data to be inserted
 *  @param index The index of this data in the GTFS file
 *
 *  @since version 1.0
 */
-(void)insertElement:(NSString *)elem atIndex:(NSInteger)index;

@end