//
//  AppDelegate.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/24.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewDelegate.h"
#import "JSONKit.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import "loginAndRegistViewController.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "UMMobClick/MobClick.h"
#import "TZTGViewController.h"
#import "complainAdvice.h"
#import "showPicViewController.h"
#import "XXNet.h"
static BOOL isBackGroundActivateApplication;

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate
@synthesize str_UserPath;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    
    
    //网易云信
    NSString *appKey = [[NTESDemoConfig sharedConfig] appKey];
    NSString *cerName= [[NTESDemoConfig sharedConfig] cerName];
    [[NIMSDK sharedSDK] registerWithAppID:appKey
                                  cerName:cerName];
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    [[NIMKit sharedKit] setProvider:[NTESDataManager sharedInstance]];
    
    
    
    // Override point for customization after application launch.
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    str_UserPath=[NSString stringWithFormat:@"%@/%@",[Util CachesPath],@"userInfo"];
    _window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];;
    [self loginShow];
    [_window makeKeyAndVisible];
    [self GetVersion];
    
    //UMConfigInstance.appKey = @"58e5b938310c932de000086f";
    //UMConfigInstance.channelId = @"App Store";
    
    //[MobClick startWithConfigure:UMConfigInstance];
    [UMessage startWithAppkey:@"58e5b938310c932de000086f" launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    [UMessage setChannel:@"App Store"];
    
    [MobClick startWithConfigure:UMConfigInstance];
    [UMessage startWithAppkey:@"58e5b938310c932de000086f" launchOptions:launchOptions];
    
    
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
   
    [UMessage setLogEnabled:YES];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    __IOS7_S
    [[UINavigationBar appearance] setBarTintColor:NAV_BACKGROUNDCOLOR];
    __IOS7_SE
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor],
                                                           NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           nil, NSFontAttributeName, nil]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType myTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:myTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    //创建并初始化一个引擎对象
    BMKMapManager *manager = [[BMKMapManager alloc] init];
    //启动地图引擎
    //BOOL success =  [manager start:@"zBWLNgRUrTp9CVb5Ez6gZpNebljmYylO" generalDelegate:nil];
    BOOL success =  [manager start:@"Fg3dLLfGwsEkEFlEP5jxzadqdo2ARk55" generalDelegate:nil];
    
    if (!success) {
        NSLog(@"失败");
    }
    
    [self VerifyMessage];
    
    [self createUpSourceTime];
    [Bugly startWithAppId:bugly_ID];
    
     [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
     NSSetUncaughtExceptionHandler(&getException);
    
    return YES;
}

//获得异常的C函数
void getException(NSException *exception)
{
    NSLog(@"名字：%@",exception.name);
    NSLog(@"原因：%@",exception.reason);
    NSLog(@"用户信息：%@",exception.userInfo);
    NSLog(@"栈内存地址：%@",exception.callStackReturnAddresses);
    NSLog(@"栈描述：%@",exception.callStackSymbols);
    //每次启动的时候将，捕获的异常信息，反馈给服务器
    //获取当前设备
    UIDevice*divice=[UIDevice currentDevice];
    //1.系统版本
    NSString*systemVersion=divice.systemVersion;
    //2.app当前版本
    //先获取当前infoplist文件数据
    NSDictionary*infoDic=[[NSBundle mainBundle] infoDictionary];
    //然后从字典中取出版本号
    NSString*version=[infoDic objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"系统版本%@",version);
    //3.系统时间
    NSDate*date=[NSDate date];
    //4.设备种类
    NSString*model=divice.model;
    //将捕获的异常数据进行保存，保存到本地
    //可以在下一次启动的时候将数据发给服务器
}



//tuisong_reg
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    NSString* aStr;
    aStr = [[NSString alloc] initWithData:deviceToken encoding:NSASCIIStringEncoding];
    
    self.UM_deviceToken= [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"UM_deviceToken=%@",self.UM_deviceToken);

}
//替换非utf8字符
//注意：如果是三字节utf-8，第二字节错误，则先替换第一字节内容(认为此字节误码为三字节utf8的头)，然后判断剩下的两个字节是否非法；
- (NSData *)replaceNoUtf8:(NSData *)data
{
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}

