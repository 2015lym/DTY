//
//  DateService.h
//  dtyios
//
//  Created by Lym on 2020/6/22.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateService : NSObject
// 当前时间时间戳
+ (NSInteger)getNowTimeInterval;

// 时间戳转字符串
+ (NSString *)timeIntervalToString:(NSInteger)timeInterval;

// 字符串转时间戳
+ (NSInteger)stringToTimeInterval:(NSString *)string;

// 字符串转NSDate
+ (NSDate *)stringToDate:(NSString *)string;

// NSDate转字符串
+ (NSString *)dateToString:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
