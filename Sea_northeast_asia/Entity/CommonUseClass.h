//
//  CommonUseClass.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/23.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonUseClass : NSObject
#pragma mark - 得到救援类型
+(NSString *)GetRescueTypeName:(NSString*)string;

#pragma mark - 弹出框
+(void)showAlter:(NSString *)massage;

+(NSString *)getMenuId:(NSString *)key forList:(NSMutableArray*)list;

+(NSString *)classToJson:(NSObject *)curraa;

+(BOOL)haveQX:(NSString *)key forList:(NSMutableArray*)list;

+(void)SwitchPark;

+(NSString *)FormatString:(id)value;

+(NSString *)getDateString:(NSString *)date;
+(NSString*)getCurrentTimes;

+ (NSString *)getUniqueStrByUUID;

+(NSString *)getID:(id)session;

+(UIColor *)getSysColor;

+(NSString *)getMMSSFromSS:(NSString *)totalTime;

+(BOOL) isWiFiOpened;

+(nullable NSString *)getCurretWiFiSsid;

+(int)meetingIsOver;
@end
