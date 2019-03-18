//
//  NTESDemoConfig.m
//  NIM
//
//  Created by amao on 4/21/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDemoConfig.h"

@interface NTESDemoConfig ()

@end

@implementation NTESDemoConfig
+ (instancetype)sharedConfig
{
    static NTESDemoConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESDemoConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        //wangyi
//        _appKey = @"1ee5a51b7d008254cd73b1d4369a9494";
//        _apiURL = @"https://app.netease.im/api";
//        _cerName= @"ENTERPRISE";
        
        //buy
        _appKey = @"6f44f64cfd07c9cf71883fe2e923cbdb";
        _apiURL = @"https://app.netease.im/api";
        _cerName= @"iosCeShi";
        
    }
    return self;
}

- (NSString *)appKey
{
    return _appKey;
}

- (NSString *)apiURL
{
    return _apiURL;
}

- (NSString *)cerName
{
    return _cerName;
}



@end
