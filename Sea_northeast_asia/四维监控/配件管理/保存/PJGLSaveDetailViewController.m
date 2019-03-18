//
//  PJGLSaveDetailViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "PJGLSaveDetailViewController.h"

@interface PJGLSaveDetailViewController ()

@end

@implementation PJGLSaveDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initWindow];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
//    13.2注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_NFCSB" object:nil];
   
}


- (void)tongzhi_warn:(NSNotification *)text{
    NSString *textId=(NSString *)text.userInfo[@"textId"];
    NSString *textValue=(NSString *)text.userInfo[@"textValue"];
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:textValue,@"str",textId,@"guid", nil];
    [self performSelectorOnMainThread:@selector(showBQValue:) withObject:dict waitUntilDone:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWindow{
    // typeID=1;
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 310)];
    [self.view addSubview:headview];
    
    //1标题60
    UIView * view_head1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 60)];
    view_head1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [headview addSubview:view_head1];
    
    
    

    
    UIImage *stopImage = [UIImage imageNamed:@"backArrow@2x"];
    UIImageView *stopImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 30, stopImage.size.width, stopImage.size.height) imageName:nil];
    stopImageView.userInteractionEnabled=YES;
    stopImageView.image = stopImage;
    [view_head1 addSubview:stopImageView];
    
    UIButton *stop_Btn = [MyControl createButtonWithFrame:CGRectMake(0, 30, 60, 40) imageName:nil bgImageName:nil title:nil SEL:@selector(btnClick_stop:) target:self];
    [view_head1 addSubview:stop_Btn];
    
    UILabel * lab_head1=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width, 20) Font:18 Text:@"NFC标签绑定" ];
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
    dtBianHao_2.text=_liftNum;
    
    UILabel *dtBianHao = [MyControl createLabelWithFrame:CGRectMake(0, 50, bounds_width.size.width, 20) Font:15 Text:@"电梯编号"];
    dtBianHao.textColor = [UIColor whiteColor];
    dtBianHao.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao];
    
    
    
    
    //3地址等69
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 146, bounds_width.size.width, 159)];
    [headview addSubview:view_head3];
    
    
    
    
    
    //22
    UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 40)];
    dateView.backgroundColor = [UIColor whiteColor];
    dateView.userInteractionEnabled=YES;
    [view_head3 addSubview:dateView];
    lab_time = [[UITextField alloc]initWithFrame:CGRectMake(10, 0,SCREEN_WIDTH-10 , 39)];
    [dateView addSubview:lab_time];
//    UIView *view_4=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 39)];
//    lab_time.leftView=view_4;
    lab_time.leftViewMode = UITextFieldViewModeAlways;
    lab_time.backgroundColor = [UIColor whiteColor];
    lab_time.placeholder = @"安装日期";
    lab_time.layer.masksToBounds = YES;
    lab_time.layer.cornerRadius = 4;
    lab_time.enabled = false;
    lab_time.delegate = self;
    lab_time.clearButtonMode = UITextFieldViewModeWhileEditing;
    lab_time.returnKeyType = UIReturnKeyDone;
    lab_time.font = [UIFont fontWithName:@"Arial" size:15.0f];
    lab_time.textColor = RGBACOLOR(112, 112, 112,1.0);
    
    
    //给日期添加手势
    UITapGestureRecognizer *date_TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(date_Tap:)];
    //将触摸事件添加到当前view
    [dateView addGestureRecognizer:date_TapGesture];
    
    UILabel *dtLine21 = [MyControl createLabelWithFrame:CGRectMake(0, 39, bounds_width.size.width, 1) Font:15 Text:@""];
    dtLine21.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [dateView addSubview:dtLine21];
    
    
    
    
    //23
    lab_name = [MyControl createTextFildWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-10, 39) Font:15 Text:nil];
    lab_name.placeholder=@"请选择配件名称";
    [view_head3 addSubview:lab_name];
    lab_name.text=_PartsTypeName;
    lab_name.enabled=NO;
    
    UILabel *dtLine22 = [MyControl createLabelWithFrame:CGRectMake(0, 39, bounds_width.size.width, 1) Font:15 Text:@""];
    dtLine22.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view_head3 addSubview:dtLine22];
    
