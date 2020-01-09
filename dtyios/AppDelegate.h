//
//  AppDelegate.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/24.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "MainViewController_dtjy.h"
#import "UserInfoEntity.h"
#import "BPush.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "JSONKit.h"
#import "warningElevatorModel.h"
//#import <TencentOpenAPI/QQApiInterface.h>
//#import "TencentOpenAPI/TencentApiInterface.h"
#import <AVFoundation/AVFoundation.h>
#import "HTTPSessionManager.h"


@class MainViewController;
@class MainViewController_dtjy;

@protocol WXDelegate <NSObject>
-(void)loginSuccessByCode:(NSString *)code;
-(void)shareSuccessByCode:(int) code;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>
{
    long counter;
    int isHT;
}
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;
@property (assign, nonatomic) NSTimer *timer;


@property (strong, nonatomic) UIWindow *window;


@property (nonatomic ,strong) NSString *str_UserPath;

@property (nonatomic ,strong) UserInfoEntity *userInfo;
@property (nonatomic ,strong) NSString *str_RegUserName;//注册用户名
@property (nonatomic ,strong) NSString *str_RegUserPW;//注册密码
@property (nonatomic ,strong) NSString *str_token;//token
@property (nonatomic ,strong) NSString *myChannel_id;
@property (strong, nonatomic) MainViewController *mainVC;
@property (strong, nonatomic) MainViewController_dtjy *mainVC_dtjy;

@property (nonatomic, weak) id<WXDelegate> wxDelegate;
-(void)loginSucceed;
-(void)loginShow;

@property (nonatomic ,strong) NSMutableArray *SelectCity;
@property (nonatomic , strong) AVAudioPlayer *avAudioPlayer;

@property (nonatomic ,strong) NSString *UM_deviceToken;//友盟——设备唯一编码：上传心跳时用
@property (nonatomic ,strong) NSString *push_Guid;//推送——报警任务ID
//@property (nonatomic ,strong) NSURL *this_video_url;//设备检查，本地视频地址
@property (nonatomic ,strong) NSMutableArray *arrData;//电梯检验的数据源

@property (nonatomic ,strong) NSMutableArray *array_selectList;//选择列表
@property (nonatomic ,strong) NSMutableArray *array_selectNameList;//选择名字列表

@property (nonatomic ,strong) NSString *videoLoginState;//网易云信登陆状态
@property (nonatomic ,strong) NSMutableArray *meetingUsers;//视频会议的人员
@property (nonatomic ,strong) NSString *meetingCreator;//creator
@property (nonatomic ,strong) NSString *meetingRoomNumber;//RoomNumber
@property (nonatomic ,strong) NSString *meetingLastMemo;//LastMemo
@property (nonatomic ,strong) NSMutableArray *meetPeopleSelf;//add视频会议的人员

@property (nonatomic ) int nfcCount;
@property (nonatomic ) int showCount;

@property (nonatomic ) float Longitude_curr;
@property (nonatomic ) float Latitude_curr;


@end

