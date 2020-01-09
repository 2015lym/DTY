//
//  RegUtils.h
//  DanShop
//
//  Created by Lym on 2018/12/10.
//  Copyright © 2018 Lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegUtils : NSObject
/**
 自定义正则验证
 
 @param reg 正则表达式
 @param content 测试内容
 @return 返回BOOL值
 */
+ (BOOL)customValidate:(NSString *)reg content:(NSString *)content;

/**
 邮箱正则验证
 
 @param email 邮箱账号
 @return 返回BOOL值
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 手机号码正则验证
 
 @param mobile 手机号码
 @return 返回BOOL值
 */
+ (BOOL)validateMobile:(NSString *)mobile;

+ (NSString *)groupValidate:(NSString *)reg content:(NSString *)content;

@end
