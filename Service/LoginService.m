//
//  LoginService.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/3/21.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService

+ (void)checkLoginState:(NSURLSessionDataTask *)task {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSDictionary *allHeaders = response.allHeaderFields;
    if ([allHeaders[@"Author"] isEqualToString:@"dropOut"]) {
        NSLog(@"响应头：%@\nURL：%@", allHeaders, response.URL);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    }
}

@end
