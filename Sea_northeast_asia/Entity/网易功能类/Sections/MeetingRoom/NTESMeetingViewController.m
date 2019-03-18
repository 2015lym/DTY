//
//  NTESMeetingViewController.m
//  NIM
//
//  Created by fenric on 16/4/7.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "NTESMeetingViewController.h"
#import "NTESChatroomSegmentedControl.h"
#import "UIView+NTES.h"
#import "NTESPageView.h"
#import "NTESChatroomViewController.h"
#import "NTESChatroomMemberListViewController.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+NTES.h"
#import "SVProgressHUD.h"
#import "UIImage+NTESColor.h"
#import "NTESMeetingActionView.h"
#import "UIView+Toast.h"
#import "NTESMeetingManager.h"
#import "NTESMeetingActorsView.h"
#import "NSDictionary+NTESJson.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESMeetingRolesManager.h"
#import "NTESDemoService.h"
#import "NTESMeetingNetCallManager.h"
#import "NTESActorSelectView.h"
#import "NIMGlobalMacro.h"
#import "NTESMeetingRolesManager.h"
#import "NTESMeetingWhiteboardViewController.h"
#import <NIMAVChat/NIMAVChat.h>
#import "MyControl.h"
#import "NTESMeetingView.h"
#import "CommonUseClass.h"
#import "MBProgressHUD.h"
#define NTESNetcallManager [NIMAVChatSDK sharedSDK].netCallManager

@interface NTESMeetingViewController ()<NTESMeetingActionViewDataSource,NTESMeetingActionViewDelegate,NIMInputDelegate,NIMChatroomManagerDelegate,NTESMeetingNetCallManagerDelegate,NTESActorSelectViewDelegate,NTESMeetingRolesManagerDelegate,NIMLoginManagerDelegate,NIMNetCallManagerDelegate,NIMSystemNotificationManagerDelegate>
{
    NTESMeetingRole *myRoleStu;
    UIImageView *backImageView;
    NIMNetCallMeeting*_meeting;
    UIView *backView;
    UILabel *label1;
    
    UIButton *audioButton2;
    UIButton *videoButton2;
    UIButton *qieHuanButton2;
    UIButton *cancelButton2;
    
    UIButton *topButton;
    UIButton *downButton;
    UIImageView *imageBgView;
    UIImageView *imageSmallView ;
}

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong) NTESChatroomViewController *chatroomViewController;

@property (nonatomic, strong) NTESMeetingActionView *actionView;

@property (nonatomic, strong) NTESMeetingActorsView *actorsView;

//@property (nonatomic, strong) NTESMeetingActionView *actionView2;
//
//@property (nonatomic, strong) NTESMeetingActorsView *actorsView2;

//@property (nonatomic, strong) NTESMeetingActorsView2 *actorsView2;

@property (nonatomic, strong) NTESMeetingView *meetingView;


@property (nonatomic, assign) BOOL keyboradIsShown;

@property (nonatomic, weak)   UIViewController *currentChildViewController;

@property (nonatomic, strong) UIAlertView *actorEnabledAlert;

@property (nonatomic, strong) NTESActorSelectView *actorSelectView;

@property (nonatomic, strong) NTESChatroomMemberListViewController *memberListVC;

@property (nonatomic, strong) NTESMeetingWhiteboardViewController *whiteboardVC;

@property (nonatomic, assign) BOOL isPoped;

@property (nonatomic, assign) BOOL isRemainStdNav;

@property (nonatomic, assign) BOOL readyForFullScreen;

@property (nonatomic, assign) BOOL BigOrSmall;

@end

@implementation NTESMeetingViewController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroom = chatroom;
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NTESMeetingNetCallManager sharedInstance] leaveMeeting];
    self.app.meetingRoomNumber=@"";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *WYID = [defaults objectForKey:@"WYID"];
    if(_isCall==1)
    {}
    else
    {
    [[NTESMeetingRolesManager sharedInstance] changeMemberActorRole:WYID];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
    self.chatroomViewController.delegate = self;
    [self.currentChildViewController beginAppearanceTransition:YES animated:animated];
    
    self.actorsView.isFullScreen = NO;
    
    if ([_JSTXType isEqualToString:@"1"]) {
        
        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBarHidden = YES;
    }
    
}

