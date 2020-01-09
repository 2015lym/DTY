//
//  AddPeopleViewController.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/24.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "AddPeopleViewController.h"

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
#import "NTESBundleSetting.h"
//十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
#define DelaySelfStartControlTime 10

@interface AddPeopleViewController ()<NIMNetCallManagerDelegate>
{
    UIView *bigView;
    NSString *receiveUserStr;
    NSString *roomID;
    NSString *WYID;
}
@property (nonatomic, strong) NSMutableArray *chatRoom;

@end

@implementation AddPeopleViewController
@synthesize app;

/// 本地视频 （此处是控制本地视频流）
- (void)onLocalDisplayviewReady:(UIView *)displayView
{
    //[self isShowLocalPreviewPeady:NO aLayer:displayView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"PeopleCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 45;
    CourseTableview.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:CourseTableview.tableView];

    //[self getSchoolCourse];
    
}
- (void)navRightBtn_Event
{
    //test
    [self createRoom];
    return;
    
    
    if (app.array_selectList.count==0) {
        
        [CommonUseClass showAlter:@"请选择邀请人员！"];
        return;
        
    }else if(app.array_selectList.count>3){
    
        [CommonUseClass showAlter:@"邀请人员数需小于3人！"];
        return;
    }else{
    
        receiveUserStr = [app.array_selectList componentsJoinedByString:@","];
        
        NSLog(@"userStr=%@",receiveUserStr);
        
        [self getSchoolCourse2];
    }
    

}
-(void)getSchoolCourse2
{
    
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    NSString *currUrl;
    currUrl=[NSString stringWithFormat:@"PageService/Base_MultiplayerVideo/IOS/%@/AddRoom",app.userInfo.UserID];
    
    RoomClass *_search=[[RoomClass alloc]init];
    _search.SendUser = WYID;
    _search.RoomID = app.userInfo.UserID;
    _search.RoomName = app.userInfo.UserID;
    _search.ReceiveUser = receiveUserStr;
    NSString *strstr=[CommonUseClass classToJson:_search];
    
    [HTTPSessionManager
     post:currUrl
     parameters:strstr
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Status"];
         
         if([success integerValue]!=0)
         {
             [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:nil waitUntilDone:NO];
             return ;
         }
         else
         {
             [self createRoom];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:nil waitUntilDone:NO];
     }];
    
}

