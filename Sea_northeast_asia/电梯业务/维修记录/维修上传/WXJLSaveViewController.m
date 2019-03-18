//
//  WXJLSaveViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/4/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "WXJLSaveViewController.h"

@interface WXJLSaveViewController ()

@end

@implementation WXJLSaveViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=_Title;
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    //主页面
    sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    sc.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //sc.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+200);
    sc.userInteractionEnabled=YES;
    [self.view addSubview:sc];
    
    [self initWindow];
    //增加监听，键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [txtbz resignFirstResponder];
    
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect rect=self.view.frame;
    
    int currTop=0;//rect.origin.y;
    
    sc.frame=CGRectMake(rect.origin.x,currTop,rect.size.width, rect.size.height-keyboardRect.size.height);//rect.origin.y
    [sc setContentSize:rect.size];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    //if(first==1)
    //{sc.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);}
    //else
        sc.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-0);//self.view.frame;
    [sc setContentSize:CGSizeMake(0, 0)];
}
-(void)initWindow{
    
    UIView * headview0=[[UIView alloc]initWithFrame:CGRectMake(0, 00, bounds_width.size.width, 10)];
    [sc addSubview:headview0];
    headview0.backgroundColor=[UIColor whiteColor];
    
    //1
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 10, bounds_width.size.width, 100)];
    [sc addSubview:headview];
    headview.backgroundColor=[UIColor whiteColor];
    

    

    UILabel * _labBack=[[UILabel alloc]init];
    UIView * _viewRight=[[UIView alloc]init];
    UILabel * _labLine=[[UILabel alloc]init];
    _labLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
    UILabel * _labStatus=[MyControl createLabelWithFrame:CGRectMake(10,68, bounds_width.size.width-73-52,24) Font:15 Text:@""];
     _labStatus.textColor=[UIColor grayColor];
    UILabel * _labAddr=[MyControl createLabelWithFrame:CGRectMake(10, 20, bounds_width.size.width-120,40) Font:15 Text:@""];
    _labAddr.numberOfLines=2;
    _labAddr.textColor=[UIColor grayColor];
    UILabel * _labDate=[MyControl createLabelWithFrame:CGRectMake(90, 68, 195,24) Font:15 Text:@""];
    //_labDate.textAlignment=NSTextAlignmentRight;
    _labDate.textColor=[UIColor grayColor];
    
     NSString * LiftNum_show =[_liftNum stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UILabel * _labID=[MyControl createLabelWithFrame:CGRectMake(0, 27, 100,17) Font:15 Text:LiftNum_show];
    _labID.textColor=[UIColor orangeColor];
    _labID.textAlignment=NSTextAlignmentCenter;
    
    [headview addSubview:_labBack];
    [headview addSubview:_viewRight];
    [headview addSubview:_labLine];
    [headview addSubview:_labStatus];
    [_viewRight addSubview:_labAddr];
    [headview addSubview:_labDate];
    [headview addSubview:_labID];
    
    UILabel * _lab1=[MyControl createLabelWithFrame:CGRectMake(0, 2, 100,21) Font:15 Text:@"电梯编号"];
    _lab1.textColor=[UIColor grayColor];
    _lab1.textAlignment=NSTextAlignmentCenter;
    [headview addSubview:_lab1];
    UILabel * _lab2=[MyControl createLabelWithFrame:CGRectMake(10, 2, 70,21) Font:15 Text:@"地址:"];
    _lab2.textColor=[UIColor grayColor];
    [_viewRight addSubview:_lab2];
    UILabel * _line2=[MyControl createLabelWithFrame:CGRectMake(100, 15, 1,40) Font:15 Text:@""];
    _line2.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [headview addSubview:_line2];
    
    _labBack.frame=CGRectMake(0, 0, bounds_width.size.width-3,95);
    _viewRight.frame=CGRectMake(101, 0, bounds_width.size.width-50,80);
    _labLine.frame=CGRectMake(0, 61, bounds_width.size.width,1);
    
    //_liftNum
    _labID.text=LiftNum_show;

    _labStatus.text=@"上次维修:";
    
    //后面的地址
    _labAddr.text=_InstallationAddress;
    
    //time
    UIImageView *img=[[UIImageView alloc]init];
    img.image=[UIImage imageNamed:@"Data_time"];
    img.frame=CGRectMake(bounds_width.size.width-175, _labDate.frame.origin.y+5, 15, 15);
    [headview addSubview:img];
    
    img.hidden=YES;
    if([_UploadDate isEqual:@""])
    {
        _labDate.text=@"尚未维修";
        
    }
    else
    {
        _UploadDate = [_UploadDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        _labDate.text=_UploadDate;
    }
    
    //2.
    UIView * headview2=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headview.frame)+10, bounds_width.size.width, 150)];
    [sc addSubview:headview2];
    headview2.backgroundColor=[UIColor whiteColor];
    
    float currwidth=bounds_width.size.width/2;
    float currLeft=(currwidth-135)/2;
    
    //2.1
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(currLeft, 10, 150, 20)];
    [self setViewImage:@"front.png" Title:@"维修前照片" View:view4 Labelwidth:100];
    [headview2 addSubview:view4];
    
    imgBefore = [[EGOImageView alloc]initWithFrame:CGRectMake(currLeft, CGRectGetMaxY(view4.frame)+10, 135, 102)];
    //imgBefore.contentMode = UIViewContentModeScaleAspectFit;
    
    _BeforePhoto=[CommonUseClass FormatString:_BeforePhoto];
    if(![_BeforePhoto isEqual:@""])
    {
        _BeforePhoto = [_BeforePhoto stringByReplacingOccurrencesOfString:@"~" withString:@""];
        _BeforePhoto=[NSString stringWithFormat:@"%@%@", Ksdby_api_Img,_BeforePhoto];
        NSURL *url = [NSURL URLWithString:_BeforePhoto];
        imgBefore.imageURL=url;
        if(imgBefore.image==nil)
        {
            imgBefore.image=[UIImage imageNamed:@"no_photos.png"];
        }
    }
    else
    {
    imgBefore.image=[UIImage imageNamed:@"wxjl_photo"];
    }
    [headview2 addSubview:imgBefore];
    
    UIButton *_btn_Before=[[UIButton alloc]initWithFrame:imgBefore.frame];
    [headview2 addSubview:_btn_Before];
    _btn_Before.tag=1;
    [_btn_Before addTarget:self action:@selector(btnclick_photo:) forControlEvents:UIControlEventTouchUpInside];
    
    //2.2
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(currLeft+currwidth, 10, 150, 20)];
    [self setViewImage:@"after.png" Title:@"维修后照片" View:view5 Labelwidth:100];
    [headview2 addSubview:view5];
    
    imgAfter = [[EGOImageView alloc]initWithFrame:CGRectMake(currLeft+currwidth, CGRectGetMaxY(view4.frame)+10, 135, 102)];
    //imgAfter.contentMode = UIViewContentModeScaleAspectFit;
    _AfterPhoto=[CommonUseClass FormatString:_AfterPhoto];
    if(![_AfterPhoto isEqual:@""])
    {
        _AfterPhoto = [_AfterPhoto stringByReplacingOccurrencesOfString:@"~" withString:@""];
        _AfterPhoto=[NSString stringWithFormat:@"%@%@", Ksdby_api_Img,_AfterPhoto];
        NSURL *url = [NSURL URLWithString:_AfterPhoto];
        imgAfter.imageURL=url;
        if(imgAfter.image==nil)
        {
            imgAfter.image=[UIImage imageNamed:@"no_photos.png"];
        }
    }
    else
    {
    imgAfter.image=[UIImage imageNamed:@"wxjl_photo"];
    }
    [headview2 addSubview:imgAfter];
    
    UIButton *_btn_After=[[UIButton alloc]initWithFrame:imgAfter.frame];
    [headview2 addSubview:_btn_After];
    _btn_After.tag=2;
    [_btn_After addTarget:self action:@selector(btnclick_photo:) forControlEvents:UIControlEventTouchUpInside];
    
    //3.
    UIView * headview3=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headview2.frame)+10, bounds_width.size.width, 220)];
    [sc addSubview:headview3];
    headview3.backgroundColor=[UIColor whiteColor];
    
    UILabel * _labbz=[MyControl createLabelWithFrame:CGRectMake(20, 10, 100,20) Font:15 Text:@"输入备注："];
    _labbz.textColor=[UIColor grayColor];
    [headview3 addSubview:_labbz];
    
    txtbz=[[UITextView alloc ]initWithFrame:CGRectMake(20, 40, bounds_width.size.width-40 , 100)];
    txtbz.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [headview3 addSubview:txtbz];
    txtbz.text=_Remark;
    
    
    commitButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 150, bounds_width.size.width-40, 44)];
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.backgroundColor = [UIColor colorWithHexString:@"#3574fa"];
    commitButton.layer.masksToBounds = YES;
    commitButton.layer.cornerRadius = 4.0;
    [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headview3 addSubview:commitButton];
}



