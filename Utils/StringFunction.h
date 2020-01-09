//
//  StringFunction.h
//  DanShop
//
//  Created by Lym on 2018/11/27.
//  Copyright © 2018 Lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringFunction : NSObject
// 字符串是否为空
+ (BOOL)isBlankString:(NSString *)str;

// id、dic 转 string
+ (NSString *)jsonToString:(id)json;

// string 转 dic
+ (NSDictionary *)stringToDic:(NSString *)jsonString;

+ (id)stringToJson:(NSString *)jsonString;
@end
