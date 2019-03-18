//
//  HTTPSessionManager.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 17/2/16.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "HTTPSessionManager.h"
//#import "PrintObject.h"

//#import "BB.h"
//#import "aa.h"
@implementation HTTPSessionManager


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
    //5.设置请求体
    //request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=[parametersJson dataUsingEncoding:NSUTF8StringEncoding];
    //6.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    
NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                   //NSLog(@"%@",dict);

                                   success(dataTask, response,data);
                               }
                           }
                       }];
    
    //7.执行任务
    [dataTask resume];
}

/*
-(void)getSchoolCourse
{
    aa *_aa=[[aa alloc]init];
    _aa.Name=@"name";
    
    
    BB *bb1=[[BB alloc]init];
    bb1.BB_Name=@"bb1";
    BB *bb2=[[BB alloc]init];
    bb2.BB_Name=@"bb2";
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [arr addObject:bb1];
    [arr addObject:bb2];
    
    _aa.BB=arr;
    
    NSMutableArray *arr1=[[NSMutableArray alloc]init];
    [arr1 addObject:_aa];
    [arr1 addObject:_aa];
    [arr1 addObject:_aa];
    //kk *_kk=[[kk alloc]init];
    //_kk.kk=arr1;
    
    NSString *strstr=@"[";
    int i=0;
    for (aa *curraa in arr1) {
        NSData
        *currjsonData = [PrintObject getJSON:curraa options:NSJSONWritingPrettyPrinted error:nil];
        NSString
        *currjsonText = [[NSString alloc] initWithData:currjsonData encoding:NSUTF8StringEncoding];
        
        strstr=[strstr stringByAppendingString:currjsonText];
        if(i<arr1.count-1)
            strstr=[strstr stringByAppendingString:@","];
        i=i+1;
    }
    strstr=[strstr stringByAppendingString:@"]"];
    
    //NSData*jsonData = [PrintObject getJSON:_kk options:NSJSONWritingPrettyPrinted error:nil];
    
    //NSString*jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@",jsonText);
    
    
    
    //对请求路径的说明
    //http://120.25.226.186:32812/login
    //协议头+主机地址+接口名称
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)
    //POST请求需要修改请求方法为POST，并把参数转换为二进制数据设置为请求体
    NSString *urlStr = [NSString stringWithFormat:@"http://192.168.1.024:8003/Login/IOS/%@/Test1",@"5b8f2616-449d-445a-94e2-c136b5a0174e"];;
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
    //5.设置请求体
    //request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody=[strstr dataUsingEncoding:NSUTF8StringEncoding];
    //6.根据会话对象创建一个Task(发送请求）
    
     //第一个参数：请求对象
     //第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     //data：响应体信息（期望的数据）
     //response：响应头信息，主要是对服务器端的描述
     //error：错误信息，如果请求失败，则error有值
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //8.解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
        
    }];
    
    //7.执行任务
    [dataTask resume];
}
*/
@end