//iOS10新增：处理前台收到通知的代理方法 ts1
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    NSString *body= notification.request.content.body;
     if([body rangeOfString:@"请求视频通话"].location !=NSNotFound)
     {
         NSDictionary * aps=[userInfo objectForKey:@"aps"];
         NSString * roomid= [aps objectForKey:@"roomId"];
         NSString * roomName= [aps objectForKey:@"roomName"];
         NSString * creator= [aps objectForKey:@"creator"];
         NSMutableDictionary * userInfo=[NSMutableDictionary new];
         [userInfo setValue:roomid forKey:@"roomId"];
         [userInfo setValue:roomName forKey:@"roomName"];
         [userInfo setValue:creator forKey:@"roomName"];
         
         if([[CommonUseClass FormatString: roomid] isEqual:@""]||[[CommonUseClass FormatString:roomName] isEqual:@""])
         {}else
         {
             //点击推送消息方法回调
             [self join:aps];
             return;
         }
     }
    else if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSDictionary * aps=[userInfo objectForKey:@"aps"];
        NSString * sound=[aps objectForKey:@"sound"];
        NSString * guid=[aps objectForKey:@"guid"];
        NSString *type =sound;
        NSLog(@"type==%@",type);
        
        if ([type isEqualToString:@"sound0"]){
            [self AudioPlay:@"sound0"];
        }
        else if ([type isEqualToString:@"sound1"]){
            [self AudioPlay:@"sound1"];
        }
        else if ([type isEqualToString:@"sound2"]){
            [self AudioPlay:@"sound2"];
        }
        else if ([type isEqualToString:@"sound3"]){
            [self AudioPlay:@"sound3"];
        }
        
        if ([type isEqualToString:@"video"]) {
           
            NSString * roomid= [userInfo objectForKey:@"roomId"];
            NSString * roomName= [userInfo objectForKey:@"roomName"];
            NSString * creator= [userInfo objectForKey:@"creator"];
            NSMutableDictionary * userInfo=[NSMutableDictionary new];
            [userInfo setValue:roomid forKey:@"roomId"];
            [userInfo setValue:roomName forKey:@"roomName"];
            [userInfo setValue:creator forKey:@"roomName"];
            
            if([[CommonUseClass FormatString: roomid] isEqual:@""]||[[CommonUseClass FormatString:roomName] isEqual:@""])
            {}else
            {
            //点击推送消息方法回调
                [self join:userInfo];
               
                return;
            }
        }

    }else{
        //应用处于前台时的本地推送接受
        
        
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}



