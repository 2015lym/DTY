//
//  XXNet.h
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define RepairRecordUrl @"Repair/Repairs"
#define RepairRecordDetailURL @"Repair/GetRepair"
#define GetOnlineListUrl @"Online/GetOnlineList"
#define GetOnlineRatesPicUrl @"Online/GetOnlineRatesPic"
#define GetProblemListURL @"Problem/GetProblemList"
#define GetArticleListURL @"Notice/GetArticleList"//通知通告
#define GetArticleURL @"Notice/GetArticle"//通知通告名细
#define GetPropertyChecksURL @"PropertyCheck/PropertyChecks"//物业巡查
#define GetPropertyCheckURL @"PropertyCheck/GetPropertyCheck"//物业巡查
#define GetModifyPwd @"User/ModifyPwd" //修改密码
#define GetUserInfoCheckURL @"User/GetUserInfo"//
#define UploadFileURL @"Check/UploadFile"
#define SaveCheckURL @"Check/SaveCheck"
//检验
#define GetInspectList @"Inspect/GetInspectList"//获取检验记录列表
#define GetInspectStepList @"Inspect/GetInspectStepList"//获取维保项列表信息
#define GetInspectByLiftNum @"Inspect/GetInspectByLiftNum"//获取电梯详情信息

#define GetIsInspectByLiftNum @"Inspect/GetIsInspectByLiftNum"//检验电梯是否存在

#define AddLift @"Inspect/AddLift"//添加电梯
#define SaveInspectDetailLock @"Inspect/SaveInspectDetailLock"//上锁解锁
#define UploadFileURL_Inspect @"Inspect/UploadFile"
#define UploadFileURL_Inspect_ios @"Inspect/IosUploadFile"//shipin
#define SaveInspectDetail @"Inspect/SaveInspectDetail"
#define UpdateInspectByID @"Inspect/UpdateInspectByID"
#define WYXC_GetPropertyStep @"PropertyCheck/GetPropertyStep"//物业巡查——得到巡查步骤
#define wxjl_GetRepairNewNum @"Repair/GetRepairNewNum"//维修记录
#define dtjy_writeName @"Inspect/SaveInspectSign"//

//video




enum HTTPMETHOD{
    METHOD_GET   = 0,
    //GET请求
    METHOD_POST  = 1,
    //POST请求
};
@interface XXNet : NSObject
+ (XXNet *)sharedUtil;/** * iOS自带网络请求框架 */
/** * AF网络请求 */
+(void)GetURL:(NSString *)URLString
       header:(NSMutableDictionary*)headers
   parameters:(NSMutableDictionary*)parameters
      succeed:(void (^)(NSDictionary* data))succeed
      failure:(void (^)(NSError *error))failure;
/** * AF数据请求 */
+(void)PostURL:(NSString *)URLString
       header:(NSMutableDictionary*)headers
       parameters:(NSMutableDictionary*)parameters
       succeed:(void (^)(NSDictionary* data))succeed
       failure:(void (^)(NSError *error))failure;


/** * 上传单张图片 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
          imageData:(NSData *)imageData
            succeed:(void (^)(NSDictionary* data))succeed
            failure:(void (^)(NSError *error))failure;

+ (void)post:URLString
  parameters:(NSString *)parametersJson
     success:(void (^)(NSURLSessionDataTask *, id,id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
