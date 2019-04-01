//
//  JYGLSave.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "JYGLSave.h"
#import "MyControl.h"
#import "XFCameraController.h"

@interface JYGLSave ()
{
    UIView*headview;
    UILabel *dtBianHao_2;
    UILabel *dtWeiZhi_2;
    UILabel *dtWeiBao_2;
    UILabel *dtdaima_2;
}

@end

@implementation JYGLSave

@synthesize app;

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    app.arrData=[NSMutableArray new];
    
//    UIButton *button = [[UIButton alloc]init];
//    button.frame = CGRectMake(0, 0, 25, 25);
//    [button setImage:[UIImage imageNamed:@"scanning_48dp1"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [button.imageView setContentMode:UIViewContentModeScaleToFill];
//    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithCustomView:button];
//    self.navigationItem.rightBarButtonItem = rightbtn;
    
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    //app.this_video_url=nil;
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    [self initWindow];
    [self InitPop];
    [self getSchoolCourse];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_image:) name:@"showImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_Video:) name:@"showVideo" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_photo:) name:@"showphoto" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_Dater:) name:@"showDater" object:nil];
    
    //添加手势
    UITapGestureRecognizer *Add_TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(View_AddTap:)];
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:Add_TapGesture];
    
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;
        //3.
        YJBJCount=0;
        app.Longitude_curr=0;
        app.Latitude_curr=0;
    //    [MBProgressHUD showSuccess:@"定位中......" toView:nil];
        //启动LocationService
        [_locService startUserLocationService];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_qianrenOK:) name:@"tongzhi_qianrenOK" object:nil];
    
}

- (void)tongzhi_qianrenOK:(NSNotification *)text{
     [_btn_WriteName setTitle:@"已签认" forState:UIControlStateNormal];
}

- (void)View_AddTap:(id)dateTap
{
    [self.view endEditing:YES];
}
- (void)tongzhi_image:(NSNotification *)text{
    NSString *type=(NSString *)text.userInfo[@"textTwo"];
    showImage *ctvc=[[showImage alloc] init];
    if([type isEqual:@"this"])
    {
        UIImage *model=(UIImage *)text.userInfo[@"textOne"];
//        ctvc.image=model;
//        ctvc.type=@"this";
        [self showImage:model];
        return;
    }
    else
    {
        
        NSString *model=(NSString *)text.userInfo[@"textOne"];
        //ctvc.url=model;
        //ctvc.type=@"server";
        UIImage *img=[UIImage imageWithData:[NSData
                                             dataWithContentsOfURL:[NSURL URLWithString:model]]];
        
        [self showImage:img];
        return;
    }
    //[self.navigationController pushViewController:ctvc animated:YES];
}

-(void)showImage:(UIImage *)img{
    item=[[UIImageView alloc]initWithImage:img];
    
    int counts = 1;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:counts];

        // 替换为中等尺寸图片
        MJPhoto *photo = [[MJPhoto alloc] init];
        UIImage *currImage=item.image;
        photo.image=currImage;
        photo.srcImageView=item;
        [photos addObject:photo];
   
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.isShowBar=YES;
    [browser show];
    
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)tongzhi_Video:(NSNotification *)text{
    
    NSString *model=(NSString *)text.userInfo[@"textOne"];
    NSString *type=(NSString *)text.userInfo[@"textTwo"];
    
    
    if([type isEqualToString:@"this"])
    {
        NSString *urlstr=(NSString *)text.userInfo[@"texturl"];
        NSURL *url=[[NSURL alloc]initWithString:urlstr];
        MPMoviePlayerViewController  * moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
        moviePlayerController.moviePlayer.movieSourceType=MPMovieSourceTypeFile;
    }
    else
    {        
    VideoViewController *ctvc=[[VideoViewController alloc] init];
    ctvc.url=model;
    [self.navigationController pushViewController:ctvc animated:YES];
    }
}

-(void)tongzhi_Dater:(NSNotification *)text{
    Daterid=(NSString *)text.userInfo[@"textTwo"];
    Daterid_listid=(NSString *)text.userInfo[@"textOne"];
    
    self.dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
    self.dater.delegate=self;
    
    [self.dater showInView:self.view animated:YES];
}