//    UIButton *btn_1 = [MyControl createButtonWithFrame:lab_name.frame imageName:nil bgImageName:nil title:nil SEL:@selector(selectName_Event:) target:self];
//    [view_head3 addSubview:btn_1];
    
    //24
    lab_Model= [MyControl createTextFildWithFrame:CGRectMake(10, 80, SCREEN_WIDTH-10, 39) Font:15 Text:@""];
    lab_Model.placeholder=@"产品编码";
    lab_Model.returnKeyType = UIReturnKeyDone;
    lab_Model.delegate = self;//设置代理
     [view_head3 addSubview:lab_Model];
    
    UILabel *dtLine23 = [MyControl createLabelWithFrame:CGRectMake(0, 119, bounds_width.size.width, 1) Font:15 Text:@""];
    dtLine23.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view_head3 addSubview:dtLine23];
    //25
    lab_Brand= [MyControl createTextFildWithFrame:CGRectMake(10, 120, SCREEN_WIDTH-10, 39) Font:15 Text:@""];
    lab_Brand.placeholder=@"配件型号";
    lab_Brand.returnKeyType = UIReturnKeyDone;
    lab_Brand.delegate = self;//设置代理
    [view_head3 addSubview:lab_Brand];
    
    
    
    //3
    UILabel *dtLine = [MyControl createLabelWithFrame:CGRectMake(0, 305, bounds_width.size.width, 5) Font:15 Text:@""];
    dtLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headview addSubview:dtLine];
    
    
    //4.band
    UIView * view1=[[UIView alloc]initWithFrame:CGRectMake(0, 310, bounds_width.size.width, 320)];
    [self.view addSubview:view1];
    
    UILabel *pjtitle = [MyControl createLabelWithFrame:CGRectMake(10, 10, 80, 20) Font:15 Text:@"标签扫描"];
    [view1 addSubview:pjtitle];
    
    //4.1
    UILabel *pjvalue = [MyControl createLabelWithFrame:CGRectMake(90, 10, 80, 20) Font:15 Text:@"标签值:"];
    [view1 addSubview:pjvalue];
    
    bq_value = [MyControl createLabelWithFrame:CGRectMake(150, 5, SCREEN_WIDTH- 160-50, 75) Font:15 Text:nil];
    bq_value.textColor=[UIColor blackColor];
    [view1 addSubview:bq_value];
    //4.2
    UILabel *pjone = [MyControl createLabelWithFrame:CGRectMake(90, 80, 80, 20) Font:15 Text:@"唯一值:"];
    [view1 addSubview:pjone];
    
    bq_code = [MyControl createLabelWithFrame:CGRectMake(150, 80, SCREEN_WIDTH- 160, 20) Font:15 Text:nil];
    bq_code.textColor=[UIColor blackColor];
    [view1 addSubview:bq_code];
    
   
    
    //4.3
    // 复制按钮
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:@"扫描" forState:UIControlStateNormal];
    copyBtn.frame = CGRectMake(SCREEN_WIDTH- 60, 10, 50, 20);
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [copyBtn addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [view1 addSubview:copyBtn];
    
    UILabel *dtLine1 = [MyControl createLabelWithFrame:CGRectMake(0, 109, bounds_width.size.width, 1) Font:15 Text:@""];
    dtLine1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view1 addSubview:dtLine1];
    
    //5.picture
    UILabel *pictitle = [MyControl createLabelWithFrame:CGRectMake(10, 120, 70, 20) Font:15 Text:@"图        片"];
    [view1 addSubview:pictitle];
    
    view_image = [[UIImageView alloc]initWithFrame:CGRectMake(80,120, SCREEN_WIDTH-100, 80)];
    view_image.userInteractionEnabled=YES;
    btn_addimage = [MyControl createButtonWithFrame:CGRectMake(8, 5, 62, 61) imageName:@"push_Addimage.png" bgImageName:nil title:nil SEL:@selector(btnClick:) target:self];
    btn_addimage.tag = 101;
    [view_image addSubview:btn_addimage];
    [view1 addSubview:view_image];
    
    arr_Photos = [NSMutableArray arrayWithCapacity:0];
    dic_attid=[NSMutableDictionary dictionary];
    arr_Failure=[NSMutableArray array];
    islog=YES;
    
    UILabel *label9=[MyControl createLabelWithFrame:CGRectMake(80, CGRectGetMaxY(view_image.frame), SCREEN_WIDTH-90, 20) Font:14 Text:@"重新拍照会覆盖现有图片。"];
    [view1 addSubview:label9];
    
    UILabel *dtLine2 = [MyControl createLabelWithFrame:CGRectMake(0, 229, bounds_width.size.width, 1) Font:15 Text:@""];
    dtLine2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view1 addSubview:dtLine2];
    
    UIButton *UpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [UpBtn setTitle:@"提交" forState:UIControlStateNormal];
    UpBtn.frame = CGRectMake( 10, 260, SCREEN_WIDTH-20, 40);
    UpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [UpBtn addTarget:self action:@selector(UpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UpBtn.backgroundColor = [CommonUseClass getSysColor];
    [UpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UpBtn.layer.masksToBounds = YES; //没这句话它圆不起来
    UpBtn.layer.cornerRadius = 5; //设置图片圆角的尺度
    [view1 addSubview:UpBtn];

}
//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [lab_Model resignFirstResponder];//取消第一响应者
    [lab_Brand resignFirstResponder];//取消第一响应者
    
    return YES;
}


- (void)date_Tap:(UITapGestureRecognizer*)dateTap
    {
        [lab_Model resignFirstResponder];
        [lab_Brand resignFirstResponder];
        
        self.dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
        self.dater.delegate=self;
        [self.dater showInView:self.view animated:YES];
        
    }

//点击空白-回收键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [lab_Model resignFirstResponder];
    [lab_Brand resignFirstResponder];
}
                 
 - (void)daterViewDidClicked:(XFDaterView *)daterView
    {
        NSLog(@"dateString=%@ timeString=%@",self.dater.dateString,self.dater.timeString);
        lab_time.text=[NSString stringWithFormat:@"%@ %@",self.dater.dateString,self.dater.timeString];
    }

