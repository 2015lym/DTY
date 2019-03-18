//
//  JYTypeViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/25.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "JYTypeViewController.h"
#import "MyControl.h"
@interface JYTypeViewController ()
{
    UIView*headview;
    UILabel *dtBianHao_2;
    UILabel *dtWeiZhi_2;
    UILabel *dtWeiBao_2;
    UILabel *dtdaima_2;
}
@end

@implementation JYTypeViewController
@synthesize app;

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    [self hiddenPop];
     [self getSchoolCourse];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    [self initWindow];
    [self InitPop];
   
    
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

- (void)btnClick_stop:(UIButton *)btn
{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JYGLListWebViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
        }
    }
}
-(void)initWindow{
    
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 220)];
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
    
    UILabel * lab_head1=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width, 20) Font:18 Text:@"检测服务"];
    lab_head1.textAlignment = NSTextAlignmentCenter;
    lab_head1.textColor=[UIColor whiteColor];
    [view_head1 addSubview:lab_head1];
    
    //2电梯编号86
    UIView * view_head2=[[UIView alloc]initWithFrame:CGRectMake(0, 60, bounds_width.size.width, 60)];
    [headview addSubview:view_head2];
    
    UIImageView *img_head2=[MyControl createImageViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, 86) imageName:@"wbdc_bg"];
    [view_head2 addSubview:img_head2];
    
    dtBianHao_2 = [MyControl createLabelWithFrame:CGRectMake(0, 20, bounds_width.size.width, 20) Font:18 Text:nil];
    dtBianHao_2.textColor = [UIColor whiteColor];
    dtBianHao_2.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao_2];
    
    UILabel *dtBianHao = [MyControl createLabelWithFrame:CGRectMake(0, 50, bounds_width.size.width, 20) Font:14 Text:@"电梯编号"];
    dtBianHao.textColor = [UIColor whiteColor];
    dtBianHao.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao];
    
    //3地址等69
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 146, bounds_width.size.width, 69)];
    [headview addSubview:view_head3];
    
    
    
//    UIImageView *img_head21=[MyControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"wb_maintenance"];
//    [view_head3 addSubview:img_head21];
    
//    UILabel *dtWeiBao = [MyControl createLabelWithFrame:CGRectMake(40, 10, 80, 20) Font:14.0 Text:@"上次检测:"];
//    //dtWeiBao.textColor = [UIColor blackColor];
//    [view_head3 addSubview:dtWeiBao];
//
//
//    dtWeiBao_2 = [MyControl createLabelWithFrame:CGRectMake(110, 10, SCREEN_WIDTH-90, 20) Font:14.0 Text:@""];
//    //dtWeiBao_2.textColor = [UIColor greenColor];
//    //dtWeiBao_2.textAlignment = NSTextAlignmentRight;
//    [view_head3 addSubview:dtWeiBao_2];
    
    
    UIImageView *img_head22=[MyControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"address_blue"];
    [view_head3 addSubview:img_head22];
    
    
    UILabel *dtWeiZhi = [MyControl createLabelWithFrame:CGRectMake(40, 10, 80, 20) Font:14 Text:@"电梯位置:"];
    //dtWeiZhi.textColor = [UIColor blackColor];
    [view_head3 addSubview:dtWeiZhi];
    
    dtWeiZhi_2 = [MyControl createLabelWithFrame:CGRectMake(110, 3, SCREEN_WIDTH- 120, 34) Font:14 Text:nil];
    dtWeiZhi_2.numberOfLines = 2;
    //dtWeiZhi_2.textColor = [UIColor blackColor];
    [view_head3 addSubview:dtWeiZhi_2];
    
    //33
    UIImageView *img_head33=[MyControl createImageViewWithFrame:CGRectMake(10, 40, 20, 20) imageName:@"zhuce_code"];
    [view_head3 addSubview:img_head33];
    
    
    UILabel *dtdaima = [MyControl createLabelWithFrame:CGRectMake(40, 40, 80, 20) Font:14 Text:@"注册代码:"];
    [view_head3 addSubview:dtdaima];
    
    dtdaima_2 = [MyControl createLabelWithFrame:CGRectMake(110, 40, SCREEN_WIDTH- 90, 20) Font:14 Text:nil];
    [view_head3 addSubview:dtdaima_2];
    
    
    // 复制按钮
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    copyBtn.frame = CGRectMake(SCREEN_WIDTH- 70, 40, 60, 20);
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [copyBtn addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [view_head3 addSubview:copyBtn];
    
    
    
    UILabel *dtLine = [MyControl createLabelWithFrame:CGRectMake(0, 215, bounds_width.size.width, 5) Font:14 Text:@""];
    dtLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headview addSubview:dtLine];
    
    
    UIImageView *img_2=[MyControl createImageViewWithFrame:CGRectMake(10, 230, 20, 20) imageName:@"date_blue"];
    [headview addSubview:img_2];
    
    UILabel *tag = [MyControl createLabelWithFrame:CGRectMake(40, 230, 180, 20) Font:18 Text:@"请选择检测类型:"];
    //dtWeiZhi.textColor = [UIColor blackColor];
    [headview addSubview:tag];
    
   
    
    view_button=[[UIView alloc]initWithFrame:CGRectMake(0, 146+69, bounds_width.size.width,SCREEN_HEIGHT -146-69)];
    [self.view addSubview:view_button];

    
}