- (void)daterViewDidClicked:(XFDaterView *)daterView
{
    NSString * textOther =[NSString stringWithFormat:@"%@ %@",self.dater.dateString,self.dater.timeString];
    
    //2.
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:Daterid,@"textOne",textOther,@"textTwo",Daterid_listid,@"Daterid_listid", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"thisDater" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)tongzhi_photo:(NSNotification *)text{
     UIImagePickerController *picker=(UIImagePickerController *)text.userInfo[@"textOne"];
     [self presentViewController:picker animated:YES completion:^{}];
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
- (void)ViewMethod:(NSDictionary*)dic {
    cellGuid=dic[@"StepId"];
    //app.this_video_url=nil;
    NSLog(@"录制视频代理");
    XFCameraController *cameraController = [XFCameraController defaultCameraController];
    
    __weak XFCameraController *weakCameraController = cameraController;
    
    cameraController.takePhotosCompletionBlock = ^(UIImage *image, NSError *error) {
        NSLog(@"takePhotosCompletionBlock");
        
        [weakCameraController dismissViewControllerAnimated:YES completion:nil];
    };
    
    cameraController.shootCompletionBlock = ^(NSURL *videoUrl, CGFloat videoTimeLength, UIImage *thumbnailImage, NSError *error) {
        NSLog(@"shootCompletionBlock");
        
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:cellGuid,@"textOne",@"this",@"textTwo",videoUrl.absoluteString,@"texturl", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"thisVideo" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
        //app.this_video_url=videoUrl;
        [weakCameraController dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:cameraController animated:YES completion:nil];
}
-(void)initWindow{
   // typeID=1;
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 270)];
    [self.view addSubview:headview];
    
    //1标题60
    UIView * view_head1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 60)];
    view_head1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [headview addSubview:view_head1];
    
    UIButton *_btn_look=[[UIButton alloc]initWithFrame:CGRectMake(bounds_width.size.width-50, 30, 40, 25)];
    _btn_look.layer.borderColor= [UIColor whiteColor].CGColor;
    _btn_look.layer.borderWidth=1.0f;
    _btn_look.layer.masksToBounds = YES;
    _btn_look.layer.cornerRadius = 4;
    [_btn_look setTitle:@"完成" forState:UIControlStateNormal];
    [_btn_look setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_look addTarget:self action:@selector(btn_over:) forControlEvents:UIControlEventTouchUpInside];
     [view_head1 addSubview:_btn_look];
    
   
    
    //    UIImageView *img_head1=[MyControl createImageViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, 86) imageName:@"wbdc_bg"];
    //    [view_head1 addSubview:img_head1];
    
    UIImage *stopImage = [UIImage imageNamed:@"backArrow@2x"];
    UIImageView *stopImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 30, stopImage.size.width, stopImage.size.height) imageName:nil];
    stopImageView.userInteractionEnabled=YES;
    stopImageView.image = stopImage;
    [view_head1 addSubview:stopImageView];
    
    UIButton *stop_Btn = [MyControl createButtonWithFrame:CGRectMake(0, 30, 60, 40) imageName:nil bgImageName:nil title:nil SEL:@selector(btnClick_stop:) target:self];
    [view_head1 addSubview:stop_Btn];
    
    UILabel * lab_head1=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width, 20) Font:18 Text:_Title ];//@"检测服务"];
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
    
    _btn_WriteName=[[UIButton alloc]initWithFrame:CGRectMake(bounds_width.size.width-70, 10, 60, 25)];
    //    _btn_WriteName.layer.borderColor= [UIColor whiteColor].CGColor;
    //    _btn_WriteName.layer.borderWidth=1.0f;
    _btn_WriteName.layer.masksToBounds = YES;
    _btn_WriteName.layer.cornerRadius = 4;
    [_btn_WriteName setTitle:@"未签认" forState:UIControlStateNormal];
    [_btn_WriteName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_WriteName setBackgroundColor:[UIColor orangeColor] ];
    [_btn_WriteName addTarget:self action:@selector(btnclk_writeName:) forControlEvents:UIControlEventTouchUpInside];
    [view_head2 addSubview:_btn_WriteName];
    
    //3地址等69
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 146, bounds_width.size.width, 119)];
    [headview addSubview:view_head3];
    
    
    
    UIImageView *img_head21=[MyControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"wb_maintenance"];
    [view_head3 addSubview:img_head21];
    
    UILabel *dtWeiBao = [MyControl createLabelWithFrame:CGRectMake(40, 10, 80, 20) Font:14.0 Text:@"上次检测:"];
    //dtWeiBao.textColor = [UIColor blackColor];
    [view_head3 addSubview:dtWeiBao];
    
    
    dtWeiBao_2 = [MyControl createLabelWithFrame:CGRectMake(110, 10, SCREEN_WIDTH-90, 20) Font:14.0 Text:@""];
    //dtWeiBao_2.textColor = [UIColor greenColor];
    //dtWeiBao_2.textAlignment = NSTextAlignmentRight;
    [view_head3 addSubview:dtWeiBao_2];
    
    //22
    UIImageView *img_head22=[MyControl createImageViewWithFrame:CGRectMake(10, 40, 20, 20) imageName:@"address_blue"];
    [view_head3 addSubview:img_head22];
    
    
    UILabel *dtWeiZhi = [MyControl createLabelWithFrame:CGRectMake(40, 40, 80, 20) Font:14 Text:@"电梯位置:"];
    [view_head3 addSubview:dtWeiZhi];
    
    dtWeiZhi_2 = [MyControl createLabelWithFrame:CGRectMake(110, 33, SCREEN_WIDTH- 120, 34) Font:14 Text:nil];
    dtWeiZhi_2.numberOfLines = 2;
    [view_head3 addSubview:dtWeiZhi_2];
    
    //33
    UIImageView *img_head33=[MyControl createImageViewWithFrame:CGRectMake(10, 100, 20, 20) imageName:@"zhuce_code"];
    [view_head3 addSubview:img_head33];
    
    
    UILabel *dtdaima = [MyControl createLabelWithFrame:CGRectMake(40, 100, 80, 20) Font:14 Text:@"注册代码:"];
    [view_head3 addSubview:dtdaima];
    
    dtdaima_2 = [MyControl createLabelWithFrame:CGRectMake(110, 100, SCREEN_WIDTH- 90, 20) Font:14 Text:nil];
    [view_head3 addSubview:dtdaima_2];
    
    // 复制按钮
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    copyBtn.frame = CGRectMake(SCREEN_WIDTH- 50, 100, 40, 20);
    copyBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [copyBtn addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [view_head3 addSubview:copyBtn];
    
    //34
    UIImageView *img_head34=[MyControl createImageViewWithFrame:CGRectMake(10, 70, 20, 20) imageName:@"wyxc_detail"];
    [view_head3 addSubview:img_head34];
    
    
    UILabel *dtdaima34 = [MyControl createLabelWithFrame:CGRectMake(40, 70, 80, 20) Font:14 Text:@"检验部门:"];
    [view_head3 addSubview:dtdaima34];
    
    UILabel *dtdaima341 = [MyControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH-50, 70, 50, 20) Font:14 Text:@"可切换"];
    dtdaima341.textColor=[CommonUseClass getSysColor];
    dtdaima341.textAlignment = NSTextAlignmentRight;
    [view_head3 addSubview:dtdaima341];
    
    DectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [DectBtn setTitle:@"" forState:UIControlStateNormal];
    DectBtn.frame = CGRectMake(110, 70, SCREEN_WIDTH, 20);
    DectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    DectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //DectBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [DectBtn addTarget:self action:@selector(DectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //DectBtn.backgroundColor = [UIColor whiteColor];
    [DectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [view_head3 addSubview:DectBtn];
    
    
    //3
    UILabel *dtLine = [MyControl createLabelWithFrame:CGRectMake(0, 265, bounds_width.size.width, 5) Font:14 Text:@""];
    dtLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headview addSubview:dtLine];
    
    
    

    
    //5
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"JYGLSaveCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(headview.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(headview.frame)-60);
    [self.view addSubview:CourseTableview.tableView];