- (void)tongzhi_VideoClose:(NSNotification *)text{
    NSString *toast = [NSString stringWithFormat:@"视频会议已关闭!"];
    [self.navigationController.visibleViewController.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
    self.app.meetingRoomNumber=@"";
    UIButton *btn=[[UIButton alloc]init];
    [self onRaiseHandPressed:btn];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChildViewController];
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    
    _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = _chatroom.roomId;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_VideoClose:) name:@"tongzhi_VideoClose" object:nil];
    
    if ([_JSTXType isEqualToString:@"1"]) {
        
        [[NTESMeetingNetCallManager sharedInstance] joinMeeting2:_chatroom.roomId delegate:self];
        
        //即时通讯
        _BigOrSmall = YES;
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.hidden=NO;
        backView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
        [self.view addSubview:backView];
        
        
        imageSmallView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, SCREEN_WIDTH/2) imageName:@"headImage"];
        imageSmallView.hidden = YES;
        [self.actionView addSubview:imageSmallView];
        
        self.actorsView.frame = CGRectMake(2*SCREEN_WIDTH/3-20, 40, SCREEN_WIDTH/3, SCREEN_WIDTH/2);
        self.actionView.frame = CGRectMake(2*SCREEN_WIDTH/3-20, 40, SCREEN_WIDTH/3, SCREEN_WIDTH/2);
        
         //视频视图
        [backView addSubview:self.actorsView];
        //大视图 覆盖视频视图
        [backView addSubview:self.actionView];
        
        
        UIImage *backImage = [UIImage imageNamed:@"bg"];
        backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-backImage.size.width/2, SCREEN_WIDTH/4, backImage.size.width, backImage.size.height)];
        backImageView.image = backImage;
        backImageView.hidden=NO;
        [backView addSubview:backImageView];
        
        
        label1 = [MyControl createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(backImageView.frame)+10, SCREEN_WIDTH, 30) Font:20 Text:@"执行任务中..."];
        label1.hidden=NO;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.textColor = [UIColor whiteColor];
        [backView addSubview:label1];
        
        UIImage *imageBg = [UIImage imageNamed:@"downImage"];
        imageBgView = [MyControl createImageViewWithFrame:CGRectMake(0, SCREEN_HEIGHT-140, SCREEN_WIDTH, imageBg.size.height) imageName:@"nil"];
        
        NSLog(@"%lf",imageBgView.frame.size.height);
        
        imageBgView.userInteractionEnabled=YES;
        imageBgView.image = imageBg;
        imageBgView.hidden=YES;
        [backView addSubview:imageBgView];
        
        
        downButton = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 0, 60, 40) imageName:nil bgImageName:nil title:nil SEL:@selector(downButtonClick:) target:self];
        [downButton setBackgroundColor:[UIColor clearColor]];
        [imageBgView addSubview:downButton];
        
        //音频按钮
        audioButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        audioButton2.frame = CGRectMake(20, 50, 60, 60);
        [audioButton2 setImage:[UIImage imageNamed:@"audio_on"] forState:UIControlStateNormal];
        [audioButton2 setImage:[UIImage imageNamed:@"audio_off"] forState:UIControlStateSelected];
        [audioButton2 addTarget:self action:@selector(onAudioPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        //视频按钮
        videoButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        videoButton2.frame = CGRectMake(CGRectGetMaxX(audioButton2.frame)+20, 50, 60, 60);
        [videoButton2 setImage:[UIImage imageNamed:@"video_on"] forState:UIControlStateNormal];
        [videoButton2 setImage:[UIImage imageNamed:@"video_off"] forState:UIControlStateSelected];
        [videoButton2 addTarget:self action:@selector(onVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //切换摄像头
        qieHuanButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        qieHuanButton2.frame = CGRectMake(CGRectGetMaxX(videoButton2.frame)+20,50, 60, 60);
        [qieHuanButton2 setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateNormal];
        [qieHuanButton2 setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateSelected];
        [qieHuanButton2 addTarget:self action:@selector(qieHuanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //结束按钮
        cancelButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton2.frame = CGRectMake(SCREEN_WIDTH-100, 40, 80, 80);
        [cancelButton2 setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        [cancelButton2 addTarget:self action:@selector(onCancelInteraction:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton2.tag = 10001;
        
        
        [imageBgView addSubview:audioButton2];
        [imageBgView addSubview:videoButton2];
        [imageBgView addSubview:qieHuanButton2];
        [imageBgView addSubview:cancelButton2];
        
        
        topButton = [MyControl createButtonWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, SCREEN_WIDTH, 30) imageName:nil bgImageName:nil title:nil SEL:@selector(topButtonClick:) target:self];
        topButton.hidden=NO;
        [topButton setImage:[UIImage imageNamed:@"topImage"] forState:UIControlStateNormal];
        [backView addSubview:topButton];
        
        
    }else if([_JSTXType isEqualToString:@"2"]){
        
        //创建会议
        
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.userInteractionEnabled=YES;
        backView.hidden=NO;
        backView.backgroundColor =[CommonUseClass getSysColor];// [UIColor colorWithHexString:@"#000000" alpha:1.0];
        [self.view addSubview:backView];
        
        
        //视频视图
        [backView addSubview:self.meetingView];
        //大视图 覆盖视频视图
        [backView addSubview:self.actionView];
        
        imageSmallView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/2) imageName:@"meeting_background2"];
        imageSmallView.hidden = YES;
        [self.meetingView addSubview:imageSmallView];
        

//
        
        //结束按钮
        cancelButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton2.frame = CGRectMake((SCREEN_WIDTH-80)/2, SCREEN_HEIGHT-120, 80, 80);
        [cancelButton2 setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        [cancelButton2 addTarget:self action:@selector(onCancelInteraction:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton2.tag = 10001;
        [backView addSubview:cancelButton2];
        
        UILabel *lab=[MyControl createLabelWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, SCREEN_HEIGHT-30, 60, 20) Font:15 Text:@"挂断"];
        lab.textColor=[UIColor whiteColor];
        lab.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:lab];
        
        //2
        [self.actionView reloadData];
        
        //勿动
        //     self.currentChildViewController = self.whiteboardVC;
        [self revertInputView];
        //    [self setupBarButtonItem];
        [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
        [[NTESMeetingRolesManager sharedInstance] setDelegate:self];
        
        //3
        [[NTESMeetingNetCallManager sharedInstance] joinMeeting3:_chatroom.roomId delegate:self];
        
    }else{
    
        //会议视频
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.userInteractionEnabled=YES;
        backView.hidden=NO;
        //backView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:1.0];
        backView.backgroundColor =[CommonUseClass getSysColor];
        [self.view addSubview:backView];
        
        
        //视频视图
        [backView addSubview:self.meetingView];
        //大视图 覆盖视频视图
        [backView addSubview:self.actionView];
        
        imageSmallView = [MyControl createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/2) imageName:@"meeting_background2"];
        imageSmallView.hidden = YES;
        [self.meetingView addSubview:imageSmallView];
        
        

        
        //结束按钮
        cancelButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton2.frame = CGRectMake((SCREEN_WIDTH-80)/2, SCREEN_HEIGHT-120, 80, 80);
        [cancelButton2 setBackgroundImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
        [cancelButton2 addTarget:self action:@selector(onCancelInteraction:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton2.tag = 10001;
        
        UILabel *lab=[MyControl createLabelWithFrame:CGRectMake((SCREEN_WIDTH-60)/2, SCREEN_HEIGHT-30, 60, 20) Font:15 Text:@"挂断"];
        lab.textColor=[UIColor whiteColor];
        lab.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:lab];
        
        
        [backView addSubview:audioButton2];
        [backView addSubview:videoButton2];
        [backView addSubview:qieHuanButton2];
        [backView addSubview:cancelButton2];
        
        //2
        [self.actionView reloadData];
        
        //勿动
        //     self.currentChildViewController = self.whiteboardVC;
        [self revertInputView];
        //    [self setupBarButtonItem];
        [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
        [[NIMSDK sharedSDK].loginManager addDelegate:self];
        [[NTESMeetingRolesManager sharedInstance] setDelegate:self];
        
        //3
        [[NTESMeetingNetCallManager sharedInstance] joinMeeting:_chatroom.roomId delegate:self];
        
        
    }
    
    UILabel * labTimememo=[MyControl createLabelWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT-170, 100, 20) Font:15 Text:@"通话时长"];
    labTimememo.textColor=[UIColor whiteColor];
    labTimememo.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:labTimememo];
    
    labTime=[MyControl createLabelWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT-150, 100, 20) Font:15 Text:@""];
    labTime.textColor=[UIColor whiteColor];
    labTime.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:labTime];
    
    nTimeCount=0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

-(void)handleTimer:(id)userinfo{
    nTimeCount++;
    NSString * str=[CommonUseClass getMMSSFromSS:[NSString stringWithFormat:@"%d",nTimeCount]];
    str=[NSString stringWithFormat:@"%@",str];
    labTime.text=str;
}
- (void)topButtonClick:(UIButton *)btn
{
    topButton.hidden=YES;
    imageBgView.hidden=NO;
}
- (void)downButtonClick:(UIButton *)btn
{
    imageBgView.hidden=YES;
    topButton.hidden=NO;
}

- (void)onAudioPressed:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        [[NTESMeetingRolesManager sharedInstance] setMyAudio:NO];
        
    }else{
        
        [[NTESMeetingRolesManager sharedInstance] setMyAudio:YES];
    }
    
}
- (void)onVideoPressed:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        imageSmallView.hidden=NO;

        [[NTESMeetingRolesManager sharedInstance] setMyVideo:NO];
    }else{
        imageSmallView.hidden=YES;
        
        [[NTESMeetingRolesManager sharedInstance] setMyVideo:YES];
    }

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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:NO];
    self.chatroomViewController.delegate = nil; //避免view不再顶层仍受到键盘回调，导致改变状态栏样式。
    [self.currentChildViewController beginAppearanceTransition:NO animated:animated];
    [self revertInputView];
    
    if ([_JSTXType isEqualToString:@"1"]) {
        
        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
    self.navigationController.navigationBar.alpha = 1;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.currentChildViewController endAppearanceTransition];
}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}