-(void)join:(NSDictionary *)userInfo
{
    self.meetingCreator=userInfo[@"creator"];
    self.meetingRoomNumber=userInfo[@"roomId"];
    self.meetingUsers=userInfo[@"userList"];
    
                    RoomListViewController *vc = [[RoomListViewController alloc] init];
                    vc.dict = userInfo;
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

-(void)AudioPlay:(NSString *)playname
{
    // 2.播放本地音频文件
    // (1)从boudle路径下读取音频文件 陈小春 - 独家记忆文件名，mp3文件格式
    NSString *path = [[NSBundle mainBundle] pathForResource:playname ofType:@"wav"];
    // (2)把音频文件转化成url格式
    NSURL *url = [NSURL fileURLWithPath:path];
    // (3)初始化音频类 并且添加播放文件
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    // (4) 设置代理
    _avAudioPlayer.delegate = self;
    // (5) 设置初始音量大小 默认1，取值范围 0~1
    _avAudioPlayer.volume = 1;
    // (6)设置音乐播放次数 负数为一直循环，直到stop，0为一次，1为2次，以此类推
    _avAudioPlayer.numberOfLoops = 0;
    // (7)播放
    [_avAudioPlayer  play];
}

//iOS10新增：处理后台点击通知的代理方法 ts2
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    NSString *body= response.notification.request.content.body;
    if([body rangeOfString:@"请求视频通话"].location !=NSNotFound)
    {
        NSDictionary * aps=[userInfo objectForKey:@"aps"];
        NSString * roomid= [aps objectForKey:@"roomId"];
        NSString * roomName= [aps objectForKey:@"roomName"];
        NSString * creator= [aps objectForKey:@"creator"];
        NSMutableDictionary * userInfo=[NSMutableDictionary new];
        [userInfo setValue:roomid forKey:@"roomId"];
        [userInfo setValue:roomName forKey:@"roomName"];
        [userInfo setValue:creator forKey:@"roomName"];
        
        if([[CommonUseClass FormatString: roomid] isEqual:@""]||[[CommonUseClass FormatString:roomName] isEqual:@""])
        {}else
        {
            //点击推送消息方法回调
            [self join:aps];
            return;
        }
    }
    else
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NSDictionary * aps=[userInfo objectForKey:@"aps"];
        NSString * sound=[aps objectForKey:@"sound"];
        NSString * guid=[CommonUseClass FormatString: [aps objectForKey:@"guid"]];
        NSString *type =sound;
        NSLog(@"type==%@",type);
        
       if ([type isEqualToString:@"notice"]){
                //通知通告
                UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
                TZTGViewController *houseVC = [[TZTGViewController alloc]init];
                [nav pushViewController:houseVC animated:YES];
        }
        else if ([type isEqualToString:@"Photo"]){
            //拍照完成推送
            showPicViewController *ctvc=[[showPicViewController alloc] init];
            NSString * taskId=[CommonUseClass FormatString: [aps objectForKey:@"taskId"]];
            ctvc.TaskId=taskId;
            UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
            [nav pushViewController:ctvc animated:YES];
        }
        else if ([type isEqualToString:@"complaint"]){
            //投诉
            complainAdvice *ctvc=[[complainAdvice alloc] init];
            //ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
            ctvc.str_type=@"zc";
            UINavigationController *nav = (UINavigationController*)self.window.rootViewController;
            [nav pushViewController:ctvc animated:YES];
        }
        else  if ([type isEqualToString:@"sound0"]||[type isEqualToString:@"sound1"]
                  ||[type isEqualToString:@"sound2"]
                  ||[type isEqualToString:@"sound3"]||[type isEqualToString:@"sound00"]){
            
//            if ([type isEqualToString:@"sound0"]){
//                [self AudioPlay:@"sound0"];
//            }
//            else if ([type isEqualToString:@"sound1"]){
//                [self AudioPlay:@"sound1"];
//            }
//            else if ([type isEqualToString:@"sound2"]){
//                [self AudioPlay:@"sound2"];
//            }
//            else if ([type isEqualToString:@"sound3"]){
//                [self AudioPlay:@"sound3"];
//            }
            
            _mainVC=[[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
            UINavigationController *nav_main_tabBar=[[UINavigationController alloc]initWithRootViewController:_mainVC];
            __IOS7_S
            [[UINavigationBar appearance] setBarTintColor:NAV_BACKGROUNDCOLOR];
            __IOS7_SE
            _window.rootViewController=nav_main_tabBar;
            self.push_Guid=guid;
//            warningElevatorModel *warnmodel=[[warningElevatorModel alloc]init];
//            //test
//            warnmodel.ID=@"974661";//guid
//            //添加 字典，将label的值通过key值设置传递
//            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:warnmodel,@"textOne", nil];
//            //创建通知
//            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_warn" object:nil userInfo:dict];
//            //通过通知中心发送通知
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        }
        if ([type isEqualToString:@"video"]) {
            
            NSString * roomid= [userInfo objectForKey:@"roomId"];
            NSString * roomName= [userInfo objectForKey:@"roomName"];
            NSString * creator= [userInfo objectForKey:@"creator"];
            NSMutableDictionary * userInfo=[NSMutableDictionary new];
            [userInfo setValue:roomid forKey:@"roomId"];
            [userInfo setValue:roomName forKey:@"roomName"];
            [userInfo setValue:creator forKey:@"roomName"];
            
            if([[CommonUseClass FormatString: roomid] isEqual:@""]||[[CommonUseClass FormatString:roomName] isEqual:@""])
            {}else
            {
                //点击推送消息方法回调
                 [self join:userInfo];

                return;
            }
        }

        
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

//app进入前台:app启动或者app从后台进入前台都会调用这个方法
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    isHT=0;
    [self endBackgroundUpdateTask];
    
    //2
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_sbts" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}


//app进入后台和锁屏都会调用此方法
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    isHT=1;
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{ [self backgroundHandler]; }];
    if (backgroundAccepted)
    {
        NSLog(@"backgrounding accepted");
    }

    [self backgroundHandler];
    
//    //2.
//    counter=0;
//     [ self comeToBackgroundMode];
}
//-(void)comeToBackgroundMode{
//    //初始化一个后台任务BackgroundTask，这个后台任务的作用就是告诉系统当前app在后台有任务处理，需要时间
//    UIApplication*  app = [UIApplication sharedApplication];
//    self.backgroundUpdateTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        [app endBackgroundTask:self.backgroundUpdateTask];
//        self.backgroundUpdateTask = UIBackgroundTaskInvalid;
//    }];
//    //开启定时器 不断向系统请求后台任务执行的时间
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(applyForMoreTime) userInfo:nil repeats:YES];
//    [self.timer fire];
//}
//
//-(void)applyForMoreTime {
//    NSLog(@"counter:%ld", counter++);
//    //如果系统给的剩余时间小于60秒 就终止当前的后台任务，再重新初始化一个后台任务，重新让系统分配时间，这样一直循环下去，保持APP在后台一直处于active状态。
//    if ([UIApplication sharedApplication].backgroundTimeRemaining < 60) {
//        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
//        self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundUpdateTask];
//            self.backgroundUpdateTask = UIBackgroundTaskInvalid;
//        }];
//    }
//}



