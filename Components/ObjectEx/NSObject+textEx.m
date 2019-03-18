//
//  NSObject+textEx.m
//  HIChat
//
//  Created by Song Ques on 14-4-16.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import "NSObject+textEx.h"

@implementation NSObject (textEx)

-(NSString*)textEx{
    // 转换空串
    if ([self isEqual:[NSNull null]]) {
        return nil;
    }
    else if ([self isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    else if([[NSString stringWithFormat:@"%@",self] isEqualToString:@"(null)"])
    {
        return @"";
    }
    else if([[NSString stringWithFormat:@"%@",self] isEqualToString:@"<null>"])
    {
        return @"";
    }
    else if (self==nil){
        return nil;
    }
    return [NSString stringWithFormat:@"%@",self];
}
@end
