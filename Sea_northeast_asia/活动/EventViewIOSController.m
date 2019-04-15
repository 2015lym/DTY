//
//  EventViewIOSController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "EventViewIOSController.h"
#import "signUpViewController.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "warningElevatorModel.h"
#import "warningElevatorLift.h"
#import "rescueList.h"
#import "elevatorRescueView.h"
#import "elevatorRescueTooBar.h"
#import "StatusTable.h"
#import "handleRecorde.h"
#import "personOrder.h"
#import "complainAdvice.h"
#import "helpInfoViewController.h"
#import "phoneInfoViewController.h"

#import "RescueCompleteViewController.h"
#import "RescueEvaluationViewController.h"
#import "RescueOmitViewController.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kRestOfHeight (kHeight - 64 - 49 )

@interface EventViewIOSController ()<BMKLocationServiceDelegate,UIGestureRecognizerDelegate>{
BOOL enableCustomMap;
    //BMKPointAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
    
    NSMutableArray* elevatorArrays;
    NSMutableArray* arr ;// [warningElevatorModel] []
    warningElevatorModel *sendArr;
    NSMutableArray *sendStatus;//操作按钮的StatusTable
    BMKPointAnnotation * pointAnnotation;
    UIButton *isClickBtn;
    UIButton *iClickBtn ;
    UIButton *btnS;
    
    rescueList *rescueL ;
    handleRecorde  *myhandleRecorde ;
    personOrder *mypersonOrder;
    complainAdvice *mycomplainAdvice;
    
    elevatorRescueView  *eV ;
    //elevatorRescueTooBar  *eVToolBar ;
    UIView *eVToolBar;
    
    int showPaopao;
    int paopaoCount;
    //var ee = rescueMesssageView.searchrescueMesssageViewView()
    /*
    var locService: BMKLocationService!
    let c =   CoverView.sharedCoverView
    var userTypes : [String] = []
    var userTypeIds : [AnyObject] = []
    var userArguments : [String] = []
    var   jiuyuan = finishResureView.finishResureV()
    */
    
    float X;
    float Y;
}

//@property (nonatomic,strong)CLLocationManager *locationManager;
//@property (nonatomic,strong) BMKLocationService *service;//定位服务
@property(nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, assign) BOOL isMonitoring;
@property (nonatomic, copy) NSString *roomid;

@property (nonatomic, strong) UIButton *callBackButton;
@property (nonatomic, strong) UIButton *seeButton;
@end

@implementation EventViewIOSController
@synthesize app;
+(instancetype)sharedLoadData
{
    static EventViewIOSController *singleton = nil;
    static dispatch_once_t onceToken;
    // dispatch_once  无论使用多线程还是单线程，都只执行一次
    dispatch_once(&onceToken, ^{
        singleton = [[EventViewIOSController alloc] initWithNibName:[Util GetResolution:@"EventViewIOSController"]  bundle:nil];
    });
    return singleton;
}


