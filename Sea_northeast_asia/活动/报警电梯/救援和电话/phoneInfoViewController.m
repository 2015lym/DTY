//
//  phoneInfoViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/14.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "phoneInfoViewController.h"
#import "MyControl.h"
@interface phoneInfoViewController ()
{
    NSString * strPhone;
}
@property (nonatomic, assign) BOOL isMonitoring;
@end

@implementation phoneInfoViewController
@synthesize app;
-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    //[[self.tabBarController.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];
    self.navigationItem.title=@"电话跟进";
    self.tabBarController.navigationItem.title=@"电话跟进";
    self.tabBarController.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    WYID = [defaults objectForKey:@"WYID"];
    self.navigationItem.title=@"电话跟进";
    self.tabBarController.navigationItem.title=@"电话跟进";

    __viewBlue.layer.masksToBounds = YES; //没这句话它圆不起来
    __viewBlue.layer.cornerRadius = 5; //设置图片圆角的尺度
    
    _viewIcon.layer.masksToBounds = YES; //没这句话它圆不起来
    _viewIcon.layer.cornerRadius = 12; //设置图片圆角的尺度
    
    
    _labNum.text=_warnModel.Lift.LiftNum;
    _labTatolTime.text=[_warnModel.TotalLossTime stringByAppendingString:@"分"];
    if(![_warnModel.StatusName isEqual:@"<null>"])
        _lblSatus.text=_warnModel.StatusName;
    else
        _lblSatus.text=@"";
    
    _lblSatus.frame=CGRectMake(_lblSatus.frame.origin
                               .x, _lblSatus.frame.origin.y,bounds_width.size.width -111, _lblSatus.frame.size.height);
    
    
    
    
    self.view.frame=CGRectMake(0, 0,bounds_width.size.width , bounds_width.size.height);
    _viewHeader.frame=CGRectMake(0, 0,bounds_width.size.width , _viewHeader.frame.size.height);
    //1.1
    float width2=bounds_width.size.width/2;
    UILabel *lab1=[MyControl createLabelWithFrame:CGRectMake(0, 10, width2, 20) Font:14 Text:@"电梯编号"];
    lab1 .textAlignment=NSTextAlignmentCenter;
    lab1.textColor=[UIColor grayColor];
    [_viewHeader addSubview:lab1];
    _labNum.frame=CGRectMake(0, 30, width2, 20);
    _labNum .textAlignment=NSTextAlignmentCenter;
    
    UILabel *labLine1=[MyControl createLabelWithFrame:CGRectMake(width2, 20, 1, 25) Font:14 Text:@""];
    labLine1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_viewHeader addSubview:labLine1];
    
    //1.2
    UILabel *lab2=[MyControl createLabelWithFrame:CGRectMake(width2+1, 10, width2, 20) Font:14 Text:@"总时间"];
    lab2 .textAlignment=NSTextAlignmentCenter;
    lab2.textColor=[UIColor grayColor];
    [_viewHeader addSubview:lab2];
    _labTatolTime.frame=CGRectMake(width2+1, 30, width2, 20);
    _labTatolTime .textAlignment=NSTextAlignmentCenter;
    
    UILabel *labLine2=[MyControl createLabelWithFrame:CGRectMake(0, 60, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine2.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_viewHeader addSubview:labLine2];
    
    //2.
    //2.0
    UIView *viewBaseH=[[UIView alloc]initWithFrame:CGRectMake(0, 106, bounds_width.size.width, 40)];
    viewBaseH.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:viewBaseH];
    
    UIImageView * img=[MyControl createImageViewWithFrame:CGRectMake(10, 13, 5, 14) imageName:@"decorate_blue"];
    [viewBaseH addSubview:img];
    
    UILabel *lab3=[MyControl createLabelWithFrame:CGRectMake(30, 10, width2, 20) Font:14 Text:@"联系方式"];
    [viewBaseH addSubview:lab3];
    
    UILabel *labLine4=[MyControl createLabelWithFrame:CGRectMake(0, 39, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine4.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [viewBaseH addSubview:labLine4];
    
    //2.1
    _viewBase.frame=CGRectMake(0, 146,bounds_width.size.width ,bounds_width.size.height- _viewHeader.frame.size.height);
    CGSize size;
    size.width = bounds_width.size.width;
    size.height =400;// bounds_width.size.height-_viewHeader.frame.size.height;
    _viewBase.contentSize = size;
    
   
    
    int lastHeight=10;//_viewBase.frame.origin.y+_viewBase.frame.size.height;
    lastHeight=[self addUser:lastHeight forLabel:@"管理人员:" forData:_warnModel.Lift.UseUsers];
    lastHeight=lastHeight+10;
    
    lastHeight=[self addUser:lastHeight forLabel:@"维保人员:" forData:_warnModel.Lift.MaintUsers];
    lastHeight=lastHeight+10;
    ////////////////no data
    lastHeight=[self addInfo:lastHeight forLabel:@"被困人员:"  forData:@""];
    lastHeight=lastHeight+10;
    lastHeight=[self addInfo:lastHeight forLabel:@"联系电话:"  forData: _warnModel.RescuePhone];
   lastHeight=lastHeight+10;
    strPhone=_warnModel.RemedyUserPhone;
    lastHeight=[self addInfo:lastHeight forLabel:@"救援人员:"  forData: _warnModel.RemedyUser];
    lastHeight=lastHeight+10;
    ////////////////no data
    lastHeight=[self addInfo:lastHeight forLabel:@"语音来电:"  forData: @""];
    
    //视频主机回拨
    lastHeight=lastHeight+20;
   
    UILabel *label=[[UILabel alloc]init];
    label.text=@"视频主机回拨:";
    [label setFont:[UIFont systemFontOfSize:14]];
    label.frame=CGRectMake(3, lastHeight, bounds_width.size.width,21);
    [_viewBase addSubview:label];

    //点击回拨
//    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [copyBtn setTitle:@"点击回拨" forState:UIControlStateNormal];
//    copyBtn.frame = CGRectMake(100, lastHeight, 60, 20);
//    copyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [copyBtn addTarget:self action:@selector(copylinkBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    copyBtn.backgroundColor = [UIColor whiteColor];
//    [copyBtn setTitleColor:[CommonUseClass getSysColor] forState:UIControlStateNormal];
//    [_viewBase addSubview:copyBtn];
    
    //点击回拨
//    UIButton *eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [eyeButton setBackgroundImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];
//    eyeButton.frame = CGRectMake(190, lastHeight, 20, 20);
//    [eyeButton addTarget:self action:@selector(noMonitoring) forControlEvents:UIControlEventTouchUpInside];
//    [_viewBase addSubview:eyeButton];
}



-(int)addInfo:(int)lastHeight forLabel:(NSString*)Label forData:(NSString*)info {
    //管理人员
    
    UIView *viewUseUser=[[UIView alloc]init];
    viewUseUser.frame=CGRectMake(3, lastHeight, bounds_width.size.width, 21);
    UILabel *label=[[UILabel alloc]init];
    label.text=Label;
    [label setFont:[UIFont systemFontOfSize:14]];
    label.frame=CGRectMake(0, 0, bounds_width.size.width,21);
    [viewUseUser addSubview:label];
    
    UILabel *currLabel=[[UILabel alloc]init];
    [currLabel setFont:[UIFont systemFontOfSize:14]];
    
    //得到标签的宽度
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0f]};
    CGRect rect = [info boundingRectWithSize:CGSizeMake(320.f, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    
    
    currLabel.frame=CGRectMake(71, 0, rect.size.width+20,21);
    
    if(![info isEqual:@"<null>"])
    {
        currLabel.text = info;
        if([Label isEqual:@"救援人员:"])
        {
            if(!(strPhone ==nil))
            {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateSelected];
                btn.frame=CGRectMake(currLabel.frame.origin.x+currLabel.frame.size.width, 0, 21,21);
                btn.tag=[strPhone longLongValue];
                
                [btn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [viewUseUser addSubview:btn];
            }
        }
        if([Label isEqual:@"联系电话:"])
        {
           
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateSelected];
                btn.frame=CGRectMake(currLabel.frame.origin.x+currLabel.frame.size.width, 0, 21,21);
                btn.tag=[info longLongValue];
                
                [btn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [viewUseUser addSubview:btn];
            
        }

    }
    
    [viewUseUser addSubview:currLabel];
    
    //[self.view addSubview:viewUseUser];
    [_viewBase addSubview:viewUseUser];
    return viewUseUser.frame.origin.y+viewUseUser.frame.size.height;
}

// MARK: - UIButton点击事件
-(void)  addClickBtn:(UIButton *)btn {
    
    /*
     if btn.tag >= 100 {
     let url1 = NSURL(string: "tel://" + "\((managerArr?.Lift?.MaintUsersArrs[btn.tag - 100].Mobile)!)")
     UIApplication.sharedApplication().openURL(url1!)
     }
     else{
     let url2 = NSURL(string: "tel://" + "\((managerArr?.Lift?.UseUsersArrs[btn.tag].Mobile)!)")
     UIApplication.sharedApplication().openURL(url2!)
     }
     */
    NSString *srt_url=[NSString stringWithFormat:@"tel://%ld", btn.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:srt_url]];
}