//    CourseTableview.tableView.scrollEnabled=NO;
    
    UIButton*  Btn = [MyControl createButtonWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60) imageName:nil bgImageName:nil title:@"一键离线传输" SEL:@selector(btnClick_update:) target:self];
    Btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Btn.backgroundColor=[CommonUseClass getSysColor];
    [self.view addSubview:Btn];
}

-(void)DectBtnClick:(UIButton*)btn{
    [self showPop:0 isDept:YES];
}

-(void)btnClick_update:(UIButton*)btn{
    [self commitSource];
}

-(void)btn_over:(UIButton*)btn{
   
        // 1、初始化
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请确认维保是否签认完毕\r\n完成后本次检测将不可更改并结束！" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        // 3、添加取消按钮
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        // 4、添加确定按钮
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self getSchoolCourse_OK];
            
        }]];
        // 5、模态切换显示弹出框
        [self presentViewController:alertController animated:YES completion:nil];
    
    
}


- (void)showData{
    [CourseTableview.dataSource removeAllObjects];
    
    
    CurriculumEntity *entity=[[CurriculumEntity alloc] init];
    entity.enroll_list=app.arrData;
    [self init_tableview_hear:entity];
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:app.arrData afterDelay:0.1];
}
/**
 * 复制链接
 */
