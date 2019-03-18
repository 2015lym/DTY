//
//  NFCSaveViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/9.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "NFCSaveViewController.h"

@interface NFCSaveViewController ()

@end

@implementation NFCSaveViewController
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
    [self InitPop];
    
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
    
    //    13.2注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_NFCSB" object:nil];
}

//点击空白-回收键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [tf resignFirstResponder];
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
    
    //1.2
    int newDiantiTag=1;//@"重新绑定电梯"
    NSString *newDiantiName=@"nfc_bandLift_re";
    if([[CommonUseClass FormatString: _liftID] isEqual:@""])//@"绑定电梯"
    {
        newDiantiTag=2;
        newDiantiName=@"nfc_bandLift";
    }
    btnNewDianti= [MyControl createButtonWithFrame:CGRectMake(bounds_width.size.width-100,15, 80, 30) imageName:nil bgImageName:newDiantiName title:nil SEL:@selector(btnClick_bandLift:) target:self];
    btnNewDianti.tag=newDiantiTag;
    [view_head2 addSubview:btnNewDianti];
    
    //3地址等69
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 106, bounds_width.size.width, 119)];
    [headview addSubview:view_head3];
    
    
    

    
    UILabel *dtWeiBao = [MyControl createLabelWithFrame:CGRectMake(20, 15, 80, 20) Font:14.0 Text:@"注册号码"];
    dtWeiBao.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiBao];
    
    
    dtWeiBao_2 = [MyControl createLabelWithFrame:CGRectMake(120, 15, SCREEN_WIDTH-90, 20) Font:14.0 Text:@""];
    _UploadDate = [_UploadDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dtWeiBao_2.text=_UploadDate;
    dtWeiBao_2.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiBao_2];
    
    

    
    
    UILabel *dtWeiZhi = [MyControl createLabelWithFrame:CGRectMake(20, 40, 120, 20) Font:14 Text:@"电梯安装地址"];
    dtWeiZhi.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiZhi];
    
    dtWeiZhi_2 = [MyControl createLabelWithFrame:CGRectMake(120, 33, SCREEN_WIDTH- 120, 34) Font:14 Text:nil];
    dtWeiZhi_2.numberOfLines = 2;
    dtWeiZhi_2.textColor = [UIColor whiteColor];
    dtWeiZhi_2.text=_InstallationAddress;
    [view_head3 addSubview:dtWeiZhi_2];
    
    UILabel *dtWeiZhi_ms = [MyControl createLabelWithFrame:CGRectMake(20, 70, 120, 20) Font:14 Text:@"描述"];
    dtWeiZhi_ms.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiZhi_ms];
    
    UILabel *dtWeiZhi_msV = [MyControl createLabelWithFrame:CGRectMake(120, 70, SCREEN_WIDTH- 120, 20) Font:14 Text:nil];
    dtWeiZhi_msV.numberOfLines = 2;
    dtWeiZhi_msV.textColor = [UIColor whiteColor];
    dtWeiZhi_msV.text=@"请确保电梯编号与注册号码的准确性";
    [view_head3 addSubview:dtWeiZhi_msV];
    
    //2
    sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 240, bounds_width.size.width, bounds_width.size.height-240)];
    sc.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sc];
    
    [self showList];
}

-(void)showList{
    
    float newWidth=(bounds_width.size.width-60)/2+4;
    
    if(_nfcList.count>0)
        [self addButton:0 forLeft:18 forWidth:newWidth forBackImg:@"nfc_back_no" forConterImg:@"nfc_c_no" forName:[CommonUseClass FormatString:_nfcList[0][@"TermName"]] forTag:1];
    if(_nfcList.count>1)
        [self addButton:0 forLeft:18+newWidth+18 forWidth:newWidth forBackImg:@"nfc_back_no" forConterImg:@"nfc_c_no" forName:[CommonUseClass FormatString:_nfcList[1][@"TermName"]] forTag:2];
    if(_nfcList.count>2)
        [self addButton:120 forLeft:18 forWidth:newWidth forBackImg:@"nfc_back_no" forConterImg:@"nfc_c_no" forName:[CommonUseClass FormatString:_nfcList[2][@"TermName"]] forTag:3];
    if(_nfcList.count>3)
        [self addButton:120 forLeft:18+newWidth+18 forWidth:newWidth forBackImg:@"nfc_back_no" forConterImg:@"nfc_c_no" forName:[CommonUseClass FormatString:_nfcList[3][@"TermName"]] forTag:4];
    if(_nfcList.count>4)
        [self addButton:240 forLeft:18 forWidth:newWidth forBackImg:@"nfc_back_no" forConterImg:@"nfc_c_no" forName:[CommonUseClass FormatString:_nfcList[4][@"TermName"]] forTag:5];
    if(_nfcList.count>5)
        [self addButton:240 forLeft:18+newWidth+18 forWidth:newWidth forBackImg:@"nfc_back_no" forConterImg:@"nfc_c_no" forName:[CommonUseClass FormatString:_nfcList[5][@"TermName"]] forTag:6];
    if(_nfcList.count>6)
        [self addButton:360 forLeft:18 forWidth:newWidth forBackImg:@"nfc_back_no" forConterImg:@"nfc_c_no" forName:[CommonUseClass FormatString:_nfcList[6][@"TermName"]] forTag:7];
    if(_nfcList.count>7)
        [self addButton:360 forLeft:18+newWidth+18 forWidth:newWidth forBackImg:@"nfc_back_no" forConterImg:@"nfc_c_no" forName:[CommonUseClass FormatString:_nfcList[1][@"TermName"]] forTag:8];
    sc.contentSize = CGSizeMake(bounds_width.size.width, 480);
    
    int i=1;
    for (NSDictionary *dic in _nfcList) {
        if(![[CommonUseClass FormatString: dic[@"NFCCode"]] isEqual:@""])
            [self band_one:[NSString stringWithFormat:@"%d", i ]];
        i++;
    }
}

