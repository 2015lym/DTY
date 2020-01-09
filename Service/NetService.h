//
//  NetService.h
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

enum HTTPMETHOD{
    METHOD_GET   = 0,
    //GET请求
    METHOD_POST  = 1,
    //POST请求
};
@interface NetService : NSObject
+ (NetService *)sharedUtil;/** * iOS自带网络请求框架 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/** * AF网络请求 */
+ (void)GET:(NSString *)URLString
    header:(NSMutableDictionary*)headers
parameters:(NSMutableDictionary*)parameters
   succeed:(void (^)(NSDictionary* data))succeed
   failure:(void (^)(NSError *error))failure;

+ (void)GET:(NSString *)URLString
      html:(NSString *)html
    header:(NSMutableDictionary*)headers
parameters:(NSMutableDictionary*)parameters
   succeed:(void (^)(NSDictionary* data))succeed
   failure:(void (^)(NSError *error))failure;


/** * AF数据请求 */
+ (void)POST:(NSString *)URLString
       html:(NSString *)html
     header:(NSMutableDictionary*)headers
 parameters:(id)parameters
    succeed:(void (^)(NSDictionary* data))succeed
    failure:(void (^)(NSError *error))failure;


/** * 上传单张图片 */
+ (void)requestAFURL:(NSString *)URLString
               html:(NSString *)html
header:(NSMutableDictionary*)headers
         parameters:(id)parameters
          imageData:(NSData *)imageData
            succeed:(void (^)(NSDictionary* data))succeed
            failure:(void (^)(NSError *error))failure;

+ (void)post:URLString
  parameters:(NSString *)parametersJson
     success:(void (^)(NSURLSessionDataTask *, id,id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

+ (void)ExecuteByType:URLString
               header:(NSMutableDictionary*)headers
           parameters:(NSString *)parametersJson
                 type:(NSString *)type
              success:(void (^)(NSURLSessionDataTask *, id,id))success
              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