-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    self.tabBarController.navigationItem.title=@"智慧电梯管理平台";
    self.navigationController.navigationBarHidden = YES;
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [BMKMapView enableCustomMapStyle:enableCustomMap];
    
    if(![[CommonUseClass FormatString: app.push_Guid]  isEqual:@""])
    {
                isClickBtn.tag=0;
                warningElevatorModel *warnmodel=[[warningElevatorModel alloc]init];
                warnmodel.ID=app.push_Guid;
                [self showOne:warnmodel];
                app.push_Guid=@"";
    }
}
+ (void)initialize {
    //设置自定义地图样式，会影响所有地图实例
    //注：必须在BMKMapView对象初始化之前调用
    NSString* path = [[NSBundle mainBundle] pathForResource:@"custom_config_清新蓝" ofType:@""];
    [BMKMapView customMapStyle:path];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initLocation
{
    _locationManager = [[BMKLocationManager alloc] init];
    
    _locationManager.delegate = self;
    
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    _locationManager.distanceFilter = 10.0f;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.allowsBackgroundLocationUpdates = YES;// YES的话是可以进行后台定位的，但需要项目配置，否则会报错，具体参考开发文档
    _locationManager.locationTimeout = 10;
    _locationManager.reGeocodeTimeout = 10;
    
    _locationManager.locatingWithReGeocode = YES;
    _locationManager.allowsBackgroundLocationUpdates = YES;
    
    if(!isAddLocation)
    {
        [self mapLocation];
        isAddLocation=1;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    locationTime=300;
    getStateAction *stateAction=[[getStateAction alloc]init];
    [stateAction GetLastStatusActionList];
    
    view_content.frame=CGRectMake(0,  0, bounds_width.size.width, bounds_width.size.height);
    _mapView.frame=CGRectMake(0,  0, bounds_width.size.width, bounds_width.size.height-48);
    _mapView.backgroundColor=[UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [self createEditableCopyOfDatabaseIfNeeded];
    //1.init
    elevatorArrays=[[NSMutableArray alloc]init];
    [elevatorArrays addObject:@"报警电梯"];
    [elevatorArrays addObject:@"救援列表"];
    [elevatorArrays addObject:@"处置记录"];
    [elevatorArrays addObject:@"人工下单"];
    //[elevatorArrays addObject:@"投诉建议"];
    sendStatus=[[NSMutableArray alloc]init];
    
    //2.map
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    //添加普通地图/个性化地图切换开关
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"normal", @"custom"]];
    [segment setSelectedSegmentIndex:0];
    [segment addTarget:self action:@selector(changeMapAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segment];
    enableCustomMap = NO;
    _mapView.mapType=BMKMapTypeStandard;
    //[self addCustomGestures];//添加自定义的手势
    
    _mapView.showMapScaleBar = YES;
    //_scaleSwith.on = NO;
    _mapView.overlooking = -30;
    //_mapView.frame = CGRectMake(0, _mapView.frame.origin.y, _mapView.frame.size.width, self.view.frame.size.height - _mapView.frame.origin.y);
    
    
    //3.init
    [self addTagButton];
    [self addbtnS];
    [self AddPointInfo];
    if(![[CommonUseClass FormatString: app.push_Guid]  isEqual:@""])
    {
//        isClickBtn.tag=0;
//        warningElevatorModel *warnmodel=[[warningElevatorModel alloc]init];
//        warnmodel.ID=app.push_Guid;
//        [self showOne:warnmodel];
//        app.push_Guid=@"";
    }
    else
    {
    //3.1 show data
    [self requestAnimationData];
    }
    
    //4.注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_warn" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_HelperOrPhone:) name:@"tongzhi_HelperOrPhone" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_RescueOK:) name:@"tongzhi_RescueOK" object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_showPicture:) name:@"tongzhi_showPicture" object:nil];
   
    [self initCity];
    
//    //
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//
//    [_locationManager requestAlwaysAuthorization];
//    /** 开始定位 */
//    [self.locationManager startUpdatingLocation];
    [self initLocation];
}

- (void)tongzhi_showPicture:(NSNotification *)text{
    NSString *guid=(NSString *)text.userInfo[@"guid"];
    NSString *TaskId=(NSString *)text.userInfo[@"TaskId"];
    showPicViewController * cdvc=[[showPicViewController alloc] init];
    cdvc.LiftId=guid;
    cdvc.TaskId=TaskId;
    [self.tabBarController.navigationController pushViewController:cdvc animated:YES];
}

- (void)tongzhi_RescueOK:(NSNotification *)text{
    warningElevatorModel *model=(warningElevatorModel *)text.userInfo[@"textOne"];
    
    [self initView];
    _mapView.hidden=false;
    [self requestAnimationData];
    
}
- (void)tongzhi_warn:(NSNotification *)text{
   warningElevatorModel *model=(warningElevatorModel *)text.userInfo[@"textOne"];
    [self showOne:model];
    }

-(void)showOne:(warningElevatorModel *)model
{
    //1.show window
    UIButton *btnWarn=[self findSubButton:@"0"];
    isClickBtn.selected = false;
    btnWarn.selected=true;
    _mapView.hidden=false;
    isClickBtn=btnWarn;
    [self initView];
    
    //2.BMKPointAnnotation
    showPaopao=1;
    [self PointAnnotationDelAll];
    //[self PointAnnotationAdd:model forZoom:15];
    [self showPointInfo:true];
    
    [self requestOneBignNeedleByID:model.ID];
    
    //0
    UILabel *b = (UILabel*)[self.view viewWithTag:10001];
    b.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    b.textColor=[UIColor whiteColor];
    UILabel *b1 = (UILabel*)[self.view viewWithTag:10000];
    b1.backgroundColor=[UIColor whiteColor];
    b1.textColor=[UIColor colorWithHexString:@"#3574fa"];
}

//- (void)tongzhi_HelperOrPhone:(NSNotification *)text{
//NSString *type=text.userInfo[@"textOne"];
//if([type isEqual:@"Helper"])
- (void)tongzhi_HelperOrPhone:(id)sender{
    UIButton *btn=(UIButton *)sender;
    if(sendArr==nil)
    {
        [CommonUseClass showAlter:@"数据正在加载，请稍候再试！"];
        return;
    }
    if(btn.tag ==0)
    {
    helpInfoViewController * cdvc=[[helpInfoViewController alloc] initWithNibName:@"helpInfoViewController" bundle:nil];
        cdvc.warnModel=sendArr;
    [self.tabBarController.navigationController pushViewController:cdvc animated:YES];
    }
    else
    {
        phoneInfoViewController * cdvc=[[phoneInfoViewController alloc] initWithNibName:@"phoneInfoViewController" bundle:nil];
        cdvc.warnModel=sendArr;
        [self.tabBarController.navigationController pushViewController:cdvc animated:YES];
    }
}




#pragma mark - 添加 UIbutton 方法


// MARK:- 添加 UIbutton 方法
- (void)addTagButton{
    //title
    UIView *V1=[[UIView alloc]init];
    V1.frame=CGRectMake(0, 0, kWidth, 50);
    V1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [self.view addSubview:V1];
    
    UILabel *lab=[MyControl createLabelWithFrame:CGRectMake(0, 20, kWidth, 20) Font:18 Text:@"智慧电梯管理平台"];
    lab.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    lab.textColor=[UIColor whiteColor];
    lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview: lab];

    
    
    NSMutableArray *dlxxImg=[[NSMutableArray alloc]init];
    [dlxxImg addObject:@"dlxx_bjdt"];
    [dlxxImg addObject:@"dlxx_jyList"];
    [dlxxImg addObject:@"dlxx_czjl"];
    [dlxxImg addObject:@"dlxx_rgxd"];
    //[dlxxImg addObject:@"dlxx_ts"];
    
   // static dispatch_once_t onceToken=0;
    //dispatch_once(&onceToken, ^{
        for (NSUInteger i = 0; i < elevatorArrays.count; i++){
          
            UIButton  *btnC = [UIButton buttonWithType:UIButtonTypeCustom];
           
            [btnC setTitle:[elevatorArrays objectAtIndex:i] forState:UIControlStateNormal];
            btnC.tag=i;
            [self addBtnB:btnC c:i imag:[dlxxImg objectAtIndex:i]];
            [self.view addSubview:btnC];
            
        }

    //});
}
// MARK:- UIButton内部调用方法
- (void)addBtnB: (UIButton*) b c: (int) c imag:(NSString *)imgName{
    
        if (b.tag == 0) {
            b.selected = true;
            isClickBtn=b;
        }
    
    UIView *V=[[UIView alloc]init];
    V.frame=CGRectMake((float)c*kWidth/4, 50, kWidth/4, 30);
    V.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [self.view addSubview:V];
    UIImageView *imgV=[[UIImageView alloc]init];
    imgV.frame=CGRectMake((kWidth/4-30)/2, 0, 30, 30);
    imgV.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    imgV.image=[UIImage imageNamed:imgName];
    [V addSubview:imgV];
    
    UIView *V1=[[UIView alloc]init];
    V1.frame=CGRectMake((float)c*kWidth/4, 80, kWidth/4, 30);
    V1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [self.view addSubview:V1];
    UILabel *lab=[MyControl createLabelWithFrame:CGRectMake((float)c*kWidth/4+(kWidth/4-60)/2, 85, 60, 20) Font:13 Text:b.titleLabel.text];
    if(c==0)
    {
        lab.backgroundColor=[UIColor whiteColor];
        lab.textColor=[UIColor colorWithHexString:@"#3574fa"];
    }
    else
    {
        lab.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
        lab.textColor=[UIColor whiteColor];
    }
    lab.textAlignment=NSTextAlignmentCenter;
    lab.layer.masksToBounds = YES; //没这句话它圆不起来
    lab.layer.cornerRadius = 8; //设置图片圆角的尺度
    lab.tag=10000+c;
    [self.view addSubview: lab];
    
    
    b.adjustsImageWhenHighlighted = false;
    b.frame=CGRectMake((float)c*kWidth/4, 50, kWidth/4, 60);
    b.titleLabel.font=[UIFont systemFontOfSize:13];
    [b setTitle:@"" forState:UIControlStateNormal];
    
    [b addTarget:self action:@selector(sendIndex:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)initView{
    //0.
    _mapView.hidden=true;
    btnS.hidden=true;
    [self showPointInfo:false];
    //1.
    if(rescueL.view!=nil)
        [rescueL.view removeFromSuperview];
    //2.
    if(myhandleRecorde.view!=nil)
        [myhandleRecorde.view removeFromSuperview];
    //3.
    if(mypersonOrder.view!=nil)
        [mypersonOrder.view removeFromSuperview];
    //4.
    if(mycomplainAdvice.view!=nil)
        [mycomplainAdvice.view removeFromSuperview];
    
    if (isClickBtn.tag==0) {
        _mapView.hidden=false;
        btnS.hidden=false;
    }
}


// MARK:- UIButton点击事件
-(void)sendIndex:(id)sender{
    
    UILabel *b = (UILabel*)[self.view viewWithTag:10000];
    b.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    b.textColor=[UIColor whiteColor];
    UILabel *b1 = (UILabel*)[self.view viewWithTag:10001];
    b1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    b1.textColor=[UIColor whiteColor];
    UILabel *b2 = (UILabel*)[self.view viewWithTag:10002];
    b2.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    b2.textColor=[UIColor whiteColor];
    UILabel *b3 = (UILabel*)[self.view viewWithTag:10003];
    b3.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    b3.textColor=[UIColor whiteColor];
    UILabel *b4 = (UILabel*)[self.view viewWithTag:10004];
    b4.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    b4.textColor=[UIColor whiteColor];
        
    UIButton *btn= (UIButton *)sender;
    isClickBtn.selected = false;
    btn.selected=true;
    isClickBtn=btn;
    [self initView];
    
    UILabel *bcurr = (UILabel*)[self.view viewWithTag:10000+btn.tag];
    bcurr.backgroundColor=[UIColor whiteColor];
    bcurr.textColor=[UIColor colorWithHexString:@"#3574fa"];
    
    switch (btn.tag) {
        case 0:
            _mapView.hidden=false;
            [self requestAnimationData];
            break;
    case 1:
            rescueL = [[rescueList alloc]init];
            rescueL.arr=arr;
            rescueL.view.frame = CGRectMake(0, 110, kWidth, kHeight-30 );
            [self.view addSubview:rescueL.view];
            break;
       
    case 2:
            myhandleRecorde = [[handleRecorde alloc]init];
            myhandleRecorde.delegate=self;
            myhandleRecorde.view.frame = CGRectMake(0, 110, kWidth, kHeight-110 );
            [self.view addSubview:myhandleRecorde.view];

            break;
    case 3:
            //mypersonOrder =[[personOrder alloc]initWithNibName:[Util GetResolution:@"personOrder"] bundle:nil];
            mypersonOrder =[[personOrder alloc]initWithNibName:@"personOrder_s" bundle:nil];
            mypersonOrder.view.frame = CGRectMake(0, 110, kWidth, kHeight-110 );
            [self.view addSubview:mypersonOrder.view];
            
            break;
    case 4:
            mycomplainAdvice   = [[complainAdvice alloc]init];
            mycomplainAdvice.delegate=self;
            mycomplainAdvice.view.frame = CGRectMake(0, 110, kWidth, kHeight-110 );
            [self.view addSubview:mycomplainAdvice.view];
            
            break;
    }
    
}

#pragma mark - 第一页签地图相关

// MARK:- 添加刷新按钮
- (void) addbtnS  {
    _callBackButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 157, 64, 27)];
    _callBackButton.hidden = YES;
    _callBackButton.layer.cornerRadius = 10;
    _callBackButton.layer.masksToBounds = YES;
    _callBackButton.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    _callBackButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_callBackButton setTitle:@"点击回拨" forState:UIControlStateNormal];
    [_callBackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_callBackButton addTarget:self action:@selector(copylinkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_callBackButton];
    
    _seeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 199, 64, 27)];
    _seeButton.hidden = YES;
    _seeButton.layer.cornerRadius = 10;
    _seeButton.layer.masksToBounds = YES;
    _seeButton.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
    _seeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_seeButton setTitle:@"点击监控" forState:UIControlStateNormal];
    [_seeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_seeButton addTarget:self action:@selector(noMonitoring) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_seeButton];
    
    //static dispatch_once_t onceToken=0;
    //dispatch_once(&onceToken, ^{
    UIButton *bbtn = [[UIButton alloc]init];
    bbtn.frame = CGRectMake(kWidth - 74, 157, 64, 27);
    //bbtn.backgroundColor = [UIColor colorWithRed:51.f/255.0 green:51.f/255.0 blue:51/255.0 alpha:0.3];
    //[bbtn setTitle:@"刷新" forState:UIControlStateNormal];
     [bbtn setImage:[UIImage imageNamed:@"dlxx_refresh"] forState:UIControlStateNormal];
     bbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    bbtn.titleLabel.textColor = [UIColor blackColor];
     [bbtn addTarget:self action:@selector(updateDatas:) forControlEvents:UIControlEventTouchUpInside];
       btnS=bbtn;
        [self.view addSubview:btnS];

    //});
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


-(void)getSchoolCourse2
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *WYID = [defaults objectForKey:@"WYID"];
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/AppSendVideoMachineMsg?fromAccid=%@&LiftID=%@&roomId=%@",WYID,sendArr.LiftId,_roomid];
    
    if (!_isMonitoring) {
        currUrl=[NSString stringWithFormat:@"NeteaseMi/AppSendVideoMachineMsg?fromAccid=%@&LiftID=%@&roomId=%@&isMonitoring=false",WYID,sendArr.LiftId,_roomid];
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
-(void)joinRoom {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *WYID = [defaults objectForKey:@"WYID"];
    NIMChatroomMember *userinfo = [[NIMChatroomMember alloc]init];
    userinfo.userId = WYID;
    
    NIMChatroom *chatroom = [[NIMChatroom alloc]init];
    chatroom.name = _roomid ;
    chatroom.roomId = _roomid;
    chatroom.creator=WYID;
    
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = chatroom.roomId;
    [[NSUserDefaults standardUserDefaults] setObject:request.roomId forKey:@"cachedRoom"];

    [[NTESMeetingManager sharedInstance] cacheMyInfo:userinfo roomId:request.roomId];
    [[NTESMeetingRolesManager sharedInstance] startNewMeeting:userinfo withChatroom:chatroom newCreated:NO];
    UINavigationController *nav = self.navigationController;
    NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithChatroom:chatroom];
    vc.charRoomName = _roomid;
    vc.JSTXType = @"2";
    vc.isCall=1;
    [nav pushViewController:vc animated:NO];
    NSMutableArray *vcs = [nav.viewControllers mutableCopy];
    nav.viewControllers = vcs;
 
}
-(void)addRoomErr:(NSString *)msg
{
    self.app.meetingRoomNumber=@"";
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)selectDataOk:(NSString *)msg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

