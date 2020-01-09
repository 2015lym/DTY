//
//  AddPeopleViewController.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/24.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "AddPeopleViewController.h"
//#import "CYZViewController.h"
#import "Util.h"
#import "CommonUseClass.h"
#import "EventCurriculumEntity.h"
#import "CYZCellViewController.h"
#import "MyControl.h"
#import "HTTPSessionManager.h"
#import <NIMSDK/NIMSDK.h>
#import <NIMAVChat/NIMAVChat.h>
#import <NIMAVChat/NIMNetCallManagerProtocol.h>
#import "NTESMeetingViewController.h"
#import "NTESMeetingManager.h"
#import "NTESMeetingRolesManager.h"
#import "NTESMeetingRoomCreateViewController.h"
#import "NTESDemoService.h"
#import "UIView+Toast.h"
#import <NIMAVChat/NIMNetCallOption.h>
#import "NTESBundleSetting.h"
#import "RoomClass.h"
//十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
#define DelaySelfStartControlTime 10

@interface AddPeopleViewController ()
{
    UIView *bigView;
    NSString *receiveUserStr;
    //NSString *roomID;
    NSString *WYID;
}
@property (nonatomic, strong) NSMutableArray *chatRoom;

@end

@implementation AddPeopleViewController
@synthesize app;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    //2.
    tabCurrent=0;
    CourseTableview.PageIndex=1;
    [self getSchoolCourse];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"选择成员";
    self.view.backgroundColor = [UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    app.array_selectList=[[NSMutableArray alloc]init];
    app.array_selectNameList=[[NSMutableArray alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    WYID = [defaults objectForKey:@"WYID"];
    
    UIButton* right_BarButoon_Item=[[UIButton alloc] init];
    right_BarButoon_Item.frame=CGRectMake(0, 0,40,35);
    [right_BarButoon_Item setTitle:@"发起" forState: UIControlStateNormal];
    [right_BarButoon_Item addTarget:self action:@selector(navRightBtn_Event) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_BarButoon_Item];
    self.navigationItem.rightBarButtonItems=@[rightItem];
    
    [self initUI];
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"PeopleCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 45;
    CourseTableview.tableView.frame = CGRectMake(0,120, SCREEN_WIDTH, SCREEN_HEIGHT-120-50);
    [self.view addSubview:CourseTableview.tableView];

   
    
}

-(void)initUI{
    UIView * viewTop=[MyControl createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) backColor:[CommonUseClass getSysColor]];
    [self.view addSubview:viewTop];
    
    //1
    UIButton *stop_Btn = [MyControl createButtonWithFrame:CGRectMake(10, 20, 35, 35) imageName:@"backArrow@2x" bgImageName:nil title:nil SEL:@selector(onCancel_close:) target:self];
    stop_Btn.tag=100;
    [viewTop addSubview:stop_Btn];
    
    //2
    [self addTab];
    
    //3
    UIView *viewSearch=[[UIView alloc]initWithFrame:CGRectMake(20, 70, SCREEN_WIDTH-40, 40)];
    [viewTop addSubview:viewSearch];
    viewSearch.backgroundColor=[UIColor whiteColor];
    viewSearch.layer.masksToBounds = YES; //没这句话它圆不起来
    viewSearch.layer.cornerRadius = 8; //设置图片圆角的尺度
    
    UIImageView *img=[MyControl createImageViewWithFrame:CGRectMake(0, 5, 30, 30) imageName:@"search_colorGray"];
    [viewSearch addSubview:img];
    
    txtSearch=[MyControl createTextFildWithFrame:CGRectMake(40, 0, viewSearch.frame.size.width-40, 40) Font:15 Text:@""];
    txtSearch.placeholder=@"搜索联系人";
    [viewSearch addSubview:txtSearch];
    txtSearch.delegate = self;
    txtSearch.backgroundColor=[UIColor whiteColor];
    txtSearch.returnKeyType = UIReturnKeyDone;
    
    UIButton *btnDiveo = [MyControl createButtonWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, bounds_width.size.width, 50) imageName:nil bgImageName:nil title:@"发起视频邀请" SEL:@selector(navRightBtn_Event) target:self];
    btnDiveo.backgroundColor = [CommonUseClass getSysColor];
    [btnDiveo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnDiveo.tag=0;
    [self .view addSubview:btnDiveo];
    
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [txtSearch resignFirstResponder];//取消第一响应者
    
    if(txtSearch.text .length>0)
    {
        if(tabCurrent==0)
        [self getSchoolCourse];
        else
        {
            myhandleRecorde.keyword=[CommonUseClass FormatString:txtSearch.text];
            [myhandleRecorde getSchoolCourse];
        }
    }
    
    return YES;
}
-(void)onCancel_close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)addTab{
    long left=SCREEN_WIDTH/2-100;
    UIButton *dyzjBtn = [MyControl createButtonWithFrame:CGRectMake(left, 20, 100, 35) imageName:nil bgImageName:nil title:@"视频通话" SEL:@selector(changeParkClick:) target:self];
    [dyzjBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dyzjBtn.tag=0;
    [self .view addSubview:dyzjBtn];
    
    
    UIButton *dyzjBtn_1 = [MyControl createButtonWithFrame:CGRectMake(bounds_width.size.width/2, 20, 100, 35) imageName:nil bgImageName:nil title:@"历史记录" SEL:@selector(changeParkClick:) target:self];
    [dyzjBtn_1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    dyzjBtn_1.tag=1;
    [self .view addSubview:dyzjBtn_1];
    
    line = [[UILabel alloc]init];
    line.frame=CGRectMake(left+20,34+20, 60, 1);
    line.backgroundColor=[UIColor whiteColor] ;
    [self .view addSubview:line];
    
    
}

- (IBAction)changeParkClick:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
    long left=SCREEN_WIDTH/2-100+20;
    switch (btn.tag) {
        case 0:
            tabCurrent=0;
            line.frame=CGRectMake(left, 34+20, 60, 1);
            [self HistoryRemore];
            [self getSchoolCourse];
            break;
        case 1:
            tabCurrent=1;
            line.frame=CGRectMake(bounds_width.size.width/2+20, 34+20, 60, 1);
            [self Historyinit];
            break;
            
        default:
            break;
    }
    
    
    
}

#pragma 弹出名细页面
-(void)SchoolCoursePush:(UIViewControllerEx *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
    //UINavigationController *nav_loginVC1=[[ UINavigationController alloc]initWithRootViewController:vc];
    //[self presentViewController:nav_loginVC1 animated:YES completion:^{
    
    //}];
    
}
-(void)HistoryRemore{
    //2.
    if(myhandleRecorde.view!=nil)
        [myhandleRecorde.view removeFromSuperview];
}

-(void)Historyinit
{
    myhandleRecorde = [[videoHistroyViewController alloc]init];
    myhandleRecorde.delegate=self;
    myhandleRecorde.keyword=[CommonUseClass FormatString: txtSearch.text];
    myhandleRecorde.view.frame = CGRectMake(0, 120, SCREEN_WIDTH, SCREEN_HEIGHT-120 );    
    [self.view addSubview:myhandleRecorde.view];
}
- (void)navRightBtn_Event
{
    if (app.array_selectList.count==0) {

        [CommonUseClass showAlter:@"请选择邀请人员！"];
        return;

    }else if(app.array_selectList.count>3){

        [CommonUseClass showAlter:@"邀请人员数需小于4人！"];
        return;
    }else{
    
        receiveUserStr = [app.array_selectList componentsJoinedByString:@","];
        
        NSLog(@"userStr=%@",receiveUserStr);
        
         _roomid=[CommonUseClass getUniqueStrByUUID];
        [self createRoom:receiveUserStr];
        
        //test
//        [self createRoom:@""];
    }    

}
-(void)getSchoolCourse2:(NSString *)toAccids
{
    
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/AppSendBatchAttachMsg?fromAccid=%@&toAccids=%@&roomId=%@",WYID,toAccids,_roomid];
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [XXNet GetURL:currUrl header:nil parameters:nil succeed:^(NSDictionary *data) {
        
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(selectDataOk:) withObject:@"" waitUntilDone:YES];
            //1.
            NSString *attach=[data objectForKey:@"Data"];
            attach = [attach stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            NSData *data = [attach dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            NSData *data = [attach dataUsingEncoding:NSUTF8StringEncoding];
            //NSDictionary *tempDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            //NSMutableArray *array=[NSMutableArray arrayWithObject:attach];
            
            //
            self.app.meetingUsers=array;
            self.app.meetingCreator=WYID;
            // [self joinRoom];
            [self performSelectorOnMainThread:@selector(joinRoom) withObject:nil waitUntilDone:NO];
            
            
            [self CreateAPPAlarmRoomRecord:toAccids];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(addRoomErr:) withObject:@"提交失败" waitUntilDone:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(addRoomErr:) withObject:MessageResult waitUntilDone:YES];
        
    }];
}

-(void)addRoomErr:(NSString *)msg
{
    self. app.  meetingRoomNumber=@"";
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)createRoom:(NSString *)peopleOther
{
    
//    test
    //1.
//    [self reserveNetCallMeeting:app.userInfo.UserID];
    //2.
//    [self requestChatRoom];
//    return;
    
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
        
        
        self. app.  meetingRoomNumber=_roomid;
        
        //test
        if(peopleOther == nil)
        {
            [self joinRoom];
            return ;
        }
        //1.
        [self getSchoolCourse2:peopleOther];
        
        
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


- (void)dismiss:(void (^)(void))completion{
    //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype  = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
    [self setUpStatusBar:UIStatusBarStyleDefault];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}
- (void)setUpStatusBar:(UIStatusBarStyle)style{
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}
- (void)fillUserSetting:(NIMNetCallOption *)option
{
//    option.videoCrop  = [[NTESBundleSetting sharedConfig] videochatVideoCrop];
    option.autoRotateRemoteVideo = [[NTESBundleSetting sharedConfig] videochatAutoRotateRemoteVideo];
    option.serverRecordAudio     = [[NTESBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo     = [[NTESBundleSetting sharedConfig] serverRecordVideo];
    option.preferredVideoEncoder = [[NTESBundleSetting sharedConfig] perferredVideoEncoder];
    option.preferredVideoDecoder = [[NTESBundleSetting sharedConfig] perferredVideoDecoder];
    option.videoMaxEncodeBitrate = [[NTESBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    option.autoDeactivateAudioSession = [[NTESBundleSetting sharedConfig] autoDeactivateAudioSession];
    option.audioDenoise = [[NTESBundleSetting sharedConfig] audioDenoise];
    option.voiceDetect = [[NTESBundleSetting sharedConfig] voiceDetect];
    option.preferHDAudio =  [[NTESBundleSetting sharedConfig] preferHDAudio];
    
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc] init];
    [self fillVideoCaptureSetting:param];
    option.videoCaptureParam = param;
    
}
- (void)fillVideoCaptureSetting:(NIMNetCallVideoCaptureParam *)param
{
    param.preferredVideoQuality = [[NTESBundleSetting sharedConfig] preferredVideoQuality];
    param.startWithBackCamera   = [[NTESBundleSetting sharedConfig] startWithBackCamera];
    
}


- (void)stopBtnClick
{
    bigView.hidden = YES;
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark TablviewDelegateEX

#pragma mark 返回编辑模式，默认为删除模式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

#pragma mark 选中行
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
    //CourseTableview.PageIndex+=1;
    //[self getSchoolCourse];
}
-(void)TableRowClickCell:(UITableItem *)value forcell:(UITableViewCellEx *)cell
{
    NSMutableDictionary *dic_value=(NSMutableDictionary *)value;
    BOOL isHave=NO;
    NSString *guidStr=[dic_value objectForKey:@"Guid"];
    for (int i =0; i<app.array_selectList.count; i++) {
        NSString *newStr=app.array_selectList[i];
        if ([guidStr isEqualToString:newStr]) {
            isHave=YES;
        }else{
            isHave=NO;
        }
    }
    if (isHave) {
        ((CYZCellViewController*)cell).checkbox.selected=YES;
    }
    else{
        ((CYZCellViewController*)cell).checkbox.selected=NO;
    }

}

-(void)TableRowClick:(UITableItem*)value
{
}
-(void)TableHeaderRowClick:(UITableItem*)value
{
    
}
-(void)pullUpdateData
{
    CourseTableview.PageIndex=1;
    [self getSchoolCourse];
}
#pragma mark - PeopleNearbyViewController
-(void)startFristLoadData
{
    [CourseTableview viewFrashData];
}
- (void)doneLoadingTableViewData
{
    [CourseTableview.tableView reloadData];
    [CourseTableview doneLoadingTableViewData];
    CourseTableview.max_Cell_Star=YES;
}

-(void)getSchoolCourse
{
//    //test
//    NSMutableArray *array_newJS=[[NSMutableArray alloc]init];
//    NSMutableDictionary *dicnew= [self addData:@"1" fromName:@"name1" forLevel:@"1"];
//    [array_newJS addObject:dicnew];
//
//    EventCurriculumEntity *entity=[[EventCurriculumEntity alloc] init];
//    entity.enroll_list=array_newJS;//array;
//    NSLog(@"++++++%@",entity.enroll_list);
//    [self init_tableview_hear:entity];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
//
//    return;
    app.array_selectList=[[NSMutableArray alloc]init];
    app.array_selectNameList=[[NSMutableArray alloc]init];
    
    array_newJS=[NSMutableArray new];
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/GetDeptUserList?userID=%@&userName=%@",app.userInfo.UserID,[CommonUseClass FormatString: txtSearch.text]];
    
   
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    [XXNet GetURL:currUrl header:nil parameters:nil succeed:^(NSDictionary *data) {
       
        if ([data[@"Success"]intValue]) {
             [self performSelectorOnMainThread:@selector(selectDataOk:) withObject:@"" waitUntilDone:YES];
            if (CourseTableview.PageIndex==1) {
                [CourseTableview.dataSource removeAllObjects];
            }
            else
            {
                [CourseTableview.dataSource removeLastObject];
            }
            
            NSString *str_json = data [@"Data"];
            array_newJS = [str_json objectFromJSONString];
            
            NSMutableArray *arrayNew=[NSMutableArray new];
            for (NSDictionary *dic in array_newJS) {
                NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [arrayNew addObject:newdic];
            }
            
            
            EventCurriculumEntity *entity=[[EventCurriculumEntity alloc] init];
            app.meetPeopleSelf=arrayNew;
            entity.enroll_list=app.meetPeopleSelf;
            //entity.enroll_list=array_newJS;
            NSLog(@"++++++%@",entity.enroll_list);
            [self init_tableview_hear:entity];
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
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
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)selectDataErr:(NSString *)msg
{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(NSMutableDictionary *)addData:(NSString *)guid fromName:(NSString *)name forLevel:(NSString *)level
{
    NSMutableDictionary *dicnew=[[NSMutableDictionary alloc]init];
    [dicnew setValue:guid forKey:@"Guid"];
    [dicnew setValue:name forKey:@"Name"];
    [dicnew setValue:level forKey:@"level"];
    return dicnew;
    //[dicnew setValue:[dic2 valueForKeyPath:@"Guid"] forKey:@"BJurisdictionGuid"];
    //[dicnew setValue:[dic2 valueForKeyPath:@"Name"] forKey:@"BJurisdictionName"];
    
}

-(void)NoDataShowImage
{
    UIView *view=[[UIView alloc ]initWithFrame:CGRectMake(0, 60, 320, 130)];
    //UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake((bounds_width.size.width-218)/2, 0, 218, 100)];
    //image.image=[UIImage imageNamed:@"NoData.png"];
    //[view addSubview:image];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((bounds_width.size.width-80)/2, 100, 80, 30)];
    label.text=@"暂无数据";
    label.textAlignment=NSTextAlignmentCenter;
    [label setTextColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]];
    [view addSubview:label];
    
    [CourseTableview.view addSubview:view];
    view.tag=3000;
}


-(void)init_tableview_hear:(EventCurriculumEntity *)entity
{
    
    if (entity.enroll_list.count) {
        
        
        for (NSMutableDictionary *dic_item in entity.enroll_list ) {
            
            
            [CourseTableview.dataSource addObject:dic_item];
            
        }
        
        /*
         if (entity.enroll_list.count>9) {
         [CourseTableview.dataSource addObject:@"加载中……"];
         }
         else
         {
         [CourseTableview.dataSource addObject:@"无更多数据"];
         }
         */
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

-(NSString *)getIds:(NSString *)toAccids{
    NSString *str=app.userInfo.UserID;
    
    NSArray *strs = [toAccids componentsSeparatedByString:@","];
    
    for (NSString *currwyid in strs) {
        for (NSDictionary * dic in array_newJS) {
            if([dic[@"LoginName"] isEqual:currwyid])
            {
                str=[NSString stringWithFormat:@"%@,%@",str,dic[@"UserID"]];
                break;
            }
        }
    }
    
    
    return str;
}

-(void)CreateAPPAlarmRoomRecord:(NSString *)toAccids
{
    NSString *ids=[self getIds:toAccids];
    
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/CreateAPPAlarmRoomRecord?userID=%@&userIds=%@&roomID=%@",app.userInfo.UserID,ids,_roomid];
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [XXNet GetURL:currUrl header:nil parameters:nil succeed:^(NSDictionary *data) {
        
//        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(selectDataOk:) withObject:@"" waitUntilDone:YES];
            
//        }
//        else
//        {
//            [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:@"提交失败" waitUntilDone:YES];
//        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:MessageResult waitUntilDone:YES];
        
    }];
}
@end
