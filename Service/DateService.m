//
//  DateService.m
//  dtyios
//
//  Created by Lym on 2020/6/22.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "DateService.h"

@implementation DateService

#pragma mark 当前时间时间戳
+ (NSInteger)getNowTimeInterval {
    NSDate *date = [NSDate date];
    NSInteger timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}

#pragma mark 时间戳转字符串
+ (NSString *)timeIntervalToString:(NSInteger)timeInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}

#pragma mark 字符串转时间戳
+ (NSInteger)stringToTimeInterval:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    NSInteger timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}

#pragma mark 字符串转NSDate
+ (NSDate *)stringToDate:(NSString *)string {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

#pragma mark NSDate转字符串
+ (NSString *)dateToString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}
@end