- (void)copylinkBtnClick:(UIButton *)sender {
    
    [MBProgressHUD showSuccess:@"复制成功!" toView:self.view];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = dtdaima_2.text;
}




-(void)getSchoolCourse
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //GetInspectStepList
    NSString *url=@"Inspect/GetInspectByLiftNumNew";
     NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:_liftNum forKey:@"LiftNum"];
    [dicHeader setValue:_TypeCode forKey:@"TypeCode"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [dicHeader setValue:_InspectDeptId forKey:@"InspectDeptId"];
    [dicHeader setValue:_TypeId forKey:@"TypeId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%f", _Longitude] forKey:@"MapX"];
    [dicHeader setValue:[NSString stringWithFormat:@"%f", _Latitude] forKey:@"MapY"];
    
    [XXNet GetURL:url header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            
            //1.
            NSString *str_json = data[@"Data"];
            NSDictionary *dic = [str_json objectFromJSONString];
            
            //2.
            NSDictionary *  dicInspect =[dic objectForKey:@"Inspect"];
            InspectId=[CommonUseClass FormatString: [dicInspect objectForKey:@"ID"]];
            dtWeiBao_2.text=[CommonUseClass getDateString: [dicInspect objectForKey:@"CreateTime"]];
            [DectBtn setTitle:[dicInspect objectForKey:@"DeptName"] forState:UIControlStateNormal];
            
            NSString *Sign=[CommonUseClass FormatString: [dicInspect objectForKey:@"Sign"]];
            if(![Sign isEqual:@""])
                [_btn_WriteName setTitle:@"已签认" forState:UIControlStateNormal];
            
            //4.
            NSMutableArray *newArr=[[NSMutableArray alloc]init];
            NSMutableArray *Arr=dic[@"InspectStep"];
            int i=1;
            for (NSMutableDictionary *currdic in Arr) {
                NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:currdic];
                [newdic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"ID"];
                i++;
                [newdic setObject:InspectId forKey:@"InspectId"];
                [newdic setObject:@"0" forKey:@"IsOutLine"];
                [newdic setObject:[NSString stringWithFormat:@"%f", app.Longitude_curr] forKey:@"Longitude"];
                [newdic setObject:[NSString stringWithFormat:@"%f",app.Latitude_curr] forKey:@"Latitude"];
                
                [newArr addObject:newdic];
            }
            
            app.arrData=newArr;
            [self showData];
            
            //5.
//            [self getSchoolCourse1];
        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(dd:) withObject:MessageResult waitUntilDone:YES];
        
    }];
    
    
}