/**
 * 复制链接
 */
- (void)copylinkBtnClick:(UIButton *)sender {
    
    [MBProgressHUD showSuccess:@"复制成功!" toView:self.view];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = dtdaima_2.text;
}

- (void)addButton4:(float)left forTop:(float)top forWidth:(float)width forHeight:(float)height forName:(NSString *)name  forName1:(NSString *)name1 forTag:(int)tag forIcon:(NSString*)imageName {
    UIView *view=[[UIView alloc]init];
    view.tag=10000+tag;
    view.frame=CGRectMake(left, top, width, height);
    [view_button addSubview:view];
    
    

    
    
    UIButton *button=[[UIButton alloc]init];
    button.frame=CGRectMake(40, 0, width-80, height);
    [button addTarget:self action:@selector(button_Event:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=tag;
    [button setTitle:name forState:UIControlStateNormal];
    button.layer.masksToBounds = YES; //没这句话它圆不起来
    button.layer.cornerRadius = 8; //设置图片圆角的尺度
    button.backgroundColor=[CommonUseClass getSysColor];
    [view  addSubview:button];
}

- (IBAction)button_Event:(id)sender {
    UIButton *btn=(UIButton *)sender;
    [self goWB:btn.tag];
}
-(void)goWB:(long)tag{
    
    for (NSDictionary *dic in arrayType) {
        if([[CommonUseClass FormatString:dic[@"ID"] ] isEqual:[NSString stringWithFormat:@"%ld",tag ]])
        {
            currdic=dic;
            break;
        }
    }
    if([[CommonUseClass FormatString: currdic[@"State"]] isEqual:@"1"])
    {
        [CommonUseClass showAlter:@"任务已完成"];
        return;
    }
    
    if([[CommonUseClass FormatString: currdic[@"DeptState"]] isEqual:@"1"])
    {
        UIButton *btn=[[UIButton alloc]init];
        btn.tag=0;//公司已经存在时，公司ID传0
        [self btnClick_ReplaceTheElevator:btn];
    }
    else
    {
    [self showPop:tag ];
    }
    

}
-(void)getSchoolCourse
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * liftstr = [_liftNum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url=[NSString stringWithFormat:@"Inspect/GetInspectType?LiftNum=%@",liftstr ];
     [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",liftstr] forHTTPHeaderField:@"LiftNum"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:url
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];

         if (dic_result.count>0) {
             
             if ([[CommonUseClass FormatString: dic_result[@"Message"]] isEqual:@"操作成功"]) {
                 NSDictionary *dict = [[dic_result objectForKey:@"Data"] objectFromJSONString];
                 
                 arrayType = [dict objectForKey:@"InspectType"];
                 
                 
                 InstallationAddress=[dict objectForKey:@"InstallationAddress"];
                 
                 NSString * LiftNum_show =[_liftNum stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 dtBianHao_2.text=LiftNum_show;
                 dtdaima_2.text=[dict objectForKey:@"CertificateNum"];
                 dtWeiZhi_2.text=InstallationAddress;
                 dtWeiBao_2.text=UploadDate;
                 liftID=[dict objectForKey:@"ID"];
                 
                 [self performSelectorOnMainThread:@selector(showWBType) withObject:nil waitUntilDone:YES];
             }
             else
             {
                 [self performSelectorOnMainThread:@selector(showResult:) withObject:dic_result[@"Message"] waitUntilDone:YES];
             }
         }
         else
         {
             [self performSelectorOnMainThread:@selector(showResult:) withObject:@"操作失败" waitUntilDone:YES];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         [self performSelectorOnMainThread:@selector(dd) withObject:nil waitUntilDone:YES];
         
     }];
}

- (void)showResult:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)showWBType{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    int top=60;
    float width=bounds_width.size.width;
    float height=44;
    
    for (NSDictionary *dic in arrayType) {
        NSString *ID=[CommonUseClass FormatString: dic[@"ID"]];
       
        [self addButton4:0 forTop:top forWidth:width forHeight:height forName: dic[@"TypeName"]  forName1:@"" forTag: [ID intValue]  forIcon:@""];
       
        top=top+44+20;
    }
    

    
}

- (void)dd{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[JYGLListWebViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
        }
    }
    
    
    [CommonUseClass showAlter:@"电梯不存在"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//////////////
-(void)InitPop{
    //蒙版
    view_Content_back=[MyControl createViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height) backColor:[UIColor blackColor]];
    view_Content_back.alpha = 0.5;// 阴影透明度
    [self.view addSubview:view_Content_back];
    
    
    view_Content_2=[MyControl createViewWithFrame:CGRectMake(10, 150, self.view.frame.size.width-20, 320) backColor:[UIColor whiteColor]];
    [self.view addSubview:view_Content_2];
    
    
    
//    UIView *viewBack=[MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 160) backColor:[UIColor whiteColor]];
//    viewBack.alpha = 1;// 阴影透明度
//    [view_Content_2 addSubview:viewBack];
    
    [self hiddenPop];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboard:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [view_Content_back addGestureRecognizer:tapGestureRecognizer];
}

//点击空白-回收键盘
-(void)keyboard:(UITapGestureRecognizer*)tap
{
    [self hiddenPop];
}

-(void)showPop:(long)tag
{
    //1.
    for(long i=view_Content_2.subviews.count-1;i>=0;i--)
    {
        id object=view_Content_2.subviews[i];
        [object removeFromSuperview ];
    }
    
    //2.
    int top=0;
    int width=view_Content_2.frame.size.width;
    
    for (NSDictionary *dic in currdic[@"Dept"]) {
      
        [self addButton_dept:0 forTop:top forWidth:width forHeight:44 forName:dic[@"DeptName"] forName1:@"" forTag:[dic[@"DeptId"] intValue] forIcon:@""];
        top=top+44;
    }

  
    view_Content_2.frame=CGRectMake(view_Content_2.frame.origin.x, view_Content_2.frame.origin.y, view_Content_2.frame.size.width, top+10);
    
    
    view_Content_2.hidden=false;
    view_Content_back.hidden=false;
}

- (void)addButton_dept:(float)left forTop:(float)top forWidth:(float)width forHeight:(float)height forName:(NSString *)name  forName1:(NSString *)name1 forTag:(int)tag forIcon:(NSString*)imageName {
    UIView *view=[[UIView alloc]init];
    view.tag=10000+tag;
    view.frame=CGRectMake(left, top, width, height);
    [view_Content_2 addSubview:view];
    
    
    UILabel *selectLabel1 = [MyControl createLabelWithFrame:CGRectMake(20, 12, SCREEN_WIDTH-40, 20) Font:14 Text:name];
    selectLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel1.alpha=1.0;
    selectLabel1.text=name;
    [view addSubview:selectLabel1];
    
    UILabel *line = [MyControl createLabelWithFrame:CGRectMake(0, 43, width, 1) Font:14 Text:@""];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    
    UIButton *btn_1 = [MyControl createButtonWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 44) imageName:nil bgImageName:nil title:@"" SEL:@selector(btnClick_ReplaceTheElevator:) target:self];
//    [btn_1.layer setMasksToBounds:YES];
//    [btn_1.layer setCornerRadius:5.0];
//    [btn_1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    btn_1.tag=tag;
    [view addSubview:btn_1];
}


