//
//  RoomListViewController.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/27.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "RoomListViewController.h"
#import "Util.h"
#import "CommonUseClass.h"
#import "EventCurriculumEntity.h"
#import "HTTPSessionManager.h"
#import "RoomClass.h"
#import <NIMAVChat/NIMAVChat.h>
#import <NIMAVChat/NIMNetCallManagerProtocol.h>
#import "UIView+Toast.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESLoginViewController.h"
#import "NTESDemoConfig.h"
#import "NTESCustomAttachmentDecoder.h"
#import "NTESLoginManager.h"
#import "NTESEnterRoomViewController.h"
#import "NTESDataManager.h"
#import "NTESPageContext.h"
#import "NTESLogManager.h"
#import "NTESMeetingRoomCreateViewController.h"
#import "NTESMeetingRoomSearchViewController.h"
#import "NTESCommonTableDelegate.h"
#import "NTESCommonTableData.h"

#import "UIView+Toast.h"
#import "NTESMeetingViewController.h"
#import "NTESMeetingManager.h"
#import "NTESMeetingRolesManager.h"
#import "AddPeopleViewController.h"
#import "NTESMeetingRolesManager.h"
#import "NTESBundleSetting.h"
#import <NIMAVChat/NIMNetCallOption.h>
#import "NTESBundleSetting.h"
#import "MyControl.h"

#define NTESNetcallManager [NIMAVChatSDK sharedSDK].netCallManager

@interface RoomListViewController ()<NIMNetCallManagerDelegate,AVAudioPlayerDelegate>
{
    UInt16 _myVolume;
    UIView *bigView;
    AVAudioPlayer *audioPlayer;
    __block int timeout;
}

@property (nonatomic, strong) NIMNetCallMeeting *meeting;
@property (nonatomic, weak) id<NTESMeetingNetCallManagerDelegate>delegate;
@end

@implementation RoomListViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"房间列表";
    self.view.backgroundColor = [UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    CourseTableview=[[UITableViewExForDeleteViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"RoomTableViewCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    
    [self getSchoolCourse];
    
    
    //视频视图
    bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bigView.backgroundColor = [UIColor blackColor];
    bigView.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:bigView];
    
    
    
    UIView *shiPinView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    [bigView addSubview:shiPinView];
    
    UIImage *userImage0 = [UIImage imageNamed:@"onCall_back"];
    UIImageView *userImageView0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    userImageView0.image = userImage0;
    [bigView addSubview:userImageView0];
    
    UIImage *userImage = [UIImage imageNamed:@"onCall_content"];
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-120, 120, 240, 190)];
    //userImageView.layer.masksToBounds=YES;
    userImageView.layer.cornerRadius=80/2.0;
    userImageView.image = userImage;
    [bigView addSubview:userImageView];
    
    
    UILabel *label1 = [MyControl createLabelWithFrame:CGRectMake(0, SCREEN_HEIGHT-160, SCREEN_WIDTH, 30) Font:18 Text:@"请求视频通话"];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    [bigView addSubview:label1];
    
    
    //接受
    UIButton *agreeBtn = [MyControl createButtonWithFrame:CGRectMake(80, SCREEN_HEIGHT-110, 60, 60) imageName:@"accept" bgImageName:nil title:@"" SEL:@selector(BtnClick:) target:self];
    agreeBtn.tag=100;
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[agreeBtn setBackgroundColor:[UIColor greenColor]];
    agreeBtn.layer.masksToBounds=YES;
    agreeBtn.layer.cornerRadius=60/2.0;
    [bigView addSubview:agreeBtn];
    
    
    //拒绝
    UIButton *stopBtn = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH-120, SCREEN_HEIGHT-110, 60, 60) imageName:@"refuse.png" bgImageName:nil title:@"" SEL:@selector(BtnClick:) target:self];
    stopBtn.tag=101;
    [stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[stopBtn setBackgroundColor:[UIColor redColor]];
    stopBtn.layer.masksToBounds=YES;
    stopBtn.layer.cornerRadius=60/2.0;
    [bigView addSubview:stopBtn];
    
    
    // 1.获取要播放音频文件的URL
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"video_chat_tip_receiver" withExtension:@".aac"];
    // 2.创建 AVAudioPlayer 对象
    audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
    
    timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                NSLog(@"111");
                AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
                [audioPlayer stop];
            });
        }else{

            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                NSLog(@"222");
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                // 3.设置循环播放
                audioPlayer.numberOfLoops = -1;
                audioPlayer.delegate = self;
                // 4.开始播放
                [audioPlayer play];
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);

}