- (void)reserveNetCallMeeting:(NSString *)roomId
{
    NIMNetCallMeeting *meeting = [[NIMNetCallMeeting alloc] init];
    meeting.name = roomId;
    meeting.type = NIMNetCallTypeVideo;
    meeting.ext = @"test extend meeting messge";
    
    [SVProgressHUD show];
    
    [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            [self enterChatRoom:roomId];
        }
        else {
            [self.view makeToast:@"分配视频会议失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

- (void)enterChatRoom:(NSString *)roomId
{
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = roomId;
    [SVProgressHUD show];
    
    __weak typeof(self) wself = self;
    
    [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError *error, NIMChatroom *room, NIMChatroomMember *me) {
        [SVProgressHUD dismiss];
        if (!error) {
            [[NTESMeetingManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
            [[NTESMeetingRolesManager sharedInstance] startNewMeeting:me withChatroom:room newCreated:YES];
            NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithChatroom:room];
            [wself.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [wself.view makeToast:@"进入会议失败，请重试" duration:2.0 position:CSToastPositionCenter];
        }
    }];
    
}


- (void)createRoom
{
//    NSString *uuid=[CommonUseClass getUniqueStrByUUID];
//    //test
//    [self reserveNetCallMeeting:uuid];
//    return;
    
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc]init];
    param.startWithCameraOn = YES;
    param.videoProcessorParam = [[NIMNetCallVideoProcessorParam alloc] init];
    

    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
//test_new    option.videoCrop = NIMNetCallVideoCrop4x3;
    option.autoRotateRemoteVideo =  NO;
    option.serverRecordAudio     = [[NTESBundleSetting sharedConfig] serverRecordAudio];
    option.serverRecordVideo     = [[NTESBundleSetting sharedConfig] serverRecordVideo];
    option.preferredVideoEncoder = [[NTESBundleSetting sharedConfig] perferredVideoEncoder];
    option.preferredVideoDecoder = [[NTESBundleSetting sharedConfig] perferredVideoDecoder];
    option.videoMaxEncodeBitrate = [[NTESBundleSetting sharedConfig] videoMaxEncodeKbps] * 1000;
    option.autoDeactivateAudioSession = [[NTESBundleSetting sharedConfig] autoDeactivateAudioSession];
    option.audioDenoise = [[NTESBundleSetting sharedConfig] audioDenoise];
    option.voiceDetect = [[NTESBundleSetting sharedConfig] voiceDetect];
    option.preferHDAudio = [[NTESBundleSetting sharedConfig] preferHDAudio];
//test_new    option.bypassStreamingVideoMixMode = [[NTESBundleSetting sharedConfig] bypassVideoMixMode];
    //option.bypassStreamingMixMode = [[NTESBundleSetting sharedConfig] bypassVideoMixMode];
    //NIMNetCallBypassStreamingMixMode
    option.videoCaptureParam = param;
    
    
    NIMNetCallMeeting* _meeting = [[NIMNetCallMeeting alloc] init];
    _meeting.name = app.userInfo.UserID;
    _meeting.type = NIMNetCallTypeVideo;
    _meeting.actor = YES;
    _meeting.ext = @"test extend meeting messge";
//    _meeting.option=option;
    
    //创建房间
    [[NIMAVChatSDK sharedSDK].netCallManager reserveMeeting:_meeting completion:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
        
        
        NIMChatroomMember *userinfo = [[NIMChatroomMember alloc]init];
        userinfo.userId = WYID;
        
        NIMChatroom *chatroom = [[NIMChatroom alloc]init];
        chatroom.name = app.userInfo.UserID;
        chatroom.roomId = app.userInfo.UserID;
        
        NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
        request.roomId = chatroom.roomId;
        [[NSUserDefaults standardUserDefaults] setObject:request.roomId forKey:@"cachedRoom"];
        
        
        
        [[NIMAVChatSDK sharedSDK].netCallManager joinMeeting:_meeting completion:^(NIMNetCallMeeting *meeting, NSError *error) {
            NSLog(@"%@",error);
            if (!error) {
        
                //默认关闭所有人视频
                [[NIMAVChatSDK sharedSDK].netCallManager setCameraDisable:YES];
                [[NIMAVChatSDK sharedSDK].netCallManager setMute:YES];
        
//                [[NTESMeetingManager sharedInstance] cacheMyInfo:userinfo roomId:request.roomId];
//                [[NTESMeetingRolesManager sharedInstance] startNewMeeting:userinfo withChatroom:chatroom newCreated:NO];
//                UINavigationController *nav = self.navigationController;
//                NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithChatroom:chatroom];
////                vc.charRoomName = app.userInfo.UserID;
////                vc.JSTXType = @"2";
//                [nav pushViewController:vc animated:NO];
//                NSMutableArray *vcs = [nav.viewControllers mutableCopy];
//                [vcs removeObject:self];
//                nav.viewControllers = vcs;
        
            }else{
                [self dismissViewControllerAnimated:NO completion:^{
                    [CommonUseClass showAlter:@"加入房间失败"];
                }];
            }
        }];
        
        
    }];
    

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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:@"CompanySelfDown" forKey:@"UserInfoState"];
    
    
    NSString *currUrl=[NSString stringWithFormat:@"PageService/Org/%@/%@/GetListUserInfo",@"",app.userInfo.UserID];
    
    NSLog(@"%@==%@",currUrl,dic_args);
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:currUrl
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
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
             
             NSMutableArray *array_newJS=[[NSMutableArray alloc]init];
             for (NSDictionary *dic in array) {
                 NSMutableDictionary *dicnew= [self addData:[dic valueForKeyPath:@"id"] fromName:[dic valueForKeyPath:@"text"] forLevel:@"1"];
                 [array_newJS addObject:dicnew];
             }
             
             EventCurriculumEntity *entity=[[EventCurriculumEntity alloc] init];
             entity.enroll_list=array_newJS;//array;
             NSLog(@"++++++%@",entity.enroll_list);
             
//             if([entity.count isEqualToString:@"0"])
//             {
//                 [self NoDataShowImage];
//             }
             
             [self init_tableview_hear:entity];
             
             [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:nil waitUntilDone:NO];
     }];
    
}

-(void)selectDataErr:(NSDictionary *)dict
{
    [CommonUseClass showAlter:MessageResult];
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

@end