-(void)hiddenPop{
    view_Content_2.hidden=YES;
    view_Content_back.hidden=YES;
}

- (void)btnClick_ReplaceTheElevator:(UIButton *)btn
{
    if(Longitude==0 ||Latitude==0)
    {
        [CommonUseClass showAlter:MessageLocation];
        return;
    }
    
    JYGLSave *ctvc=[[JYGLSave alloc] init];
        ctvc.Latitude=Latitude;
        ctvc.Longitude=Longitude;
    ctvc.liftNum=_liftNum;
    ctvc.TypeCode=currdic[@"TypeCode"];
    ctvc.InspectDeptId=[NSString stringWithFormat:@"%ld", btn.tag];
    ctvc.TypeId=currdic[@"ID"];
    ctvc.Title=currdic[@"TypeName"];
    ctvc.DectList=currdic[@"Dept"];
    [self.navigationController pushViewController:ctvc animated:YES];
    
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
        
        
        BMKAddressComponent *class=result.addressDetail;
        
        NSString *State =class.province;
        NSString *City = class.city;
        NSString *SubLocality = class.district;
        NSString *Thoroughfare= class.streetName;
        if(Thoroughfare==nil)Thoroughfare=@"";
        NSString *SubThoroughfare=class.streetNumber;
        if(SubThoroughfare==nil)SubThoroughfare=@"";
        
        //1
        NSString *DW=[State stringByAppendingString:City];
        DW=[DW stringByAppendingString:SubLocality];
        DW=[DW stringByAppendingString:Thoroughfare];
        DW=[DW stringByAppendingString:SubThoroughfare];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        
        
        Longitude=_locService.userLocation.location.coordinate.longitude;//经度
        Latitude=_locService.userLocation.location.coordinate.latitude;//纬度
        
        
        [_locService stopUserLocationService];
        
        
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
