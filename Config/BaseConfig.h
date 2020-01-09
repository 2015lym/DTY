//
//  BaseConfig.h
//  Sea_northeast_asia
//
//  Created by Lym on 2020/1/8.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BaseConfig_h
#define BaseConfig_h

//1常开
//1.1
static NSString * const Ksdby_api = @"http://api.searchneasia.com/";

//线上
static NSString * const Ksdby_api_2 = @"http://appapi.dianti119.com/api/";
//线上维保图片
static NSString * const Ksdby_api_Img = @"http://appapi.dianti119.com";

////内网1
//static NSString * const Ksdby_api_2 = @"http://192.168.1.42:8080/api/";
////内网1维保图片
//static NSString * const Ksdby_api_Img = @"http://192.168.1.42:8080";
//
////内网2
//static NSString * const Ksdby_api_2 = @"http://192.168.1.125:8080/api/";
////内网2维保图片
//static NSString * const Ksdby_api_Img = @"http://192.168.1.125:8080";

// bugly
static NSString * const bugly_ID = @"e0476b271a";

/*微信支付appId*/
static NSString * const WX_AppID  = @"wxe9704bd8e0a2cc7f";
static NSString * const URL_SECRET  = @"51dca053331a5b52df357f3bdea393ae";
static NSString * const QQ_AppID  = @"1105662348";

// 提示信息
static NSString * const MsgBack  = @"您确定要退出吗？";
static NSString * const MessageResult = @"服务器错误";
static NSString * const MessageResult_login = @"服务器错误(请检查网络连接状态或与管理员联系)！";
static NSString * const SysDataError = @"数据错误";
static NSString * const MessagePushErr = @"您没有此模块权限或通知设置没打开";
static NSString * const MessageLocation = @"定位未成功，请检查网络或定位设置是否开启！";


#pragma mark - 部门角色相关配置
/// 软件开发公司角色
static NSString * const SoftDeptRoleCode = @"SoftDeptRole";

/// 12365角色
static NSString * const AbcDeptRoleCode = @"12365DeptRole";

/// 省质监角色
static NSString * const ProvinDeptRoleCode = @"ProvinDeptRole";

/// 市质监角色
static NSString * const CityDeptRoleCode = @"CityDeptRole";

/// 物业部门角色
static NSString * const UseDeptRoleCode = @"UseDeptRole";

/// 维保部门角色
static NSString * const MaintDeptRoleCode = @"MaintDeptRole";

/// 登记部门角色
static NSString * const RegDeptRoleCode = @"RegDeptRole";

/// 制造部门角色
static NSString * const MadeDeptRoleCode = @"MadeDeptRole";

/// 年检部门角色
static NSString * const YearDeptRoleCode = @"YearDeptRole";

/// 一级救援
static NSString * const RescueLevel1 = @"Rescue_Level1";

/// 二级救援
static NSString * const RescueLevel2 = @"Rescue_Level3";

/// 三级救援
static NSString * const RescueLevel3 = @"Rescue_Level3";

/// 屏蔽原因
static NSString * const ShieldingCauseCode = @"ShieldingCause";


#endif /* BaseConfig_h */
