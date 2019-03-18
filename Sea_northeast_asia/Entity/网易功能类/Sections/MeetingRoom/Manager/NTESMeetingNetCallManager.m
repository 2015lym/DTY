//
//  NTESMeetingNetCallManager.m
//  NIMEducationDemo
//
//  Created by fenric on 16/4/24.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMeetingNetCallManager.h"
#import "NTESMeetingRolesManager.h"
#import "NTESBundleSetting.h"
#import <NIMAVChat/NIMNetCallOption.h>
#import "NTESBundleSetting.h"

#define NTESNetcallManager [NIMAVChatSDK sharedSDK].netCallManager

@interface NTESMeetingNetCallManager()<NIMNetCallManagerDelegate>
{
    UInt16 _myVolume;
}

@property (nonatomic, strong) NIMNetCallMeeting *meeting;
@property (nonatomic, weak) id<NTESMeetingNetCallManagerDelegate>delegate;

@end

@implementation NTESMeetingNetCallManager

//即时通讯
- (void)joinMeeting2:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate
{
    if (_meeting) {
        [self leaveMeeting];
    }
    
    [NTESNetcallManager addDelegate:self];
    
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = name;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = [NTESMeetingRolesManager sharedInstance].myRole.isActor;
    
    [self fillNetCallOption:_meeting];
    
    _delegate = delegate;
    
    __weak typeof(self) wself = self;
    
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        
        
        if (error) {
            DDLogError(@"Join meeting %@error: %zd.", meeting.name, error.code);
            _meeting = nil;
            if (wself.delegate) {
                [wself.delegate onJoinMeetingFailed:meeting.name error:error];
            }
        }
        else {
            DDLogInfo(@"Join meeting %@ success, ext:%@", meeting.name, meeting.ext);
            
            _isInMeeting = YES;
            NTESMeetingRole *myRole = [NTESMeetingRolesManager sharedInstance].myRole;
            DDLogInfo(@"Reset mute:%d, camera disable:%d",!myRole.audioOn,!myRole.videoOn);
            
            [NTESNetcallManager setMute:myRole.audioOn];
//            [[NTESMeetingRolesManager sharedInstance] setMyAudio:YES];
            [NTESNetcallManager setCameraDisable:myRole.videoOn];
            [NTESNetcallManager switchCamera:NIMNetCallCameraBack];
            
            if (wself.delegate) {
                [wself.delegate onMeetingConntectStatus:YES];
            }
            NSString *myUid = [NTESMeetingRolesManager sharedInstance].myRole.uid;
            DDLogInfo(@"Joined meeting.");
            [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:myUid
                                                               isJoined:YES];
        }
    }];
    
}

//会议视频
- (void)joinMeeting:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate
{
//    if (_meeting) {
//        [self leaveMeeting];
//    }
    
    [NTESNetcallManager addDelegate:self];
    
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = name;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = [NTESMeetingRolesManager sharedInstance].myRole.isActor;
    
    [self fillNetCallOption:_meeting];

    _delegate = delegate;
    
    __weak typeof(self) wself = self;
    
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
    
        
        if (error) {
            DDLogError(@"Join meeting %@error: %zd.", meeting.name, error.code);
            _meeting = nil;
            if (wself.delegate) {
                [wself.delegate onJoinMeetingFailed:meeting.name error:error];
            }
        }
        else {
            DDLogInfo(@"Join meeting %@ success, ext:%@", meeting.name, meeting.ext);
            
            _isInMeeting = YES;
            NTESMeetingRole *myRole = [NTESMeetingRolesManager sharedInstance].myRole;
            DDLogInfo(@"Reset mute:%d, camera disable:%d",!myRole.audioOn,!myRole.videoOn);
            
            [NTESNetcallManager setMute:myRole.audioOn];
//            [[NTESMeetingRolesManager sharedInstance] setMyAudio:YES];
            [NTESNetcallManager setCameraDisable:myRole.videoOn];
            [NTESNetcallManager switchCamera:NIMNetCallCameraFront];
            
            if (wself.delegate) {
                [wself.delegate onMeetingConntectStatus:YES];
            }
            NSString *myUid = [NTESMeetingRolesManager sharedInstance].myRole.uid;
            DDLogInfo(@"Joined meeting.");
            [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:myUid
                                                            isJoined:YES];
        }
    }];

}

