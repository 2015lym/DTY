//
//  NetService.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "NetService.h"
#import "AFAppDotNetAPIClient.h"
#import "JSONKit.h"


@implementation NetService

/** * AF网络请求 */
+ (void)GET:(NSString *)URLString
    header:(NSMutableDictionary*)headers
parameters:(NSMutableDictionary*)parameters
   succeed:(void (^)(NSDictionary* data))succeed
   failure:(void (^)(NSError *error))failure {
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@",[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    URLString = [Ksdby_api_2 stringByAppendingString:URLString];
//    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager= [AFAppDotNetAPIClient manager];
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    if (headers != nil) {
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        for (NSString *httpHeaderField in headers.allKeys) {
            NSString *value = [NSString stringWithFormat:@"%@",headers[httpHeaderField]];
//            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    [manager.requestSerializer setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"LastLoginDeviceCode"];
    [manager.requestSerializer setValue:@"Ios" forHTTPHeaderField:@"DeviceType"];
    
    parameters = [self setCommonParams:parameters];
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        [LoginService checkLoginState:task];
        succeed([NetService dictionaryWithJsonString:responseStr]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (void)GET:(NSString *)URLString
      html:(NSString *)html
    header:(NSMutableDictionary*)headers
parameters:(NSMutableDictionary*)parameters
   succeed:(void (^)(NSDictionary* data))succeed
   failure:(void (^)(NSError *error))failure {
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@",[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    URLString = [html stringByAppendingString:URLString];
    //    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager= [AFAppDotNetAPIClient manager];
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    if (headers != nil) {
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        for (NSString *httpHeaderField in headers.allKeys) {
            NSString *value = [NSString stringWithFormat:@"%@",headers[httpHeaderField]];
            //            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    [manager.requestSerializer setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"LastLoginDeviceCode"];
    [manager.requestSerializer setValue:@"Ios" forHTTPHeaderField:@"DeviceType"];
    parameters = [self setCommonParams:parameters];
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        [LoginService checkLoginState:task];
        succeed([NetService dictionaryWithJsonString:responseStr]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}
/** * AF网络请求 */
+ (void)POST:(NSString *)URLString
       html:(NSString *)html
     header:(NSMutableDictionary*)headers
 parameters:(id)parameters
    succeed:(void (^)(NSDictionary* data))succeed
    failure:(void (^)(NSError *error))failure {
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@",[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    URLString = [html stringByAppendingString:URLString];
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    if (headers != nil) {
        for (NSString *httpHeaderField in headers.allKeys) {
            NSString *value = [NSString stringWithFormat:@"%@",headers[httpHeaderField]];
            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    [manager.requestSerializer setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"LastLoginDeviceCode"];
    [manager.requestSerializer setValue:@"Ios" forHTTPHeaderField:@"DeviceType"];
    parameters = [self setCommonParams:parameters];
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        [LoginService checkLoginState:task];
        succeed([NetService dictionaryWithJsonString:responseStr]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}
/*json * @brief 把格式化的JSON格式的字符串转换成字典 * @param jsonString JSON格式的字符串 * @return 返回字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData                                                        options:NSJSONReadingMutableContainers                                                          error:&error];
    if (error) {
        //        DNSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}


/** * 上传单张图片 */
+ (void)requestAFURL:(NSString *)URLString
               html:(NSString *)html
header:(NSMutableDictionary*)headers
         parameters:(id)parameters
          imageData:(NSData *)imageData
            succeed:(void (^)(NSDictionary* data))succeed
            failure:(void (^)(NSError *error))failure{
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@%@",html,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    //    DNSLog(@"/n POST上传单张图片参数列表:%@/n/n%@/n",parameters,[XMHttp URLEncryOrDecryString:parameters IsHead:false]);
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 60;
    if (headers != nil) {
        for (NSString *httpHeaderField in headers.allKeys) {
            NSString *value = [NSString stringWithFormat:@"%@",headers[httpHeaderField]];
//            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    [manager.requestSerializer setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"LastLoginDeviceCode"];
    [manager.requestSerializer setValue:@"Ios" forHTTPHeaderField:@"DeviceType"];
    // 5. POST数据
    parameters = [self setCommonParams:parameters];
    [manager POST:URLString  parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
//        // 要解决此问题，
//        // 可以在上传时使用当前的系统事件作为文件名
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        // 设置时间格式
//        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName =parameters[@"fileName"];// [NSString stringWithFormat:@"%@.png", str];
        //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:@"image/jpeg"];
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        [LoginService checkLoginState:task];
        succeed([NetService dictionaryWithJsonString:responseStr]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

+ (void)post:URLString
  parameters:(NSString *)parametersJson
     success:(void (^)(NSURLSessionDataTask *, id,id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    //对请求路径的说明
    //http://120.25.226.186:32812/login
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Ksdby_api_2,URLString];
    //NSString *urlStr = [NSString stringWithFormat:@"http://106.74.113.204:8002/%@",URLString];
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    //NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    NSURL *url = [NSURL URLWithString:urlStr];
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"LastLoginDeviceCode"];
    [request setValue:@"Ios" forHTTPHeaderField:@"DeviceType"];
    
    //5.设置请求体
    //request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = [parametersJson dataUsingEncoding:NSUTF8StringEncoding];
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    
    
    __block NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                //NSLog(@"%@",dict);
                //[self hideProgress];
                
                NSString *str_result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary* dic_result = [str_result objectFromJSONString];
                NSString *Status = [dic_result objectForKey:@"Status"];
                
//                [LoginService checkLoginState:dataTask];
                success(dataTask, response,data);
            }
        }
    }];
    
    //7.执行任务
    [dataTask resume];
}

+ (void)ExecuteByType:URLString
               header:(NSMutableDictionary*)headers
           parameters:(NSString *)parametersJson
                 type:(NSString *)type
              success:(void (^)(NSURLSessionDataTask *, id,id))success
              failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    //对请求路径的说明
    //http://120.25.226.186:32812/login
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",Ksdby_api_2,URLString];
    //NSString *urlStr = [NSString stringWithFormat:@"http://106.74.113.204:8002/%@",URLString];
    //1.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2.根据会话对象创建task
    //NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    NSURL *url = [NSURL URLWithString:urlStr];
    //3.创建可变的请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //4.修改请求方法为POST
    request.HTTPMethod = type;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forHTTPHeaderField:@"LastLoginDeviceCode"];
    [request setValue:@"Ios" forHTTPHeaderField:@"DeviceType"];
    //5.设置请求体
    //request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = [parametersJson dataUsingEncoding:NSUTF8StringEncoding];
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    
    if (headers != nil) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//这个很关键，一定要设置
        for (NSString *httpHeaderField in headers.allKeys) {
            NSString *value = [NSString stringWithFormat:@"%@",headers[httpHeaderField]];
            //            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [request setValue:value forHTTPHeaderField:httpHeaderField];//这里就是你自己对应的参数
        }
    }
    
    
    __block NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(dataTask, error);
            }
        } else {
            if (success) {
                //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                //NSLog(@"%@",dict);
//                [LoginService checkLoginState:dataTask];
                success(dataTask, response,data);
            }
        }
    }];
    
    //7.执行任务
    [dataTask resume];
}

+ (NSMutableDictionary *)setCommonParams:(NSMutableDictionary *)params {
    if (!params) {
        params = [NSMutableDictionary dictionary];
    }
    return params;
}
@end
