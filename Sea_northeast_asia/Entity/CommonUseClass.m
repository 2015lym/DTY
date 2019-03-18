//
//  CommonUseClass.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/23.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "CommonUseClass.h"
#import "PrintObject.h"
#import "AFAppDotNetAPIClient.h"
#import "appDelegate.h"

#import<objc/runtime.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <net/if.h>
#import "NTESMeetingViewController.h"
@interface CommonUseClass ()

@end

@implementation CommonUseClass

#pragma mark - 得到救援类型
+(NSString *)GetRescueTypeName:(NSString*)string
{
    NSString *value=@"";
    if ([string isEqual:@"1"]) {
        value=@"维保救援";
    }
    else if ([string isEqual:@"2"]) {
        value=@"应急救援";
    }
    else if ([string isEqual:@"3"]) {
        value=@"应急救援";
    }
    return value;
}

#pragma mark - 弹出框
+(void)showAlter:(NSString *)massage{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:massage
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
    
}

#pragma mark - getMenuId
+(NSString *)getMenuId:(NSString *)key forList:(NSMutableArray*)list
{
    NSString *menuId=@"";
    for (NSMutableDictionary *dic_item in list )
    {
        NSString *currKey=[dic_item objectForKey:@"Ios"];
        if([currKey isEqualToString :key])
        {
            menuId=[dic_item objectForKey:@"Guid"];
        }
    }
    
    return menuId;
}

+(NSString *)classToJson:(NSObject *)curraa
{
    NSData
    *currjsonData = [PrintObject getJSON:curraa options:NSJSONWritingPrettyPrinted error:nil];
    NSString
    *currjsonText = [[NSString alloc] initWithData:currjsonData encoding:NSUTF8StringEncoding];
    
    return currjsonText;
}

#pragma mark - 是否有二级三级权限
+(BOOL)haveQX:(NSString *)key forList:(NSMutableArray*)list
{
    BOOL bvalue=false;
    for (NSMutableDictionary *dic_item in list )
    {
        NSString *currKey=[dic_item objectForKey:@"Url"];
        if([currKey isEqualToString :key])
        {
            return true;
        }
    }
    
    return bvalue;
}

+(NSString *)FormatString:(id)value
{
    NSString *returnValue= [NSString stringWithFormat:@"%@",value];;
    if([returnValue isEqual:@"<null>"] || [returnValue isEqual:@"(null)"])
    {
        returnValue=@"";
    }
    return returnValue;
}

+(NSString *)getDateString:(NSString *)date
{
    if([[self FormatString:date] isEqual:@""])return @"";
    
    NSArray *Time = [date componentsSeparatedByString:@"."];
    NSArray *cTime = [[Time objectAtIndex:0] componentsSeparatedByString:@"T"];
    if(cTime.count==2)
    {
    if(![[cTime objectAtIndex:0] isEqual:@"<null>"]&&![[cTime objectAtIndex:0] isEqual:@""])
        return  [NSString stringWithFormat:@"%@ %@",  [cTime objectAtIndex:0], [cTime objectAtIndex:1]];
    else
        return  @"";
    }
    else
        return [cTime objectAtIndex:0];
}