- (void)setupChildViewController
{
    NSArray *vcs = [self makeChildViewControllers];
    for (UIViewController *vc in vcs) {
        [self addChildViewController:vc];
    }
}

#pragma mark - NTESMeetingActionViewDataSource

- (NSInteger)numberOfPages
{
    return self.childViewControllers.count;
}

- (UIView *)viewInPage:(NSInteger)index
{
    UIView *view = self.childViewControllers[index].view;
    return view;
}

- (CGFloat)actorsViewHeight
{
    return self.actorsView.height;
}

#pragma mark - NTESMeetingActionViewDelegate

- (void)onSegmentControlChanged:(NTESChatroomSegmentedControl *)control
{
    UIViewController *lastChild = self.currentChildViewController;
    UIViewController *child = self.childViewControllers[self.actionView.segmentedControl.selectedSegmentIndex];
    
    if ([child isKindOfClass:[NTESChatroomMemberListViewController class]]) {
        
        self.actionView.unreadRedTip.hidden = YES;
        
    }
    
    [lastChild beginAppearanceTransition:NO animated:YES];
    [child beginAppearanceTransition:YES animated:YES];
    [self.actionView.pageView scrollToPage:self.actionView.segmentedControl.selectedSegmentIndex];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.currentChildViewController = child;
        [lastChild endAppearanceTransition];
        [child endAppearanceTransition];
        [self revertInputView];
        
    });
}