-(void)deleteMag{
     [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)getSchoolCourse1
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:_liftNum forKey:@"LiftNum"];
    [dicHeader setValue:_TypeCode forKey:@"TypeCode"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [dicHeader setValue:_InspectDeptId forKey:@"InspectDeptId"];
    [dicHeader setValue:_TypeId forKey:@"TypeId"];
    [XXNet GetURL:GetInspectByLiftNum header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
       
        [self performSelectorOnMainThread:@selector(deleteMag) withObject:nil waitUntilDone:YES];
        if ([data[@"Success"]intValue]) {
            NSString *str_json = data [@"Data"];//InspectDetails"];
            NSDictionary *  dic = [str_json objectFromJSONString];
            
             NSString * LiftNum_show =[_liftNum stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            dtBianHao_2.text=LiftNum_show;
            NSDictionary *dic_lift =[dic objectForKey:@"Lift"];
            dtWeiZhi_2.text=[dic_lift objectForKey:@"InstallationAddress"];
            dtdaima_2.text=[dic_lift objectForKey:@"CertificateNum"];
            
           
//            NSArray *currArr=[dic objectForKey:@"InspectDetails"];
//            NSMutableArray *newArr=[[NSMutableArray alloc]init];
//
//            int i=1;
//            for (NSMutableDictionary *currdic in app.arrData) {
//                NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:currdic];
//                [newdic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"ID"];
//                i++;
//                [newdic setObject:@"" forKey:@"Remark"];
//                [newdic setObject:@"" forKey:@"CreateTime1"];
//                [newdic setObject:@"" forKey:@"UserName"];
//                [newdic setObject:@"" forKey:@"PhotoUrl"];
//                [newdic setObject:@"" forKey:@"VideoPath"];
//                [newdic setObject:@"0" forKey:@"IsLock"];
//                [newdic setObject:InspectId forKey:@"InspectId"];
//                [newdic setObject:@"0" forKey:@"IsPassed"];
//                [newdic setObject:[NSString stringWithFormat:@"%f", _Longitude] forKey:@"Longitude"];
//                [newdic setObject:[NSString stringWithFormat:@"%f",_Latitude] forKey:@"Latitude"];
//                [newdic setObject:@"0" forKey:@"IsOutLine"];
//                for (NSMutableDictionary *currdic_value in currArr) {
//
//
//                    if([[currdic_value objectForKey:@"StepId"] isEqual: [currdic objectForKey:@"StepId"] ])
//                    {
//
//                        [newdic setObject:[currdic_value objectForKey:@"Remark"] forKey:@"Remark"];
//                        [newdic setObject:[currdic_value objectForKey:@"CreateTime"] forKey:@"CreateTime1"];
//                        [newdic setObject:[currdic_value objectForKey:@"UserName"] forKey:@"UserName"];
//                        [newdic setObject:[currdic_value objectForKey:@"PhotoUrl"] forKey:@"PhotoUrl"];
//                        [newdic setObject:[currdic_value objectForKey:@"VideoPath"] forKey:@"VideoPath"];
//                        [newdic setObject:[currdic_value objectForKey:@"IsLock"] forKey:@"IsLock"];
//                        [newdic setObject:[currdic_value objectForKey:@"InspectId"] forKey:@"InspectId"];
//                        [newdic setObject:[currdic_value objectForKey:@"IsPassed"] forKey:@"IsPassed"];
//                        [newdic setObject:[NSString stringWithFormat:@"%f",_Longitude] forKey:@"Longitude"];
//                        [newdic setObject:[NSString stringWithFormat:@"%f",_Latitude] forKey:@"Latitude"];
////                        [newdic setObject:[currdic_value objectForKey:@"InspectTemplateAttributeEntityList"] forKey:@"InspectTemplateAttributeEntityList"];
//                        break;
//                    }
//
//                }
//                [newArr addObject:newdic];
//            }
//
//            app.arrData=newArr;
//            [self showData];
        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(dd:) withObject:MessageResult waitUntilDone:YES];
        
    }];
    
}

-(void)getSchoolCourse_OK
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
        [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    
    //UpdateInspectByID
    NSString *str=[NSString stringWithFormat:@"%@?id=%@",@"Inspect/UpdateInspectByIDNew",InspectId];
    
    [XXNet GetURL:str header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]==1) {
            [CommonUseClass showAlter:@"操作成功!"];
            [self .navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(dd:) withObject:data[@"Message"] waitUntilDone:YES];
        }
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(dd:) withObject:MessageResult_login waitUntilDone:YES];
        
    }];
    
    
}