- (void)UpBtnClick:(UIButton *)sender {
    
   
    
    
    if([[CommonUseClass FormatString: lab_name.text] isEqual:@""] )
    {
        [CommonUseClass showAlter:@"请先选择配件名称"];
        return;
    }
    
    if([[CommonUseClass FormatString: bq_value.text] isEqual:@""] ||[[CommonUseClass FormatString: bq_code.text] isEqual:@""])
    {
        [CommonUseClass showAlter:@"请先扫描标签"];
        return;
    }
    
    if(arr_Photos.count<=0)
    {
        [CommonUseClass showAlter:@"请先拍照"];
        return;
    }
    
   [self thisSaveData];
//    //3.是否连网
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager startMonitoring];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//
//        if (status == -1) {
//            //NSLog(@"未识别网络");
//            [self thisSaveData];
//        }
//        else if (status == 0) {
//            //NSLog(@"无网络");
//            [self thisSaveData];
//        }else{
//             [self SubmitData];
//        }
//
//        [manager stopMonitoring];
//    }];
}

- (void)copylinkBtnClick:(UIButton *)sender {
    if([[CommonUseClass FormatString: lab_name.text] isEqual:@""] )
    {
        [CommonUseClass showAlter:@"请先选择配件名称"];
        return;
    }
    //1.
//    /**
//     三个参数
//     第一个参数：代理对象
//     第二个参数：线程
//     第三个参数：Session读取一个还是多个NDEF。YES：读取一个结束，NO：读取多个
//     */
//    NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT) invalidateAfterFirstRead:YES];
//
//    [session beginSession];
    
    
    //2.
//    999997`10020030040050060070`轿顶钢丝绳`华盾大数据研究院1号楼`2018-11-02 13:36:43
    NSString *str=_liftNum;
    str=[NSString stringWithFormat:@"%@`%@`%@",str,_CertificateNum,lab_name.text ];
    if(_InstallationAddress.length>15)
        _InstallationAddress=[_InstallationAddress substringFromIndex:_InstallationAddress.length-15];
    str=[NSString stringWithFormat:@"%@`%@`%@",str,_InstallationAddress,[CommonUseClass getCurrentTimes] ];
    
    
    NFCSBNewViewController *vc=[[NFCSBNewViewController alloc]init];
    vc.Title= lab_name.text;
    vc.Memo=@"";
    vc.type=@"writeDetail";
    vc.writeString=str;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 具体父子关系看官方文档
 */
- (void)readerSession:(NFCNDEFReaderSession *)session didInvalidateWithError:(NSError *)error
{
    if(error.code==1)
    {
        [self performSelectorOnMainThread:@selector(showMsg) withObject:nil waitUntilDone:YES];
    }
}

-(void)showMsg{
//    [CommonUseClass showAlter:@"扫描失败，可能发生的原因：非法设备！（注：NFC扫描需要设备在IPONE7及以上，并且系统版本在iOS 11及以上！）"];
        NFCSBNewViewController *vc=[[NFCSBNewViewController alloc]init];
        vc.Title= lab_name.text;
        vc.Memo=@"";
        [self.navigationController pushViewController:vc animated:YES];
}
- (void) readerSession:(nonnull NFCNDEFReaderSession *)session didDetectNDEFs:(nonnull NSArray<NFCNDEFMessage *> *)messages {
    
    for (NFCNDEFMessage *message in messages) {
        for (NFCNDEFPayload *payload in message.records) {
            NSLog(@"Payload data:%@",payload.payload);
            NSData *newdata=payload.payload;
            newdata= [newdata subdataWithRange:NSMakeRange(3, newdata.length-3)];
            NSString *str=[[ NSString alloc] initWithData:newdata encoding:NSUTF8StringEncoding];
            NSLog(@"Payload str:%@",str);
            NSString *guid=[CommonUseClass getID:session];
            
            
            //2.
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:str,@"str",guid,@"guid", nil];
             [self performSelectorOnMainThread:@selector(showBQValue:) withObject:dict waitUntilDone:YES];
           
        }
    }
}
-(void)showBQValue:(NSDictionary *)dict
{
    bq_value.text=dict[@"str"];
    bq_code.text=dict[@"guid"];
}


