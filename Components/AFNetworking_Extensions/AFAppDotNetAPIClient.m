// AFAppDotNetAPIClient.h
//
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFAppDotNetAPIClient.h"

//static NSString * const AFAppDotNetAPIBaseURLString = @"http://admin.ksdby.urnxyz.com/";
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://192.168.1.111:8102/";
//static NSString * const AFAppDotNetAPIBaseURLString_token = @"http://192.168.1.111:8101/";
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://admin.searchneasia.com/";
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://192.168.1.59:8080/api/";

//内网-100上测试服务器
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://www.lnsinodom.cn:91/api/";
//static NSString * const AFAppDotNetAPIBaseURLString_token = @"http://192.168.1.59:8080/api/";

//线上
static NSString * const AFAppDotNetAPIBaseURLString =Ksdby_api_2;
static NSString * const AFAppDotNetAPIBaseURLString_token =Ksdby_api_2;
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://192.168.1.108:8081/api/";
//static NSString * const AFAppDotNetAPIBaseURLString = @"http://192.168.1.59:8080/api/";

@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
        
    return _sharedClient;
    
    /*
    [[AFAppDotNetAPIClient sharedClient] 
     POST:(nonnull NSString *) 
     parameters:(nullable id)
     progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    [[AFAppDotNetAPIClient sharedClient] 
     POST:(nonnull NSString *) 
     parameters:(nullable id) 
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }]*/
}

+ (instancetype)sharedClient_token {
    
    static AFAppDotNetAPIClient *_sharedClient2 = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient2 = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString_token]];
        _sharedClient2.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        _sharedClient2.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient2.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient2;
    
}

+ (instancetype)sharedClient_new {
    
    AFAppDotNetAPIClient *_sharedClient2 = nil;
   
        _sharedClient2 = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString_token]];
        _sharedClient2.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        _sharedClient2.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sharedClient2.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    
    return _sharedClient2;
    
}

@end