- (void)dd:(NSString *)msg{
    
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)init_tableview_hear:(CurriculumEntity *)entity
{
    if (entity.enroll_list.count) {
        
        for (NSMutableDictionary *dic_item in entity.enroll_list ) {
//            if([[dic_item objectForKey:@"TypeID"]intValue] !=typeID)continue;
            [CourseTableview.dataSource addObject:dic_item];
            
        }
        if (entity.enroll_list.count>19) {
            //[CourseTableview.dataSource addObject:@"加载中……"];
        }
        else
        {
            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
    }
}
#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    //    CourseTableview.PageIndex+=1;
    //
    //
    //        [self getSchoolCourse];
    
    
}
-(void)TableRowClick:(UITableItem*)value
{
    
    
    
    
}
-(void)TableHeaderRowClick:(UITableItem*)value
{
    
}
-(void)pullUpdateData
{
//    CourseTableview.PageIndex=1;
//
//
//    [self getSchoolCourse];
    
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

-(void)btnclk_writeName:(UIButton*)btn{
    
    writeNameViewController *detail = [[writeNameViewController alloc]init];
    detail.lift_ID=InspectId;
    detail.TypeID=_TypeId;
    detail.TypeName=_Title;
    [self.navigationController pushViewController:detail animated:YES];
}

//1.jianyan
- (void)commitSource
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    updata_allCount=0;
    updata_currCount=0;
    updata_OK=@"";
    updata_no=@"";
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"Datajianyan"] ;
    for (NSDictionary * warnmodel in array0) {
        //1.
        if(![InspectId isEqual:  warnmodel[@"InspectId"]])
        {
            continue;
        }
        updata_allCount++;
    }
    if(updata_allCount==0)
    {
        [CommonUseClass showAlter:@"没有需要上传的数据！"];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    
    for (NSDictionary * warnmodel in array0) {
        //1.
        if(![InspectId isEqual:  warnmodel[@"InspectId"]])
        {
            continue;
        }
        
        //2
        
        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
        {
            if([warnmodel[@"have_online_phone"] isEqual:@"1"])
            {
                [self updatephone:warnmodel];
            }
            else
            {
                [self SubmitData:@"" forData:warnmodel];
            }
        }
        else
        {
            NSString *url=[NSString stringWithFormat:@"%@", warnmodel[@"online_video_url"]];
            if(![url  isEqual:@""])
            {
                [self updateVideo:warnmodel];
            }
            else
            {
                [self SubmitData:@"" forData:warnmodel];
            }
        }
    }
}


- (void)updatephone:(NSDictionary *)warnmodel
{
    NSData *data =warnmodel[@"online_phone"];
    
    [XXNet requestAFURL:UploadFileURL_Inspect parameters:nil imageData:data succeed:^(NSDictionary *data) {
        //        NSLog(@"%@",data);
        if ([data[@"Success"]intValue]) {
            NSString *str_imgurl = data[@"Data"];
            [self SubmitData:str_imgurl forData:warnmodel];
        }
    } failure:^(NSError *error) {
        updata_currCount++;
        updata_no =[NSString stringWithFormat:@"%@%@,", updata_no,warnmodel[@"ID"] ];
        
        [self performSelectorOnMainThread:@selector(saveOver) withObject:nil waitUntilDone:YES];
    }];
}

- (void)updateVideo:(NSDictionary *)warnmodel
{
    NSString *urlstr=[NSString stringWithFormat:@"%@", warnmodel[@"online_video_url"]];
    NSURL * url=[NSURL URLWithString:urlstr];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data==nil)
    {
        updata_currCount++;
        updata_no =[NSString stringWithFormat:@"%@%@,", updata_no,warnmodel[@"ID"] ];
        [self saveOver];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:@".mp4" forKey:@"fileName"];
    
    [XXNet requestAFURL:UploadFileURL_Inspect_ios parameters:dic imageData:data succeed:^(NSDictionary *data) {
        if ([data[@"Success"]intValue]) {
            NSString *str_imgurl = data[@"Data"];
            [self SubmitData:str_imgurl forData:warnmodel];
        }
    } failure:^(NSError *error) {
        updata_currCount++;
        updata_no =[NSString stringWithFormat:@"%@%@,", updata_no,warnmodel[@"ID"] ];
        
        [self performSelectorOnMainThread:@selector(saveOver) withObject:nil waitUntilDone:YES];
    }];
}