-(int)addUser:(int)lastHeight forLabel:(NSString*)Label forData:(NSMutableArray*)array{
    //管理人员
    
    UIView *viewUseUser=[[UIView alloc]init];
    UILabel *label=[[UILabel alloc]init];
    label.text=Label;
    [label setFont:[UIFont systemFontOfSize:14]];
    label.frame=CGRectMake(3, 0, bounds_width.size.width,21);
    [viewUseUser addSubview:label];
    
    if(array.count!=0)
    {
        int i=0;
        viewUseUser.frame=CGRectMake(0, lastHeight, bounds_width.size.width, array.count*21);
        for (NSMutableDictionary *dic_item in array )
        {
            UILabel *currLabel=[[UILabel alloc]init];
            [currLabel setFont:[UIFont systemFontOfSize:14]];
            NSString *userName=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UserName"]];
            NSString *Mobile=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"Mobile"]];
            currLabel.text = [userName stringByAppendingString:@"("];
            currLabel.text = [currLabel.text stringByAppendingString:Mobile];
            currLabel.text = [currLabel.text stringByAppendingString:@")"];
            
            //得到标签的宽度
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0f]};
            CGRect rect = [currLabel.text boundingRectWithSize:CGSizeMake(320.f, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:attributes
                                                       context:nil];
            
            currLabel.frame=CGRectMake(71, i*21, rect.size.width+20,21);
            
            if(![Mobile  isEqual:@"<null>"])
            {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"phone_green.png"]  forState: UIControlStateSelected];
                btn.frame=CGRectMake(currLabel.frame.origin.x+currLabel.frame.size.width, currLabel.frame.origin.y, 21,21);
                btn.tag=[Mobile longLongValue];
                
                [btn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
                [viewUseUser addSubview:btn];
            }
            
            
            
            [viewUseUser addSubview:currLabel];
            
            i=i+1;
        }
    }
    else
    {
        viewUseUser.frame=CGRectMake(0, lastHeight, bounds_width.size.width, 21);
    }
    //[self.view addSubview:viewUseUser];
    [_viewBase addSubview:viewUseUser];
    return viewUseUser.frame.origin.y+viewUseUser.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)copylinkBtnClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _roomid=[CommonUseClass getUniqueStrByUUID];
    _isMonitoring = YES;
    [self createRoom];
}

