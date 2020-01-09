//
//  StringFunction.m
//  DanShop
//
//  Created by Lym on 2018/11/27.
//  Copyright © 2018 Lym. All rights reserved.
//

#import "StringFunction.h"

@implementation StringFunction

+ (BOOL)isBlankString:(NSString *)str {
    NSString *string = str;
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)jsonToString:(id)json {
    if(json==nil){
        return nil;
    }
    NSOutputStream *outstream=[NSOutputStream outputStreamToMemory];
    [outstream open];
    [NSJSONSerialization writeJSONObject:json toStream:outstream options:0 error:nil];
    NSData *data=[outstream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    NSMutableString *str=[[NSMutableString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSRange range;
    range.length = str.length;
    range.location = 0;
    [str replaceOccurrencesOfString:@"\\/" withString:@"/" options:NSLiteralSearch range:range];
    return str;
}

+ (NSDictionary *)stringToDic:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

+ (id)stringToJson:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    if(err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:NSJSONReadingMutableContainers
                                             error:&err];;
}
@end