//当点击视频视图时
- (void)onTouchActionBackground:(UITapGestureRecognizer *)gesture
{
    /*
    CGPoint point  = [gesture locationInView:self.actorsView];
    UIView *view = [self.actorsView hitTest:point withEvent:nil];
    
    
    if (view) {
        
        if ([_JSTXType isEqualToString:@"1"]) {
            
            self.navigationController.navigationBarHidden = YES;
            
            if (_BigOrSmall==YES) {
                NSLog(@"1111");
                _BigOrSmall=NO;
//                [UIView animateWithDuration:0.5 animations:^{
//                    
//                    self.actionView.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT/2+SCREEN_WIDTH/3);
//                    self.actorsView.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT/2+SCREEN_WIDTH/3);
//                }];
                
                
            }else{
                NSLog(@"222");
                _BigOrSmall=YES;
                
//                [UIView animateWithDuration:0.5 animations:^{
//                    
//                    self.actionView.frame = CGRectMake(2*SCREEN_WIDTH/3-20, 40, SCREEN_WIDTH/3, SCREEN_WIDTH/2);
//                    self.actorsView.frame = CGRectMake(2*SCREEN_WIDTH/3-20, 40, SCREEN_WIDTH/3, SCREEN_WIDTH/2);
//                }];
                
            }
            
        }else{
        
            self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
        }
        
    }
    
    if ([view isKindOfClass:[UIControl class]]) {
        UIControl *control = (UIControl *)view;
        [control sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    [self.chatroomViewController.sessionInputView endEditing:YES];
     */
}

#pragma mark - Get

//视频主视图高度
- (CGFloat)meetingActorsViewHeight
{
    return NIMKit_UIScreenHeight;
}

- (NTESMeetingActorsView *)actorsView{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_actorsView) {
        _actorsView = [[NTESMeetingActorsView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,self.meetingActorsViewHeight)];
        
        _actorsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _actorsView;
}

- (NTESMeetingView *)meetingView{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_meetingView) {
        _meetingView = [[NTESMeetingView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,self.meetingActorsViewHeight/3*2)];
        
        _meetingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _meetingView;
}

- (NTESMeetingActionView *)actionView
{
    if (!self.isViewLoaded) {
        return nil;
    }
    if (!_actionView) {
        _actionView = [[NTESMeetingActionView alloc] initWithDataSource:self];
        _actionView.frame = self.view.bounds;
        _actionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _actionView.delegate = self;
        _actionView.unreadRedTip.hidden = YES;
    }
    return _actionView;
}


#pragma mark - NIMInputDelegate
- (void)showInputView
{
    self.keyboradIsShown = YES;
}

- (void)hideInputView
{
    self.keyboradIsShown = NO;
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        
        NSString *toast;
        
        if ([_chatroom.creator isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            toast = @"教学已结束";
        }
        else {
            switch (reason) {
                case NIMChatroomKickReasonByManager:
                    toast = @"你已被老师请出房间";
                    break;
                case NIMChatroomKickReasonInvalidRoom:
                    toast = @"老师已经结束了教学";
                    break;
                case NIMChatroomKickReasonByConflictLogin:
                    toast = @"你已被自己踢出了房间";
                    break;
                default:
                    toast = @"你已被踢出了房间";
                    break;
            }
        }
        
        
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        
        //判断 当前页面是document列表的情况
        if ([self.navigationController.visibleViewController isKindOfClass:[NTESDocumentViewController class]]) {
            [self.navigationController.visibleViewController.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
            NSUInteger index = [self.navigationController.viewControllers indexOfObject:self.navigationController.visibleViewController]-2;
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
        }
        else if(self.actorsView.isFullScreen)//正在全屏 先退出全屏
        {
            [self.presentedViewController.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
            self.actorsView.showFullScreenBtn = NO;
            [self pop];
        }
        else{
            [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
            [self pop];
        }
    }
}

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepLoginOK) {
        if (![[NTESMeetingNetCallManager sharedInstance] isInMeeting]) {
            [self.view makeToast:@"登录成功，重新进入房间"];
            [[NTESMeetingNetCallManager sharedInstance] joinMeeting:_chatroom.roomId delegate:self];
        }
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    DDLogInfo(@"chatroom connectionStateChanged roomId : %@  state:%zd",roomId,state);
    if(state==NIMChatroomConnectionStateEnterOK)
    {
        [self requestChatRoomInfo];
    }
}

#pragma mark - NTESMeetingNetCallManagerDelegate
- (void)onJoinMeetingFailed:(NSString *)name error:(NSError *)error
{
    NSString *msg=@"无法加入视频，退出房间";
    if(error.code==404)msg=@"本次通话已结束";
    [self.view.window makeToast:msg duration:3.0 position:CSToastPositionCenter];
    
    if ([[[NTESMeetingRolesManager sharedInstance] myRole] isManager]) {
        [self requestCloseChatRoom];
    }
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself pop];

    });
}