- (void)noMonitoring {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _roomid=[CommonUseClass getUniqueStrByUUID];
    _isMonitoring = NO;
    [self createRoom];
}

- (void)createRoom
{
    
   
    
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc]init];
    param.startWithCameraOn = YES;
    
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    //option.videoCrop = NIMNetCallVideoCrop4x3;
    option.autoRotateRemoteVideo = NO;
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
    
    
    NIMNetCallMeeting* _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = _roomid;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = YES;
    _meeting.ext = @"test extend meeting messge";
    _meeting.option=option;
    
    //创建房间
    [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:_meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        
        
        self.app.meetingRoomNumber=_roomid;
    
        //1.
        [self getSchoolCourse2];
        
        
    }];
    
}

-(void)joinRoom
{
    NIMChatroomMember *userinfo = [[NIMChatroomMember alloc]init];
    userinfo.userId = WYID;
    
    NIMChatroom *chatroom = [[NIMChatroom alloc]init];
    chatroom.name = _roomid ;
    chatroom.roomId = _roomid;
    chatroom.creator=WYID;
    
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = chatroom.roomId;
    [[NSUserDefaults standardUserDefaults] setObject:request.roomId forKey:@"cachedRoom"];
    
    //        [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
    //
    //            NSLog(@"%@",error);
    //
    //            if (!error) {
    
    [[NTESMeetingManager sharedInstance] cacheMyInfo:userinfo roomId:request.roomId];
    [[NTESMeetingRolesManager sharedInstance] startNewMeeting:userinfo withChatroom:chatroom newCreated:NO];
    UINavigationController *nav = self.navigationController;
    NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithChatroom:chatroom];
    vc.charRoomName = _roomid;
    vc.JSTXType = @"2";
    vc.isCall=1;
    [nav pushViewController:vc animated:NO];
    NSMutableArray *vcs = [nav.viewControllers mutableCopy];
    //                [vcs removeObject:self];
    nav.viewControllers = vcs;
    
    //            }else{
    //
    //                [self dismissViewControllerAnimated:NO completion:^{
    //                    [CommonUseClass showAlter:@"加入房间失败"];
    //                }];
    //            }
    
    //        }];
}

-(void)getSchoolCourse2
{
    
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/AppSendVideoMachineMsg?fromAccid=%@&LiftID=%@&roomId=%@",WYID,_warnModel.LiftId,_roomid];
    
    if (!_isMonitoring) {
        currUrl=[NSString stringWithFormat:@"NeteaseMi/AppSendVideoMachineMsg?fromAccid=%@&LiftID=%@&roomId=%@&isMonitoring=false",WYID,_warnModel.LiftId,_roomid];
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [XXNet GetURL:currUrl header:nil parameters:nil succeed:^(NSDictionary *data) {

        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(selectDataOk:) withObject:@"" waitUntilDone:YES];
            //1.
            NSString *attach=[data objectForKey:@"Data"];
            attach = [attach stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            NSData *data = [attach dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

            self.app.meetingUsers=array;
            self.app.meetingCreator=WYID;

            [self performSelectorOnMainThread:@selector(joinRoom) withObject:nil waitUntilDone:NO];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(addRoomErr:) withObject:@"回拔失败！" waitUntilDone:YES];
        }

    } failure:^(NSError *error) {
        NSString *msg=[NSString stringWithFormat:@"回拔失败！%@",MessageResult];
        [self performSelectorOnMainThread:@selector(addRoomErr:) withObject:msg waitUntilDone:YES];

    }];
}

-(void)addRoomErr:(NSString *)msg
{
    self. app.  meetingRoomNumber=@"";
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)selectDataOk:(NSString *)msg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
