//
//  NSDictionary+JsonMethods.m
//  audi-services
//
//  Created by 安泽旭 on 13-10-29.
//  Copyright (c) 2013年 zhangkongli. All rights reserved.
//

#import "NSDictionary+JsonMethods.h"

@implementation NSDictionary (JsonMethods)

-(NSString *) jsonFromDictionary{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return str;
}

@end