- (void)SubmitData:(NSString *)imgurl forData:(NSDictionary *)warnmodel{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    if(![imgurl isEqual:@""])
    {
        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
        {
            [dic setValue:imgurl forKey:@"PhotoUrl"];
            [dic setValue:@"" forKey:@"VideoPath"];
        }
        else
        {
            [dic setValue:@"" forKey:@"PhotoUrl"];
            [dic setValue:imgurl forKey:@"VideoPath"];
        }
    }
    
    [dic setValue:app.userInfo.UserID forKey:@"UserId"];
    [dic setValue:app.userInfo.username forKey:@"UserName"];
    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"InspectId"]] forKey:@"InspectId"];
    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"TypeID"]] forKey:@"TypeID"];
    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"TypeName"]] forKey:@"TypeName"];
    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"StepId"]] forKey:@"StepId"];
    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"StepName"]] forKey:@"StepName"];
    [dic setValue:[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPassed"]] forKey:@"IsPassed"];
    [dic setValue:[CommonUseClass FormatString:  [warnmodel objectForKey:@"Remark"]] forKey:@"Remark"];
    [dic setValue:  [warnmodel objectForKey:@"MapX"] forKey:@"MapY"];
    [dic setValue:  [warnmodel objectForKey:@"MapY"] forKey:@"MapX"];
    [dic setValue:  [warnmodel objectForKey:@"CreateTime"] forKey:@"CreateTime"];
    
[dic setValue:  [warnmodel objectForKey:@"TemplateAttributeJson"] forKey:@"TemplateAttributeJson"];
    
    //SaveInspectDetail
    [XXNet post:@"Inspect/SaveInspectDetailNew" parameters:[dic JSONString]
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
            NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary* dic_result=[str_result objectFromJSONString];
            NSString *success=[dic_result objectForKey:@"Success"];
            updata_currCount++;
            if (success.intValue == 1) {
                //[self performSelectorOnMainThread:@selector(dd1_ok:) withObject:imgurl waitUntilDone:NO];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSArray *array0 = [defaults objectForKey:@"Datajianyan"] ;
                NSMutableArray *array = [array0 mutableCopy];
                for (NSDictionary *dic in array) {
                    if(dic[@"InspectId"] ==warnmodel[@"InspectId"]
                       &&dic[@"StepId"]==warnmodel[@"StepId"])
                    {
                        [array removeObject:dic];
                        
                        [defaults removeObjectForKey:@"Datajianyan"];
                        [defaults synchronize];
                        NSArray *myArray = [array copy];
                        [defaults setObject:myArray forKey:@"Datajianyan"];
                        [defaults synchronize];
                        break;
                    }
                }

                updata_OK =[NSString stringWithFormat:@"%@%@,", updata_OK,warnmodel[@"ID"] ];
            }
            else
            {
                updata_no =[NSString stringWithFormat:@"%@%@,", updata_no,warnmodel[@"ID"] ];
            }
            
            
           [self performSelectorOnMainThread:@selector(saveOver) withObject:nil waitUntilDone:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            updata_currCount++;
            updata_no =[NSString stringWithFormat:@"%@%@,", updata_no,warnmodel[@"ID"] ];
            
            [self performSelectorOnMainThread:@selector(saveOver) withObject:nil waitUntilDone:YES];
        }];
}

-(void)updateNo:(NSString *)msg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [CommonUseClass showAlter:msg];
}

-(void)saveOver{
    if(updata_currCount==updata_allCount)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(updata_OK.length>1)
        {
            updata_OK=[updata_OK substringToIndex:updata_OK.length-1];
            updata_OK=[NSString stringWithFormat:@"步骤%@上传成功!",updata_OK];
        }
        if(updata_no.length>1)
        {
            updata_no=[updata_no substringToIndex:updata_no.length-1];
            updata_no=[NSString stringWithFormat:@"步骤%@上传失败!",updata_no];
        }
        //1
        NSString *str=  [NSString stringWithFormat:@"%@%@",updata_OK,updata_no];
        [self performSelectorOnMainThread:@selector(updateNo:) withObject:str waitUntilDone:YES];
        
        [self getSchoolCourse];
    }
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
        
        app.Longitude_curr=_locService.userLocation.location.coordinate.longitude;//经度
        app.Latitude_curr=_locService.userLocation.location.coordinate.latitude;//纬度
        
 
        
       
        
