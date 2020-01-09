//
//  Util.h
//  WageQuery
//
//  Created by Song Ques on 13-6-7.
//  Copyright (c) 2013年 掌控力. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>  
#import "GTMBase64.h"
#import "AFAppDotNetAPIClient.h"
//图文混排
#define BEGIN_FLAG @"["
#define END_FLAG @"]"

#define BEGIN_EMOJI @"["
#define END_EMOJI @"]"

@interface Util:NSObject

#pragma mark - 判断是否整形
+ (BOOL)isPureInt:(NSString*)string;
    
#pragma mark - 得到一个月的天数
+ (int)howManyDaysInThisMonth:(int)year month:(int)imonth;

#pragma mark - 格式化当前时间
+ (NSString*)nowDateToString:(NSString*)formatValue;

#pragma mark - 把字符串转换成时间
+ (NSDate *)convertStringToDate:(NSString*)strValue formatValue:(NSString*)formatValue;

#pragma mark - 把时间转换成字符串
+ (NSString *)convertDateToString:(NSDate*)dateValue formatValue:(NSString*)formatValue;

#pragma mark - 通过日期获取星座
+ (NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d;

#pragma mark -  把时间显示成文字
+ (NSString*)day_hour_string:(NSDate*)startData endDate:(NSDate*)endDate;
#pragma mark -  把时间显示成文字
+ (NSString*)day_hour_stringNew:(NSDate*)startData endDate:(NSDate*)endDate;

#pragma mark -  比较时间
+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString  *)formate;

#pragma mark - 判断是否含有特殊字符
+ (BOOL) hasSpecialCharacter:(NSString *)str;

#pragma mark - 日期转换long
+ (long long) timeIntervalWithDate:(NSDate*)date;

#pragma mark - 将long long型数据转化为nsdate
+ (NSDate *)dateWithTimeInterval:(NSNumber *)interval;

#pragma mark - 获取数据库显示的错误信息
+ (NSString  *)fetchErrorMessages:(NSDictionary *)result;

#pragma mark - APP Path
+ (NSString *)ApplicationPath;

#pragma mark - 创建目录
+ (BOOL)createFiled:(NSString *)strPath;

#pragma mark - 删除目录
+ (BOOL)deleteFileAtPath:(NSString*)_path;

#pragma mark - 获取用户指定的应用目录
+ (NSString*)getCacheDirectory:(NSString*)dir;

#pragma mark - 获取用户指定的应用目录Caches
+ (NSString *)GetMyCachesPath;

#pragma mark - 获取用户指定的应用目录App UserInfo Caches
+ (NSString*)getUserInfoCachesPath;

#pragma mark - 获取用户指定的应用目录App Caches
+ (NSString *)CachesPath;

#pragma mark - 获取WAV文件长度
+ (NSNumber*)getWAVLength:(NSString*)str_filePath;

#pragma mark -获取文件的MD5值
+ (NSString *)md5:(NSString *)path;

#pragma mark - 获取性别
+ (NSString *)getSex:(NSString *)sexValue;

#pragma mark - 获取年龄描述
+ (NSString *)getAge:(NSString *)sexValue;

#pragma mark - 图片整比例缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
+ (UIImage *)scaleToSize:(UIImage *)img;


#pragma mark - 截取部分图像
+ (UIImage*)subToImage:(UIImage *)img rect:(CGRect)rect;
+ (UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;
#pragma mark - 验证用户名
+ (BOOL)invalidate_username:(NSString*)usertext;

#pragma mark - 字符串长度
+ (BOOL)invalidate_strleng6_20:(NSString*)strtext;

#pragma mark - 正则表达试验证
+ (BOOL)invalidate_strForRes:(NSString*)strtext ResStr:(NSString*)ResStr;

#pragma mark - 判断字符串是否是表情
+ (BOOL)DeterminingWhetherStringexpression:(NSString *)message;


+ (NSString*)deleteEmoji:(NSString*)stringContent;

+ (void)getImageRange:(NSString*)message arraySource:(NSMutableArray*)array;

+ (NSString*)emojiImageRange:(NSString*)message;

+ (NSString*)getVersionValue;

+ (UIView *)assembleMessageAtIndex:(NSString  *)message;
+ (UIView *)assembleMessageAtIndexEX:(NSString  *)message;
+ (UIView *)assembleMessageAtIndexTop_EX:(NSString  *)message;
#pragma mark -学友圈文本内容生成
+ (UIView *)makingTextView:(NSString *)content;
#pragma mark -获取设备分辨率
+ (NSString *)GetResolution:(NSString *)xib_name;
#pragma mark -适配字号
+ (float)GetUIFontSize:(float)Fontsize;
@end
