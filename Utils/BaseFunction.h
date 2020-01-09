//
//  BaseFunction.h
//  DanShop
//
//  Created by Lym on 2018/11/27.
//  Copyright © 2018 Lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseFunction : NSObject
// 是否联网
+ (BOOL)connectedToNetwork;
// 获取日期时间
+ (NSString *)getDayTime;
// 获取当前时间
+ (NSString *)getCurrentTime;
// 获取时间戳
+ (NSString *)getTimestamp;
// 时间戳转时间
+ (NSString *)getTimeFromTimesTamp:(NSString *)timeStr;
// 格式化时间
+ (NSString *)formatTime:(NSString *)time;

// 获取 App 版本号
+ (NSString *)getAppVersion;

+ (NSData *)getUploadImageData:(UIImage *)image;


@end

