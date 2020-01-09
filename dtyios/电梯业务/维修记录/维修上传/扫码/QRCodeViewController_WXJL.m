//
//  QRCodeViewController_WXJL.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/4/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "QRCodeViewController_WXJL.h"
#import <AVFoundation/AVFoundation.h>
#import "CommonUseClass.h"

#import "MyControl.h"
@interface QRCodeViewController_WXJL ()<AVCaptureMetadataOutputObjectsDelegate>
{
    float jing;
    float  wei;
    NSString *addressStr;
    
    NSString *QRCode;
    int isOpen;
}
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
- (IBAction)startStopReading:(id)sender;

@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;

@property (nonatomic, strong) WXJLSaveViewController *questionBox;

-(BOOL)startReading;
-(void)stopReading;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation QRCodeViewController_WXJL

@synthesize app;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    _captureSession = nil;
    _isReading = NO;
    [self startReading];
    _isReading=YES;
    okCount=0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    _viewPreview.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
    self.navigationItem.title=@"扫一扫";
    
    
    //2.
    
    //    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
    //    left_BarButoon_Item.frame=CGRectMake(0, 0,80,25);
    //    [left_BarButoon_Item setTitle:@"输码进入" forState:UIControlStateNormal];
    //    //[left_BarButoon_Item setImage: [UIImage imageNamed:@"record.png"] forState:UIControlStateNormal];
    //    [left_BarButoon_Item addTarget:self action:@selector(listBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
    //    self.navigationItem.rightBarButtonItems=@[leftItem];
    
    //3.
    
    
    
    [self createUI];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_SelectPark" object:nil];
    
    
}

-(void)listBtn_Event:(id)sender{
    
    
    QRCode_Write *ctvc=[[QRCode_Write alloc] init];
    
    [self.navigationController pushViewController:ctvc animated:YES];
    
}

- (void)tongzhi_warn:(NSNotification *)text
{
    NSString *code=(NSString *)text.userInfo[@"textOne"];
    _lblStatus.text=code;
    [self gotoDetail];
}


-(void)navLeftBtn_Event:(id)sender{
    if([_lblStatus.text isEqual:@""])
    {
        [CommonUseClass showAlter:@"请扫描二维码！" ];
        return;
    }
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_lblStatus.text,@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_QRCode" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popViewControllerAnimated:true];
}

- (BOOL)startReading {
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //4.实例化捕捉会话
    _captureSession = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [_captureSession addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    [_captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    //7.设置预览图层填充方式
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //10.设置扫描范围
    captureMetadataOutput.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.8f, 0.8f);
    
    //10.1.扫描框
    //_boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.height - _viewPreview.bounds.size.height * 0.4f)];
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f)];
    _boxView.layer.borderColor = [UIColor greenColor].CGColor;
    _boxView.layer.borderWidth = 1.0f;
    
    [_viewPreview addSubview:_boxView];
    
    //10.2.扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = [UIColor brownColor].CGColor;
    
    [_boxView.layer addSublayer:_scanLayer];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    
    [timer fire];
    
    //10.开始扫描
    [_captureSession startRunning];
    
    
    return YES;
}

- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [_startBtn setTitle:@"结束扫描" forState:UIControlStateNormal];
            [_lblStatus setText:@""];
        }
    }
    else{
        [self stopReading];
        [_startBtn setTitle:@"开始扫描" forState:UIControlStateNormal];
    }
    
    _isReading = !_isReading;
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_scanLayer removeFromSuperlayer];
    [_videoPreviewLayer removeFromSuperlayer];
    
    if(okCount==1)
        [self gotoDetail];
}



#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        //1.stop
        [_captureSession stopRunning];
        _captureSession = nil;
        [_scanLayer removeFromSuperlayer];
        [_videoPreviewLayer removeFromSuperlayer];
        //2.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            NSArray *s = [[metadataObj stringValue] componentsSeparatedByString:@"="];
            if(s.count>=2)
            {
                okCount++;
                LiftNum = [s objectAtIndex:1];
                
                [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
                [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
                _isReading = NO;
            }
        }
        else
        {
            _captureSession = nil;
            _isReading = NO;
            [self startReading];
            _isReading=YES;
        }
    }
}

- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = _scanLayer.frame;
    if (_boxView.frame.size.height < _scanLayer.frame.origin.y) {
        frame.origin.y = 0;
        _scanLayer.frame = frame;
    }else{
        
        frame.origin.y += 5;
        
        [UIView animateWithDuration:0.1 animations:^{
            _scanLayer.frame = frame;
        }];
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}


-(void)createUI{
    viewLast=[MyControl createViewWithFrame:CGRectMake(0, bounds_width.size.height-160, bounds_width.size.width, 100) backColor:[UIColor blackColor]] ;// grayColor]];
    viewLast.alpha = 0.6;    //切记这个地方不要设置alpha
    [self.view addSubview:viewLast];
    
    float width=(bounds_width.size.width-20)/3;
    [self addButton:width forWidth:width forName:@"闪光灯" forTag:1 forIcon:@"lamp"];
    
}


- (void)addButton:(float)left forWidth:(float)width forName:(NSString *)name forTag:(int)tag forIcon:(NSString*)imageName {
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(left, 0, width, 80);
    [viewLast addSubview:view];
    
    UIButton *image=[[UIButton alloc]init];
    image.frame=CGRectMake((width-40)/2, 0+10, 40, 40);
    //    image.backgroundColor=[UIColor cyanColor];
    image.layer.masksToBounds = YES; //没这句话它圆不起来
    image.layer.cornerRadius = 20; //设置图片圆角的尺度
    [image setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [view addSubview:image];
    
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(0, 50+10, width, 20);
    label.text=name;
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    [view addSubview:label];
    
    UIButton *button=[[UIButton alloc]init];
    button.frame=CGRectMake(left, 0, width, 80);
    [button addTarget:self action:@selector(button_Event:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=tag;
    [viewLast addSubview:button];
}

- (void)button_Event:(UIButton *)btn{
    
    UIButton *button=(UIButton *)btn;
    
    if(button.tag==1)
    {
        [self openFlash];
    }
    
    
}





- (void)openFlash {
    
    if (isOpen == 0) { //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
        isOpen=1;
    }else{//关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
        isOpen=0;
    }
}



-(void)gotoDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:LiftNum forKey:@"LiftNum"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    //    NSString *url=WYXC_GetPropertyStep;
    //    url=[NSString stringWithFormat:@"%@?liftNum=%@",url,LiftNum];
    [XXNet PostURL:wxjl_GetRepairNewNum header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[CommonUseClass FormatString: data[@"Message"]] isEqual:@"操作成功"]) {
            
            NSString *str_json = data [@"Data"];
            NSDictionary *  dic = [str_json objectFromJSONString];
            if(![[CommonUseClass FormatString: dic [@"LiftNum"]]  isEqual:@""])
            {
                UploadDate=[CommonUseClass FormatString:dic [@"CreateTime"]];
                InstallationAddress=[CommonUseClass FormatString: dic [@"RepairPosition"]];
                Remark=[CommonUseClass FormatString: dic [@"Remark"]];
                BeforePhoto=[CommonUseClass FormatString: dic [@"BeforePhoto"]];
                AfterPhoto=[CommonUseClass FormatString: dic [@"AfterPhoto"]];
                ID=[CommonUseClass FormatString: dic [@"Id"]];
                liftID=[CommonUseClass FormatString: dic [@"LiftId"]];
//                stet=[dic objectForKey:@"PropertyStep"];
//                PropertyCheckId=[dic objectForKey:@"PropertyCheckId"];
                //    self.questionBox.liftID=liftID;
                [self gotoDetail_go];
            }
            else if ([[CommonUseClass FormatString: data[@"Message"]] isEqual:@"电梯不存在"]) {
                [self outLine];
            }
        }
        else
        {
            [CommonUseClass showAlter:data[@"Message"]];
        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(dd) withObject:nil waitUntilDone:YES];
        
    }];
    
    
}
- (void)dd{
    
    [CommonUseClass showAlter:@"操作失败"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


#pragma mark - 暂无此电梯信息，是否创建？-------
-(void)outLine
{
    // 1、初始化
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"暂无此电梯信息，是否创建？" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    // 3、添加取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        _captureSession = nil;
        _isReading = NO;
        [self startReading];
        _isReading=YES;
    }]];
    // 4、添加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self gotoDetail_go];
    }]];
    // 5、模态切换显示弹出框
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)gotoDetail_go{
    
    //    JYGLSave *ctvc=[[JYGLSave alloc] init];
    //    //ctvc.model=warnModel;
    //    ctvc.liftNum=LiftNum;
    //    [self.navigationController pushViewController:ctvc animated:YES];
    
    //SZConfigure *configure = [[SZConfigure alloc] init];
//    configure.checkedImage = @"dx_h@2x";
//    configure.unCheckedImage = @"dx@2x";
//    configure.optionTextColor = [UIColor lightGrayColor];
    self.questionBox = [[WXJLSaveViewController alloc] init];
    self.questionBox.typeStr=@"0";
    self.questionBox.liftNum = LiftNum;
    self.questionBox.liftID = liftID;
    int tag=0;
    self.questionBox.floorNumber=tag;    
        self.questionBox.UploadDate=UploadDate;
        self.questionBox.InstallationAddress=InstallationAddress;
        self.questionBox.Remark=Remark;
        self.questionBox.BeforePhoto=BeforePhoto;
        self.questionBox.AfterPhoto=AfterPhoto;
        self.questionBox.ID=ID;
        NSString * title=@"维修记录";
        self.questionBox.Title=title;
        self.questionBox.CType=[NSString stringWithFormat:@"%d", tag];
        [self.navigationController pushViewController:self.questionBox animated:YES];
}