// MARK:- 添加刷新按钮调用方法
- (void) updateDatas:(id)sender{
  
    [self requestAnimationData];
}

// MARK:- 添加大头针时的网络请求回调方法
- (void)requestAnimationData{
  
   
    [self showPointInfo:false];
    [self requestAnimationData:1 forpid:@"1"];
    
  }



// MARK:- 大头针的网络请求数据
- (void)requestAnimationData: (int) uId forpid: (NSString*) pId
{
    _allXY=[[NSMutableArray alloc]init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self PointAnnotationDelAll];
    arr=[[NSMutableArray alloc]init];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:app.userInfo.UserID forKey:@"UserId"];
    [dic_args setObject:@"-1" forKey:@"PhoneId"];
    //let  phoneId = CFStringCreateCopy( nil, CFUUIDCreateString( nil, CFUUIDCreate( nil ) ))
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%i",1] forHTTPHeaderField:@"PageIndex"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:@"20" forHTTPHeaderField:@"PageSize"];
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:@"Task/GetTaskList"
     
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"state"] intValue];
            if (state_value==0) {
                allTags=[[dic_result objectForKey:@"Data"] objectFromJSONString];
               
                for (NSMutableDictionary *dic_item in allTags ){
                    //warningElevatorModel
                     warningElevatorModel *model=[[warningElevatorModel alloc] init];
                    model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CreateTime"]];
                    model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                    model.LiftId=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftId"]] ;
                    model.StatusName=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"StatusName"]];
                    model.RescueType=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueType"]];
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"TotalLossTime"]];
                    NSDictionary* dic_item3=[dic_item objectForKey:@"Lift"];
                    warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                    lift.BaiduMapXY=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapXY"]];
                      lift.BaiduMapZoom=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapZoom"]];
                    lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftNum"]];
                    lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"InstallationAddress"]];
                    lift.AddressPath=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"AddressPath"]];
                    
                    model.Lift=lift;
                    [arr addObject:model];
                    
                    //pointAnnotation
                    showPaopao=0;
                     [self PointAnnotationAdd:model forZoom:0];
                    [_allXY addObject:model];
                }
                [self  setCenterAndZoom];
                [MBProgressHUD showSuccess:[NSString stringWithFormat:@"共%lu%@",(unsigned long)allTags.count,@"个救援内容!"] toView:nil];
            }
             else
             {
                 [self showAlter:@"获取列表失败！"];
             }
         }
         else
         {
             [self showAlter:@"获取列表失败！"];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取列表失败！"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];

}

#pragma mark - 地图自定义事件
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPointAnnotation *old=(BMKPointAnnotation *)annotation;
    NSArray *info= [old.subtitle componentsSeparatedByString:@","];
    if(info.count<3)return nil;
    
    
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    if([[info objectAtIndex:0] isEqual:@"1"]){
        annotationView.image =[UIImage imageNamed:@"alarm_36dp.png"];
    }
    else
    {annotationView.image =[UIImage imageNamed:@"rescue_36dp.png"];
    }

   
    //if(paopaoCount==0)
    //{
        //自定义内容气泡
        UIView *areaPaoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
        areaPaoView.layer.cornerRadius=20;
        areaPaoView.layer.masksToBounds=YES;
        areaPaoView.backgroundColor=[UIColor whiteColor];
    
    UIButton *img=[UIButton buttonWithType:UIButtonTypeCustom];
    if([[info objectAtIndex:0] isEqual:@"1"]){
    [img setImage:[UIImage imageNamed:@"alarm_36dp.png"]  forState: UIControlStateNormal];
    }
    else
    {[img setImage:[UIImage imageNamed:@"rescue_36dp.png"]  forState: UIControlStateNormal];}

    img.frame=CGRectMake(0, 10, 30, 30);
    [areaPaoView addSubview:img];
    
            UILabel * labelNo = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 200, 30)];
            labelNo.text =[info objectAtIndex:1];
            labelNo.textColor = [UIColor blackColor];
            labelNo.backgroundColor = [UIColor clearColor];
            [areaPaoView addSubview:labelNo];
    
            UILabel * labelStationName = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, 300, 30)];
            labelStationName.text =[info objectAtIndex:2];
            labelStationName.textColor = [UIColor blackColor];
            labelStationName.backgroundColor = [UIColor clearColor];
            [areaPaoView addSubview:labelStationName];
    
    if([[info objectAtIndex:0] isEqual:@"2"]&&![[info objectAtIndex:2]  isEqual:@"<null>"])
    {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"ic_phone_forwarded_black_24dp.png"]  forState: UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"ic_phone_forwarded_black_24dp.png"]  forState: UIControlStateSelected];
        btn.frame=CGRectMake(170, 22, 21, 21);
        btn.tag=[[info objectAtIndex:2]  longLongValue];
        
        [btn addTarget:self action:@selector(addClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [areaPaoView addSubview:btn];
    }

    
        BMKActionPaopaoView *paopao=[[BMKActionPaopaoView alloc]initWithCustomView:areaPaoView];
        annotationView.paopaoView=nil;
        annotationView.paopaoView=paopao;
        paopaoCount=1;
    
        if(showPaopao==1)
            [annotationView setSelected:YES];
    //}

     
    
    
        return annotationView;
    }

// MARK: - UIButton点击事件
-(void)  addClickBtn:(UIButton *)btn {
    
    NSString *srt_url=[NSString stringWithFormat:@"tel://%ld", btn.tag];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:srt_url]];
    
}

#pragma mark - 地图委托
// MARK:- 一个大头针的网络请求数据闭包调用方法
- (void)requestOneBignNeedle: (double)currlatitude
{
   
    if (arr.count >= 0) {
        for (warningElevatorModel *ss in arr ){
            NSArray *s = [ss.Lift.BaiduMapXY componentsSeparatedByString:@","];
            if(s.count<2)continue;
            if ([[s objectAtIndex:1] doubleValue] ==  currlatitude){
                [self requestOneBignNeedleByID:ss.ID];
            }
        }
    }
    
}
// MARK:- 一个大头针的网络请求数据闭包调用方法
- (void)requestOneBignNeedleByID: (NSString *)TaskID
{
    //paopaoCount=0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                NSString *string = [@"Task/GetTask?id=" stringByAppendingString:TaskID];
                [[AFAppDotNetAPIClient sharedClient]
                 GET:string
                 
                 parameters:nil
                 progress:^(NSProgress * _Nonnull uploadProgress) {
                     
                 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     NSLog(@"success:%@",responseObject);
                     
                     
                     NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                     NSDictionary* dic_result=[str_result objectFromJSONString];
                     
                     if (dic_result.count>0) {
                         int state_value=[[dic_result objectForKey:@"state"] intValue];
                         if (state_value==0) {
                             NSDictionary* dic_item=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                             
                                 //warningElevatorModel
                                 warningElevatorModel *model=[[warningElevatorModel alloc] init];
                                 model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CreateTime"]];
                                 model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                                 model.LiftId=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftId"]] ;
                                 NSDictionary* dic_item3=[dic_item objectForKey:@"Lift"];
                                 warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                                 lift.BaiduMapXY=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapXY"]];
                                 lift.BaiduMapZoom=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapZoom"]];
                                 lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftNum"]];
                                 lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"InstallationAddress"]];
                                 lift.AddressPath=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"AddressPath"]];
                                 model.Lift=lift;
                             model.StatusName=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"StatusName"]];
                             if([model.StatusName isEqual:@"<null>"])
                             {model.StatusName=@"";}
                             model.StatusId=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"StatusId"]];
                             model.RescueType=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueType"]];
                             model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"TotalLossTime"]];
                             
                             //选择一个大头针
                             lift.CertificateNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"CertificateNum"]];
                             lift.MachineNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"MachineNum"]];
                             lift.CustomNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"CustomNum"]];
                             lift.Brand=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"Brand"]];
                             lift.Model=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"Model"]];
                             
                             
                             //使用场所
                             NSString* arr_LiftSiteDict=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftSiteDict"]];
                             if(![arr_LiftSiteDict isEqual:@"<null>"])
                             {
                                 NSDictionary* dic_LiftSiteDict=[dic_item3 objectForKey:@"LiftSiteDict"];
                                 lift.LiftSiteDict=[NSString stringWithFormat:@"%@",[dic_LiftSiteDict objectForKey:@"DictName"]];
                             }
                             

                             //电梯类型
                             NSString* arr_LiftTypeDict=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftTypeDict"]];
                             if(![arr_LiftTypeDict isEqual:@"<null>"])
                             {
                                 NSDictionary* dic_LiftTypeDict=[dic_item3 objectForKey:@"LiftTypeDict"];
                                 lift.LiftTypeDict=[NSString stringWithFormat:@"%@",[dic_LiftTypeDict objectForKey:@"DictName"]];
                             }
                             
                             //使用单位
                             NSString* arr_UseDepartment=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"UseDepartment"]];
                             if(![arr_UseDepartment isEqual:@"<null>"])
                             {
                                 NSDictionary* dic_UseDepartment=[dic_item3 objectForKey:@"UseDepartment"];
                                 lift.UseDepartment=[NSString stringWithFormat:@"%@",[dic_UseDepartment objectForKey:@"DeptName"]];
                             }
                             //管理人员
                             lift.UseUsers=[dic_item3 objectForKey:@"UseUsers"];
                             //维保人员
                             lift.MaintUsers=[dic_item3 objectForKey:@"MaintUsers"];
                             //二级维保单位
                             lift.Maint2Users=[dic_item3 objectForKey:@"Maint2Users"];
                             //3级维保单位
                             lift.Maint3Users=[dic_item3 objectForKey:@"Maint3Users"];
                             
                             //维保单位
                             NSString* arr_MaintenanceDepartment=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"MaintenanceDepartment"]];
                             if(![arr_MaintenanceDepartment isEqual:@"<null>"])
                             {
                                 NSDictionary* dic_MaintenanceDepartment=[dic_item3 objectForKey:@"MaintenanceDepartment"];
                                 lift.MaintenanceDepartment=[NSString stringWithFormat:@"%@",[dic_MaintenanceDepartment objectForKey:@"DeptName"]];
                             }
                             //任务来源
                             NSString* arr_SourceDict=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"SourceDict"]];
                             if(![arr_SourceDict isEqual:@"<null>"])
                             {
                                 NSDictionary* dic_SourceDict=[dic_item objectForKey:@"SourceDict"];
                                 model.SourceDict=[NSString stringWithFormat:@"%@",[dic_SourceDict objectForKey:@"DictName"]];
                             }
                             //救援人员
                             NSString* arr_RemedyUser=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RemedyUser"]];
                             if(![arr_RemedyUser isEqual:@"<null>"])
                             {
                                 NSDictionary* dic_RemedyUser=[dic_item objectForKey:@"RemedyUser"];
                              
                                 NSString *userName=[NSString stringWithFormat:@"%@",[dic_RemedyUser objectForKey:@"UserName"]];
                                 NSString *Mobile=[NSString stringWithFormat:@"%@",[dic_RemedyUser objectForKey:@"Mobile"]];
                                 model.RemedyUserPhone=Mobile;
                                 model.RemedyUser = [userName stringByAppendingString:@"("];
                                 model.RemedyUser  = [model.RemedyUser  stringByAppendingString:Mobile];
                                 model.RemedyUser  = [model.RemedyUser  stringByAppendingString:@")"];
                                 model.RemedyUserId=[dic_RemedyUser objectForKey:@"ID"];//[dic_item objectForKey:@"ID"];
                             }

                             
                             model.UseConfirmTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UseConfirmTime"]];
                             model.RescueNumber=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueNumber"]];
                             model.RescuePhone=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescuePhone"]];
                             model.Content=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"Content"]];
                             model.RescueCompleteTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueCompleteTime"]];
                             model.MaintConfirmTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintConfirmTime"]];
                             [self  OneBignNeedle:model];
                             
                             
                         }
                         else
                         {
                             [self showAlter:@"获取数据失败！"];
                         }
                         
                     }
                     else
                     {
                         [self showAlter:@"获取数据失败！"];
                     }
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     NSLog(@"error:%@",[error userInfo] );
                     [self showAlter:@"获取数据失败！"];
                 }];
