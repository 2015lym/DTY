//
//  SWJKBandSaveViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/12.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "SWJKBandSaveViewController.h"

@interface SWJKBandSaveViewController ()

@end

@implementation SWJKBandSaveViewController

@synthesize app;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.navigationItem.title=_Title;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initWindow];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    //3.
    YJBJCount=0;
    Longitude=0;
    Latitude=0;
    [MBProgressHUD showSuccess:@"定位中......" toView:nil];
    //启动LocationService
    [_locService startUserLocationService];
}

//点击空白-回收键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [tf_zcCode resignFirstResponder];
    [tf_sbCode resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWindow{
    
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 260)];
    [self.view addSubview:headview];
    
    //1标题60
    UIView * view_head1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 60)];
    view_head1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [headview addSubview:view_head1];
    
    //    UIImageView *img_head1=[MyControl createImageViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, 86) imageName:@"wbdc_bg"];
    //    [view_head1 addSubview:img_head1];
    
    UIImage *stopImage = [UIImage imageNamed:@"backArrow@2x"];
    UIImageView *stopImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 30, stopImage.size.width, stopImage.size.height) imageName:nil];
    stopImageView.userInteractionEnabled=YES;
    stopImageView.image = stopImage;
    [view_head1 addSubview:stopImageView];
    
    UIButton *stop_Btn = [MyControl createButtonWithFrame:CGRectMake(0, 30, 60, 40) imageName:nil bgImageName:nil title:nil SEL:@selector(btnClick_stop:) target:self];
    [view_head1 addSubview:stop_Btn];
    
    UILabel * lab_head1=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width, 20) Font:18 Text:_Title];
    lab_head1.textAlignment = NSTextAlignmentCenter;
    lab_head1.textColor=[UIColor whiteColor];
    [view_head1 addSubview:lab_head1];
    
    //2电梯编号86
    UIView * view_head2=[[UIView alloc]initWithFrame:CGRectMake(0, 60, bounds_width.size.width, 60)];
    [headview addSubview:view_head2];
    
    UIImageView *img_head2=[MyControl createImageViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, 175) imageName:@"NFCBack"];
    [view_head2 addSubview:img_head2];
    
    
    //2.1
    UIImageView *img_head21=[MyControl createImageViewWithFrame:CGRectMake(20, 20, 26, 20) imageName:@"nfc_liftNum"];
    [view_head2 addSubview:img_head21];
    
    UILabel *dtBianHao = [MyControl createLabelWithFrame:CGRectMake(20+10+26, 20, bounds_width.size.width, 20) Font:18 Text:@"电梯编号"];
    dtBianHao.textColor = [UIColor whiteColor];
    //dtBianHao.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao];
    
    dtBianHao_2 = [MyControl createLabelWithFrame:CGRectMake(140, 20, bounds_width.size.width, 20) Font:18 Text:nil];
    dtBianHao_2.textColor = [UIColor whiteColor];
    //dtBianHao_2.textAlignment = NSTextAlignmentCenter;
    
    NSString * LiftNum_show =[_liftNum stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dtBianHao_2.text=LiftNum_show;
    [view_head2 addSubview:dtBianHao_2];
    
    UILabel *dtLine = [MyControl createLabelWithFrame:CGRectMake(20, 45, bounds_width.size.width-40, 1) Font:14 Text:@""];
    dtLine.backgroundColor = [UIColor whiteColor];
    [view_head2 addSubview:dtLine];
    
  
    
    //3地址等69
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 106, bounds_width.size.width, 119)];
    [headview addSubview:view_head3];
    
    
    
    
    
    UILabel *dtWeiBao = [MyControl createLabelWithFrame:CGRectMake(20, 15, 90, 20) Font:14.0 Text:@"注 册 号 码："];
    dtWeiBao.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiBao];
    
    tf_zcCode=[MyControl createTextFildWithFrame:CGRectMake(120, 15, SCREEN_WIDTH-90, 20) Font:14.0 Text:@""];
    tf_zcCode.textColor = [UIColor whiteColor];
    [view_head3 addSubview:tf_zcCode];
    
    
    
    
    
    UILabel *dtWeiZhi = [MyControl createLabelWithFrame:CGRectMake(20, 40, 120, 20) Font:14 Text:@"设备序列号："];
    dtWeiZhi.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiZhi];
    
    tf_sbCode=[MyControl createTextFildWithFrame:CGRectMake(120, 33, SCREEN_WIDTH- 120, 34) Font:14.0 Text:@""];
    tf_sbCode.textColor = [UIColor whiteColor];
    [view_head3 addSubview:tf_sbCode];
   
    
    UILabel *dtWeiZhi_ms = [MyControl createLabelWithFrame:CGRectMake(20, 70, 120, 20) Font:14 Text:@"描 述 内 容："];
    dtWeiZhi_ms.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiZhi_ms];
    
    UILabel *dtWeiZhi_msV = [MyControl createLabelWithFrame:CGRectMake(120, 70, SCREEN_WIDTH- 120, 20) Font:14 Text:nil];
    dtWeiZhi_msV.numberOfLines = 2;
    dtWeiZhi_msV.textColor = [UIColor whiteColor];
    dtWeiZhi_msV.text=@"请确保设备序列号与注册号码的准确性";
    [view_head3 addSubview:dtWeiZhi_msV];
    
    //2
    sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 240, bounds_width.size.width, bounds_width.size.height-240)];
    sc.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sc];
    
    UIButton *UpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [UpBtn setTitle:@"绑定" forState:UIControlStateNormal];
    UpBtn.frame = CGRectMake( 10, 250, SCREEN_WIDTH-20, 40);
    UpBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [UpBtn addTarget:self action:@selector(UpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UpBtn.backgroundColor = [CommonUseClass getSysColor];
    [UpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UpBtn.layer.masksToBounds = YES; //没这句话它圆不起来
    UpBtn.layer.cornerRadius = 5; //设置图片圆角的尺度
    [self.view addSubview:UpBtn];
    
    
}




- (void)band_one:(NSString *)index
{
    UIImageView *imgBack = (UIImageView *)[self.view viewWithTag:(1000+[index intValue])];
    NSString *strback= [@"nfc_back_" stringByAppendingString:index];
    imgBack.image=[UIImage imageNamed:strback];
    UIImageView *imgC = (UIImageView *)[self.view viewWithTag:(2000+[index intValue])];
    NSString *strC= [@"nfc_c_" stringByAppendingString:index];
    imgC.image=[UIImage imageNamed:strC];
}







- (void)aa:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(NSString *)getStrUpdate:(NSString *)NFCCode forID:(NSString *)guid{
    NFCBandClass *ewm_class = [[NFCBandClass alloc]init];
    
    
    ewm_class.LiftId = _liftID;
    ewm_class.NFCCode=NFCCode;
    ewm_class.NFCNum=guid;
    ewm_class.CheckTermName=currDic[@"TermName"];
    NSString *str123=[CommonUseClass classToJson:ewm_class];
    
    
    
    
    //    NSString *str_str=@"[";
    //    str_str=[str_str stringByAppendingString:mutableStr];
    //    str_str=[str_str stringByAppendingString:@"]"];
    
    return str123;
}


- (void)cc{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [CommonUseClass showAlter:@"提交成功"];
    
    [self band_one:currTag];
    
    //
    //    //创建通知
    //    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_success_wyxc" object:nil userInfo:nil];
    //    //通过通知中心发送通知
    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)btnClick_stop:(UIButton *)btn
{
    NSString *msg=MsgBack;
    // 1、初始化
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    // 3、添加取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
    // 4、添加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    // 5、模态切换显示弹出框
    [self presentViewController:alertController animated:YES completion:nil];
    
}



- (void)UpBtnClick:(UIButton *)btn
{
    if(tf_zcCode.text.length<=0)
    {
        [CommonUseClass showAlter:@"请输入注册号码!"];
        return;
    }
    if(tf_zcCode.text.length!=20)
    {
        [CommonUseClass showAlter:@"请输入准确的注册号码!"];
        return;
    }
    
    if(tf_sbCode.text.length<=0)
    {
        [CommonUseClass showAlter:@"请输入设备序列号!"];
        return;
    }
    
    if(Longitude==0 ||Latitude==0)
    {
        [CommonUseClass showAlter:MessageLocation];
        return;
    }
    
    [self getSchoolCourse_bandLift];
    
}

-(void)getSchoolCourse_bandLift
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:tf_sbCode.text forKey:@"SerialNumber"];
    [dicHeader setValue:tf_zcCode.text forKey:@"CertificateNum"];
    [dicHeader setValue:self.app.userInfo.UserID forKey:@"UserId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%f", Longitude] forKey:@"Longitude"];
    [dicHeader setValue:[NSString stringWithFormat:@"%f",Latitude] forKey:@"Latitude"];
    NSString *url=@"Equipments/EquipmentsBind";
    //url=[NSString stringWithFormat:@"%@?LiftNum=%@&CertificateNum=%@",url,_liftNum,tf.text];
    
    [XXNet PostURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(bandLiftOK:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(dd:) withObject:data[@"Message"] waitUntilDone:YES];
        }
    } failure:^(NSError *error) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:MessageResult
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)dd:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)bandLiftOK:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    tf_sbCode.text=@"";
    tf_zcCode.text=@"";
}




/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //[_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"%f",userLocation.location.coordinate.latitude);
    NSLog(@"%f",userLocation.location.coordinate.longitude);
    
    
    float y = _locService.userLocation.location.coordinate.latitude;//纬度
    float x = _locService.userLocation.location.coordinate.longitude;//经度
    //发起反向地理编码检索
    CLLocationCoordinate2D pt1 = (CLLocationCoordinate2D){y, x};
    BMKReverseGeoCodeOption *reverseSearch = [[BMKReverseGeoCodeOption alloc]init];
    reverseSearch.reverseGeoPoint = pt1;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseSearch];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
        //        isLoad=YES;
        
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}



- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //1
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
        Longitude=_locService.userLocation.location.coordinate.longitude;//经度
        Latitude=_locService.userLocation.location.coordinate.latitude;//纬度
        
        
        //[_locService stopUserLocationService];
        
        
    }
}


/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
    //    [self AddData];
}
//地图区域改变完成后会调用此接口
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}
@end