-(void)join{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *WYID = [defaults objectForKey:@"WYID"];
    
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc]init];
    param.startWithCameraOn = YES;
    
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    option.autoRotateRemoteVideo = [[NTESBundleSetting sharedConfig] videochatAutoRotateRemoteVideo];
    option.serverRecordAudio     = [[NTESBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo     = [[NTESBundleSetting sharedConfig] serverRecordVideo];
    option.preferredVideoEncoder = [[NTESBundleSetting sharedConfig] perferredVideoEncoder];
    option.preferredVideoDecoder = [[NTESBundleSetting sharedConfig] perferredVideoDecoder];
    option.videoMaxEncodeBitrate = [[NTESBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    option.autoDeactivateAudioSession = NO;//[[NTESBundleSetting sharedConfig] autoDeactivateAudioSession];
    option.audioDenoise = [[NTESBundleSetting sharedConfig] audioDenoise];
    option.voiceDetect = [[NTESBundleSetting sharedConfig] voiceDetect];
    option.preferHDAudio = [[NTESBundleSetting sharedConfig] preferHDAudio];
    option.bypassStreamingMixMode = [[NTESBundleSetting sharedConfig] bypassVideoMixMode];
    option.videoCaptureParam = param;
    
    
    NSLog(@"%@",_dict );
    
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = [_dict objectForKey:@"roomId"];
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = YES;
    _meeting.ext = @"test extend meeting messge";
    _meeting.option=option;
    
    NIMChatroomMember *userinfo = [[NIMChatroomMember alloc]init];
    userinfo.userId = WYID;
    
    NIMChatroom *chatroom = [[NIMChatroom alloc]init];
    chatroom.name = [_dict objectForKey:@"roomName"];
    chatroom.roomId = [_dict objectForKey:@"roomId"];
    
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = chatroom.roomId;
    [[NSUserDefaults standardUserDefaults] setObject:request.roomId forKey:@"cachedRoom"];
    
    NSLog(@"%@",_meeting);
    
    //        [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
    //            [MBProgressHUD hideHUDForView:bigView animated:YES];
    //            NSLog(@"%@",error);
    
    //            if (!error) {
    bigView.hidden = YES;
    [[NTESMeetingManager sharedInstance] cacheMyInfo:userinfo roomId:request.roomId];
    [[NTESMeetingRolesManager sharedInstance] startNewMeeting:userinfo withChatroom:chatroom newCreated:NO];
    UINavigationController *nav = self.navigationController;
    NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithChatroom:chatroom];
    vc.charRoomName = [_dict objectForKey:@"roomName"];
    [nav pushViewController:vc animated:NO];
    NSMutableArray *vcs = [nav.viewControllers mutableCopy];
    [vcs removeObject:self];
    nav.viewControllers = vcs;
    
    //            }else{
    //                [CommonUseClass showAlter:@"加入房间失败"];
    //                [self dismissViewControllerAnimated:NO completion:^{
    //                    bigView.hidden = YES;
    //                }];
    //            }
    //
    //        }];
}
- (void)BtnClick:(UIButton *)btn
{
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    timeout = 0;
    
    if (btn.tag==100) {
        
        [MBProgressHUD showHUDAddedTo:bigView animated:YES];
        
        if([app.videoLoginState isEqual: @"1"])
        {
            [self join];
        }
        else{
            [self.view.window makeToast:@"您的帐号被其它端登陆，请重新登录！" duration:3.0 position:CSToastPositionCenter];
            [self dismissViewControllerAnimated:NO completion:^{
                bigView.hidden = YES;
            }];
        }
        
        
       
        
    }
    if (btn.tag==101) {
        self.app.meetingRoomNumber=@"";
        [self dismissViewControllerAnimated:NO completion:^{
            bigView.hidden = YES;
        }];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!CourseTableview.editing)
        return;
    /*
     Goods *good = [_goodsAry objectAtIndex:indexPath.row];
     if (![_selectArray containsObject:good]) {
     [_selectArray addObject:good];
     }
     */
}
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
    [self getSchoolCourse];
}

-(void)TableRowClick:(UITableItem*)value
{

    __weak typeof(self) wself = self;
    
    NSDictionary *dict = (NSDictionary *)value;
    
    NSString *RoomName = [dict objectForKey:@"RoomName"];
    NSString *roomID = [dict objectForKey:@"RoomID"];
    NSString *WYID = [dict objectForKey:@"WYUserID"];
    

    
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc]init];
    param.startWithCameraOn = YES;
    
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    option.autoRotateRemoteVideo = [[NTESBundleSetting sharedConfig] videochatAutoRotateRemoteVideo];
    option.serverRecordAudio     = [[NTESBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo     = [[NTESBundleSetting sharedConfig] serverRecordVideo];
    option.preferredVideoEncoder = [[NTESBundleSetting sharedConfig] perferredVideoEncoder];
    option.preferredVideoDecoder = [[NTESBundleSetting sharedConfig] perferredVideoDecoder];
    option.videoMaxEncodeBitrate = [[NTESBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    option.autoDeactivateAudioSession = [[NTESBundleSetting sharedConfig] autoDeactivateAudioSession];
    option.audioDenoise = [[NTESBundleSetting sharedConfig] audioDenoise];
    option.voiceDetect = [[NTESBundleSetting sharedConfig] voiceDetect];
    option.preferHDAudio = [[NTESBundleSetting sharedConfig] preferHDAudio];
    option.bypassStreamingMixMode = [[NTESBundleSetting sharedConfig] bypassVideoMixMode];
    option.videoCaptureParam = param;
    
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = roomID;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = YES;
    _meeting.ext = @"test extend meeting messge";
    _meeting.option=option;
    
    NIMChatroomMember *userinfo = [[NIMChatroomMember alloc]init];
    userinfo.userId = WYID;
    
    NIMChatroom *chatroom = [[NIMChatroom alloc]init];
    chatroom.name = RoomName;
    chatroom.roomId = roomID;
    
    
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = chatroom.roomId;
    [[NSUserDefaults standardUserDefaults] setObject:request.roomId forKey:@"cachedRoom"];
    
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
        
        NSLog(@"%@",error);
        
        if (!error) {
            bigView.hidden = YES;
            [[NTESMeetingManager sharedInstance] cacheMyInfo:userinfo roomId:request.roomId];
            [[NTESMeetingRolesManager sharedInstance] startNewMeeting:userinfo withChatroom:chatroom newCreated:NO];
            UINavigationController *nav = self.navigationController;
            NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithChatroom:chatroom];
            vc.charRoomName = [_dict objectForKey:@"roomName"];
            [nav pushViewController:vc animated:NO];
            NSMutableArray *vcs = [nav.viewControllers mutableCopy];
            [vcs removeObject:self];
            nav.viewControllers = vcs;
            
        }else{
            
            [self dismissViewControllerAnimated:NO completion:^{
                bigView.hidden = YES;
                [CommonUseClass showAlter:@"加入房间失败"];
            }];
        }
            
        }];
    
}

