//
//  DateConverter.m
//  Career Map 3
//
//  Created by Adel  Shehadeh on 5/21/15.
//  Copyright (c) 2015 Adel  Shehadeh. All rights reserved.
//

#import "DateConverter.h"

@implementation DateConverter


//convert any date to local time
- (NSString *) convertDateToLocalTime: (NSDate *) date{
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MMM dd, yyyy HH:mm"];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    return [dateFormatter stringFromDate:date ];
    
}



@end