- (void)onMeetingConntectStatus:(BOOL)connected
{
    DDLogInfo(@"Meeting %@ ...", connected ? @"connected" : @"disconnected");
    if (connected) {
    }
    else {
        [self.view.window makeToast:@"音视频服务连接异常" duration:2.0 position:CSToastPositionCenter];
        [self.actorsView stopLocalPreview];
        [self.meetingView stopLocalPreview];
    }
}

- (void)onSetBypassStreamingEnabled:(BOOL)enabled error:(NSUInteger)code
{
    DDLogError(@"Set bypass enabled %d error %zd", enabled, code);
    NSString *toast = [NSString stringWithFormat:@"%@互动直播失败 (%zd)", enabled ? @"开启" : @"关闭", code];
    [self.view.window makeToast:toast duration:3.0 position:CSToastPositionCenter];
}

#pragma mark - NTESMeetingRolesManagerDelegate

- (void)meetingRolesUpdate
{
    [self.actorsView updateActors];
    [self.meetingView updateActors];
    [self.memberListVC refresh];
    [self.whiteboardVC checkPermission];
    [self setupBarButtonItem];
}

- (void)meetingVolumesUpdate
{
    [self.memberListVC refresh];
}

- (void)chatroomMembersUpdated:(NSArray *)members entered:(BOOL)entered
{
    [self.memberListVC updateMembers:members entered:entered];
}

- (void)meetingMemberRaiseHand
{
    if (self.actionView.segmentedControl.selectedSegmentIndex != 2) {
        self.actionView.unreadRedTip.hidden = NO;
    }
}

- (void)meetingActorBeenEnabled
{
    if (!self.actorSelectView) {
        _isRemainStdNav = NO;
        self.actorSelectView = [[NTESActorSelectView alloc] initWithFrame:self.view.bounds];
        self.actorSelectView.delegate = self;
        [self.actorSelectView setUserInteractionEnabled:YES];
        //        [self.view addSubview:self.actorSelectView];
    }
}

- (void)meetingActorBeenDisabled
{
    [self removeActorSelectView];
    
    BOOL accepted = [[NTESMeetingNetCallManager sharedInstance] setBypassLiveStreaming:NO];
    
    if (!accepted) {
        [self.view.window makeToast:@"关闭互动直播被拒绝" duration:3.0 position:CSToastPositionTop];
    }
    
    [self.view.window makeToast:@"你已被老师取消互动" duration:2.0 position:CSToastPositionCenter];
}

- (void)meetingActorsNumberExceedMax
{
    [self.view makeToast:@"互动人数已满" duration:1 position:CSToastPositionCenter];
}

-(void)meetingRolesShowFullScreen:(NSString*)notifyExt
{
    if ([self showFullScreenBtn:notifyExt]) {
        
        self.actorsView.showFullScreenBtn = YES;
    }
    else
    {
        self.actorsView.showFullScreenBtn = NO;
    }
}


//老师允许后  确定 点击事件
#pragma mark - NTESActorSelectViewDelegate
- (void)onSelectedAudio:(BOOL)audioOn video:(BOOL)videoOn whiteboard:(BOOL)whiteboardOn
{
    [self removeActorSelectView];
    _isRemainStdNav = NO;
    
    if (audioOn) {
        
        [[NTESMeetingRolesManager sharedInstance] setMyAudio:YES];
    }
    
    if (videoOn) {
        
        [[NTESMeetingRolesManager sharedInstance] setMyVideo:YES];
        
        //前后摄像头转换
        [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraBack];
        //摄像头方向
        [[NIMAVChatSDK sharedSDK].netCallManager setVideoCaptureOrientation:NIMVideoOrientationDefault];
    }
    
    //    if (whiteboardOn) {
    //
    //        [[NTESMeetingRolesManager sharedInstance] setMyWhiteBoard:YES];
    //    }
    //
    //    BOOL accepted = [[NTESMeetingNetCallManager sharedInstance] setBypassLiveStreaming:YES];
    //
    //    if (!accepted) {
    //
    //        [self.view.window makeToast:@"开启互动直播被拒绝" duration:3.0 position:CSToastPositionTop];
    //    }
}

