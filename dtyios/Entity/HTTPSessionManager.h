//
//  HTTPSessionManager.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 17/2/16.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPSessionManager : NSObject
+ (void)post:(NSString *)method
   URLString:(NSString *)URLString
      Header:(NSString *)header
  parameters:(NSString *)parametersJson
     success:(void (^)(NSURLSessionDataTask *, id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

+ (void)post:URLString
  parameters:(NSString *)parametersJson
     success:(void (^)(NSURLSessionDataTask *, id,id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