-(void)addButton:(int )top forLeft :(float)left forWidth:(float)width forBackImg:(NSString *)backImg
    forConterImg:(NSString *)ConterImg forName:(NSString *)name forTag:(int)tag
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(left, top, width, 105)];
    [sc addSubview:view];
    
    UIImageView *img_head22=[MyControl createImageViewWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageName:backImg];
    img_head22.tag=1000+tag;
    [view addSubview:img_head22];
    
    UIImageView *img_head33=[MyControl createImageViewWithFrame:CGRectMake((width-70)/2,0,  70, 70) imageName:ConterImg];
    img_head33.tag=2000+tag;
    [view addSubview:img_head33];
    
    UILabel *dttext = [MyControl createLabelWithFrame:CGRectMake(0, 63, width, 34) Font:14 Text:name];
    dttext.numberOfLines = 2;
    dttext.textAlignment=NSTextAlignmentCenter;
    [view addSubview:dttext];
    
    UIButton *btnBand= [MyControl createButtonWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) imageName:nil bgImageName:nil title:nil SEL:@selector(btnClick_band:) target:self];
    btnBand.tag=tag;
    [view addSubview:btnBand];
    
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



- (void)btnClick_band:(UIButton *)btn
{
    currTag=[NSString stringWithFormat:@"%ld", btn.tag];
    long index=btn.tag-1;
    currDic=_nfcList[index];
    
//    //test"0480B35AE64C81"@"9FE095021E2B01"
//    [self save:@"002" forID: @"0480B35AE64C81"];
//    return;
//    //test
    
    
    /**
     三个参数
     第一个参数：代理对象
     第二个参数：线程
     第三个参数：Session读取一个还是多个NDEF。YES：读取一个结束，NO：读取多个
     */
    NFCNDEFReaderSession *session = [[NFCNDEFReaderSession alloc] initWithDelegate:self queue:dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT) invalidateAfterFirstRead:YES];
    
    [session beginSession];
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
    vc.Title=[CommonUseClass FormatString: currDic[@"TermName"]];
    vc.Memo=[CommonUseClass FormatString: currDic[@"TermDesc"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tongzhi_warn:(NSNotification *)text{
    NSString *textId=(NSString *)text.userInfo[@"textId"];
    NSString *textValue=(NSString *)text.userInfo[@"textValue"];
    
    [self save:textValue forID:textId];
    
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
            [self save:str forID:guid];
        }
    }
}

-(void)save:(NSString *)nfccode forID:(NSString *)guid {
    NSString *str_str=[self getStrUpdate:nfccode forID:guid];
    //3.是否连网
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == -1) {
            //NSLog(@"未识别网络");
            [self thisSaveData:str_str];
        }
        else if (status == 0) {
            //NSLog(@"无网络");
            [self thisSaveData:str_str];
        }else{
            
            [self WBupload:str_str];
            
        }
    }];
}

-(void )WBupload:(NSString *)parm
{
    NSString *currUrl2=@"NFC/BindCheckNFC";
    [HTTPSessionManager
     post:currUrl2
     parameters:parm
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         //         NSLog(@"success====%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         NSString *Message=[dic_result objectForKey:@"Message"];
         
         NSLog(@"dic_result：%@",dic_result);
         
         if([success integerValue]!=1)
         {
             [self performSelectorOnMainThread:@selector(aa:) withObject:Message waitUntilDone:YES];
         }
         else
         {
             [self performSelectorOnMainThread:@selector(cc) withObject:data waitUntilDone:NO];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self performSelectorOnMainThread:@selector(aa:) withObject:@"提交失败" waitUntilDone:YES];
         
     }];
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