- (void)btnClick_stop:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
//    NSString *msg=MsgBack;
//    // 1、初始化
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    // 3、添加取消按钮
//    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
//    // 4、添加确定按钮
//    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }]];
//    // 5、模态切换显示弹出框
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)btnClick:(UIButton *)btn
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil  otherButtonTitles:@"拍照",@"相册",nil];
    actionSheet.tag=1001;
    [actionSheet showInView:self.view];
}



- (void)dd:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)deleteThisValue:(NSMutableArray *)array
{
    for (NSDictionary *dic in array) {
        if([dic[@"LiftId"] isEqual: _LiftId]
           &&[[CommonUseClass FormatString: dic[@"PartsTypeId"]] isEqual:[CommonUseClass FormatString:_PartsTypeId]])
        {
            [array removeObject:dic];
            return;
        }
    }
}

-(void)thisSaveData{
    //1.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"PeiJianBand"] ;
    NSMutableArray *array = [array0 mutableCopy];
    if(array==nil)
    {
        array=[NSMutableArray new];
    }
    [self deleteThisValue:array];
    
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[CommonUseClass FormatString: bq_code.text] forKey:@"Manufacturer"];
    [dicHeader setValue:lab_Brand.text forKey:@"Brand"];
    [dicHeader setValue:lab_Model.text forKey:@"Model"];
    [dicHeader setValue:lab_time.text forKey:@"InstallationTime"];
    [dicHeader setValue:_PartsTypeId forKey:@"PartsTypeId"];
    [dicHeader setValue:lab_name.text forKey:@"ProductName"];
    [dicHeader setValue:_LiftId forKey:@"LiftId"];
    [dicHeader setValue:self.app.userInfo.UserID forKey:@"UserId"];
    UIImageView *imagview=arr_Photos[0];
    NSData *imageData = UIImageJPEGRepresentation(imagview.image,0.4f);
    [dicHeader setObject:imageData forKey:@"MultipartFile"];
    
    
    
    //3
    [array addObject:dicHeader];
    NSArray *myArray = [array copy];
    [defaults setObject:myArray forKey:@"PeiJianBand"];
    [defaults synchronize];
    [CommonUseClass showAlter:@"离线缓存成功！"];
    [self saveOK:@"0"];
}

- (void)saveOK:(NSString *)isOnline{
    //1.
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_PartsTypeId,@"textOne",isOnline,@"isOnline", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_PeiJianBandOK" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //2.
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)SubmitData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImageView *imgview=(UIImageView *)arr_Photos[0];
    NSData *data =UIImageJPEGRepresentation(imgview.image, 0.4f);
    
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[CommonUseClass FormatString: bq_code.text] forKey:@"Manufacturer"];
    [dicHeader setValue:lab_Brand.text forKey:@"Model"];
    [dicHeader setValue:lab_Model.text forKey:@"Brand"];
    [dicHeader setValue:lab_time.text forKey:@"InstallationTime"];
    [dicHeader setValue:_PartsTypeId forKey:@"PartsTypeId"];
    [dicHeader setValue:lab_name.text forKey:@"ProductName"];
    [dicHeader setValue:_LiftId forKey:@"LiftId"];
    [dicHeader setValue:self.app.userInfo.UserID forKey:@"UserId"];

    [XXNet requestAFURL:@"LiftParts/AddLiftParts" parameters:dicHeader imageData:data succeed:^(NSDictionary *data) {
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(dd:) withObject:data[@"Message"] waitUntilDone:YES];
            [self saveOK:@"1"];
        }
        else
        {
             [self performSelectorOnMainThread:@selector(dd:) withObject:data[@"Message"] waitUntilDone:YES];
        }
    } failure:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(dd:) withObject:MessageResult waitUntilDone:YES];
    }];
}





