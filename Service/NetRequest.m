//
//  NetRequest.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/3/21.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "NetRequest.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetRequest

+ (AFHTTPSessionManager *)setSessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer =  [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    [manager.requestSerializer setValue:[UserService getUserToken] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"LastLoginDeviceCode"];
    [manager.requestSerializer setValue:@"Ios" forHTTPHeaderField:@"DeviceType"];
    if ([[UserService getUserType] isEqualToString:@"old"]) {
        [manager.requestSerializer setValue:[UserService getOldUserInfo].UserId forHTTPHeaderField:@"userId"];
    }
    return manager;
}

+ (NSString *)setUrlString:(NSString *)url {
    url = [NSString stringWithFormat:@"%@",[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    if ([url hasPrefix:@"http"]) {
        return url;
    } else {
        return [Ksdby_api_2 stringByAppendingString:url];
    }
}

+ (void)GET:(NSString *)url
     params:(NSMutableDictionary *)params
   callback:(ServiceRequestCallback)callback
errorCallback:(ServiceErrorCallback)errorCallback {
    AFHTTPSessionManager *manager = [self setSessionManager];
    NSString *requestUrl = [self setUrlString:url];
    params = [self setCommonRequestParams:params];
    [manager GET:requestUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [LoginService checkLoginState:task];
        if (callback) {
            BaseModel *model = [BaseModel yy_modelWithJSON:responseObject];
            callback(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorCallback) {
            NSLog(@"%@", error);
            errorCallback(error);
        }
    }];
}

+ (void)PUT:(NSString *)url
     params:(NSMutableDictionary *)params
   callback:(ServiceRequestCallback)callback
errorCallback:(ServiceErrorCallback)errorCallback {
    AFHTTPSessionManager *manager = [self setSessionManager];
    NSString *requestUrl = [self setUrlString:url];
    
    if ([requestUrl containsString:@"Shares/groupappShares"]) {
    }else{
        params = [self setCommonRequestParams:params];
    }
    [manager PUT:requestUrl parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [LoginService checkLoginState:task];
        if (callback) {
            BaseModel *model = [BaseModel yy_modelWithJSON:responseObject];
            callback(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorCallback) {
            NSLog(@"%@", error);
            errorCallback(error);
        }
    }];
}

+ (void)POST:(NSString *)url
      params:(NSMutableDictionary *)params
    callback:(ServiceRequestCallback)callback
errorCallback:(ServiceErrorCallback)errorCallback {
    AFHTTPSessionManager *manager = [self setSessionManager];
    NSString *requestUrl = [self setUrlString:url];
    
    if ([requestUrl containsString:@"Shares/groupappShares"]) {
    }else{
        params = [self setCommonRequestParams:params];
    }
    [manager POST:requestUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [LoginService checkLoginState:task];
        if (callback) {
            BaseModel *model = [BaseModel yy_modelWithJSON:responseObject];
            callback(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorCallback) {
            NSLog(@"%@", error);
            errorCallback(error);
        }
    }];
}

+ (void)POST:(NSString *)url
      params:(NSMutableDictionary *)params
    callback:(ServiceRequestCallback)callback
progressCallback:(ServiceProgressCallback)progressCallback
errorCallback:(ServiceErrorCallback)errorCallback {
    AFHTTPSessionManager *manager = [self setSessionManager];
    NSString *requestUrl = [self setUrlString:url];
    
    params = [self setCommonRequestParams:params];
    [manager POST:requestUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progressCallback) {
            progressCallback(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (callback) {
            BaseModel *model = [BaseModel yy_modelWithJSON:responseObject];
            callback(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorCallback) {
            NSLog(@"%@", error);
            errorCallback(error);
        }
    }];
}

+ (NSMutableDictionary *)setCommonRequestParams:(NSMutableDictionary *)params {
    if (!params) {
        params = [NSMutableDictionary dictionary];
    }
    return params;
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

+ (void)uploadFile:(NSString *)url
            params:(NSMutableDictionary *)params
          fileData:(NSData *)fileData
          mimeType:(NSString *)mimeType
          callback:(UploadImageCallback)callback
     errorCallback:(ServiceErrorCallback)errorCallback {
    
    AFHTTPSessionManager *manager = [self setSessionManager];
    NSString *requestUrl = [self setUrlString:url];
    params = [self setCommonRequestParams:params];
    
    [manager POST:requestUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName = params[@"fileName"];
        [formData appendPartWithFileData:fileData name:fileName fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (callback) {
            callback(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (errorCallback) {
            errorCallback(error);
        }
    }];
}

+ (NSString *)setOldUrlString:(NSString *)url {
    url = [NSString stringWithFormat:@"%@",[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    if ([url hasPrefix:@"http"]) {
        return url;
    } else {
        return [old_base_api stringByAppendingString:url];
    }
}

+ (void)OLD_POST:(NSString *)url
          params:(NSMutableDictionary *)params
        callback:(OldServiceRequestCallback)callback
   errorCallback:(ServiceErrorCallback)errorCallback {
    AFHTTPSessionManager *manager = [self setSessionManager];
    NSString *requestUrl = [self setOldUrlString:url];
    params = [self setCommonRequestParams:params];
    
    [manager POST:requestUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [LoginService checkLoginState:task];
        if (callback) {
            NSString *string = [StringFunction jsonToString:responseObject];
            OldElevatorBaseModel *model = [OldElevatorBaseModel yy_modelWithJSON:[StringFunction stringToJson:string]];
            callback(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorCallback) {
            NSLog(@"%@", error);
            errorCallback(error);
        }
    }];
}

+ (void)OLD_uploadFile:(NSString *)url
                params:(NSMutableDictionary *)params
              fileData:(NSData *)fileData
              mimeType:(NSString *)mimeType
              callback:(OldServiceRequestCallback)callback
         errorCallback:(ServiceErrorCallback)errorCallback {
    
    AFHTTPSessionManager *manager = [self setSessionManager];
    NSString *requestUrl = [self setOldUrlString:url];
    params = [self setCommonRequestParams:params];
    
    [manager POST:requestUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *fileName = params[@"fileName"];
        [formData appendPartWithFileData:fileData name:fileName fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (callback) {
            NSString *string = [StringFunction jsonToString:responseObject];
            OldElevatorBaseModel *model = [OldElevatorBaseModel yy_modelWithJSON:[StringFunction stringToJson:string]];
            callback(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        if (errorCallback) {
            errorCallback(error);
        }
    }];
}
@end
