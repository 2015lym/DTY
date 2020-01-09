//
//  NetRequest.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/3/21.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "OldElevatorBaseModel.h"

typedef void (^OldServiceRequestCallback)(OldElevatorBaseModel *baseModel);

typedef void (^ServiceRequestCallback)(BaseModel *baseModel);
typedef void (^ServiceProgressCallback)(NSProgress *uploadProgress);
typedef void (^ServiceErrorCallback)(NSError* error);
typedef void (^UploadImageCallback)(id responseObject);

@interface NetRequest : NSObject

/**
 GET请求
 
 @param url 请求地址
 @param headers 请求头
 @param params 请求参数
 @param callback 成功返回
 @param errorCallback 失败返回
 */
+ (void)GET:(NSString *)url
     params:(NSMutableDictionary *)params
   callback:(ServiceRequestCallback)callback
errorCallback:(ServiceErrorCallback)errorCallback;

// PUT
+ (void)PUT:(NSString *)url
     params:(NSMutableDictionary *)params
   callback:(ServiceRequestCallback)callback
errorCallback:(ServiceErrorCallback)errorCallback;

/**
 POST请求
 
 @param url 请求地址
 @param headers 请求头
 @param params 请求参数
 @param callback 成功返回
 @param errorCallback 失败返回
 */
+ (void)POST:(NSString *)url
      params:(NSMutableDictionary *)params
    callback:(ServiceRequestCallback)callback
errorCallback:(ServiceErrorCallback)errorCallback;

/**
 POST请求（带进度）
 
 @param url 请求地址
 @param headers 请求头
 @param params 请求参数
 @param callback 成功返回
 @param progressCallback 进度返回
 @param errorCallback 失败返回
 */
+ (void)POST:(NSString *)url
      params:(NSMutableDictionary *)params
    callback:(ServiceRequestCallback)callback
progressCallback:(ServiceProgressCallback)progressCallback
errorCallback:(ServiceErrorCallback)errorCallback;

+ (void)uploadFile:(NSString *)url
            params:(NSMutableDictionary *)params
          fileData:(NSData *)fileData
          mimeType:(NSString *)mimeType
          callback:(UploadImageCallback)callback
     errorCallback:(ServiceErrorCallback)errorCallback;


+ (void)OLD_POST:(NSString *)url
          params:(NSMutableDictionary *)params
        callback:(OldServiceRequestCallback)callback
   errorCallback:(ServiceErrorCallback)errorCallback;

+ (void)OLD_uploadFile:(NSString *)url
                params:(NSMutableDictionary *)params
              fileData:(NSData *)fileData
              mimeType:(NSString *)mimeType
              callback:(OldServiceRequestCallback)callback
         errorCallback:(ServiceErrorCallback)errorCallback;
@end

