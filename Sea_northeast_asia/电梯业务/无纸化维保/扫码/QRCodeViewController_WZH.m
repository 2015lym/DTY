//
//  QRCodeViewController_WZH.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "QRCodeViewController_WZH.h"
#import <AVFoundation/AVFoundation.h>
#import "CommonUseClass.h"
#import "EWMDetailViewController.h"

#import "DTWBWebViewController.h"
@interface QRCodeViewController_WZH ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

- (IBAction)startStopReading:(id)sender;

@property (strong, nonatomic) UIView *boxView;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) CALayer *scanLayer;

-(BOOL)startReading;
-(void)stopReading;

//捕捉会话
@property (nonatomic, strong) AVCaptureSession *captureSession;
//展示layer
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end

@implementation QRCodeViewController_WZH
@synthesize app;
-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    _viewPreview.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
    self.navigationItem.title=@"扫一扫";
    
    _captureSession = nil;
    _isReading = NO;
    
    //    //test
    //    [self goWBDC:@"110211"];
    //    return;
    //    //test
    isOK=0;
    [self startReading];
    _isReading=YES;
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
    _boxView = [[UIView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.2f, _viewPreview.bounds.size.height * 0.3f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f, _viewPreview.bounds.size.width - _viewPreview.bounds.size.width * 0.4f)];
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
    
    
    NSArray *array = [_lblStatus.text componentsSeparatedByString:@"="];
    NSString *str = [NSString stringWithFormat:@"%@",[array lastObject]];
    
    //    //添加 字典，将label的值通过key值设置传递
    //    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_lblStatus.text,@"textOne", nil];
    //    //创建通知
    //    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_QRCode" object:nil userInfo:dict];
    //    //通过通知中心发送通知
    //    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSLog(@"扫描成功==%@",str);
    
    //    EWMDetailViewController *vc = [[EWMDetailViewController alloc] init];
    //    vc.liftNum = str;
    //    [self.navigationController pushViewController:vc animated:YES];
    
    [self goWBDC:str];
}
-(void)goWBDC:(NSString *)str{
    [self getSchoolCourse :str];
    
}

-(void)goWB:(NSString *)str{
    SZConfigure *configure = [[SZConfigure alloc] init];
    configure.checkedImage = @"dx_h@2x";
    configure.unCheckedImage = @"dx@2x";
    configure.optionTextColor = [UIColor lightGrayColor];
    self.questionBox = [[SZQuestionCheckBox alloc] initWithItem:self.item andConfigure:configure];
    self.questionBox.typeStr=@"0";
    self.questionBox.liftNum = str;
    [self.navigationController pushViewController:self.questionBox animated:YES];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //判断是否有数据
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //判断回传的数据类型
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            isOK++;
            if(isOK>1)return;
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            _isReading = NO;
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


-(void)getSchoolCourse:(NSString *)str
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",self.app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    
     [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",str] forHTTPHeaderField:@"LiftNum"];
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:@"Check/GetLiftCheckByLiftNum2"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if([[CommonUseClass FormatString: dic_result[@"Success"]] isEqual:@"1"])
         {
         //NSDictionary *dict = [[dic_result objectForKey:@"Data"] objectFromJSONString];
             
             
         
         WBDCViewController_WZH *wbdc=  [[WBDCViewController_WZH alloc] init];
         wbdc.liftNum=str;
         [self.navigationController pushViewController:wbdc animated:YES];
             
             
         }
         else
         {
              [self performSelectorOnMainThread:@selector(dd:) withObject:dic_result[@"Message"] waitUntilDone:YES];
         }
         
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         [self performSelectorOnMainThread:@selector(dd:) withObject:@"电梯不存在" waitUntilDone:YES];
         
     }];
    
    
}
- (void)dd:(NSString *)msg{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[DTWBWebViewController_WZH class]]) {
            [self.navigationController popToViewController:controller animated:NO];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end