//白班 讨论 成员  显示设置

#pragma mark - Private
- (NSArray *)makeChildViewControllers{
    
    self.chatroomViewController = [[NTESChatroomViewController alloc] initWithChatroom:self.chatroom];
    self.chatroomViewController.delegate = self;
    self.memberListVC = [[NTESChatroomMemberListViewController alloc] initWithChatroom:self.chatroom];
    self.whiteboardVC = [[NTESMeetingWhiteboardViewController alloc] initWithChatroom:self.chatroom];
    
    return nil;
}

-(BOOL)showFullScreenBtn:(NSString * )jsonString
{
    if(jsonString)
    {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *err;
        
        NSDictionary *dic = [NSJSONSerialization  JSONObjectWithData:jsonData
                             
                                                             options:NSJSONReadingAllowFragments
                             
                                                               error:&err];
        if ([dic objectForKey:@"fullScreenType"])
        {
            if([[dic objectForKey:@"fullScreenType"]integerValue] == 1)
            {
                return YES;
            }
        }
        return NO;
    }
    
    return NO;
}
- (void)revertInputView
{
    UIView *inputView  = self.chatroomViewController.sessionInputView;
    UIView *revertView;
    if ([self.currentChildViewController isKindOfClass:[NTESChatroomViewController class]]) {
        revertView = self.view;
    }else{
        revertView = self.chatroomViewController.view;
    }
    CGFloat height = revertView.height;
    [revertView addSubview:inputView];
    inputView.bottom = height;
}

- (void)setupBarButtonItem
{
    
    [self refreshStdNavBar];

    //显示左边leftBarButtonItem
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    //左边返回button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"chatroom_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"chatroom_back_selected"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton sizeToFit];
    
    //房间号label
    NSString * string =  [NSString stringWithFormat:@"房间：%@",_charRoomName];
    CGRect rectTitle = [string boundingRectWithSize:CGSizeMake(999, 30)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                            context:nil];
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, rectTitle.size.width+20, 30)];
    title.font = [UIFont systemFontOfSize:12];
    title.textColor = [UIColor whiteColor];
    title.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    title.text = string;
    title.textAlignment = NSTextAlignmentCenter;
    
    title.layer.cornerRadius = 15;
    title.layer.masksToBounds = YES;
    [leftView addSubview:leftButton];
    [leftView addSubview:title];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
    self.navigationItem.leftItemsSupplementBackButton = NO;
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSMutableArray *arrayItems=[NSMutableArray array];
    [arrayItems addObject:negativeSpacer];
    [arrayItems addObject:leftItem];
    negativeSpacer.width = -7;
    
    self.navigationItem.leftBarButtonItems = arrayItems;
}