- (void)backgroundHandler {
    counter=0;
    NSLog(@"### -->backgroundinghandler");
    UIApplication*    app = [UIApplication sharedApplication];
    self.backgroundUpdateTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask: self.backgroundUpdateTask];
        self.backgroundUpdateTask = UIBackgroundTaskInvalid;
    }];
    
    
    
    // Start the long-running task
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (isHT) {
            NSLog(@"counter:%ld", counter++);
            sleep(1);
            
            if(counter%150==0)
            {
                counter=0;
                [self beingBackgroundUpdateTask];
            }
        }
    });
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"我就是传说中的Background Fetch💦");
}

- (void)beingBackgroundUpdateTask
{
    self.backgroundUpdateTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundUpdateTask];
    self.backgroundUpdateTask = UIBackgroundTaskInvalid;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    [self VerifyMessage];
}





- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    videoMainViewController *video=[[videoMainViewController alloc]init];
    [video videologout];
}
// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{

    completionHandler(UIBackgroundFetchResultNewData);
    // 打印到日志 textView 中
    NSLog(@"********** iOS7.0之后 background **********");
    // 应用在前台，不跳转页面，让用户选择。
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"acitve ");
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        if(![userInfo[@"type"]isEqualToString:@"1"])
            [_mainVC setIsMessage:NO];
    }
    //杀死状态下，直接跳转到跳转页面。
    if (application.applicationState == UIApplicationStateInactive && !isBackGroundActivateApplication)
    {
        //        SkipViewController *skipCtr = [[SkipViewController alloc]init];
        // 根视图是nav 用push 方式跳转
        //        [_tabBarCtr.selectedViewController pushViewController:skipCtr animated:YES];
        if (_mainVC!=nil) {
            [_mainVC pushWebview:@"跳转" info:userInfo];
        }
        NSLog(@"applacation is unactive ===== %@",userInfo);
        /*
         // 根视图是普通的viewctr 用present跳转
         [_tabBarCtr.selectedViewController presentViewController:skipCtr animated:YES completion:nil]; */
    }
    // 应用在后台。当后台设置aps字段里的 content-available 值为 1 并开启远程通知激活应用的选项
    if (application.applicationState == UIApplicationStateBackground) {
        NSLog(@"background is Activated Application ");
        // 此处可以选择激活应用提前下载邮件图片等内容。
        isBackGroundActivateApplication = YES;
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    //    [self.viewController addLogString:[NSString stringWithFormat:@"Received Remote Notification :\n%@",userInfo]];
    
    NSLog(@"%@",userInfo);

}

-(void)loginShow
{
    NSString   *str_CachePath_Login = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"Login"];
   NSMutableArray  *userinfo1=[NSMutableArray arrayWithContentsOfFile:str_CachePath_Login];
    if(userinfo1.count==5)
    {
        _userInfo=[[UserInfoEntity alloc]init];
        [_userInfo setUserInfo:userinfo1[0] forpwd:@"" forUserID:userinfo1[1] forDeptRoleCode:userinfo1[2] forRoleId:userinfo1 [3] forNikename:[userinfo1 lastObject]];
        [self loginSucceed];
    }
    else
    {
    loginAndRegistViewController *view_Login
    =[[loginAndRegistViewController alloc]initWithNibName:[Util GetResolution:@"loginAndRegistViewController"] bundle:nil];
   _window.rootViewController=view_Login;
    }
}