//-(void)getSchoolCourse1
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
//    [dicHeader setValue:LiftNum forKey:@"LiftNum"];
//    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
//    [XXNet GetURL:GetInspectByLiftNum header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if ([data[@"Success"]intValue]) {
//            NSString *str_json = data [@"Data"];//InspectDetails"];
//            NSDictionary *  dic = [str_json objectFromJSONString];
//            NSArray *currArr=[dic objectForKey:@"InspectDetails"];
//            NSMutableArray *newArr=[[NSMutableArray alloc]init];
//
//            for (NSMutableDictionary *currdic in arrData) {
//                NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:currdic];
//                for (NSMutableDictionary *currdic_value in currArr) {
//
//
//                    if([[currdic_value objectForKey:@"StepId"] isEqual: [currdic objectForKey:@"ID"] ])
//                    {
//
//                        [newdic setObject:[currdic_value objectForKey:@"Remark"] forKey:@"Remark"];
//                        [newdic setObject:[currdic_value objectForKey:@"CreateTime"] forKey:@"CreateTime1"];
//                        [newdic setObject:[currdic_value objectForKey:@"UserName"] forKey:@"UserName"];
//                        [newdic setObject:[currdic_value objectForKey:@"PhotoUrl"] forKey:@"PhotoUrl"];
//                        [newdic setObject:[currdic_value objectForKey:@"VideoPath"] forKey:@"VideoPath"];
//                        break;
//                    }
//
//                }
//                [newArr addObject:newdic];
//            }
//
//            arrData=newArr;
//
//
//
//            JYGLSave *ctvc=[[JYGLSave alloc] init];
//            //ctvc.model=warnModel;
//            //ctvc.liftNum=warnModel.Lift.LiftNum;
//            [self.navigationController pushViewController:ctvc animated:YES];
//        }
//
//    } failure:^(NSError *error) {
//
//        [self performSelectorOnMainThread:@selector(dd) withObject:nil waitUntilDone:YES];
//
//    }];
//
//
//}
@end