-(void)commitButtonClick{
    
//    [CommonUseClass showAlter:[NSString stringWithFormat:@"请选择巡查步骤%d",i+1]];
//    return;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    
    [_locService startUserLocationService];
    
    
    //    //3.是否连网
    //    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //    [manager startMonitoring];
    //    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    //
    //        if (status == -1) {
    //            //NSLog(@"未识别网络");
    //            [self thisSaveData:str_str];
    //        }
    //        else if (status == 0) {
    //            //NSLog(@"无网络");
    //            [self thisSaveData:str_str];
    //        }else{
    //            //test
    //            //[self thisSaveData:str_str];
    //            //return;
    //
    //
    //            [self WBupload:str_str];
    //
    //        }
    //    }];
    
    
}

//UIImage图片转成Base64字符串
-(NSString *)ImageToBase64:(UIImage *)originImage
{
    
    NSData *data = UIImageJPEGRepresentation(originImage, 0.2f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
}

-(NSString *)getStrUpdate{
    WXJLClass *ewm_class = [[WXJLClass alloc]init];

    //NSMutableArray *mutableArr = [[NSMutableArray alloc]init];

    ewm_class.UserId = app.userInfo.UserID;
    ewm_class.LiftId=_liftID;
    
    NSString *jw = [NSString stringWithFormat:@"%f,%f",Longitude,Latitude];
    ewm_class.RepairPosition=jw;
    ewm_class.Remark=txtbz.text;

    ewm_class.ID=_ID;
    
    
   NSString *strstr=[CommonUseClass classToJson:ewm_class];
    
    if(have1==1)
    {
        NSString * currImg= [self ImageToBase64:imgBefore.image];
        NSString *str_0=@"\"BeforePhoto\" :\"";
        str_0=[str_0 stringByAppendingString:currImg];
        str_0=[str_0 stringByAppendingString:@"\","];
        
        NSString *d = strstr;
        strstr = [d stringByReplacingOccurrencesOfString:@"\"BeforePhoto\" : null," withString:str_0];
    }
    
    if(have2==1)
    {
        NSString * currImg= [self ImageToBase64:imgAfter.image];
        NSString *str_0=@"\"AfterPhoto\" :\"";
        str_0=[str_0 stringByAppendingString:currImg];
        str_0=[str_0 stringByAppendingString:@"\","];
        
        NSString *d = strstr;
        strstr = [d stringByReplacingOccurrencesOfString:@"\"AfterPhoto\" : null," withString:str_0];
    }

    

        //NSString *str456 = [self addPic:[NSString stringWithFormat:@"%d",i] forAll:str123];

        //[mutableArr addObject:str456];

        //str123 = nil;
        //str456 = nil;


    //NSString *mutableStr = [mutableArr componentsJoinedByString:@","];


//    NSString *str_str=@"[";
//    str_str=[str_str stringByAppendingString:mutableStr];
//    str_str=[str_str stringByAppendingString:@"]"];
    
    return strstr;
}
-(void )WBupload:(NSString *)parm
{
    NSString *currUrl2=@"Repair/SaveRepairNew";
    [HTTPSessionManager
     post:currUrl2
     parameters:parm
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         //         NSLog(@"success====%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         
         NSLog(@"dic_result：%@",dic_result);
         
         if([success integerValue]!=1)
         {
             [self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         }
         else
         {
             [self performSelectorOnMainThread:@selector(cc) withObject:data waitUntilDone:NO];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         
     }];
}


- (void)aa{
    [CommonUseClass showAlter:@"提交失败"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)cc{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [CommonUseClass showAlter:@"提交成功"];
    
    //返回到指定视图控制器
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[WXJLListWebViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_success_wyxc" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

- (void)btnclick_photo:(UIButton *)sender {
    index=sender.tag;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.view.tag=1000;
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    AVAuthorizationStatus authstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authstatus ==AVAuthorizationStatusRestricted || authstatus ==AVAuthorizationStatusDenied) //用户关闭了权限
    {
        [CommonUseClass showAlter:@"相机权限未开启！"];
        return;
    }
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.sourceType = sourceType;
    
 
    [self presentViewController:picker animated:YES completion:^{}];
    
}

//拍照或选择相册后的编辑图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *image;
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            
            if (image!=nil) {
                if(index==1)
                {
                    have1=1;
                    imgBefore.image=image;
                }
                else   if(index==2)
                {
                    have2=1;
                    imgAfter.image=image;
                }
            }
        }];
        
    }else if ([mediaType isEqualToString:@"public.movie"])
    {
        
    }
}