- (void)leaveMeeting
{
    if (_meeting) {
        [NTESNetcallManager leaveMeeting:_meeting];
        _meeting = nil;
    }
    [NTESNetcallManager removeDelegate:self];
    _isInMeeting = NO;
}

- (BOOL)setBypassLiveStreaming:(BOOL)enabled
{
//    return [NTESNetcallManager setBypassStreamingEnabled:enabled];
        return YES;
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"user %@ joined meeting", uid);
    
    
    if ([meeting.name isEqualToString:_meeting.name]) {
        [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:uid isJoined:YES];
    }
}

- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"user %@ left meeting", uid);
    
    if ([meeting.name isEqualToString:_meeting.name]) {
        [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:uid isJoined:NO];
    }
}

- (void)onMeetingError:(NSError *)error
               meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"meeting error %zd", error.code);
    _isInMeeting = NO;
    [_delegate onMeetingConntectStatus:NO];
}



- (void)onMyVolumeUpdate:(UInt16)volume
{
    _myVolume = volume;
}

- (void)onSpeakingUsersReport:(nullable NSArray<NIMNetCallUserInfo *> *)report
{
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    NSMutableDictionary *volumes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[self volumeLevel:_myVolume], myUid, nil];
    
    for (NIMNetCallUserInfo *info in report) {
        [volumes setObject:[self volumeLevel:info.volume] forKey:info.uid];
    }
    
    [[NTESMeetingRolesManager sharedInstance] updateVolumes:volumes];
}

- (void)onSetBypassStreamingEnabled:(BOOL)enabled result:(NSError *)result
{
    if (result) {
        if (self.delegate) {
            [self.delegate onSetBypassStreamingEnabled:enabled error:result.code];
        }
    }
}

- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user
{
    DDLogInfo(@"Net status of %@ is %zd", user, status);
}