[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    

}

//MARK:- 一个大头针的数据绑定
-(void)OneBignNeedle:(warningElevatorModel *) _warningElevatorModel{
    //1.CreateTime 并且 计算totalTime
     NSArray *Time = [_warningElevatorModel.CreateTime componentsSeparatedByString:@"."];
    NSArray *cTime = [[Time objectAtIndex:0] componentsSeparatedByString:@"T"];
    NSString *totalTimeStr = [[cTime objectAtIndex:0] stringByAppendingString:@" "];
    totalTimeStr = [totalTimeStr stringByAppendingString:[cTime objectAtIndex:1]];
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[dateFormat dateFromString:totalTimeStr];
    int totalTime = (int)
                        (
                         [[NSDate date] timeIntervalSince1970] - [date timeIntervalSince1970]
                         ) / 60;
     [eV changeLableText:[cTime objectAtIndex:0] for2:[cTime objectAtIndex:1] for4:[NSString stringWithFormat:@"%d",totalTime]  for6:@"" for7:@""  for9:@"" for10:@""];
    
    
    //2.接单时间
    NSArray *Rtime = [_warningElevatorModel.MaintConfirmTime componentsSeparatedByString:@"."];
    if (_warningElevatorModel.MaintConfirmTime != nil &&Rtime.count==2){
         NSArray *receiveTime =[[Rtime objectAtIndex:0] componentsSeparatedByString:@"T"];
        [eV changeLableText:[cTime objectAtIndex:0] for2:[cTime objectAtIndex:1] for4:[NSString stringWithFormat:@"%d",totalTime]  for6:[receiveTime objectAtIndex:0] for7:[receiveTime objectAtIndex:1]  for9:@"" for10:@""];
        
        
        //3.完成时间
        NSArray *Rtime1 = [_warningElevatorModel.RescueCompleteTime componentsSeparatedByString:@"."];
        if (_warningElevatorModel.RescueCompleteTime != nil &&Rtime1.count==2){
            NSArray *receiveTime1 =[[Rtime1 objectAtIndex:0] componentsSeparatedByString:@"T"];
            [eV changeLableText:[cTime objectAtIndex:0] for2:[cTime objectAtIndex:1] for4:[NSString stringWithFormat:@"%d",totalTime]  for6:[receiveTime objectAtIndex:0] for7:[receiveTime objectAtIndex:1]  for9:[receiveTime1 objectAtIndex:0] for10:[receiveTime1 objectAtIndex:1]];
        }

     }
    
    
   
    //从StatusTable表里查询数据
    NSMutableArray *statusArr=[self Link_Database_status:_warningElevatorModel.StatusId];
    
    [self OneControl:_warningElevatorModel forStatusTable:statusArr];
    

}



//一个大头针的数据绑定-- 流程控制
-(void)OneControl:(warningElevatorModel *) _warningElevatorModel forStatusTable:(NSMutableArray *)statusArr{
    sendArr = [[warningElevatorModel alloc]init];
    sendArr = _warningElevatorModel;
    
    showPaopao=1;
    [self PointAnnotationAdd:sendArr forZoom:15];
    [self AddResueButton:_warningElevatorModel forStatusTable:statusArr];
   
    
   
}
typedef enum {
    AFEncapsulationBoundaryPhase = 1,
    AFHeaderPhase                = 2,
    AFBodyPhase                  = 3,
    AFFinalBoundaryPhase         = 4,
} AFHTTPBodyPartReadPhase;


typedef enum
{
    /// 已报警，等待确认
    Init = 0,
    
    /// 已确认，等待维保回复
    Confirm = 11,
    
    /// 误报
    Omit = 12,
    
    /// 确认超时，等待维保回复
    ConfirmTimeout = 13,
    
    /// 无连续报警，需进一步确认
    One = 14,
    
    /// 已接单，等待应急人员到场
    Receive = 21,
    
    /// 已接单，等待维保人员到场
    Weibao = 22,
    
    /// 维保弃单，等待应急人员接单
    Push = 23,
    
    /// 维保接单超时，等待应急人员处理
    Timeout = 24,
    
    /// 已接单，等待应急人员到场
    Level3 = 25,
    
    /// 维保接单超时，等待应急人员接单
    WeibaoTimeout = 26,
    
    /// 已到场，正在救援
    Arrive = 31,
    
    /// 完成救援，尚未评价
    Finish = 41,
    
    /// 完成救援，完成评价
    Evaluate = 51,
}EnumTaskStatus;

-(void)AddResueButton:(warningElevatorModel *) task forStatusTable:(NSMutableArray *)actions
//private void AddResueButton(ViewGroup linearLayout, IReadOnlyCollection<StatusAction> actions, TaskEntity info)
{
    [sendStatus removeAllObjects];
    for(UIView *view in viewOP.subviews)
    {
        [view removeFromSuperview];
    }
    
    if (actions.count == 0) return;
    
       //已接单的救援只显示接单人员定位
      NSArray *taskStatus = [NSArray arrayWithObjects:
                        [NSString stringWithFormat:@"%d",ConfirmTimeout],[NSString stringWithFormat:@"%d",Push],
                             [NSString stringWithFormat:@"%d",Timeout], [NSString stringWithFormat:@"%d",WeibaoTimeout],nil];
    
     NSArray *roleCodes = [NSArray arrayWithObjects:@"SoftDeptRole",@"12365DeptRole",@"ProvinDeptRole", @"CityDeptRole",nil];
    

    //人工派单
    if ([roleCodes containsObject:app.userInfo.DeptRoleCode] && [taskStatus containsObject:task.StatusId])
    {
        [self GetMaintUsers:[task.ID intValue]];
    }
    
    NSMutableArray *userType = [self GetUserType:task ];
    
    //正常救援流程
    int countbtn=0;
    buttonIdNameList=[NSMutableArray new];
    for (StatusTable* item in actions){
        for (int i = 0; i < userType.count; i ++) {
            NSString *curruser=[userType objectAtIndex: i];
            NSString *curritem=item.UserType;
            if  (![curruser  isEqualToString:curritem]   ){
                continue;
            }
            
         UIButton * btn =[self CreateRescueBtn:countbtn+1000 foractionName:item.ActionName];//MethodHelper.DynamicResId
            
            
         [btn addTarget:self action:@selector(btnOPClick:) forControlEvents:UIControlEventTouchUpInside];
         [sendStatus addObject:item];
   
           
    [viewOP addSubview:btn];
    //frame
    countbtn=countbtn+1;
    }
    }
    
    if(countbtn==1)
    {
      UIButton *btn=[viewOP viewWithTag:0+1000];
      btn.frame=CGRectMake(0, 0,49 ,btn.frame.size.height);
    }
    else if(countbtn>0)
    {
        //float currwidth=bounds_width.size.width/countbtn;
        //float currleft=(currwidth-100)/2;
        for (int i = 0; i <= countbtn; i ++) {
            UIButton *btn=[viewOP viewWithTag:i+1000];
            //btn.frame=CGRectMake(currwidth*i+currleft, 0,49,btn.frame.size.height);//100 , 30);
            btn.frame=CGRectMake(0, (57+10)*i,49,btn.frame.size.height);//100 , 30);
        }
    }
}