- (void)setViewImage:(NSString*)imgName Title:(NSString*)title View:(UIView*)view Labelwidth:(float)width {
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    img.image = [UIImage imageNamed:imgName];
    [view addSubview:img];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+10, 0, width, 20)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGBACOLOR(131, 145, 177, 1);
    [view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (isLoad) {
        return;
    }
    
    NSLog(@"%f",userLocation.location.coordinate.latitude);
    NSLog(@"%f",userLocation.location.coordinate.longitude);
    
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
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
        isLoad=YES;
        
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        myBMKPointAnnotation* item = [[myBMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        item.nType=1;
        
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
        
        //2
        NSString *DW1=@"";
        DW1=[State stringByAppendingString:@","];
        DW1=[DW1 stringByAppendingString:City];
        DW1=[DW1 stringByAppendingString:@","];
        DW1=[DW1 stringByAppendingString:SubLocality];
        DW1=[DW1 stringByAppendingString:@","];
        DW1=[DW1 stringByAppendingString:Thoroughfare];
        DW1=[DW1 stringByAppendingString:@","];
        DW1=[DW1 stringByAppendingString:SubThoroughfare];
        //        address=DW1;
        
        Longitude=_locService.userLocation.location.coordinate.longitude;//经度
        Latitude=_locService.userLocation.location.coordinate.latitude;//纬度
        
        NSString *str_update=[self getStrUpdate];
        [self WBupload:str_update];
        
       
        
        //        _address.text=DW;
        /*
         if(dic.count>0)
         {
         if(YJBJCount!=0)return ;
         YJBJCount=1;
         NSString *State = [place.addressDictionary valueForKey:@"State"] ;
         NSString *City = [place.addressDictionary valueForKey:@"City"] ;
         NSString *SubLocality = [place.addressDictionary valueForKey:@"SubLocality"] ;
         NSString *Street = [place.addressDictionary valueForKey:@"Street"] ;
         
         DW=[State stringByAppendingString:City];
         DW=[DW stringByAppendingString:SubLocality];
         DW=[DW stringByAppendingString:Street];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         // [self AddYJBJ:DW forLongitude:newLocation.coordinate.longitude forLatitude:newLocation.coordinate.latitude];
         address=DW;
         Longitude=newLocation.coordinate.longitude;
         Latitude=newLocation.coordinate.latitude;
         _address.text=DW;
         super.is_Location=NO;
         [manager stopUpdatingLocation];
         }
         */
        
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