-(void)thisSaveData:(NSString *)str {
    //1
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"NFCBand"] ;
    NSMutableArray *array = [array0 mutableCopy];
    [defaults removeObjectForKey:@"NFCBand"];
    [defaults synchronize];
    
    //2
    if(array==nil)
    {
        array=[NSMutableArray new];
    }
    NSDictionary *newdic=[[NSDictionary alloc]initWithObjectsAndKeys:[CommonUseClass getUniqueStrByUUID],@"guid",str,@"value", nil];
    
    [array addObject:newdic];
    NSArray *myArray = [array copy];
    
    //3
    [defaults setObject:myArray forKey:@"NFCBand"];
    [defaults synchronize];
    
    [CommonUseClass showAlter:@"离线缓存成功！"];
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

//////////////
-(void)InitPop{
    //蒙版
    view_Content_back=[MyControl createViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height) backColor:[UIColor blackColor]];
    view_Content_back.alpha = 0.5;// 阴影透明度
    [self.view addSubview:view_Content_back];
    
    
    view_Content_2=[MyControl createViewWithFrame:CGRectMake(10, 150, self.view.frame.size.width-20, 240) backColor:[UIColor whiteColor]];
    [self.view addSubview:view_Content_2];
    
    
    
    UIView *viewBack=[MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 240) backColor:[UIColor whiteColor]];
    viewBack.alpha = 1;// 阴影透明度
    [view_Content_2 addSubview:viewBack];
    
    UILabel *selectLabel = [MyControl createLabelWithFrame:CGRectMake(0, 10, viewBack.frame.size.width, 20) Font:18 Text:@"输入电梯注册号码"];
    selectLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel.alpha=1.0;
    selectLabel.textAlignment = NSTextAlignmentCenter;
    [viewBack addSubview:selectLabel];
    
    tf=[MyControl createTextFildWithFrame:CGRectMake(20, CGRectGetMaxY(selectLabel.frame)+20, viewBack.frame.size.width-130-20, 40) Font:15 Text:@""];
    [tf.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    [tf.layer setBorderWidth:1];
    [viewBack addSubview:tf];
    
    //1.2
    UIButton *btn_select = [MyControl createButtonWithFrame:CGRectMake(viewBack.frame.size.width-120, CGRectGetMaxY(selectLabel.frame)+20, 50, 40) imageName:nil bgImageName:nil title:@"查询" SEL:@selector(btnClick_getLift:) target:self];
    [btn_select.layer setMasksToBounds:YES];
    [btn_select.layer setCornerRadius:5.0];
    [btn_select setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    btn_select.tag=200;
    [viewBack addSubview:btn_select];
   
    UIButton *btn_1 = [MyControl createButtonWithFrame:CGRectMake(viewBack.frame.size.width-60, CGRectGetMaxY(selectLabel.frame)+20, 60, 40) imageName:nil bgImageName:nil title:@"确定" SEL:@selector(btnClick_ReplaceTheElevator:) target:self];
        [btn_1.layer setMasksToBounds:YES];
        [btn_1.layer setCornerRadius:5.0];
    [btn_1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    btn_1.tag=200;
    [viewBack addSubview:btn_1];
    
    UILabel *selectLabel1 = [MyControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(btn_1.frame)+20, SCREEN_WIDTH-40, 20) Font:14 Text:@"提示:请输入当前电梯的准确注册号码"];
    selectLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel1.alpha=1.0;
    [viewBack addSubview:selectLabel1];
    
    //2.1
    UILabel *selectLabel_bh = [MyControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(selectLabel1.frame)+20,80, 20) Font:14 Text:@"电梯编号:"];
    selectLabel_bh.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel_bh.alpha=1.0;
    [viewBack addSubview:selectLabel_bh];
    
    selectLabel_bhvalue = [MyControl createLabelWithFrame:CGRectMake(90, CGRectGetMaxY(selectLabel1.frame)+20, SCREEN_WIDTH-100, 20) Font:14 Text:@""];
    selectLabel_bhvalue.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel_bhvalue.alpha=1.0;
    [viewBack addSubview:selectLabel_bhvalue];
    
    //2.2
    UILabel *selectLabel_dz = [MyControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(selectLabel_bhvalue.frame)+20, 60, 20) Font:14 Text:@"地址:"];
    selectLabel_dz.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel_dz.alpha=1.0;
    [viewBack addSubview:selectLabel_dz];
    
    selectLabel_dzvalue = [MyControl createLabelWithFrame:CGRectMake(70, CGRectGetMaxY(selectLabel_bhvalue.frame)+10, SCREEN_WIDTH-80, 40) Font:14 Text:@""];
    selectLabel_dzvalue.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel_dzvalue.alpha=1.0;
    [viewBack addSubview:selectLabel_dzvalue];
    
    [self hiddenPop];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboard:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [view_Content_back addGestureRecognizer:tapGestureRecognizer];
}
- (void)btnClick_bandLift:(UIButton *)btn
{
    view_Content_2.hidden=false;
    view_Content_back.hidden=false;
}
//点击空白-回收键盘
-(void)keyboard:(UITapGestureRecognizer*)tap
{
    [tf resignFirstResponder];
    [self hiddenPop];
}