-(void)loginSucceed
{
    dispatch_async(dispatch_get_main_queue(), ^{
    NSString *userid=[NSString stringWithFormat:@"%@" , _userInfo.UserID];
    //推送注册
    [UMessage addAlias:userid type:@"ELEVATOR" response:^(id responseObject, NSError *error) {
        
        NSLog(@"---responseObject---%@", responseObject);
        NSLog(@"---error----%@", error);
    }];
        });
    
    //video_login
    videoMainViewController *videoMain=[[videoMainViewController alloc]init];
     [videoMain videologin:_userInfo.username];
    NSString *WYID =_userInfo.username;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:WYID forKey:@"WYID"];
    
    UINavigationController *nav_main_tabBar;
//     if (_userInfo.RoleId.intValue == 23)
//     {
//    _mainVC_dtjy=[[MainViewController_dtjy alloc]initWithNibName:@"MainViewController_dtjy" bundle:nil];
//
//    nav_main_tabBar=[[UINavigationController alloc]initWithRootViewController:_mainVC_dtjy];
//     }
//    else
//    {
        _mainVC=[[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
        
        nav_main_tabBar=[[UINavigationController alloc]initWithRootViewController:_mainVC];
//    }

    __IOS7_S
    [[UINavigationBar appearance] setBarTintColor:NAV_BACKGROUNDCOLOR];
    __IOS7_SE
    _window.rootViewController=nav_main_tabBar;
}
-(void)VerifyMessage
{
    if (_mainVC!=nil) {
        if (self.str_token.length>0) {
            NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
            NSString *token=self.str_token;
            [dic_args setObject:token forKey:@"access_token"];
            [dic_args setObject:@"code" forKey:@"response_type"];
            [dic_args setObject:@"getMsgFlag" forKey:@"redirect_uri"];
            [dic_args setObject:@"{\"isToken\":true,\"param\":{}}" forKey:@"state"];
            
            [[AFAppDotNetAPIClient sharedClient_token]
             POST:@"apiDataByAccessToken.php"
             parameters:dic_args
             progress:^(NSProgress * _Nonnull uploadProgress) {
                 
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"success:%@",responseObject);
                 NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                 NSDictionary* dic_result=[str_result objectFromJSONString];
                 NSString *status=[dic_result objectForKey:@"status"];
                 if(status!=nil&&[status isEqualToString:@"OK"])
                 {
                     if ([[[dic_result objectForKey:@"result"] objectForKey:@"msgFlag"] isEqualToString:@"1"]) {
                         [_mainVC setIsMessage:NO];
                     }
                     else
                         [_mainVC setIsMessage:YES];
                 }
                 else
                 {
                     [_mainVC setIsMessage:YES];
                 }
                 
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"error:%@",[error userInfo] );
                 [_mainVC setIsMessage:YES];
             }];
            
        }
        else
             [_mainVC setIsMessage:YES];
        // http://192.168.1.111:8101/apiDataByAccessToken.php
    }

}
- (void)GetVersion {
    [XXNet GetURL:@"AppVersion/GetArticle?type=IOS_eecp" header:nil parameters:nil succeed:^(NSDictionary *data) {
        NSLog(@"%@",data);
        if ([data[@"Success"]intValue] == 1) {
            NSDictionary *dicJson = [data[@"Data"] objectFromJSONString];
            NSString *netVersion = [dicJson objectForKey:@"VersionName"];
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
            NSString *messageStr = [NSString stringWithFormat:@"版本:%@已更新完成，请及时更新。",netVersion];
            if ([currentVersion compare:netVersion] == NSOrderedAscending) {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"版本更新" message:messageStr delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去更新", nil];
                [alertView show];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *updateStr = @"https://itunes.apple.com/us/app/dian-ti-yun/id1201258663?l=zh&ls=1&mt=8";
        NSURL *dddURL=[NSURL URLWithString:updateStr];
        [[UIApplication sharedApplication]openURL:dddURL];
    }
}

- (void)createUpSourceTime
{
    __block NSInteger second = 0;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timers = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timers, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 60, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timers, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0) {
                
                AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
                [manager startMonitoring];
                [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                    
                    if (status == -1) {
                        
                        NSLog(@"未识别网络");
                    }
                    else if (status == 0) {
                        
                        NSLog(@"无网络");
                    }else{
                        
                        //[self commitSource];dtjy
                        [self commitSource_weibao];
                        [self commitSource_nfcBand];
                        [self commitSource_weibao_FNC];
                        NSLog(@"+++++++2");
                    }
                }];
                
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timers);
                
            }
        });
    });
    //启动源
    dispatch_resume(timers);
    
}