+(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

+ (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString ;
}

+(NSString *)getID:(id)session
{
    NSString *returnValue=@"";
    Ivar ivar = class_getInstanceVariable([session class], [@"_foundTags" UTF8String]);
    NSArray *ivarValue = object_getIvar(session, ivar);
    if(ivarValue.count>0)
    {
        NSDictionary *dic=ivarValue[0];
        NSString *tagid=[NSString stringWithFormat:@"%@",dic ];
        @"<NFTagInternal: 0x1c808fcd0> { TagTech=A Type=MiFare Identifier=<9fe09502 1e2b0100 0000> }";
        NSArray *s = [tagid componentsSeparatedByString:@"Identifier=<"];
        if(s.count>=2)tagid=s[1];
        s = [tagid componentsSeparatedByString:@">"];
        if(s.count>=2)tagid=s[0];
        tagid = [tagid stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(tagid.length>14)tagid=[tagid substringToIndex:14];
        returnValue=[tagid uppercaseString];
        
        NSLog(@"Payload str:%@",returnValue);
    }
    
    return returnValue;
}
//+ (DeviceType)deviceType{
//
//
//    struct utsname systemInfo;
//    uname(&systemInfo);
//    NSString *platform = [NSString stringWithCString:systemInfo.machine
//                                            encoding:NSUTF8StringEncoding];
//    //simulator
//    if ([platform isEqualToString:@"i386"])          return Simulator;
//    if ([platform isEqualToString:@"x86_64"])        return Simulator;
//
//    //iPhone
//    if ([platform isEqualToString:@"iPhone1,1"])     return IPhone_1G;
//    if ([platform isEqualToString:@"iPhone1,2"])     return IPhone_3G;
//    if ([platform isEqualToString:@"iPhone2,1"])     return IPhone_3GS;
//    if ([platform isEqualToString:@"iPhone3,1"])     return IPhone_4;
//    if ([platform isEqualToString:@"iPhone3,2"])     return IPhone_4;
//    if ([platform isEqualToString:@"iPhone4,1"])     return IPhone_4s;
//    if ([platform isEqualToString:@"iPhone5,1"])     return IPhone_5;
//    if ([platform isEqualToString:@"iPhone5,2"])     return IPhone_5;
//    if ([platform isEqualToString:@"iPhone5,3"])     return IPhone_5C;
//    if ([platform isEqualToString:@"iPhone5,4"])     return IPhone_5C;
//    if ([platform isEqualToString:@"iPhone6,1"])     return IPhone_5S;
//    if ([platform isEqualToString:@"iPhone6,2"])     return IPhone_5S;
//    if ([platform isEqualToString:@"iPhone7,1"])     return IPhone_6P;
//    if ([platform isEqualToString:@"iPhone7,2"])     return IPhone_6;
//    if ([platform isEqualToString:@"iPhone8,1"])     return IPhone_6s;
//    if ([platform isEqualToString:@"iPhone8,2"])     return IPhone_6s_P;
//    if ([platform isEqualToString:@"iPhone8,4"])     return IPhone_SE;
//    if ([platform isEqualToString:@"iPhone9,1"])     return IPhone_7;
//    if ([platform isEqualToString:@"iPhone9,3"])     return IPhone_7;
//    if ([platform isEqualToString:@"iPhone9,2"])     return IPhone_7P;
//    if ([platform isEqualToString:@"iPhone9,4"])     return IPhone_7P;
//    if ([platform isEqualToString:@"iPhone10,1"])    return IPhone_8;
//    if ([platform isEqualToString:@"iPhone10,4"])    return IPhone_8;
//    if ([platform isEqualToString:@"iPhone10,2"])    return IPhone_8P;
//    if ([platform isEqualToString:@"iPhone10,5"])    return IPhone_8P;
//    if ([platform isEqualToString:@"iPhone10,3"])    return IPhone_X;
//    if ([platform isEqualToString:@"iPhone10,6"])    return IPhone_X;
//
//    return Unknown;
//
//}

+(UIColor *)getSysColor{
return  [UIColor colorWithHexString:@"#3574fa"];
}

+(NSString *)getMMSSFromSS:(NSString *)totalTime{
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    
    return format_time;
}

+(BOOL) isWiFiOpened
{
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    if( ! getifaddrs(&interfaces) )
    {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next)
        {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP )
            {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}

+(nullable NSString *)getCurretWiFiSsid
{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs)
    {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [(NSDictionary*)info count]) { break; }
    }
    return [(NSDictionary*)info objectForKey:@"SSID"];
}

+(int)meetingIsOver
{
    AppDelegate* app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    UINavigationController * nav=(UINavigationController *)app.window.rootViewController;
    if(nav. viewControllers.count==0)return 0;
    NSMutableArray *vcs1 =[nav. viewControllers mutableCopy] ;
    if(vcs1<=0)return 0;
    for (long i=0;i<vcs1.count;i++) {
        UIViewController *tempself=vcs1[i];
        if ([tempself isKindOfClass:[NTESMeetingViewController class]])
        {
            return 1;
        }
    }
    return  0;
}


@end