//        [_locService stopUserLocationService];
        
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

-(void)showPop:(long)tag isDept:(BOOL)isDept {
    //1.
    for(long i=view_Content_2.subviews.count-1;i>=0;i--)
    {
        id object=view_Content_2.subviews[i];
        [object removeFromSuperview ];
    }
    
    //2.
    int top=0;
    int width=view_Content_2.frame.size.width;
    

    if (isDept) {
        for (NSDictionary *dic in _DectList) {
            [self addButton_dept:0 forTop:top forWidth:width forHeight:44 forName:dic[@"DeptName"] forName1:@"" forTag:[dic[@"DeptId"] intValue] forIcon:@"" isDept:YES];
            top=top+44;
        }
    } else {
        for (NSDictionary *dic in _WorkFormList) {
            [self addButton_dept:0 forTop:top forWidth:width forHeight:44 forName:dic[@"Name"] forName1:@"" forTag:[dic[@"Id"] intValue] forIcon:@"" isDept:NO];
            top=top+44;
        }
    }
    
    view_Content_2.frame=CGRectMake(view_Content_2.frame.origin.x, view_Content_2.frame.origin.y, view_Content_2.frame.size.width, top+50);
    
    
    view_Content_2.hidden=false;
    view_Content_back.hidden=false;
}

- (void)showPop2:(UIButton *)btn {
    [self hiddenPop];
    UILabel *lab=[view_Content_2 viewWithTag:btn.tag+90000];
    if(lab!=nil)
        selectDect=lab.text;
    _InspectDeptId = [NSString stringWithFormat:@"%ld", btn.tag];
    [self showPop:0 isDept:NO];
}

- (void)addButton_dept:(float)left forTop:(float)top forWidth:(float)width forHeight:(float)height forName:(NSString *)name  forName1:(NSString *)name1 forTag:(int)tag forIcon:(NSString*)imageName isDept:(BOOL)isDept {
    UIView *view=[[UIView alloc]init];
    view.tag=10000+tag;
    view.frame=CGRectMake(left, top, width, height);
    [view_Content_2 addSubview:view];
    
    
    UILabel *selectLabel1 = [MyControl createLabelWithFrame:CGRectMake(20, 12, SCREEN_WIDTH-40, 20) Font:14 Text:name];
    selectLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel1.alpha=1.0;
    selectLabel1.text=name;
    selectLabel1.tag=tag+90000;
    [view addSubview:selectLabel1];
    
    UILabel *line = [MyControl createLabelWithFrame:CGRectMake(0, 43, width, 1) Font:14 Text:@""];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    

    if (isDept) {
        UIButton *btn_1 = [MyControl createButtonWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 44) imageName:nil bgImageName:nil title:@"" SEL:@selector(showPop2:) target:self];
        btn_1.tag=tag;
        [view addSubview:btn_1];
    } else {
        UIButton *btn_1 = [MyControl createButtonWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 44) imageName:nil bgImageName:nil title:@"" SEL:@selector(btnClick_ReplaceTheElevator:) target:self];
        btn_1.tag=tag;
        [view addSubview:btn_1];
    }
}


-(void)hiddenPop{
    view_Content_2.hidden=YES;
    view_Content_back.hidden=YES;
}

- (void)btnClick_ReplaceTheElevator:(UIButton *)btn {
    [self hiddenPop];
    _workFormId = [NSString stringWithFormat:@"%ld", btn.tag];
    [self setDect];
}

-(void)setDect
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //GetInspectStepList
    NSString *url=@"Inspect/UpdateInspectDept";
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:InspectId forKey:@"ID"];
    [dicHeader setValue:_InspectDeptId forKey:@"InspectDeptId"];
    [dicHeader setValue:_workFormId forKey:@"WorkForm"];
    
    [XXNet GetURL:url header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(dectResult:) withObject:data[@"Message"] waitUntilDone:YES];
             [DectBtn setTitle:selectDect forState:UIControlStateNormal];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(dectResult:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(dectResult:) withObject:MessageResult waitUntilDone:YES];
    }];
}

- (void)dectResult:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