//3.nfcBand
- (void)commitSource_nfcBand
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"NFCBand"] ;
    for (NSDictionary * warnmodel in array0) {
        [self WBupload_NFCBand:[warnmodel objectForKey:@"value"] forGuid:[warnmodel objectForKey:@"guid"]];
    }
}

-(void )WBupload_NFCBand:(NSString *)parm forGuid:(NSString *)guid
{
    NSString *currUrl2=@"NFC/BindCheckNFC";
    [HTTPSessionManager
     post:currUrl2
     parameters:parm
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         
         NSLog(@"dic_result：%@",dic_result);
         
         if([success integerValue]!=1)
         {
             //[self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         }
         else
         {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSArray *array0 = [defaults objectForKey:@"NFCBand"] ;
             NSMutableArray *array = [array0 mutableCopy];
             for (NSDictionary *dic in array) {
                 if(dic[@"guid"]==guid)
                 {
                     [array removeObject:dic];
                     
                     [defaults removeObjectForKey:@"NFCBand"];
                     [defaults synchronize];
                     NSArray *myArray = [array copy];
                     [defaults setObject:myArray forKey:@"NFCBand"];
                     [defaults synchronize];
                     break;
                 }
             }
             //[self performSelectorOnMainThread:@selector(cc) withObject:data waitUntilDone:NO];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         //[self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         
     }];
}

//4.weibao_FNC
- (void)commitSource_weibao_FNC
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"Nfcweibao"] ;
    for (NSDictionary * warnmodel in array0) {
        [self WBupload_FNC:[warnmodel objectForKey:@"value"] forGuid:[warnmodel objectForKey:@"guid"]];
    }
}

-(void )WBupload_FNC:(NSString *)parm forGuid:(NSString *)guid
{
    NSString *currUrl2=@"Check/SaveNFCCheckDetails";
    [HTTPSessionManager
     post:currUrl2
     parameters:parm
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         //         NSLog(@"success====%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         
         NSLog(@"dic_result：%@",dic_result);
         
         if([success integerValue]!=1)
         {
             //[self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         }
         else
         {
             //[self performSelectorOnMainThread:@selector(cc) withObject:data waitUntilDone:NO];
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSArray *array0 = [defaults objectForKey:@"Nfcweibao"] ;
             NSMutableArray *array = [array0 mutableCopy];
             for (NSDictionary *dic in array) {
                 if(dic[@"guid"]==guid)
                 {
                     [array removeObject:dic];
                     
                     [defaults removeObjectForKey:@"Nfcweibao"];
                     [defaults synchronize];
                     NSArray *myArray = [array copy];
                     [defaults setObject:myArray forKey:@"Nfcweibao"];
                     [defaults synchronize];
                     break;
                 }
             }
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         //[self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         
     }];
}

//2.weibao
- (void)commitSource_weibao
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"Dataweibao"] ;
    for (NSDictionary * warnmodel in array0) {
        [self WBupload:[warnmodel objectForKey:@"value"] forGuid:[warnmodel objectForKey:@"guid"]];
    }
}