-(void)setLocationTime:(long)tag{
    for (NSDictionary *dic in buttonIdNameList) {
        if([dic[@"tag"] isEqual:[NSString stringWithFormat:@"%ld",tag] ])
        {
            if([dic[@"name"] isEqual:@"接单"])
            {
                locationTime=20;
            }
            else if([dic[@"name"] isEqual:@"确认到场"])
            {
                locationTime=300;
            }
        }
    }
}

- (void) btnOPClick:(id)sender{
    UIButton *currBtn=(UIButton*)sender;
    [self setLocationTime:currBtn.tag];
    //2
    long tag=currBtn.tag-1000;
    
     if (sendArr != NULL)
     {
         warningElevatorModel *task =[[warningElevatorModel alloc]init];
         task.ID=sendArr.ID;//info.TaskId
         task.CreateTime=sendArr.CreateTime;
        
         StatusTable *item=[sendStatus objectAtIndex:tag ];
         
         StatusTable *status = [self GetStatusActionByArg:item.Argument];
     if (status.StatusId == nil)
     {
     task.StatusId = item.Argument;
     task.StatusName = item.ActionName;
     }
     else
     {
     task.StatusId = status.StatusId;
     task.StatusName = status.StatusName;
     }
     
     switch ([task.StatusId intValue])
     {
     case Confirm:
     case Omit:
     case ConfirmTimeout:
     case Evaluate:
     task.ConfirmUserId = app.userInfo.UserID;
     break;
     case Receive:
     case Weibao:
     case Push:
     case Timeout:
     case Level3:
     case WeibaoTimeout:
     case Arrive:
     case Finish:
     task.RemedyUserId = app.userInfo.UserID;
     break;
     }
     //救援完成
     if ([item.Argument intValue] == Finish)
     {
         RescueCompleteViewController * cdvc=[[RescueCompleteViewController alloc] initWithNibName:@"RescueCompleteViewController_s" bundle:nil];
          cdvc.task=task;
         [self.tabBarController.navigationController pushViewController:cdvc animated:YES];
     }
     //救援评价
     else if ([item.Argument intValue] == Evaluate)
     {
     
         RescueEvaluationViewController * cdvc=[[RescueEvaluationViewController alloc] initWithNibName:@"RescueEvaluationViewController_s" bundle:nil];
         cdvc.task=task;
         [self.tabBarController.navigationController pushViewController:cdvc animated:YES];
     }
     //误报&调试测试
     else if ([item.Argument intValue] == Omit)
     {
         RescueOmitViewController * cdvc=[[RescueOmitViewController alloc] initWithNibName:@"RescueOmitViewController_s" bundle:nil];
         cdvc.task=task;
         [self.tabBarController.navigationController pushViewController:cdvc animated:YES];
     }
     else
     {
     //除救援评价外的处理
         [self SaveTaskStatus:task];
     
     }
     }
     else
     {
        [self showAlter:@"获取救援任务失败！"];
     }
    
     
   
}


-(void)SaveTaskStatus:(warningElevatorModel *) task
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    
    [dic_args setObject:task.StatusId forKey:@"StatusId"];
    [dic_args setObject:task.StatusName forKey:@"StatusName"];
    if(task.RemedyUserId !=nil)
        [dic_args setObject:task.RemedyUserId forKey:@"RemedyUserId"];
    if(task.ConfirmUserId!=nil)
        [dic_args setObject:task.ConfirmUserId forKey:@"ConfirmUserId"];
    [dic_args setObject:task.CreateTime forKey:@"CreateTime"];
    [dic_args setObject:task.ID forKey:@"ID"];
     [[AFAppDotNetAPIClient sharedClient]
     POST:@"Task/SaveTaskStatus"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         NSString *sms_data=[dic_result objectForKey:@"Data"];
         NSDictionary* dic_data=[sms_data objectFromJSONString];
         BOOL b=[success boolValue];
         if(b!=YES)
         {
             [self showAlter:@"操作失败！"];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             return ;
         }
         else
         {
             [self initView];
             _mapView.hidden=false;
             [self requestAnimationData];

             [MBProgressHUD showSuccess:@"操作成功!" toView:nil];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"操作失败！"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}





-(void) GetMaintUsers:(int) taskId
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *string = [@"Task/GetLocationList?taskId=" stringByAppendingString:[NSString stringWithFormat:@"%d",taskId]];
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                NSMutableArray *allTagswb=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 
                 for (NSMutableDictionary *dic_item in allTagswb ){
                     NSString * baiduX=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"BaiduMapX"]];
                     NSString * baiduY=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"BaiduMapY"]];
                     
                     NSDictionary* dic_item3=[dic_item objectForKey:@"User"];
                     NSString * UserName=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"UserName"]];
                     NSString * Mobile=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"Mobile"]];
                     
                     //pointAnnotation
                     pointAnnotation = [[BMKPointAnnotation alloc]init];
                         double f0=[baiduX doubleValue];
                         double f1=[baiduY doubleValue];
                         CLLocationCoordinate2D coor=CLLocationCoordinate2DMake(f1, f0);
                        pointAnnotation.coordinate = coor;
           
                         
                         NSString *str=@"2,";//1为电梯2为维保
                         str=[str stringByAppendingString:UserName];
                         str=[str stringByAppendingString:@","];
                         str=[str stringByAppendingString:Mobile];
                         pointAnnotation.subtitle =str;
                     
                     showPaopao=0;
                         [_mapView addAnnotation:pointAnnotation];

                 }
                 
                 if (allTagswb.count > 0)
                 {
                     [MBProgressHUD showSuccess:[NSString stringWithFormat:@"附近有%lu%@",(unsigned long)allTagswb.count,@"个应急人员!"] toView:nil];
                 }
                 else
                 {
                     [MBProgressHUD showSuccess:[NSString stringWithFormat:@"附近无应急人员!"] toView:nil];
                 }

             }
             else
             {
                 //[self showAlter:@"获取列表失败！"];
             }
         }
         else
         {
             //[self showAlter:@"获取列表失败！"];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取周边维保失败！"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];

}

-(BOOL) IsHas:(NSMutableArray *) users forValue:(NSString *)value
{
    bool have=false;
    for(int i=0;i<users.count;i++)
    {
        NSDictionary *dic=[users objectAtIndex:i];
        if([dic objectForKey:@"ID"]==value)
            return true;
    }
    return have;
}

-(NSMutableArray*) GetUserType:(warningElevatorModel *) task
{
    NSMutableArray *bRet;
    NSArray *roleCodes = [NSArray arrayWithObjects:@"SoftDeptRole",nil];
    
    //人工派单
    if ([roleCodes containsObject:app.userInfo.DeptRoleCode] )
    {
        //bRet.AddRange(new[] { null, "0", "1" });
        bRet =[NSMutableArray arrayWithObjects:@"", @"0", @"1",nil];
    }
    //当用户为之前改变状态人时
    else if (task.RemedyUserId == app.userInfo.UserID)
    {
        bRet =[NSMutableArray arrayWithObjects:@"", nil];
    }
    //使用单位
    else if ([self IsHas :task.Lift.UseUsers  forValue:app.userInfo.UserID])
    {
        bRet =[NSMutableArray arrayWithObjects: @"0",nil];
    }
    //一级维保单位
    else if ([self IsHas :task.Lift.MaintUsers  forValue:app.userInfo.UserID])
    {
        bRet =[NSMutableArray arrayWithObjects: @"1",nil];
    }
    //二级维保单位
    else if ([self IsHas :task.Lift.Maint2Users  forValue:app.userInfo.UserID])
    {
        bRet =[NSMutableArray arrayWithObjects: @"2",nil];
    }
    //三级维保
    else if ((task.Lift.Maint3Users == nil || task.Lift.Maint3Users.count == 0) ? [self IsHas :task.Lift.Maint2Users  forValue:app.userInfo.UserID] : [self IsHas :task.Lift.Maint3Users  forValue:app.userInfo.UserID])
    {
        bRet =[NSMutableArray arrayWithObjects: @"3",nil];
    }
    //周边维保MaintDeptRoleCode
    else if ([@"MaintDeptRole" isEqual:app.userInfo.DeptRoleCode])
    {
        
        if (Push == (int)task.StatusId || WeibaoTimeout == (int)task.StatusId)
        {
            bRet =[NSMutableArray arrayWithObjects: @"2",nil];
        } else if (Timeout == (int)task.StatusId)
        {
            bRet =[NSMutableArray arrayWithObjects: @"3",nil];
        }
        
    }
    
    return bRet;
}

-(UIButton *) CreateRescueBtn:(int) id foractionName:(NSString*) actionName
{
    //1.
    NSMutableDictionary *dicIdname=[NSMutableDictionary new];
    [dicIdname setObject:[NSString stringWithFormat:@"%d", id] forKey:@"tag"];
     [dicIdname setObject:actionName forKey:@"name"];
    [buttonIdNameList addObject:dicIdname];
    //2.
    UIButton *btn=[[UIButton alloc]init];
   [btn setTitle:actionName forState:UIControlStateNormal];
    btn.tag=id;
    //Id = id
   
    /*
    if ([actionName  isEqual: @"接单"])//绿色
    {
        [btn setBackgroundColor:[UIColor colorWithRed:89.f/255.f green:236.f/255.f blue:0.f/255.f alpha:1]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else if ([actionName  isEqual: @"弃单"] || [actionName  isEqual: @"误报"] || [actionName  isEqual: @"安装调试"])//红色
    {
        [btn setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:34.f/255.f blue:16.f/255.f alpha:1]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else//蓝色
    {
        [btn setBackgroundColor:[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:1]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
     */
    
    NSString *imgName=@"";
    int height=49;
    
    if([actionName rangeOfString:@"接单"].location !=NSNotFound)
    {imgName=@"dlxx_btn_jd";height=49;}
    else if([actionName rangeOfString:@"误报"].location !=NSNotFound)
    {imgName=@"dlxx_btn_wb";height=49;}
    else if([actionName rangeOfString:@"安装调试"].location !=NSNotFound)
    {imgName=@"dlxx_btn_ts";height=49;}
    else if([actionName rangeOfString:@"完成救援"].location !=NSNotFound)
    {imgName=@"dlxx_btn_wcjy";height=57;}
    else if([actionName rangeOfString:@"确认到场"].location !=NSNotFound)
    {imgName=@"dlxx_btn_qrdc";height=57;}
    else if([actionName rangeOfString:@"确认报警"].location !=NSNotFound)
    {imgName=@"dlxx_btn_qrbj";height=57;}
    else if([actionName rangeOfString:@"评价"].location !=NSNotFound)
    {imgName=@"dlxx_btn_pj";height=49;}
    btn.frame=CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width, height);
    [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    btn.layer.masksToBounds = YES; //没这句话它圆不起来
    btn.layer.cornerRadius = 5; //设置图片圆角的尺度
    return btn;
}