//UIImage图片转成Base64字符串
-(NSString *)ImageToBase64:(UIImage *)originImage
{
    
    NSData *data = UIImageJPEGRepresentation(originImage, 0.4f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
}


#pragma mark - 加载图片
-(void)initPhotos
{
    for (UIView *view_header_item in [view_image subviews]) {
        if (view_header_item.tag!=6000) {
            [view_header_item removeFromSuperview];
        }
    }
    int j=(int)arr_Photos.count;
    view_image.userInteractionEnabled=YES;
    j=j>4?4:j;
    for (int i=0; i<j; i++) {
        
        imageview=[arr_Photos objectAtIndex:i];
        imageview.userInteractionEnabled = YES;
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.layer.masksToBounds = YES; //没这句话它圆不起来
        imageview.layer.cornerRadius = 5; //设置图片圆角的尺度
        UILongPressGestureRecognizerEx *longPressGesture = [[UILongPressGestureRecognizerEx alloc] initWithTarget:self action:@selector(imageView_longPressGesture:)];
        [longPressGesture setMinimumPressDuration:1];
        longPressGesture.perentView=imageview;
        [imageview addGestureRecognizer:longPressGesture];
        BOOL isbtn=YES;
        if (arr_Failure.count>0) {
            for (UIImageView *itme in arr_Failure) {
                if (imageview==itme) {
                    isbtn =NO;
                    break;
                }
            }
        }
        if (isbtn) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor=[UIColor clearColor];
            [btn addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i;
            btn.frame=CGRectMake(0, 0,64,64);
            [imageview addSubview:btn];
        }
        int  a=(i/4+1);
        int marginTop = (64+5) * a-64 ;
        if (i % 4==0) {
            imageview.frame= CGRectMake(20, marginTop,64,64);
        }
        else if (i % 4==1)
        {
            imageview.frame= CGRectMake(92, marginTop,64,64);
        }
        else if (i % 4==2)
        {
            imageview.frame= CGRectMake(164, marginTop,64, 64);
        }
        else
        {
            imageview.frame= CGRectMake(236, marginTop,64, 64);
        }
        [imageview setBackgroundColor:[UIColor blackColor]];
        [view_image addSubview:imageview];
    }
    int a=(j/4+1);
    int marginTop = (64+5) * a-64 ;
    if (j % 4==0) {
        btn_addimage.frame= CGRectMake(20, marginTop,64,64);
    }
    else if (j % 4==1)
    {
        btn_addimage.frame= CGRectMake(92, marginTop,64,64);
    }
    else if (j % 4==2)
    {
        btn_addimage.frame= CGRectMake(164, marginTop,64, 64);
    }
    else
    {
        btn_addimage.frame= CGRectMake(236, marginTop,64, 64);
    }
    [view_image addSubview:btn_addimage];
    if (arr_Photos.count==2) {
        [btn_addimage setHidden:YES];
    }
    else
    {
        [btn_addimage setHidden:NO];
    }
}
#pragma mark 查看大图
-(void)showImage:(id)saend{
    //[text_Contents resignFirstResponder];
    UIButton *btn=(UIButton *)saend;
    int i=(int)btn.tag;
    
    int counts = (int)arr_Photos.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:counts];
    for (int i = 0; i<counts; i++) {
        // 替换为中等尺寸图片
        UIImageView *item=[arr_Photos objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image=item.image;
        //        photo.srcImageView =item.phosmall_ecoImage;  // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.isShowBar=YES;
    [browser show];
    
    [self.navigationController pushViewController:browser animated:YES];
}
#pragma mark 删除图片
-(void)imageView_longPressGesture:(UILongPressGestureRecognizer*)sender
{
    //    view_face.hidden=YES;
    //[text_Contents resignFirstResponder];
    UILongPressGestureRecognizerEx *lpgr=(UILongPressGestureRecognizerEx*)sender;
    image_delete=lpgr.perentView;
    
    if (islog) {
        islog=NO;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        actionSheet.tag=1000;
        [actionSheet showInView:self.view];
    }
    
}

//拍照或相册-删除视图上得图片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    islog =YES;
    if (actionSheet.tag==1000) {
        switch (buttonIndex) {
            case 0:
            {   //删除视图上得图片
                for (int i=0; i<arr_Photos.count; i++)
                {
                    UIImageView *item= [arr_Photos objectAtIndex:i];
                    if ([image_delete isEqual: item]) {
                        [arr_Photos removeObject:item];
                        break;
                    }
                }
                //删除上传成功 attid
                NSArray *array_value=[dic_attid allValues];
                NSArray *array_key=[dic_attid allKeys];
                for (int i=0; i<array_value.count; i++)
                {
                    UIImageView *item= [array_value objectAtIndex:i];
                    if ([image_delete isEqual: item]) {
                        [dic_attid removeObjectForKey:[array_key objectAtIndex:i]];
                        break;
                    }
                }
                [self initPhotos];
            }
                break;
            default:
                break;
        }
    }
    if (actionSheet.tag==1001) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.view.tag=1000;
        picker.delegate = self;
        picker.allowsEditing = YES;
        switch (buttonIndex)
        {
            case 0:
            {
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
                break;
            case 1:
            {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
                
                
                picker.delegate = self;
                
                picker.sourceType = sourceType;
                [self presentViewController:picker animated:YES completion:^{}];
                
            }
                break;
            case 2:
            {
            }
                break;
        }
        
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
//                PECropViewController *controller = [[PECropViewController alloc] init];
//                controller.delegate = self;
//                controller.image = image;
//
//                CGFloat width = image.size.width;
//                CGFloat height = image.size.height;
//
//                controller.imageCropRect = CGRectMake(0,
//                                                      0,
//                                                      width,
//                                                      height);
//                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
//                [self presentViewController:navigationController animated:NO completion:nil];
                
                picUrl=@"";
                
                UIImageView *imagev=[[UIImageView alloc] init ];
                imagev.image=image;
                [self upload_Image:imagev isRestart:YES];
                
            }
        }];
        
    }else if ([mediaType isEqualToString:@"public.movie"])
    {
        
    }
    
}
#pragma mark PECropViewControllerDelegate
- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    UIImageView *image=[[UIImageView alloc] init ];
    image.image=[Util scaleToSize:croppedImage];
    if (image.image) {
        [self upload_Image:image isRestart:YES];
    }
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 上传图片
-(void)upload_Image:(UIImageView *)image isRestart:(BOOL)isRestart
{
    Indication *invc;
    if (isRestart)
    {
        invc=[[Indication alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        [image addSubview:invc];
        invc.isStar=NO;
    }
    else
    {
        NSArray *arr=[image subviews];
        for (UIView *item in arr) {
            NSString *str=[NSString stringWithUTF8String:object_getClassName(item)];
            if ([str isEqualToString:@"Indication"]) {
                if (invc.isStar) {
                    return;
                }
                invc=(Indication *)item;
                invc.lab_label1.text=@"";
                break;
            }
        }
    }
    if (invc==nil) {
        invc=[[Indication alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        invc.isStar=NO;
    }
    
    UIButton *btn;
    if (isRestart) {
        arr_Photos=[NSMutableArray new];/////////////one
        [arr_Photos addObject:image];
        //失败按钮
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor clearColor];
        btn.tag=8000+arr_Photos.count;
        btn.frame=CGRectMake(0, 0,64,64);
    }
    [invc startAnimating];
    [self initPhotos];
    
    [dic_attid setObject:image forKey:@"1"];
    [invc stopAnimating];
    invc.isStar=NO;
    [invc removeFromSuperview];
    if(!isRestart)
    {
        [arr_Failure removeObject:image];
    }
    //isUpload=NO;
    
}
#pragma mark-addImage点击
-(void)ADD_Restart:(UIImageView *)imageview btn:(UIButton *)btn
{
    [btn addTarget:self action:@selector(btn_Restart:) forControlEvents:UIControlEventTouchUpInside];
    [imageview addSubview:btn];
}
-(void)btn_Restart:(id)saend{
    UIButton *btn=(UIButton *)saend;
    int i=(int)btn.tag;
    i=i-8000;
    NSLog(@"%i",i);
    UIImageView *image=[arr_Photos objectAtIndex:i-1];
    [self upload_Image:image isRestart:NO];
}



@end