//用户端导航栏UI
-(void)refreshStdNavBar
{
    
    NTESMeetingRole *myRole = [[NTESMeetingRolesManager sharedInstance] myRole];
    
//    if ([_JSTXType isEqualToString:@"1"]) {
//        
//        if (myRole.videoOn) {
//            backImageView.hidden=NO;
//        }else{
//            backImageView.hidden=YES;
//        }
//    }

    NSString *audioImage;
    NSString *videoImage;
    NSString *audioImageSelected;
    NSString *videoImageSelected;
    
    if ([_JSTXType isEqualToString:@"1"]) {
        audioImage = myRole.audioOn ? @"chatroom_audio_on" : @"chatroom_audio_off";
        videoImage = myRole.videoOn ?  @"chatroom_video_on": @"chatroom_video_off";
        audioImageSelected = myRole.audioOn ? @"chatroom_audio_selected" : @"chatroom_audio_off_selected";
        videoImageSelected = myRole.videoOn ? @"chatroom_video_selected" : @"chatroom_video_off_selected";
    }else{
        audioImage = myRole.audioOn ? @"chatroom_audio_on" : @"chatroom_audio_off";
        videoImage = myRole.videoOn ?  @"chatroom_video_off": @"chatroom_video_on";
        audioImageSelected = myRole.audioOn ? @"chatroom_audio_selected" : @"chatroom_audio_off_selected";
        videoImageSelected = myRole.videoOn ? @"chatroom_video_selected" : @"chatroom_video_off_selected";
    }
    
    CGFloat btnWidth = 30;
    CGFloat btnHeight = 30;
    CGFloat btnMargin = 7;
    
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,5*(btnWidth+btnMargin), btnHeight)];
    //视频按钮
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.frame = CGRectMake(2*btnMargin+btnWidth, 0, btnWidth, btnHeight);
    [videoButton setImage:[UIImage imageNamed:videoImage] forState:UIControlStateNormal];
    [videoButton setImage:[UIImage imageNamed:videoImageSelected] forState:UIControlStateHighlighted];
    if ([_JSTXType isEqualToString:@"1"]) {
        [videoButton addTarget:self action:@selector(onSelfVideoPressed:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [videoButton addTarget:self action:@selector(onSelfVideoPressed2:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //音频按钮
    UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioButton.frame = CGRectMake(3*btnMargin+2*btnWidth, 0, btnWidth, btnHeight);
    [audioButton setImage:[UIImage imageNamed:audioImage] forState:UIControlStateNormal];
    [audioButton setImage:[UIImage imageNamed:audioImageSelected] forState:UIControlStateHighlighted];
    [audioButton addTarget:self action:@selector(onSelfAudioPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //结束按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(4*btnMargin+3*btnWidth, 0, btnWidth, btnHeight);
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom_selected"] forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [cancelButton setTitle:@"结束" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onCancelInteraction:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 10001;
    
    //切换摄像头
    UIButton *qieHuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qieHuanButton.frame = CGRectMake(5*btnMargin+4*btnWidth, 0, btnWidth, btnHeight);
    [qieHuanButton setImage:[UIImage imageNamed:@"btn_player_camera_normal"] forState:UIControlStateNormal];
    [qieHuanButton addTarget:self action:@selector(qieHuanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [rightView addSubview:audioButton];
    if ([_JSTXType isEqualToString:@"1"]) {
        [rightView addSubview:videoButton];
    }else{
        
    }
    [rightView addSubview:cancelButton];
    [rightView addSubview:qieHuanButton];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    NSMutableArray *arrayItems=[NSMutableArray array];
    [arrayItems addObject:negativeSpacer];
    [arrayItems addObject:rightItem];
    negativeSpacer.width = -btnMargin;
    self.navigationItem.rightBarButtonItems = arrayItems;
    
}
//即时通讯
- (void)qieHuanButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        //前后摄像头转换
        [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraFront];
        
    }else{
        
        //前后摄像头转换
        [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraBack];
        
    }
}
//会议视频
- (void)qieHuanButtonClick2:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        //前后摄像头转换
        [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraBack];
        
    }else{
        
        //前后摄像头转换
        [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:NIMNetCallCameraFront];
        
    }
}
- (void)onBack:(id)sender
{
    NTESMeetingRole *myRole = [[NTESMeetingRolesManager sharedInstance] myRole];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出房间吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                if (myRole.isManager ) {
                    [self requestCloseChatRoom];
                }else{
                    if ([_JSTXType isEqualToString:@"2"]) {
                        [self removeActorSelectView];
                        [[NTESMeetingRolesManager sharedInstance] setMyVideo:NO];
                        [self pop];
                    }else{
                        [self pop2];
                    }
                }
                break;
            }
                
            default:
                break;
        }
    }];
}

-(void)onCancelInteraction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定退出房间吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
    
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                [self roomOver];
                self.app.meetingRoomNumber=@"";
                [[NTESMeetingNetCallManager sharedInstance] leaveMeeting];
                [self onRaiseHandPressed:sender];
                break;
            }
                
            default:
                break;
        }
    }];
}

//互动 点击事件
- (void)onRaiseHandPressed:(id)sender
{
    
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer =nil;
    
  if([_JSTXType isEqualToString:@"2"]){
        [self removeActorSelectView];
        [[NTESMeetingRolesManager sharedInstance] setMyVideo:NO];
        [self pop];
    }else{

        [self pop2];
    };

}

- (void)onSelfVideoPressed:(UIButton*)sender
{
    BOOL videoIsOn = [NTESMeetingRolesManager sharedInstance].myRole.videoOn;

    [[NTESMeetingRolesManager sharedInstance] setMyVideo:!videoIsOn];
}
- (void)onSelfVideoPressed2:(UIButton *)sender
{
    BOOL videoIsOn = [NTESMeetingRolesManager sharedInstance].myRole.videoOn;
    
    [[NTESMeetingRolesManager sharedInstance] setMyVideo:!videoIsOn];
}

- (void)onSelfAudioPressed:(id)sender
{
    BOOL audioIsOn = [NTESMeetingRolesManager sharedInstance].myRole.audioOn;
    [[NTESMeetingRolesManager sharedInstance] setMyAudio:!audioIsOn];
}