#pragma mark - 地图点击事件
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view  {
    
    NSArray *info= [view.annotation.subtitle componentsSeparatedByString:@","];
    if(info.count<3)return ;
    
    if([[info objectAtIndex:0] isEqual:@"1"])
    {
    double currlatitude=view.annotation.coordinate.latitude;
    [self requestOneBignNeedle:currlatitude];
    [self PointAnnotationDelAll];
      [self showPointInfo:true];
    }
  }

#pragma mark - 通用
// MARK:- 一个大头针的数据绑定--显示上方和下方的信息
-(void)AddPointInfo{
    eV = [[elevatorRescueView alloc]init];
    
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    float h3=bounds_width.size.height;
    
    if (size_screen.width==320.0f) {
       eV.view.frame = CGRectMake(0,h3-47-39-66-80, kWidth, 39);
    }
    else
    {
        eV.view.frame = CGRectMake(0, h3-47-45-66-60, kWidth, 39);//45
    }
    
    [self.view addSubview:eV.view];
    
    
    
    viewOP = [[UIView alloc]init];
    viewOP.frame = CGRectMake(bounds_width.size.width-57, 217, 57, 250 );//117+30=147
    [self.view addSubview:viewOP];
    
    /*
    eVToolBar = [[elevatorRescueTooBar alloc]initWithNibName:@"elevatorRescueTooBar" bundle:nil];
    eVToolBar.view.tag=-1;
    //eVToolBar.view.frame = CGRectMake(0, h3-47-30-66, kWidth, 30);
    CGRect rect= eVToolBar.view.frame;
    rect=CGRectMake(0, 60, 700, 30);;//kWidth
    [eVToolBar.view setFrame:rect];
    [self.view addSubview:eVToolBar.view];
    eVToolBar.view.backgroundColor=[UIColor redColor];
     */
    
    //toolBar
    eVToolBar = [[UIView alloc]init];    
    CGRect rect= eVToolBar.frame;
    rect=CGRectMake(0, 110, kWidth, 30);;//kWidth
    [eVToolBar setFrame:rect];
    [self.view addSubview:eVToolBar];
    eVToolBar.backgroundColor=[UIColor whiteColor];
    
    double newWidth=[UIScreen mainScreen].bounds.size.width/2;
    UIButton *_btnHelper=[[UIButton alloc]init];
    _btnHelper.frame=CGRectMake(0, 0, newWidth, 30) ;
    [eVToolBar addSubview:_btnHelper];
    [_btnHelper setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnHelper setTitle:@"救援信息" forState:UIControlStateNormal];
    _btnHelper.tag=0;
    _btnHelper.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [_btnHelper addTarget:self action:@selector(tongzhi_HelperOrPhone:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labLine1=[MyControl createLabelWithFrame:CGRectMake(newWidth, 0, 1, 30) Font:14 Text:@""];
    labLine1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [eVToolBar addSubview:labLine1];

    
    UIButton *_btnPhone=[[UIButton alloc]init];
    _btnPhone.frame=CGRectMake(newWidth+1, 0, newWidth, 30) ;
    [eVToolBar addSubview:_btnPhone];
    [_btnPhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnPhone setTitle:@"电话跟进" forState:UIControlStateNormal];
    _btnPhone.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    _btnPhone.tag=1;
    [_btnPhone addTarget:self action:@selector(tongzhi_HelperOrPhone:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)showPointInfo:(bool)isShow{
    eV.view.hidden=!isShow;
    viewOP.hidden=!isShow;
    eVToolBar.hidden=!isShow;
    _callBackButton.hidden = !isShow;
    _seeButton.hidden = !isShow;
    
//    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
//                                                  message:[NSString stringWithFormat:@"%f", bounds_width.size.height]
//                                                 delegate:nil
//                                        cancelButtonTitle:@"确定"
//                                        otherButtonTitles:nil, nil];
//    [alert show];
    
    
    //eV.view.frame = CGRectMake(0, self.view.frame.size.height-48-45, kWidth, 45);
    eV.view.frame = CGRectMake(0, bounds_width.size.height-48-45, kWidth, 45);//45
}

-(void)PointAnnotationDelAll{
    NSArray *annotations = [NSArray arrayWithArray:_mapView.annotations];
    for (BMKPointAnnotation *annotation in annotations) {
        if (![[annotation class] isMemberOfClass:[BMKUserLocation class]]) {
            [_mapView removeAnnotation:annotation];
           
        }
    }
}
//添加一个地图点
-(void)PointAnnotationAdd:(warningElevatorModel*)model forZoom:(int)zoom
{
    NSArray *s = [model.Lift.BaiduMapXY componentsSeparatedByString:@","];
    if(![self isBlankString :model.Lift.BaiduMapXY] &&s.count==2){
        paopaoCount=0;
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        double f0=[[s objectAtIndex:0] doubleValue];
        double f1=[[s objectAtIndex:1] doubleValue];
        CLLocationCoordinate2D coor=CLLocationCoordinate2DMake(f1, f0);
        if(zoom==0)
        {
        BMKCoordinateSpan span;
        //计算地理位置的跨度
        span.latitudeDelta = 10.0f;
        span.longitudeDelta = 10.0f;
        //得出数据的坐标区域
        BMKCoordinateRegion viewRegion ;
        viewRegion.center=coor;
        viewRegion.span=span;
        
        _mapView.region=viewRegion;
        }
        else
        {
            //得出数据的坐标区域
            BMKCoordinateRegion viewRegion ;
            viewRegion.center=coor;
            
            
            _mapView.region=viewRegion;
            
            [_mapView setZoomEnabled:YES];
            [_mapView setZoomLevel:15];
            
            
        }
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = model.Lift.LiftNum;
        //pointAnnotation.subtitle = model.Lift.InstallationAddress;
        
        NSString *str=@"1,";//1为电梯2为维保
        str=[str stringByAppendingString:model.Lift.LiftNum];
        str=[str stringByAppendingString:@","];
        str=[str stringByAppendingString:model.Lift.InstallationAddress];
        pointAnnotation.subtitle =str;
        
        [_mapView addAnnotation:pointAnnotation];
    }
    else
    {
        //[MBProgressHUD showError:@"有一条纪录无坐标信息!" toView:nil];
    }
    
}


-(UIButton*)findSubButton:(NSString*)tag
{
    for (UIView* subView in self.view.subviews)
    {
        if([subView isKindOfClass:[UIButton class]])
        {
            if(subView.tag==0)
            {
                UIButton *btn=(UIButton *)subView;
                return btn;
            }
        }
    }
    return nil;
}




-(void)showAlter:(NSString *)massage{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:massage
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
    
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(void)createEditableCopyOfDatabaseIfNeeded
{
    // 先判断 sandbox 下面的 documents 子文件夹里面有没有数据库文件 test.sqlite
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"SinodomSQLite.db"];
    BOOL ifFind = [fileManager fileExistsAtPath:writableDBPath];
    if (ifFind)
    {
       //[self Link_Database];
    }
    else{
        NSLog(@"数据库不存在,需要复制");
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"SinodomSQLite" ofType:@"sqlite"];
        BOOL ifSuccess = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!ifSuccess) {
            NSLog(@"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }else {
            NSLog(@"createEditableCopyOfDatabaseIfNeeded 初始化成功");
            //[self Link_Database];
        }
        
    }
    
}


-(NSMutableArray *)Link_Database_status :(NSString *)statusID
{
//    fmdDB=[FMDatabase databaseWithPath: [[NSBundle mainBundle] pathForResource:@"SinodomSQLite" ofType:@"sqlite"]];
    
    fmdDB=[FMDatabase databaseWithPath: [getStateAction getDatabaseFileName]];
    [fmdDB open];
    NSMutableArray *statusarr=[NSMutableArray array];
    NSString *str_sql=@"select * from TL_StatusAction where statusId='";
    str_sql=[str_sql stringByAppendingString:statusID];
    str_sql=[str_sql stringByAppendingString:@"'"];
    
    FMResultSet *result_set=[fmdDB executeQuery:str_sql];
    while ([result_set next]) {
        StatusTable *Entity=[[StatusTable alloc]init];
        Entity.StatusId=[result_set stringForColumn:@"StatusId"];
        Entity.StatusName=[result_set stringForColumn:@"StatusName"];
        Entity.UserType=[result_set stringForColumn:@"UserType"];
        if([[CommonUseClass FormatString: Entity.UserType ] isEqual:@""] )
            Entity.UserType=@"";
        
        Entity.ActionName=[result_set stringForColumn:@"ActionName"];
        Entity.Argument=[result_set stringForColumn:@"Argument"];
        
        [statusarr addObject:Entity];
    }
    
    [fmdDB close];
    return statusarr;
}

-(StatusTable *)GetStatusActionByArg:(NSString *)argument
{
//取第一条

//fmdDB=[FMDatabase databaseWithPath: [[NSBundle mainBundle] pathForResource:@"SinodomSQLite" ofType:@"sqlite"]];
    fmdDB=[FMDatabase databaseWithPath: [getStateAction getDatabaseFileName]];
[fmdDB open];
StatusTable *status=[[StatusTable alloc]init];
NSString *str_sql=@"select * from TL_StatusAction where statusId='";
str_sql=[str_sql stringByAppendingString:argument];
str_sql=[str_sql stringByAppendingString:@"'"];

FMResultSet *result_set=[fmdDB executeQuery:str_sql];
while ([result_set next]) {
    StatusTable *Entity=[[StatusTable alloc]init];
     Entity.StatusId=[result_set stringForColumn:@"StatusId"];
    Entity.StatusName=[result_set stringForColumn:@"StatusName"];
    Entity.UserType=[result_set stringForColumn:@"UserType"];
     if([[CommonUseClass FormatString: Entity.UserType ] isEqual:@""] )
        Entity.UserType=@"";
    
    Entity.ActionName=[result_set stringForColumn:@"ActionName"];
    Entity.Argument=[result_set stringForColumn:@"Argument"];
    
    status=Entity;
    break;
}

[fmdDB close];
return status;
}
//////////////////////////////////old////////////////////////////

- (void)setMapPadding {
    ///地图预留边界，默认：UIEdgeInsetsZero。设置后，会根据mapPadding调整logo、比例尺、指南针的位置，以及targetScreenPt(BMKMapStatus.targetScreenPt)
    _mapView.mapPadding = UIEdgeInsetsMake(0, 0, 28, 0);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _mapView.frame.origin.y + _mapView.frame.size.height - 92, self.view.frame.size.width, 28)];
    label.text = @"已设置mapPadding为(0, 0, 28, 0)";
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    label.alpha = 0.7;
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
}
- (void)addPointAnnotations
{
    NSMutableArray *result=[[NSMutableArray alloc]init];
    
    
     BMKPointAnnotation  * curr = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
        curr.coordinate = coor;
        curr.title = @"test";
        curr.subtitle = @"此Annotation可拖拽!";
    [result addObject:curr];
    
    curr = [[BMKPointAnnotation alloc]init];
    coor.latitude = 40.115;
    coor.longitude = 116.404;
    curr.coordinate = coor;
    curr.title = @"test";
    curr.subtitle = @"此Annotation可拖拽!";
    [result addObject:curr];
    
    [_mapView addAnnotations:result];
    
}

//添加标注
- (void)addPointAnnotation
{
    if (pointAnnotation == nil) {
        pointAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 41.4009490000;
        coor.longitude = 125.3134410000;
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = @"test";
        pointAnnotation.subtitle = @"此Annotation可拖拽!";
    }
    [_mapView addAnnotation:pointAnnotation];
}

// 添加动画Annotation
- (void)addAnimatedAnnotation {
    if (animatedAnnotation == nil) {
        animatedAnnotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = 40.115;
        coor.longitude = 116.404;
        animatedAnnotation.coordinate = coor;
        animatedAnnotation.title = @"我是动画Annotation";
    }
    [_mapView addAnnotation:animatedAnnotation];
}



-(void)viewWillDisappear:(BOOL)animated {
    [BMKMapView enableCustomMapStyle:NO];//关闭个性化地图
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)changeMapAction:(UISegmentedControl *)segment {
    /*
     *注：必须在BMKMapView对象初始化之前设置自定义地图样式，设置后会影响所有地图实例
     *设置方法：+ (void)customMapStyle:(NSString*) customMapStyleJsonFilePath;
     */
    enableCustomMap = segment.selectedSegmentIndex == 1;
    //打开/关闭个性化地图
    [BMKMapView enableCustomMapStyle:enableCustomMap];
}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"BMKMapView控件初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    //    [alert show];
    //    alert = nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: click blank");
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"map view: double click");
}




