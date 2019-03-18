//
//  QRCodeViewController_PJGL.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "QRCodeViewController_PJGL.h"
#import <AVFoundation/AVFoundation.h>
#import "CommonUseClass.h"

#import "MyControl.h"
@interface QRCodeViewController_PJGL ()<AVCaptureMetadataOutputObjectsDelegate>
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

//@property (nonatomic, strong) WYXCSaveViewController *questionBox;

-(BOOL)startReading;
-(void)stopReading;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation QRCodeViewController_PJGL

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
    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
    left_BarButoon_Item.frame=CGRectMake(0, 0,80,25);
    [left_BarButoon_Item setTitle:@"输码进入" forState:UIControlStateNormal];
    [left_BarButoon_Item addTarget:self action:@selector(listBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
    self.navigationItem.rightBarButtonItems=@[leftItem];
    
    //3.
    [self createUI];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_SelectPark" object:nil];
    
}

-(void)listBtn_Event:(id)sender{
    
    
    QRCode_Write_PJGL *ctvc=[[QRCode_Write_PJGL alloc] init];
    
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
    
    if(1==okCount)
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
    [dicHeader setValue:[CommonUseClass FormatString:LiftNum] forKey:@"LiftNum"];
    //[dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    NSString *url=[NSString stringWithFormat:@"LiftParts/GetLift"];
    [XXNet PostURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[CommonUseClass FormatString: data[@"Success"]] isEqual:@"1"]) {
            
            NSString *str_json = data [@"Data"];
            NSDictionary *dic = [str_json objectFromJSONString];
            LiftNum=[CommonUseClass FormatString:dic [@"LiftNum"]];
            CertificateNum=[CommonUseClass FormatString:dic [@"CertificateNum"]];
            NSString *path=[CommonUseClass FormatString: dic [@"AddressPath"]];
            InstallationAddress=[CommonUseClass FormatString: dic [@"InstallationAddress"]];
            InstallationAddress = [path stringByAppendingString:InstallationAddress];
            LiftId=[CommonUseClass FormatString:dic [@"LiftId"]];
            
            _classLiftParts=[[classLiftParts alloc]init];
            _classLiftParts.LiftId=LiftId;
            _classLiftParts.LiftNum=LiftNum;
            _classLiftParts.CertificateNum=CertificateNum;
            _classLiftParts.AddressPath=path;
            _classLiftParts.InstallationAddress=InstallationAddress;
            _classLiftParts.list=dic [@"list"];
            _classLiftParts.listType=dic [@"listType"];
            
            [self gotoDetail_go];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(dd:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        
    } failure:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(dd:) withObject:MessageResult waitUntilDone:YES];
    }];
    
}
- (void)dd:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)gotoDetail_go{
    
    PJGLSaveViewController *ctvc=[[PJGLSaveViewController alloc] init];
    ctvc.LiftId=LiftId;
    ctvc.liftNum=LiftNum;
    ctvc.InstallationAddress=InstallationAddress;
    ctvc.CertificateNum=CertificateNum;
    ctvc.classLiftParts=_classLiftParts;
    [self.navigationController pushViewController:ctvc animated:YES];
    
   
}


@end
