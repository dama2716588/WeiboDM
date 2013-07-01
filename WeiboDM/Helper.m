//
//  Helper.m
//  WeiboDM
//
//  Created by ma yulong on 13-5-26.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+ (NSString *)getPinTimeString:(NSString *)dateString {
    if (dateString == nil) {
        return @"";
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *datePin = [dateFormat dateFromString:dateString];
    
    NSDate *now = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate:today options:0];
    
    double timeInterval = [now timeIntervalSinceDate:datePin];
    double hour = timeInterval / (60 * 60);
    if ([datePin timeIntervalSince1970] > [today timeIntervalSince1970] || hour <= 6) {
        if (hour >= 1) {
            return [NSString stringWithFormat:@"%dh+", (int) hour];
        } else {
            double minute = timeInterval / 60;
            if (minute <= 5) {
                return @"刚刚";
            }
            return [NSString stringWithFormat:@"%dm+", (int) minute];
        }
    } else if ([datePin timeIntervalSince1970] > [yesterday timeIntervalSince1970]
               && [datePin timeIntervalSince1970] < [today timeIntervalSince1970]) {
        return @"昨天";
    } else {
        [dateFormat setDateFormat:@"MM-dd"];
        return [dateFormat stringFromDate:datePin];
    }
}

@end
