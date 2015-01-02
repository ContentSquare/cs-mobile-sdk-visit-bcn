//
//  MVACalendar.h
//  VisitBCN
//
//  Created by Mauro Vime Castillo on 04/09/14.
//  Copyright (c) 2014 Mauro Vime Castillo. All rights reserved.
//

/**
 *  This class represents a calendar.
 *
 *  We can represent this class as a table:
 *
 *  | ServiceID | Days  | Start date | End date | Exceptions |
 *  |:---------:|:-----:|:----------:|:--------:|:----------:|
 *  | NSString  | Array |  NSString  | NSString |   Array    |
 *
 *  @since version 1.0
 */

#import <Foundation/Foundation.h>

@interface MVACalendar : NSObject

/**
 *  The identifier of the service
 *
 *  @see MVADate class
 *  @see MVATrip class
 *  @since version 1.0
 */
@property NSString *serviceID;

/**
 *  The days that this calendar is operative
 *
 *  @since version 1.0
 */
@property NSMutableArray *days;

/**
 *  The first day this date is operative
 *
 *  @since version 1.0
 */
@property NSString *startDate;

/**
 *  The last day this date is operative
 *
 *  @since version 1.0
 */
@property NSString *endDate;

/**
 *  The exceptions of this calendar
 *
 *  @see MVADate
 *  @since version 1.0
 */
@property NSMutableArray *exceptions;

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