-(void )WBupload:(NSString *)parm forGuid:(NSString *)guid
{
    NSString *currUrl2=@"Check/SaveCheckDetails";
    [HTTPSessionManager
     post:currUrl2
     parameters:parm
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         //         NSLog(@"success====%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         
         NSLog(@"dic_result：%@",dic_result);
         
         if([success integerValue]!=1)
         {
             //[self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         }
         else
         {
             //[self performSelectorOnMainThread:@selector(cc) withObject:data waitUntilDone:NO];
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             NSArray *array0 = [defaults objectForKey:@"Dataweibao"] ;
             NSMutableArray *array = [array0 mutableCopy];
             for (NSDictionary *dic in array) {
                 if(dic[@"guid"]==guid)
                 {
                     [array removeObject:dic];
                     
                     [defaults removeObjectForKey:@"Dataweibao"];
                     [defaults synchronize];
                     NSArray *myArray = [array copy];
                     [defaults setObject:myArray forKey:@"Dataweibao"];
                     [defaults synchronize];
                     break;
                 }
             }
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         //[self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         
     }];
}

////1.jianyan
//- (void)commitSource
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *array0 = [defaults objectForKey:@"Datajianyan"] ;
//    for (NSDictionary * warnmodel in array0) {
//        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
//        {
//            if([warnmodel[@"have_this_phone"] isEqual:@"1"])
//            {
//                [self updatephone:warnmodel];
//            }
//            else
//            {
//                [self SubmitData:@"" forData:warnmodel];
//            }
//        }
//        else
//        {
//            NSString *url=[NSString stringWithFormat:@"%@", warnmodel[@"this_video_url"]];
//            if(![url  isEqual:@""])
//            {
//                [self updateVideo:warnmodel];
//            }
//            else
//            {
//                [self SubmitData:@"" forData:warnmodel];
//            }
//        }
//    }
//
//}
//
//
//- (void)updatephone:(NSDictionary *)warnmodel
//{
//    NSData *data =warnmodel[@"this_phone"];
//
//    [XXNet requestAFURL:UploadFileURL_Inspect parameters:nil imageData:data succeed:^(NSDictionary *data) {
//        //        NSLog(@"%@",data);
//        if ([data[@"Success"]intValue]) {
//            NSString *str_imgurl = data[@"Data"];
//            [self SubmitData:str_imgurl forData:warnmodel];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}
//
//- (void)updateVideo:(NSDictionary *)warnmodel
//{
//    NSString *urlstr=[NSString stringWithFormat:@"%@", warnmodel[@"this_video_url"]];
//    NSURL * url=[NSURL URLWithString:urlstr];
//
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:@".mp4" forKey:@"fileName"];
//
//    [XXNet requestAFURL:UploadFileURL_Inspect_ios parameters:dic imageData:data succeed:^(NSDictionary *data) {
//        if ([data[@"Success"]intValue]) {
//            NSString *str_imgurl = data[@"Data"];
//            [self SubmitData:str_imgurl forData:warnmodel];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}
//
//
//
//- (void)SubmitData:(NSString *)imgurl forData:(NSDictionary *)warnmodel{
//
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//
//    if(![imgurl isEqual:@""])
//    {
//        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
//        {
//            [dic setValue:imgurl forKey:@"PhotoUrl"];
//            [dic setValue:@"" forKey:@"VideoPath"];
//        }
//        else
//        {
//            [dic setValue:@"" forKey:@"PhotoUrl"];
//            [dic setValue:imgurl forKey:@"VideoPath"];
//        }
//    }
//
//    [dic setValue:self.userInfo.UserID forKey:@"UserId"];
//    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"InspectId"]] forKey:@"InspectId"];
//    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"TypeID"]] forKey:@"TypeID"];
//    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"TypeName"]] forKey:@"TypeName"];
//    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"ID"]] forKey:@"StepId"];
//    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"StepName"]] forKey:@"StepName"];
//    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPassed"]] forKey:@"IsPassed"];
//    [dic setValue:[CommonUseClass FormatString:  [warnmodel objectForKey:@"Remark"]] forKey:@"Remark"];
//    [dic setValue:  [warnmodel objectForKey:@"MapX"] forKey:@"MapX"];
//    [dic setValue:  [warnmodel objectForKey:@"MapY"] forKey:@"MapY"];
//    [XXNet post:SaveInspectDetail parameters:[dic JSONString]
//        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
//        NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSDictionary* dic_result=[str_result objectFromJSONString];
//        NSString *success=[dic_result objectForKey:@"Success"];
//        if (success.intValue == 1) {
//            //[self performSelectorOnMainThread:@selector(dd1_ok:) withObject:imgurl waitUntilDone:NO];
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            NSArray *array0 = [defaults objectForKey:@"Datajianyan"] ;
//            NSMutableArray *array = [array0 mutableCopy];
//            for (NSDictionary *dic in array) {
//                if(dic[@"InspectId"]==warnmodel[@"InspectId"]
//                   &&dic[@"ID"]==warnmodel[@"ID"])
//                {
//                    [array removeObject:dic];
//
//                    [defaults removeObjectForKey:@"Datajianyan"];
//                    [defaults synchronize];
//                    NSArray *myArray = [array copy];
//                    [defaults setObject:myArray forKey:@"Datajianyan"];
//                    [defaults synchronize];
//                    break;
//                }
//            }
//        }
//        else
//        {
//            //[self performSelectorOnMainThread:@selector(dd1:) withObject:[dic_result objectForKey:@"Message"] waitUntilDone:NO];
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //[self performSelectorOnMainThread:@selector(dd1:) withObject:@"操作失败!" waitUntilDone:NO];
//        NSLog(@"%@",error);
//    }];
//}
@end