#pragma mark - 以上是地图








- (void)tongzhi:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"textOne"]);
    
    // NSString *srt_url=[NSString stringWithFormat:@"%@bigBaiduMap.html?longitude=%@&latitude=%@",Ksdby_api,text.userInfo[@"textOne"],text.userInfo[@"textTwo"]];
    signUpViewController *ctvc=[[signUpViewController alloc] init];
    ctvc.actId=text.userInfo[@"textOne"];
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    ctvc.cell=text.userInfo[@"textTwo"];
    //[ctvc setUrl:srt_url];
    //[_delegate SchoolCoursePush_newNaV:ctvc];
    UINavigationController *nav_loginVC1=[[ UINavigationController alloc]initWithRootViewController:ctvc];
    [self presentViewController:nav_loginVC1 animated:YES completion:^{
        
    }];
    
}


-(void)addscvc
{
    scvc=[[EventCourseViewController alloc] init];
    
        
    scvc.tag=@"-1";
//    scvc.view.tag=-1;
    //scvc.dic_school_info=dic_school_info;
    scvc.delegate=self;
    CGRect rect= view_content.frame;
    //rect=CGRectMake(kWidth*2, 0, kWidth, kRestOfHeight);
    rect=CGRectMake(0, 0, kWidth, view_content.frame.size.height);

    [scvc.view setFrame:rect];
    //[firstCollection addSubview:scvc.view];
    [view_content addSubview:scvc.view];
}

#pragma 弹出名细页面
-(void)SchoolCoursePush:(UIViewControllerEx *)vc
{
   [self.navigationController pushViewController:vc animated:YES];
    //UINavigationController *nav_loginVC1=[[ UINavigationController alloc]initWithRootViewController:vc];
    //[self presentViewController:nav_loginVC1 animated:YES completion:^{
        
    //}];

}
-(void)SchoolCoursePush_newNaV:(UIViewControllerEx *)vc:(UIViewControllerEx *)vc
{
    //[self.navigationController pushViewController:vc animated:YES];
    UINavigationController *nav_loginVC1=[[ UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav_loginVC1 animated:YES completion:^{
    
    }];
    
}
//心跳
- (void)mapLocation
{
    nTimeCount=0;
    if(timer==nil)
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

-(void)handleTimer:(id)userinfo{
    
    if (nTimeCount%locationTime==0)  {//300
        nTimeCount=0;
         [_locationManager startUpdatingLocation];
    }
    nTimeCount++;
//    NSLog(@"nTimeCount==%d", nTimeCount);
}

- (void)mapLocation0
{
    
    
    
    __block NSInteger second = 0;
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * locationTime, 0);//300
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second == 0) {
                NSLog(@"locationTime");
                
 [_locationManager startUpdatingLocation];
               
//                NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//
//                NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
//
//                [dic_args setObject:app.userInfo.UserID forKey:@"UserId"];
//                [dic_args setObject:[NSString stringWithFormat:@"%@",idfv] forKey:@"PhoneId"];
//                [dic_args setObject:[NSString stringWithFormat:@"%f",X] forKey:@"BaiduMapX"];
//                [dic_args setObject:[NSString stringWithFormat:@"%f",Y] forKey:@"BaiduMapY"];
//                [dic_args setObject:[NSString stringWithFormat:@"%f,%f",X,Y] forKey:@"LongitudeAndLatitude"];
//
//                NSDate *date = [NSDate date]; // 获得时间对象
//                NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
//                [forMatter setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
//                NSString *dateStr = [forMatter stringFromDate:date];
//
//
//                NSString *my=[NSString stringWithFormat: @"{\"BaiduMapX\" : \"%f\",\"BaiduMapY\" : \"%f\",\"LongitudeAndLatitude\" : \"%f,%f\",\"PhoneId\" : \"%@\",\"UserId\" : %@}",X,Y,X,Y,app.UM_deviceToken,app.userInfo.UserID];
//
//
//                [[AFAppDotNetAPIClient sharedClient_token]
//                 POST:@"Location/SaveLocation"
//                 parameters:my//dic_args
//                 progress:^(NSProgress * _Nonnull uploadProgress) {
//
//                 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                     NSLog(@"success:%@",responseObject);
//
//                     NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//                     NSDictionary* dic_result=[str_result objectFromJSONString];
//
//
//                     NSLog(@"dic_result==%@",dic_result);
//
//                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                     NSLog(@"error:%@",[error userInfo] );
//                 }];
                
                
                
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                NSLog(@"++++++++=2");
                
            }
        });
    });
    //启动源
    dispatch_resume(timer);
}

-(void)addLocation{
    SaveLocationClass *class=[[SaveLocationClass alloc ]init];
    class.BaiduMapX=[NSString stringWithFormat:@"%f",Y];
    class.BaiduMapY=[NSString stringWithFormat:@"%f",X];
    class.LongitudeAndLatitude=[NSString stringWithFormat:@"%f,%f",Y,X];
    class.PhoneId=app.UM_deviceToken;
    class.UserId=app.userInfo.UserID;
    
    NSString *strList=[CommonUseClass classToJson:class];
    
    NSLog(@"strList==%@",strList);
    
    [HTTPSessionManager
     post:@"Location/SaveLocation"
     parameters:strList
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSLog(@"dic_result==%@",dic_result);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
     }];
}


