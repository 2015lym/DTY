//
//  BaseFunction.m
//  DanShop
//
//  Created by Lym on 2018/11/27.
//  Copyright © 2018 Lym. All rights reserved.
//

#import "BaseFunction.h"
#import <SystemConfiguration/SCNetworkReachability.h>

@implementation BaseFunction

#pragma mark - ---------- 是否联网 ----------
+ (BOOL)connectedToNetwork {
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;//IP地址
    
    bzero(&zeroAddress, sizeof(zeroAddress));//将地址转换为0.0.0.0
    zeroAddress.ss_len = sizeof(zeroAddress);//地址长度
    zeroAddress.ss_family = AF_INET;//地址类型为UDP, TCP, etc.
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags) {
        return NO;
    }
    //根据获得的连接标志进行判断
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable&&!needsConnection) ? YES : NO;
}

#pragma mark - ---------- 获取日期时间 ----------
+ (NSString *)getDayTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

#pragma mark - ---------- 获取当前时间 ----------
+ (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

#pragma mark - ---------- 时间戳 ----------
+ (NSString *)getTimestamp {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", time];
}

#pragma mark - ---------- 格式化时间 ----------
+ (NSString *)formatTime:(NSString *)time {
    if (!time || time.length == 0) {
        return @"";
    }
    NSLog(@"%@", time);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (time.length > 19) {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    NSDate *date = [formatter dateFromString:time];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *result = [formatter stringFromDate:date];
    return result;
}

#pragma mark - ---------- 版本号 ----------
+ (NSString *)getAppVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic valueForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

#pragma mark - ---------- 时间戳转时间 ----------
+ (NSString *)getTimeFromTimesTamp:(NSString *)timeStr {
    double time = [timeStr doubleValue];
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    // 将时间转换为字符串
    NSString *timeS = [formatter stringFromDate:myDate];
    return timeS;
}

+ (NSData *)getUploadImageData:(UIImage *)image {
    if (!image) {
        return nil;
    }
    NSData *data = UIImageJPEGRepresentation(image, 0.4f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:encodedImageStr options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    return decodeData;
}

@end