//创建房间
- (void)joinMeeting3:(NSString *)name delegate:(id<NTESMeetingNetCallManagerDelegate>)delegate
{
//    if (_meeting) {
//        [self leaveMeeting];
//    }
    
    [NTESNetcallManager addDelegate:self];
    
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = name;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = [NTESMeetingRolesManager sharedInstance].myRole.isActor;
    
    [self fillNetCallOption:_meeting];
    
    _delegate = delegate;
    
    __weak typeof(self) wself = self;
    
    [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
         
        
        if (error) {
            DDLogError(@"Join meeting %@error: %zd.", meeting.name, error.code);
            _meeting = nil;
            if (wself.delegate) {
                [wself.delegate onJoinMeetingFailed:meeting.name error:error];
            }
        }
        else {
            DDLogInfo(@"Join meeting %@ success, ext:%@", meeting.name, meeting.ext);
            
            _isInMeeting = YES;
            NTESMeetingRole *myRole = [NTESMeetingRolesManager sharedInstance].myRole;
            DDLogInfo(@"Reset mute:%d, camera disable:%d",!myRole.audioOn,!myRole.videoOn);
            
            [NTESNetcallManager setMute:myRole.audioOn];
            [[NTESMeetingRolesManager sharedInstance] setMyVideo:YES];
            [NTESNetcallManager switchCamera:NIMNetCallCameraFront];
            
            if (wself.delegate) {
                [wself.delegate onMeetingConntectStatus:YES];
            }
            NSString *myUid = [NTESMeetingRolesManager sharedInstance].myRole.uid;
            DDLogInfo(@"Joined meeting.");
            [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:myUid
                                                               isJoined:YES];
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
        
        NSString *currwyid= [[NIMSDK sharedSDK].loginManager currentAccount];
        self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        if([currwyid isEqual:self.app.meetingCreator])
        {
            [self roomAddPeople:uid];
        }
        
    }
}

- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"user %@ left meeting", uid);

    if ([meeting.name isEqualToString:_meeting.name]) {
        //主播结束，会议结束
        AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        if([uid isEqual:app.meetingCreator])
        {
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_VideoClose" object:nil userInfo:nil];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        else
        {
        [[NTESMeetingRolesManager sharedInstance] updateMeetingUser:uid isJoined:NO];
        }
        
        
        
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
    //option.videoCrop = NIMNetCallVideoCrop4x3;
//    option.disableVideoCropping = ![[NTESBundleSetting sharedConfig] videochatAutoCropping];
    option.autoRotateRemoteVideo = NO;
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
    
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc]init];
    param.startWithCameraOn = YES;
    param. videoCaptureOrientation=NIMVideoOrientationPortrait;
    param.preferredVideoQuality=NIMNetCallVideoQualityLow;
    option.videoCaptureParam = param;
   
    
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


-(void)roomOver
{
    NSString *currwyid= [[NIMSDK sharedSDK].loginManager currentAccount];
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if(![currwyid isEqual:self.app.meetingCreator])
    {
        return;
    }
    
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/APPAlarmRoomRecordUpdateEndTime?roomID=%@",self.app.meetingRoomNumber];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [XXNet GetURL:currUrl header:nil parameters:nil succeed:^(NSDictionary *data) {
        
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(selectDataOk:) withObject:@"" waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:@"查询失败" waitUntilDone:YES];
        }
        
    } failure:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:MessageResult waitUntilDone:YES];
    }];
}

-(void)selectDataOk:(NSString *)msg
{
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)selectDataErr:(NSString *)msg
{
    [CommonUseClass showAlter:msg];
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)roomAddPeople:(NSString *)wyid
{
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString *userid=@"";
    for (NSDictionary *dic in self.app.meetingUsers) {
        if([dic[@"WYID"]isEqual:wyid] )
        {
            userid=dic[@"userID"];
        }
    }
    
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/APPAlarmRoomRecordUserUpdateState?roomID=%@&userID=%@",self.app.meetingRoomNumber,userid];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [XXNet GetURL:currUrl header:nil parameters:nil succeed:^(NSDictionary *data) {
        
//        if ([data[@"Success"]intValue]) {
//            [self performSelectorOnMainThread:@selector(selectDataOk:) withObject:@"" waitUntilDone:YES];
//        }
//        else
//        {
//            [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:@"查询失败" waitUntilDone:YES];
//        }
        
    } failure:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:MessageResult waitUntilDone:YES];
    }];
}
@end
