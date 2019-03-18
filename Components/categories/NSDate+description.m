//
//  NSDate+description.m
//  CRMSalesManager
//
//  Created by 李 朋远 on 13-5-23.
//  Copyright (c) 2013年 Roliand Group. All rights reserved.
//

#import "NSDate+description.h"

@implementation NSDate (description)

- (NSString *)description {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    return [fmt stringFromDate:self];
}

@end