-(void)hiddenPop{
    view_Content_2.hidden=YES;
    view_Content_back.hidden=YES;
}

- (void)btnClick_ReplaceTheElevator:(UIButton *)btn
{
    if(tf.text.length<=0)
    {
        [CommonUseClass showAlter:@"请输入注册号码!"];
        return;
    }
    if(tf.text.length!=20)
    {
        [CommonUseClass showAlter:@"请输入准确的注册号码!"];
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
    [dicHeader setValue:_liftNum forKey:@"LiftNum"];
    [dicHeader setValue:tf.text forKey:@"CertificateNum"];
    [dicHeader setValue:self.app.userInfo.UserID forKey:@"UserId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%f", Longitude] forKey:@"Longitude"];
    [dicHeader setValue:[NSString stringWithFormat:@"%f",Latitude] forKey:@"Latitude"];
    NSString *url=@"NFC/LiftSign";
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
                                                      message:@"绑定失败！"
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
    
    [self gotoDetail ];
}


-(void)gotoDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:_liftNum forKey:@"LiftNum"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    NSString *url=[NSString stringWithFormat:@"NFC/GetCheckTermIsNFC?LiftNum=%@",_liftNum];
    [XXNet GetURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[CommonUseClass FormatString: data[@"Message"]] isEqual:@"操作成功"]) {
            
            NSString *str_json = data [@"Data"];
            NSArray *arrData = [str_json objectFromJSONString];
            if(arrData.count>0)
            {
                NSMutableDictionary *dic=arrData[0];
                _UploadDate=[CommonUseClass FormatString:dic [@"CertificateNum"]];
                
                NSString *path=[CommonUseClass FormatString: dic [@"AddressPath"]];
                _InstallationAddress=[CommonUseClass FormatString: dic [@"InstallationAddress"]];
                _InstallationAddress = [path stringByAppendingString:_InstallationAddress];
                
                _liftID=[dic objectForKey:@"LiftID"];
                _nfcList=arrData;
                
                 [self performSelectorOnMainThread:@selector(reBand:) withObject:data[@"Message"] waitUntilDone:YES];
                
            }
            else if ([[CommonUseClass FormatString: data[@"Message"]] isEqual:@"电梯不存在"]) {
                //[self outLine];
            }
        }
        else
        {
            [CommonUseClass showAlter:data[@"Message"]];
        }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"查询失败！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

- (void)reBand:(NSString *)msg{
    [self hiddenPop];
    tf.text=@"";
    
    [btnNewDianti setBackgroundImage:[UIImage imageNamed:@"nfc_bandLift_re"] forState:UIControlStateNormal];
    dtWeiBao_2.text=_UploadDate;
    dtWeiZhi_2.text=_InstallationAddress;
    
    [tf resignFirstResponder];
    [sc.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self showList];
}


//getlift
- (void)btnClick_getLift:(UIButton *)btn
{
    if(tf.text.length<=0)
    {
        [CommonUseClass showAlter:@"请输入注册号码!"];
        return;
    }
    if(tf.text.length!=20)
    {
        [CommonUseClass showAlter:@"请输入准确的注册号码!"];
        return;
    }
    
    [self GetLift];
}
-(void)GetLift
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:tf.text forKey:@"CertificateNum"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    NSString *url=[NSString stringWithFormat:@"Lift/GetLiftByCertificateNum?CertificateNum=%@",tf.text];
    [XXNet GetURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[CommonUseClass FormatString: data[@"Message"]] isEqual:@"操作成功"]) {
            
            NSString *str_json = data [@"Data"];
            NSDictionary *dic = [str_json objectFromJSONString];
            [self performSelectorOnMainThread:@selector(showLift:) withObject:dic waitUntilDone:YES];
            
        }
        else
        {
            [CommonUseClass showAlter:data[@"Message"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"查询失败！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

- (void)showLift:(NSDictionary *)dic{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    selectLabel_bhvalue.text=[CommonUseClass FormatString:dic [@"LiftNum"]];
    
    NSString *path=[CommonUseClass FormatString: dic [@"AddressPath"]];
    NSString *dz=[CommonUseClass FormatString: dic [@"InstallationAddress"]];
    dz = [path stringByAppendingString:dz];
    selectLabel_dzvalue.text=dz;
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
