//
//  JSTXViewController.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/6/1.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "JSTXViewController.h"
#import "MyControl.h"
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


@interface JSTXViewController ()<AVAudioPlayerDelegate>
{
    UIView *bigView;
    AVAudioPlayer *audioPlayer;
    __block int timeout;
    SystemSoundID sound;
}
@end

@implementation JSTXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"_dict=%@",_dict);
    

    
    //视频视图
    bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bigView.backgroundColor = [UIColor blackColor];
    bigView.hidden = NO;
    UIWindow * window = [UIApplication sharedApplication].windows[0];
    [window addSubview:bigView];
    
    
    UIView *shiPinView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    [bigView addSubview:shiPinView];
    
    UIImage *userImage = [UIImage imageNamed:@"Patrol"];
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 100, 100, 100)];
    userImageView.layer.masksToBounds=YES;
    userImageView.layer.cornerRadius=80/2.0;
    userImageView.image = userImage;
    [bigView addSubview:userImageView];
    
    
    UILabel *label1 = [MyControl createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(userImageView.frame)+10, SCREEN_WIDTH, 30) Font:18 Text:@"视频巡查..."];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    [bigView addSubview:label1];

    
    UIButton *agreeBtn = [MyControl createButtonWithFrame:CGRectMake(60, SCREEN_HEIGHT-150, 80, 80) imageName:nil bgImageName:nil title:nil SEL:@selector(BtnClick:) target:self];
    agreeBtn.tag=101;
    [agreeBtn setImage:[UIImage imageNamed:@"refuse"] forState:UIControlStateNormal];
    [bigView addSubview:agreeBtn];
    
    
    UIButton *stopBtn = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH-120, SCREEN_HEIGHT-150, 80, 80) imageName:nil bgImageName:nil title:nil SEL:@selector(BtnClick:) target:self];
    stopBtn.tag=100;
    [stopBtn setImage:[UIImage imageNamed:@"accept"] forState:UIControlStateNormal];
    [bigView addSubview:stopBtn];
    
    
//    1.获取要播放音频文件的URL
    NSURL *fileURL = [[NSBundle mainBundle]URLForResource:@"video_chat_tip_receiver" withExtension:@".aac"];
    
    //2.创建 AVAudioPlayer 对象
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
                
                //如果你想震动的提示播放音乐的话就在下面填入你的音乐文件
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

- (void)BtnClick:(UIButton *)btn
{
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    
    timeout = 0;
    
    if (btn.tag==100) {
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
 //test_new       option.bypassStreamingVideoMixMode = [[NTESBundleSetting sharedConfig] bypassVideoMixMode];
        option.videoCaptureParam = param;
        
        NIMNetCallMeeting* _meeting = [[NIMNetCallMeeting alloc] init];
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
        
        
        
        [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
            
            NSLog(@"%@",error);
            
            if (!error) {
                bigView.hidden = YES;
                [[NTESMeetingManager sharedInstance] cacheMyInfo:userinfo roomId:request.roomId];
                [[NTESMeetingRolesManager sharedInstance] startNewMeeting:userinfo withChatroom:chatroom newCreated:NO];
                UINavigationController *nav = self.navigationController;
                NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithChatroom:chatroom];
                vc.charRoomName = [_dict objectForKey:@"roomName"];
                vc.JSTXType = @"2";
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
    if (btn.tag==101) {
        
        [self dismissViewControllerAnimated:NO completion:^{
            bigView.hidden = YES;
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