#pragma mark - private
- (void)fillNetCallOption:(NIMNetCallMeeting *)meeting
{
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    
    //    option.disableVideoCropping = ![[NTESBundleSetting sharedConfig] videochatAutoCropping];
    option.autoRotateRemoteVideo = [[NTESBundleSetting sharedConfig] videochatAutoRotateRemoteVideo];
    option.serverRecordAudio     = [[NTESBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo     = [[NTESBundleSetting sharedConfig] serverRecordVideo];
    option.preferredVideoEncoder = [[NTESBundleSetting sharedConfig] perferredVideoEncoder];
    option.preferredVideoDecoder = [[NTESBundleSetting sharedConfig] perferredVideoDecoder];
    option.videoMaxEncodeBitrate = [[NTESBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    //    option.startWithBackCamera   = [[NTESBundleSetting sharedConfig] startWithBackCamera];
    option.autoDeactivateAudioSession = [[NTESBundleSetting sharedConfig] autoDeactivateAudioSession];
    option.audioDenoise = [[NTESBundleSetting sharedConfig] audioDenoise];
    option.voiceDetect = [[NTESBundleSetting sharedConfig] voiceDetect];
    option.preferHDAudio = [[NTESBundleSetting sharedConfig] preferHDAudio];
    //    option.preferredVideoQuality = [[NTESBundleSetting sharedConfig] preferredVideoQuality];
    option.bypassStreamingMixMode = [[NTESBundleSetting sharedConfig] bypassVideoMixMode];
    
    BOOL isManager = [NTESMeetingRolesManager sharedInstance].myRole.isManager;
    
    //会议的观众这里默认用低清发送视频
    //    if (option.preferredVideoQuality == NIMNetCallVideoQualityDefault) {
    //        if (!isManager) {
    //            option.preferredVideoQuality = NIMNetCallVideoQualityLow;
    //        }
    //    }
    
    option.bypassStreamingUrl = isManager ? [[NTESMeetingRolesManager sharedInstance] livePushUrl] : nil;
    option.enableBypassStreaming = isManager;
    
    _meeting.option = option;
}


-(NSNumber *)volumeLevel:(UInt16)volume
{
    int32_t volumeLevel = 0;
    volume /= 40;
    while (volume > 0) {
        volumeLevel ++;
        volume /= 2;
    }
    if (volumeLevel > 8) volumeLevel = 8;
    
    return @(volumeLevel);
}


-(void)TableHeaderRowClick:(UITableItem*)value
{
    
}
-(void)pullUpdateData
{
    CourseTableview.PageIndex=1;
    [self getSchoolCourse];
}
- (void)doneLoadingTableViewData
{
    [CourseTableview.tableView reloadData];
    [CourseTableview doneLoadingTableViewData];
    CourseTableview.max_Cell_Star=YES;
}

-(void)getSchoolCourse
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    NSString *currUrl;
    currUrl=[NSString stringWithFormat:@"PageService/Base_MultiplayerVideo/%@/%@/GetPagesMultiplayerVideo",@"",app.userInfo.UserID];
    
    RoomClass *_search=[[RoomClass alloc]init];
//    _search.Guid = app.userInfo.userGuid;
    
    NSString *strstr=[CommonUseClass classToJson:_search];
    
    [HTTPSessionManager
     post:currUrl
     parameters:strstr
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Status"];
         
         if([success longLongValue]!=0)
         {
             [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:nil waitUntilDone:NO];
             return ;
         }
         else
         {
             
             if (CourseTableview.PageIndex==1) {
                 [CourseTableview.dataSource removeAllObjects];
             }
             else
             {
                 [CourseTableview.dataSource removeLastObject];
             }
             
             NSMutableArray *array=[NSMutableArray arrayWithArray:[dic_result objectForKey:@"Results"]];
             EventCurriculumEntity *entity=[[EventCurriculumEntity alloc] init];
             entity.enroll_list=array;
             
             [self init_tableview_hear:entity];
             
             [self performSelectorOnMainThread:@selector(cc:) withObject:data waitUntilDone:NO];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:nil waitUntilDone:NO];
     }];
    
}

-(void)selectDataErr:(NSDictionary *)dict
{
    [CommonUseClass showAlter:MessageResult];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)cc:(id)data
{
    [self doneLoadingTableViewData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)NoDataShowImage
{
    UIView *view=[[UIView alloc ]initWithFrame:CGRectMake(0, 60, 320, 130)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((bounds_width.size.width-80)/2, 100, 80, 30)];
    label.text=@"暂无数据";
    label.textAlignment=NSTextAlignmentCenter;
    [label setTextColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]];
    [view addSubview:label];
    
    [CourseTableview.view addSubview:view];
    view.tag=3000;
}


//加载
-(void)init_tableview_hear:(EventCurriculumEntity *)entity
{
    
    if (entity.enroll_list.count) {
        
        for (NSMutableDictionary *dic_item in entity.enroll_list ) {
            
            [CourseTableview.dataSource addObject:dic_item];
        }
        
        if (entity.enroll_list.count>19) {
            [CourseTableview.dataSource addObject:@"加载中……"];
        }
        else
        {
            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
        
    }
}






@end