- (void)requestCloseChatRoom
{
    [SVProgressHUD show];
    __weak typeof(self) wself = self;
    
    [[NTESDemoService sharedService] closeChatRoom:_chatroom.roomId creator:_chatroom.creator completion:^(NSError *error, NSString *roomId) {
        [SVProgressHUD dismiss];
        if (error) {
            [wself.view makeToast:@"结束房间失败" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)requestChatRoomInfo
{
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomInfo:_chatroom.roomId completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom) {
        if (!error) {
            if([wself showFullScreenBtn:chatroom.ext])
            {
                wself.actorsView.showFullScreenBtn = YES;
            }
        }
        else
        {
            [wself.view makeToast:@"获取聊天室信息失败" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}


- (void)removeActorSelectView
{
    if (self.actorSelectView) {
        [self.actorSelectView removeFromSuperview];
        self.actorSelectView = nil;
    }
}

- (void)pop
{
    //if (!self.isPoped) {
        self.isPoped = YES;
        [self.navigationController popViewControllerAnimated:YES];
    //}
}
- (void)pop2
{
    //if (!self.isPoped) {
        self.isPoped = YES;
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    //}
}
#pragma mark - Rotate supportedInterfaceOrientations
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//========================

+ (NSString *)notificationMessage:(NIMMessage *)message{
    NIMNotificationObject *object = message.messageObject;
    switch (object.notificationType) {
        case NIMNotificationTypeTeam:{
//            return [NIMKitUtil teamNotificationFormatedMessage:message];
        }
        case NIMNotificationTypeNetCall:{
//            return [NIMKitUtil netcallNotificationFormatedMessage:message];
        }
        case NIMNotificationTypeChatroom:{
            return [self chatroomNotificationFormatedMessage:message];
        }
        default:
            return @"";
    }
}

+ (NSString *)chatroomNotificationFormatedMessage:(NIMMessage *)message{
    NIMNotificationObject *object = message.messageObject;
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
    NSMutableArray *targetNicks = [[NSMutableArray alloc] init];
    for (NIMChatroomNotificationMember *memebr in content.targets) {
        if ([memebr.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            [targetNicks addObject:@"你"];
        }else{
            [targetNicks addObject:memebr.nick];
        }
        
    }
    NSString *targetText =[targetNicks componentsJoinedByString:@","];
    switch (content.eventType) {
        case NIMChatroomEventTypeEnter:
        {
            return [NSString stringWithFormat:@"欢迎%@进入房间",targetText];
        }
        case NIMChatroomEventTypeAddBlack:
        {
            return [NSString stringWithFormat:@"%@被管理员拉入黑名单",targetText];
        }
        case NIMChatroomEventTypeRemoveBlack:
        {
            return [NSString stringWithFormat:@"%@被管理员解除拉黑",targetText];
        }
        case NIMChatroomEventTypeAddMute:
        {
            if (content.targets.count == 1 && [[content.targets.firstObject userId] isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]])
            {
                return @"你已被禁言";
            }
            else
            {
                return [NSString stringWithFormat:@"%@被管理员禁言",targetText];
            }
        }
        case NIMChatroomEventTypeRemoveMute:
        {
            return [NSString stringWithFormat:@"%@被管理员解除禁言",targetText];
        }
        case NIMChatroomEventTypeAddManager:
        {
            return [NSString stringWithFormat:@"%@被任命管理员身份",targetText];
        }
        case NIMChatroomEventTypeRemoveManager:
        {
            return [NSString stringWithFormat:@"%@被解除管理员身份",targetText];
        }
        case NIMChatroomEventTypeRemoveCommon:
        {
            return [NSString stringWithFormat:@"%@被解除成员身份",targetText];
        }
        case NIMChatroomEventTypeAddCommon:
        {
            return [NSString stringWithFormat:@"%@被添加为成员身份",targetText];
        }
        case NIMChatroomEventTypeInfoUpdated:
        {
            return [NSString stringWithFormat:@"公告已更新"];
        }
        case NIMChatroomEventTypeKicked:
        {
            return [NSString stringWithFormat:@"%@被管理员移出房间",targetText];
        }
        case NIMChatroomEventTypeExit:
        {
            return [NSString stringWithFormat:@"%@离开了房间",targetText];
        }
        case NIMChatroomEventTypeClosed:
        {
            return [NSString stringWithFormat:@"房间已关闭"];
        }
        default:
            break;
    }
    return @"";
}
#pragma mark - NIMLoginManagerDelegate
- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    [self.view.window makeToast:@"您的帐号被其它端登陆，请重新登录！" duration:3.0 position:CSToastPositionCenter];
    
    if ([[[NTESMeetingRolesManager sharedInstance] myRole] isManager]) {
        [self requestCloseChatRoom];
    }
    
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself pop];
        
    });
}

- (void)onMultiLoginClientsChanged
{
    
}

-(void)roomOver
{
    NSString *currwyid= [[NIMSDK sharedSDK].loginManager currentAccount];
    
    if(![currwyid isEqual:self.app.meetingCreator])
    {
        return;
    }
    
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/APPAlarmRoomRecordUpdateEndTime?roomID=%@",self.app.meetingRoomNumber];
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

-(void)selectDataOk:(NSString *)msg
{
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)selectDataErr:(NSString *)msg
{
    [CommonUseClass showAlter:msg];
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - onReceiveCustomSystemNotification
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    //{"roomId":"100001","creator":"10000032","roomName":"100001","userCount":"3"}
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * WYID = [defaults objectForKey:@"WYID"];
    
    if([notification.content isKindOfClass: [NSString class]])
    {
        NSDictionary* userInfo=[notification.content objectFromJSONString];
        
        NSString * roomid= [userInfo objectForKey:@"roomId"];
        NSString * roomName= [userInfo objectForKey:@"roomName"];
        NSString * creator= [userInfo objectForKey:@"creator"];
        
        if([[CommonUseClass FormatString: roomid] isEqual:@""]||[[CommonUseClass FormatString:roomName] isEqual:@""])
        {}
        else
        {
            self.app.meetingUsers=userInfo[@"userList"];
        }
    }
}
@end