#pragma mark - BMKLocationManagerDelegate
/**
 *  @brief 当定位发生错误时，会调用代理的此方法。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param error 返回的错误，参考 CLError 。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error
{
    
    NSLog(@"serial loc error = %@", error);
    
}


- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error

{
    
    
    if (error)
    {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
        
        
    } if (location) {//得到定位信息，添加annotation
        if (location.location) {
            NSLog(@"LOC = %@",location.location);
        }
        BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
        
        pointAnnotation.coordinate = location.location.coordinate;
        pointAnnotation.title = @"连续定位";
        if (location.rgcData) {
            pointAnnotation.subtitle = [location.rgcData description];
        } else {
            pointAnnotation.subtitle = @"rgc = null!";
        }
        
        
        
        CLLocationCoordinate2D baiduCoor =location.location.coordinate;
            X = baiduCoor.latitude;
            Y = baiduCoor.longitude;
        
        
        NSLog(@"经纬度==%f==%f",X,Y);
        [self addLocation];
        [_locationManager stopUpdatingLocation];
        
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ac.ybjk.com/ua.php"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {//
        
                //        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //        NSLog(@"result %@",result);
            }];
        
            [task resume];
        
    }
    
    
    
}



/**
 *  @brief 定位权限状态改变时回调函数
 *  @param manager 定位 BMKLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    
    NSLog(@"serial loc CLAuthorizationStatus = %d", status);
    
}



/**
 * BMKLocationManagerShouldDisplayHeadingCalibration:
 *    该方法为BMKLocationManager提示需要设备校正回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 */
- (BOOL)BMKLocationManagerShouldDisplayHeadingCalibration:(BMKLocationManager * _Nonnull)manager
{
    
    
    NSLog(@"serial loc need calibration heading! ");
    return YES;
}

/**
 * BMKLocationManager:didUpdateHeading:
 *    该方法为BMKLocationManager提供设备朝向的回调方法。
 * @param manager 提供该定位结果的BMKLocationManager类的实例
 * @param heading 设备的朝向结果
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
          didUpdateHeading:(CLHeading * _Nullable)heading
{
    
    
    
    NSLog(@"serial loc heading = %@", heading.description);
    
}

//#pragma mark -  定位代理方法
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//
//    CLLocation *loc = [locations objectAtIndex:0];
//
//    X = loc.coordinate.latitude;
//    Y = loc.coordinate.longitude;
//
//    if(!isAddLocation)
//    {
//        [self mapLocation];
//        isAddLocation=1;
//    }
//    //    NSLog(@"经纬度==%f==%f",X,Y);
//
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ac.ybjk.com/ua.php"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {//
//
//        //        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        //        NSLog(@"result %@",result);
//    }];
//
//    [task resume];
//}

//city
- (void)initCity
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    app.SelectCity=[[NSMutableArray alloc]init];
    NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d1 setObject:@"0" forKey:@"tagId"];
    [d1 setObject:@"市(全部)" forKey:@"tagName"];
    [app.SelectCity addObject:d1];

    NSString *string = [@"Address/GetCityList?userId=" stringByAppendingString:[NSString stringWithFormat:@"%@",app.userInfo.UserID]];
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                 NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 for (NSMutableDictionary *dic_item in currArr )
                 {
                     NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                     [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                     [d1 setObject:[dic_item objectForKey:@"Name"]  forKey:@"tagName"];
                     
                     [app.SelectCity addObject:d1];
                 }
             }
             else
             {
                 
             }
         }
         else
         {
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         //[CommonUseClass showAlter:@"获取市列表失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}

- (void)  setCenterAndZoom {
    [_mapView showAnnotations:_mapView.annotations animated:NO];
    int z=_mapView.zoomLevel;
    [_mapView setZoomLevel:z];
//    [self getMax];
//    [self calculateDistance];
//    [self setCenter];
//    [self getLevel];
}

//比较选出集合中最大经纬度
- (void)  getMax {
    self.latitudeList =[NSMutableArray new];
    self.longitudeList=[NSMutableArray new];
    for (int i = 0; i < _allXY.count; i++) {
        warningElevatorModel *model= [_allXY objectAtIndex:i];
        NSArray *s = [model.Lift.BaiduMapXY componentsSeparatedByString:@","];
        if(![self isBlankString :model.Lift.BaiduMapXY] &&s.count==2){
            NSString * f0=[s objectAtIndex:0] ;
            NSString * f1=[s objectAtIndex:1] ;
            [self.latitudeList addObject: f0];
            [self.longitudeList addObject: f1];
        }
    }
    
    maxLatitude = [self getmax:self.latitudeList];
    minLatitude = [self getmin:self.latitudeList];
    maxLongitude =[self getmax:self.longitudeList];
    minLongitude =[self getmin:self.longitudeList];
}

//计算两个Marker之间的距离
- (void)  calculateDistance {
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(minLatitude,minLongitude));
    
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(maxLatitude,maxLongitude));
    
    distance = BMKMetersBetweenMapPoints(point1,point2);
}

//根据距离判断地图级别3-22
- (void)  getLevel{
    //对应缩放级别 21 20  19  18  17   16   15   14    13    12    11     10     9      8      7       6       5       4        3
    NSArray * zoom =[[NSArray alloc]initWithObjects:@"5", @"10", @"20", @"50", @"100", @"200", @"500", @"1000", @"2000", @"5000", @"10000", @"20000", @"25000", @"50000", @"100000", @"200000", @"500000", @"1000000", @"2000000",nil];
    BOOL isSetLevel = NO;
    for (int i = 0; i < zoom.count; i++) {
        int zoomNow = [[zoom objectAtIndex:i]intValue];
        if (zoomNow - distance > 0) {
            isSetLevel = true;
            int level = 21 - (i + 1) + 4;
            //设置地图显示级别为计算所得level
            //mBaiduMap.setMapStatus(MapStatusUpdateFactory.newMapStatus(new MapStatus.Builder().zoom(level).build()));
            //[_mapView setZoomLevel:level];
            break;
        }
    }
    if (!isSetLevel) {
        int level = 5;
        //设置地图显示级别为计算所得level
        //mBaiduMap.setMapStatus(MapStatusUpdateFactory.newMapStatus(new MapStatus.Builder().zoom(level).build()));
        //[_mapView setZoomLevel:level];
    }
}

//计算中心点经纬度，将其设为启动时地图中心
- (void) setCenter {
    CLLocationCoordinate2D center =CLLocationCoordinate2DMake((maxLatitude + minLatitude) / 2,(maxLongitude + minLongitude) / 2);
  
    [self  setCenter:center];
}

//设置地图中心
- (void)  setCenter:(CLLocationCoordinate2D) pt {
    //MapStatusUpdate status = MapStatusUpdateFactory.newLatLng(pt);
    //mBaiduMap.animateMapStatus(status, 1000);
    
    //CGPoint pt1=CGPointMake(pt.latitude, pt.longitude);
    //[_mapView setCenter:pt1];
    //[_mapView setCenterCoordinate:pt animated:NO];
    _mapView.centerCoordinate = pt;//移动到中心点
    
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    annotation.coordinate = pt;
//    annotation.title = @"这里是center";
//    [_mapView addAnnotation:annotation];
    
//    BMKCoordinateSpan span;
//    //计算地理位置的跨度
//    span.latitudeDelta = 10.0f;
//    span.longitudeDelta = 10.0f;
//    //得出数据的坐标区域
//    BMKCoordinateRegion viewRegion ;
//    viewRegion.center=pt;
//    viewRegion.span=span;
//
//    _mapView.region=viewRegion;
    
  
}


-(double)getmax:(NSArray *)list
{
    double max=0;
    for (NSString *curr in list) {
        double currV=[curr doubleValue];
        if(currV>max)max=currV;
    }
    return max;
}
-(double)getmin:(NSArray *)list
{
    double max=99999;
    for (NSString *curr in list) {
        double currV=[curr doubleValue];
        if(currV<max)max=currV;
    }
    return max;
}




#pragma mark - NIMLoginManagerDelegate
- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    app.videoLoginState=@"0";
}

- (void)onMultiLoginClientsChanged
{
    app.videoLoginState=@"0";
}



#pragma mark - NIMChatManagerDelegate

- (void)onRecvMessages:(NSArray *)messages
{
   
}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    if(! app.userInfo.UserID)
    {
        return;
    }
    if([[CommonUseClass  FormatString: app.userInfo.UserID] isEqual:@""])
    {
        return;
    }
    //{"roomId":"100001","creator":"10000032","roomName":"100001"}
    
    if([notification.content isKindOfClass: [NSString class]])
    {
        NSString *newStr= [notification.content stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        newStr= [notification.content stringByReplacingOccurrencesOfString:@"null" withString:@""];
        NSDictionary* userInfo=[newStr objectFromJSONString];
       
        //1
        NSString * roomid= [userInfo objectForKey:@"roomId"];
        NSString * roomName= [userInfo objectForKey:@"roomName"];
        if([[CommonUseClass FormatString: roomid] isEqual:@""]||[[CommonUseClass FormatString:roomName] isEqual:@""])
        {
            return;
        }
        
        if([CommonUseClass meetingIsOver]>0)
        {
            [self.view.window makeToast:@"视频会议未结束,无法接听其他视频会议!" duration:3.0 position:CSToastPositionCenter];
            return;
        }
        
        //3.
        if([app.  meetingRoomNumber isEqual: roomName])
        {
            return;
        }
        
//        if([app.meetingLastMemo isEqual:notification.content])
//        {
//            return;
//        }
        
        //4.
        [self addlocalNotificationForNewVersion:userInfo];
        app.meetingLastMemo=notification.content;
    }
}

- (void)addlocalNotificationForNewVersion:(NSDictionary *)aps {
    // 1.创建通知
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    // 2.设置通知的必选参数
    // 设置通知显示的内容
    localNotification.alertBody = @"请求视频通话";
    
    NSMutableDictionary * userInfo=[[NSMutableDictionary alloc]init];
    [userInfo setObject:aps forKey:@"aps"];
    localNotification.userInfo=userInfo;
    
    localNotification.regionTriggersOnce=YES;
//    // 设置通知的发送时间,单位秒
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
    //解锁滑动时的事件
    //localNotification.alertAction = @"别磨蹭了!";
    //收到通知时App icon的角标
    //localNotification.applicationIconBadgeNumber = 1;
    //推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    // 3.发送通知(? : 根据项目需要使用)
    // 方式一: 根据通知的发送时间(fireDate)发送通知
    //[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // 方式二: 立即发送通知
     [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}


@end
