//
//  SBTSViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/5.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "SBTSViewController.h"
#import "MyControl.h"
#import "CommonUseClass.h"
#import "GCDAsyncSocket.h"
@interface SBTSViewController ()<GCDAsyncSocketDelegate>
{
    UILabel *text_show;
    UIView *view1;
    UIView *view2;
}
// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (nonatomic, assign) BOOL connected;
@end

@implementation SBTSViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self setWifi];
}

- (void)dealloc{
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (nil != link) {
        [link invalidate];
        link = nil;
    }
}

- (void)btnClick_stop:(UIButton *)btn
{
    [CommonUseClass showAlter:@"设备调试完成，请手动连接其他网络！"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"设备调试";
    self.view.backgroundColor=[UIColor whiteColor];
     self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    sbtsModel=[[SBTSModel alloc]init];
    [self initWindow];
    
    UIButton *right_BarButoon_Item=[[UIButton alloc] init];
    right_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    [right_BarButoon_Item setImage:[UIImage imageNamed:@"backArrow@2x"] forState:UIControlStateNormal];
    [right_BarButoon_Item addTarget:self action:@selector(btnClick_stop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_BarButoon_Item];
    self.navigationItem.leftBarButtonItems=@[rightItem];
    
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tapGesturRecognizer];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_sbts" object:nil];
    
}

-(void)tapAction:(id)tap
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)tongzhi_warn:(NSNotification *)text{
    [self setWifi];
}


-(void)addTab{
    long left=(SCREEN_WIDTH/2-80)/2;
    UIButton *dyzjBtn = [MyControl createButtonWithFrame:CGRectMake(left, 50, 80, 35) imageName:nil bgImageName:nil title:@"设备调试" SEL:@selector(changeParkClick:) target:self];
    [dyzjBtn setTitleColor:[CommonUseClass getSysColor] forState:UIControlStateNormal];
    dyzjBtn.tag=0;
    [self .view addSubview:dyzjBtn];
    
    
    UIButton *dyzjBtn_1 = [MyControl createButtonWithFrame:CGRectMake(left+bounds_width.size.width/2, 50, 80, 35) imageName:nil bgImageName:nil title:@"电梯绑定" SEL:@selector(changeParkClick:) target:self];
    [dyzjBtn_1 setTitleColor:[CommonUseClass getSysColor] forState:UIControlStateNormal];
    dyzjBtn_1.tag=1;
    [self .view addSubview:dyzjBtn_1];
    
    line = [[UILabel alloc]init];
    line.frame=CGRectMake(left+20,34+50, 40, 1);
    line.backgroundColor=[CommonUseClass getSysColor] ;
    [self .view addSubview:line];
    
    //2.
    tabCurrent=0;
//    CourseTableview.PageIndex=1;
//    [self getSchoolCourse];
}

- (IBAction)changeParkClick:(id)sender {
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    UIButton *btn=(UIButton *)sender;
    
    long left=(SCREEN_WIDTH/2-80)/2;
    switch (btn.tag) {
        case 0:
            tabCurrent=0;
            line.frame=CGRectMake(left+20, 34+50, 40, 1);
            view2.hidden=YES;
            view1.hidden=NO;
            break;
        case 1:
        {
            tabCurrent=1;
            line.frame=CGRectMake(bounds_width.size.width/2+left+20, 34+50, 40, 1);
            view2.hidden=NO;
            view1.hidden=YES;
            
            //e2
            NSData *data=[sbtsModel getE2];
            [self.clientSocket writeData:data withTimeout:- 1 tag:0];
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
            break;
            
        default:
            break;
    }
}

/////////////////////wifi
-(void)goWifi
{
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=WIFI"]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
//    } else {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"]];
//    }

    NSURL * url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];           [[UIApplication sharedApplication] openURL:url];
        
    }

}

-(void)setWifi
{
if([CommonUseClass isWiFiOpened] && [[CommonUseClass getCurretWiFiSsid] isEqual:@"HD2000"])
{
    [self dismissWaitingAlert];
    lab_wifi.text=@"Wifi:HD2000";
    [self connectAction];
}
else
{
    lab_wifi.text=@"Wifi:";
    [self showWaitingAlert:@"需要手动连接Wifi"];
}
}
/////////////////////wifi
//////////////////////////////UIAlertView
-(void)showWaitingAlert:(NSString *)msg{
    waittingAlert = [[UIAlertView alloc] initWithTitle:msg
                                               message: @"请连接名称为【HD2000】的Wifi"
                                              delegate: self
                                     cancelButtonTitle: @"退出"
                                     otherButtonTitles: @"确认",nil];
    
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
    [waittingAlert addSubview:activityView];
    [activityView startAnimating];
    
    [waittingAlert show];
}
-(void) dismissWaitingAlert{
    if (waittingAlert != nil) {
        [waittingAlert dismissWithClickedButtonIndex:0 animated:YES];
        //[waittingAlert release];
        waittingAlert =nil;
    }
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:true];
    }
    else
    {
    [self goWifi];
    }
}

//////////////////////////////UIAlertView
//////////////////////////////tcp
// 开始连接
- (void)connectAction
{
    // 链接服务器
    if (!self.connected)
    {
        self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        NSLog(@"开始连接%@",self.clientSocket);
        
        NSError *error = nil;
        self.connected = [self.clientSocket connectToHost:@"192.168.4.1" onPort:5000 viaInterface:nil withTimeout:-1 error:&error];
        
        if(self.connected)
        {
            //[self showMessageWithStr:@"客户端尝试连接"];
        }
        else
        {
            self.connected = NO;
            [MBProgressHUD showSuccess:@"通信未建立" toView:nil];
        }
    }
    else
    {
        [MBProgressHUD showSuccess:@"通信已建立" toView:nil];
        [self getCommond:1];
    }
}



#pragma mark - GCDAsyncSocketDelegate

/**
 连接主机对应端口号
 
 @param sock 客户端socket
 @param host 主机
 @param port 端口号
 */
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    //    NSLog(@"连接主机对应端口%@", sock);
    [MBProgressHUD showSuccess:@"通信已建立" toView:nil];
    lab_tcp.text=@"通信已建立";
    
    // 连接后,可读取服务器端的数据
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
    self.connected = YES;
    
    //e1
    NSData * appUserId=[sbtsModel getByteForInt:self.app.userInfo.UserID];
    NSData *data=[sbtsModel getE1:appUserId];
    [self.clientSocket writeData:data withTimeout:- 1 tag:0];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/**
 客户端socket断开
 
 @param sock 客户端socket
 @param err 错误描述
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    [MBProgressHUD showSuccess:@"通信未建立" toView:nil];
    lab_tcp.text=@"通信未建立";
    
    self.clientSocket.delegate = nil;
    self.clientSocket = nil;
    self.connected = NO;
}


// 发送数据
- (IBAction)sendMessageAction:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSData *data=[self getCommond:btn.tag];
    
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    [self.clientSocket writeData:data withTimeout:- 1 tag:0];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/**
 读取数据
 
 @param sock 客户端socket
 @param data 读取到的数据
 @param tag 当前读取的标记
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    // 读取到服务器数据值后,能再次读取
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
    
    //sbbind
    if(data.length>1)
    {
        Byte *testByte = (Byte *)[data bytes];
        if (testByte[0]==0xe1||testByte[0]==0xe2||testByte[0]==0xe3) {
            [self getsbandReturn:data];
            return;
        }
    }
    else
    {
        return;
    }
    
    //sbts
    if(data.length==36)
    {
        //NSData * adata=[data subdataWithRange:NSMakeRange(1, 32)];
        [self showReturnData:data];
    }
    else
    {
        if(data.length>1)
        {
            NSMutableData *mutableData =[NSMutableData dataWithData:data_old];
            [mutableData appendData:(NSData *)data];
            Byte *testByte = (Byte *)[mutableData bytes];
            
            Byte newbyte[36];
            if (mutableData.length>=36)
            {
                newbyte[0]=0xe3;
                for (long i=mutableData.length-1; i>=0; i--) {
                    if(testByte[i]==0xaa)
                    {
                        
                    }
                }
            }
            
            
            
//             &&testByte[0]==0xaa) {
//                [self showReturnData:mutableData];
//            }
//            else
//            {
//                [MBProgressHUD showError:@"错误数据" toView:nil];
//            }
        }
        
         data_old=data;
    }
   
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// 信息展示
- (void)showMessageWithStr_sbReturn:(NSString *)str
{
    text_show.text =str;
}

/////////////////////////sbband
-(void)getsbandReturn:(NSData *)data{
    Byte *testByte = (Byte *)[data bytes];
    if (testByte[0]==0xe1)
    {
        if(data.length>2)
        {
            if(testByte[1]==0x00)
            {lab_auth.text=@"已授权";}
            else
            {lab_auth.text=@"未授权";}
        }
    }
    else if (testByte[0]==0xe2)
    {
        if(data.length<2)return;
        
        if(testByte[1]==0x00)
        {
            if(data.length<93)
                return;
            NSString *zch=@"";
            NSString *zch1=[self getString: testByte[2]];
            NSString *zch2=[self getString: testByte[3]];
            NSString *zch3=[self getString: testByte[4]];
            NSString *zch4=[self getString: testByte[5]];
            NSString *zch5=[self getString: testByte[6]];
            NSString *zch6=[self getString: testByte[7]];
            NSString *zch7=[self getString: testByte[8]];
            NSString *zch8=[self getString: testByte[9]];
            NSString *zch9=[self getString: testByte[10]];
            NSString *zch10=[self getString: testByte[11]];
            zch=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",zch1,zch2,zch3,zch4,zch5,zch6,zch7,zch8,zch9,zch10 ];
            lab_sbCode.text=zch;
            
            NSString *zcCode=@"";
            NSString *zcCode1=[self getString: testByte[12]];
            NSString *zcCode2=[self getString: testByte[13]];
            NSString *zcCode3=[self getString: testByte[14]];
            NSString *zcCode4=[self getString: testByte[15]];
            NSString *zcCode5=[self getString: testByte[16]];
            NSString *zcCode6=[self getString: testByte[17]];
            NSString *zcCode7=[self getString: testByte[18]];
            NSString *zcCode8=[self getString: testByte[19]];
            NSString *zcCode9=[self getString: testByte[20]];
            NSString *zcCode10=[self getString: testByte[21]];
            NSString *zcCode11=[self getString: testByte[22]];
            NSString *zcCode12=[self getString: testByte[23]];
            NSString *zcCode13=[self getString: testByte[24]];
            NSString *zcCode14=[self getString: testByte[25]];
            NSString *zcCode15=[self getString: testByte[26]];
            NSString *zcCode16=[self getString: testByte[27]];
            NSString *zcCode17=[self getString: testByte[28]];
            NSString *zcCode18=[self getString: testByte[29]];
            NSString *zcCode19=[self getString: testByte[30]];
            NSString *zcCode20=[self getString: testByte[31]];
            zcCode=[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",zcCode1 ,zcCode2,zcCode3,zcCode4,zcCode5,zcCode6,zcCode7,zcCode8,zcCode9,zcCode10,zcCode11,zcCode12,zcCode13,zcCode14,zcCode15,zcCode16,zcCode17,zcCode18,zcCode19,zcCode20];
            lab_zcCode.text=zcCode;
            
            NSData * data_dz=[data subdataWithRange:NSMakeRange(32, 60)];
            NSString *str_dz = [[NSString alloc] initWithData:data_dz encoding:NSUTF8StringEncoding];
            lab_dz.text=str_dz;
        }
        else if(testByte[1]==0x01)
        {
            if(data.length<93)
                return;
            
            NSData * appUserId=[sbtsModel getByteForInt:self.app.userInfo.UserID];
            NSData *data=[sbtsModel getE2_1:appUserId forzcCode:tf_zcCode.text forType:0x02];
            [self.clientSocket writeData:data withTimeout:- 1 tag:0];
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        else if(testByte[1]==0x02)
        {
            if(data.length<4)
                return;
            
            if(testByte[2]==0x00)
            {
                [CommonUseClass showAlter:@"需要app确认绑定"];
            }
            if(testByte[2]==0x01)
            {
                [CommonUseClass showAlter:@"已成功绑定"];
            }
            if(testByte[2]==0x02)
            {
                [CommonUseClass showAlter:@"电梯注册码错误"];
            }
            if(testByte[2]==0x03)
            {
                [CommonUseClass showAlter:@"电梯编码错误"];
            }
            if(testByte[2]==0x04)
            {
                [CommonUseClass showAlter:@"效验错误"];
            }
            if(testByte[2]==0x05)
            {
                [CommonUseClass showAlter:@"连接不到网络"];
            }
            if(testByte[2]==0x06)
            {
                [CommonUseClass showAlter:@"该设备已绑过其他电梯"];
            }
            if(testByte[2]==0x07)
            {
                [CommonUseClass showAlter:@"该注册码已绑定其他设备"];
            }
        }
    }
    else if (testByte[0]==0xe3)
    {
        if(data.length>2)
        {
            if(testByte[1]==0x00)
            {
               [CommonUseClass showAlter:@"操作成功"];
               if( [wbState_state isEqual:@"sk"])
                   lab_wbState.text=@"维保已开始，谢谢！";
                else
                    lab_wbState.text=@"维保已结束，谢谢！";
            }
            else
            {[CommonUseClass showAlter:@"操作失败"];}
        }
    }
}
/////////////////////////sbband




-(NSData *)getCommond:(long)tag{
    
    if(tag==1)//menu
    {
        Byte  bytes[] ={0x04};
        return [[NSData alloc] initWithBytes:bytes length:1];
    }
    else if(tag==2)//esc
    {
        Byte  bytes[] ={0x02};
        return [[NSData alloc] initWithBytes:bytes length:1];
    }
    else if(tag==3)//up
    {
        Byte  bytes[] ={0x08};
        return [[NSData alloc] initWithBytes:bytes length:1];
    }
    else if(tag==4)//down
    {
        Byte  bytes[] ={0x10};
        return [[NSData alloc] initWithBytes:bytes length:1];
    }
    else if(tag==5)//left
    {
        Byte  bytes[] ={0x21};
        return [[NSData alloc] initWithBytes:bytes length:1];
    }
    else if(tag==6)//right
    {
        Byte  bytes[] ={0x20};
        return [[NSData alloc] initWithBytes:bytes length:1];
    }
    else if(tag==7)//Enter
    {
        Byte  bytes[] ={0x80};
        return [[NSData alloc] initWithBytes:bytes length:1];
    }
    return nil;
}

-(void)showReturnData:(NSData *)datas{

    Byte *testByte = (Byte *)[datas bytes];
     if (testByte[0]!=0xaa) {
         [MBProgressHUD showError:@"错误数据" toView:nil];
         return;
     }
    //1.clear
    [self clearLine];
    link.paused=YES;
    [link invalidate];
    link = nil;
    
    //2.show
    lab_1.text=[self getString: testByte[1]];
    lab_2.text=[self getString: testByte[2]];
    lab_3.text=[self getString: testByte[3]];
    lab_4.text=[self getString: testByte[4]];
    lab_5.text=[self getString: testByte[5]];
    lab_6.text=[self getString: testByte[6]];
    lab_7.text=[self getString: testByte[7]];
    lab_8.text=[self getString: testByte[8]];
    lab_9.text=[self getString: testByte[9]];
    lab_10.text=[self getString: testByte[10]];
    lab_11.text=[self getString: testByte[11]];
    lab_12.text=[self getString: testByte[12]];
    lab_13.text=[self getString: testByte[13]];
    lab_14.text=[self getString: testByte[14]];
    lab_15.text=[self getString: testByte[15]];
    lab_16.text=[self getString: testByte[16]];
    lab_17.text=[self getString: testByte[17]];
    lab_18.text=[self getString: testByte[18]];
    lab_19.text=[self getString: testByte[19]];
    lab_20.text=[self getString: testByte[20]];
    lab_21.text=[self getString: testByte[21]];
    lab_22.text=[self getString: testByte[22]];
    lab_23.text=[self getString: testByte[23]];
    lab_24.text=[self getString: testByte[24]];
    lab_25.text=[self getString: testByte[25]];
    lab_26.text=[self getString: testByte[26]];
    lab_27.text=[self getString: testByte[27]];
    lab_28.text=[self getString: testByte[28]];
    lab_29.text=[self getString: testByte[29]];
    lab_30.text=[self getString: testByte[30]];
    lab_31.text=[self getString: testByte[31]];
    lab_32.text=[self getString: testByte[32]];
    
    //3.
    int posion = testByte[35] - 16 * 3+1;
    if(posion<=0||posion>36)return;
    if(testByte[33]==0x01)//光标有无
    {
        lineCursor =(UILabel *)[self.view viewWithTag:(1000+posion)];
        if(testByte[34]==0x01)//光标是否闪烁
        {
            lineCursorCount=0;
            link = [CADisplayLink displayLinkWithTarget:self selector:@selector(lineChange)];
            link.frameInterval =30;
            [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        }
        else
        {
            lineCursor.hidden=NO;
        }
    }
}

-(void)lineChange
{
    if(lineCursorCount==0)
    {
        lineCursor.hidden=NO;
        lineCursorCount=1;
    }
    else
    {
        lineCursor.hidden=YES;
        lineCursorCount=0;
    }
}

-(NSString *) getString:(Byte )byte {
    NSString *str;
     Byte  bytes[] ={byte};
    NSData *data=[[NSData alloc] initWithBytes:bytes length:1];
    if (byte==0xff) {
        str = @"■";
    } else if (byte==0xDB) {
        str = @"□";
    } else if (byte==0x00) {
        str = @"↑";
    } else if (byte==0x01) {
        str = @"↓";
    } else {
    str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return str;
}
//////////////////////////////tcp

-(void)createLabel:(NSString *)title forLabelWidth:(int)labelWidth forValueControl:(UILabel *)label forTop:(int)top forImageName:(NSString *)imgName{
    UIView *view=[MyControl createViewWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 60) backColor:[UIColor whiteColor]];
    [view2 addSubview:view];
    
    UIImageView *img=[MyControl createImageViewWithFrame:CGRectMake(10, 20, 20, 20) imageName:imgName];
    [view addSubview:img];
    
    UILabel *lab=[MyControl createLabelWithFrame:CGRectMake(40, 20, labelWidth, 20) Font:15 Text:title];
    [view addSubview:lab];
    
    [view addSubview:label];
    
    UILabel *line=[MyControl createLabelWithFrame:CGRectMake(0, 59, SCREEN_WIDTH, 1) Font:15 Text:@""];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
}

-(void)createLabel1:(NSString *)title forLabelWidth:(int)labelWidth forValueControl:(UITextField *)label forTop:(int)top forImageName:(NSString *)imgName{
    UIView *view=[MyControl createViewWithFrame:CGRectMake(0, top, SCREEN_WIDTH, 90) backColor:[UIColor whiteColor]];
    [view2 addSubview:view];
    
    UIImageView *img=[MyControl createImageViewWithFrame:CGRectMake(10, 20, 20, 20) imageName:imgName];
    [view addSubview:img];
    
    UILabel *lab=[MyControl createLabelWithFrame:CGRectMake(40, 20, labelWidth, 20) Font:15 Text:title];
    [view addSubview:lab];
    
    
    label.placeholder=@"请输入20位电梯注册代码";
    label.layer.borderColor= [UIColor lightGrayColor].CGColor;
    label.layer.borderWidth=1.0f;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 4;
    [view addSubview:label];
    
    UIButton * btn_ks=[MyControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, 50, 60, 30) imageName:nil bgImageName:nil title:@"提交" SEL:@selector(sbbdUpdateClick:) target:self];
    [btn_ks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_ks .backgroundColor=[CommonUseClass getSysColor];
    btn_ks.layer.masksToBounds = YES;
    btn_ks.layer.cornerRadius = 4;
    [view addSubview:btn_ks];
    
    UILabel *line=[MyControl createLabelWithFrame:CGRectMake(0, 89, SCREEN_WIDTH, 1) Font:15 Text:@""];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
}

- (IBAction)sbbdUpdateClick:(id)sender {
    if(tf_zcCode.text.length==0)
    {
        [CommonUseClass showAlter:@"请输入20位注册代码！"];
        return;
    }
    if(tf_zcCode.text.length!=20)
    {
        [CommonUseClass showAlter:@"请输入20位注册代码！"];
        return;
    }
    //e1
    NSData * appUserId=[sbtsModel getByteForInt:self.app.userInfo.UserID];
    NSData *data=[sbtsModel getE2_1:appUserId forzcCode:tf_zcCode.text forType:0x01];
    [self.clientSocket writeData:data withTimeout:- 1 tag:0];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (IBAction)sbbdWBKSClick:(id)sender {
    //e3
    wbState_state=@"ks";
    NSData * appUserId=[sbtsModel getByteForInt:self.app.userInfo.UserID];
    NSData *data=[sbtsModel getE3:appUserId forType:0x01];
    [self.clientSocket writeData:data withTimeout:- 1 tag:0];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
- (IBAction)sbbdWBJSClick:(id)sender {
    //e3
    wbState_state=@"js";
    NSData * appUserId=[sbtsModel getByteForInt:self.app.userInfo.UserID];
    NSData *data=[sbtsModel getE3:appUserId forType:0x02];
    [self.clientSocket writeData:data withTimeout:- 1 tag:0];
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

-(void)initWindow{
    
    //1.top
    UIView * viewTop=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self .view addSubview: viewTop];
    
    UILabel * topLine=[[UILabel alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    topLine.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [viewTop addSubview: topLine];
    
    UIImageView *img_top_1=[MyControl createImageViewWithFrame:CGRectMake(10, 14, 14, 11) imageName:@"sbts_wifi"];
    [viewTop addSubview:img_top_1];
    lab_wifi=[MyControl createLabelWithFrame:CGRectMake(35, 0, 150, 40) Font:12 Text:@"Wifi:"];
    lab_wifi.textColor=[UIColor grayColor];
    [viewTop addSubview:lab_wifi];
    
    UIImageView *img_top_2=[MyControl createImageViewWithFrame:CGRectMake(SCREEN_WIDTH/2, 14, 14, 11) imageName:@"sbts_tcp"];
    [viewTop addSubview:img_top_2];
    lab_tcp=[MyControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH/2+25, 0, 100, 40) Font:12 Text:@"通信已断开"];
    lab_tcp.textColor=[UIColor grayColor];
    [viewTop addSubview:lab_tcp];
    
    UIImageView *img_top_3=[MyControl createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-80, 14, 14, 11) imageName:@"sbts_auth"];
    [viewTop addSubview:img_top_3];
    lab_auth=[MyControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH-60, 0, 50, 40) Font:12 Text:@"未授权"];
    lab_auth.textColor=[UIColor grayColor];
    [viewTop addSubview:lab_auth];
    
    //2.tab
    [self addTab];
    
    //2.0
    view2=[MyControl createViewWithFrame:CGRectMake(0,CGRectGetMaxY(line.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(line.frame)) backColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    
    int top2=0;
    lab_sbCode=[MyControl createLabelWithFrame:CGRectMake(40+60, 20, SCREEN_WIDTH-60-60, 20) Font:15 Text:@""];
    [self createLabel:@"设备号:" forLabelWidth:60 forValueControl:lab_sbCode forTop:top2 forImageName:@"sbts_sbCode"];
    
    top2=top2 +60;
    lab_zcCode=[MyControl createLabelWithFrame:CGRectMake(40+135, 20, SCREEN_WIDTH-60-135, 20) Font:15 Text:@""];
    [self createLabel:@"当前设备注册代码:" forLabelWidth:135 forValueControl:lab_zcCode forTop:top2 forImageName:@"sbts_zcCode"];
    
    top2=top2 +60;
    tf_zcCode=[MyControl createTextFildWithFrame:CGRectMake(10, 50, SCREEN_WIDTH-60-30, 30) Font:15 Text:@""];
    [self createLabel1:@"待输入的注册代码" forLabelWidth:200 forValueControl:tf_zcCode forTop:top2 forImageName:@"sbts_write"];
    
    top2=top2 +90;
    lab_dz=[MyControl createLabelWithFrame:CGRectMake(40+75, 20, SCREEN_WIDTH-60-75, 20) Font:15 Text:@""];
    [self createLabel:@"电梯地址:" forLabelWidth:75 forValueControl:lab_dz forTop:top2 forImageName:@"sbts_dz"];
    
    top2=top2 +60+20;
    float currwidth=(SCREEN_WIDTH-60)/2;
    UIButton * btn_ks=[MyControl createButtonWithFrame:CGRectMake(20, top2, currwidth, 35) imageName:nil bgImageName:nil title:@"维保开始" SEL:@selector(sbbdWBKSClick:) target:self];
    [btn_ks setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_ks .backgroundColor=[UIColor orangeColor];
    [view2 addSubview:btn_ks];
    btn_ks.layer.masksToBounds = YES;
    btn_ks.layer.cornerRadius = 4;
    
    UIButton * btn_js=[MyControl createButtonWithFrame:CGRectMake(40+currwidth, top2, currwidth, 35) imageName:nil bgImageName:nil title:@"维保结束" SEL:@selector(sbbdWBJSClick:) target:self];
    [btn_js setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     btn_js .backgroundColor=[CommonUseClass getSysColor];
    [view2 addSubview:btn_js];
    btn_js.layer.masksToBounds = YES;
    btn_js.layer.cornerRadius = 4;
    
    UILabel *line2=[MyControl createLabelWithFrame:CGRectMake(0, 1, SCREEN_WIDTH, 1) Font:15 Text:@""];
    line2.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view2 addSubview:line2];
    
    top2=top2 +60+20;
    lab_wbState=[MyControl createLabelWithFrame:CGRectMake(20, top2, SCREEN_WIDTH-40, 35) Font:15 Text:@"维保已结束，谢谢！"];
    lab_wbState.textColor=[UIColor whiteColor];
    lab_wbState .backgroundColor=[CommonUseClass getSysColor];
    [view2 addSubview:lab_wbState];
    lab_wbState.layer.masksToBounds = YES;
    lab_wbState.layer.cornerRadius = 4;
    lab_wbState.textAlignment=NSTextAlignmentCenter;
    
    //2.1
    view1=[MyControl createViewWithFrame:CGRectMake(0,CGRectGetMaxY(line.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(line.frame)) backColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    
    
    UIImageView *img=[MyControl createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) imageName:@"sbts_backgoup"];
    [view1 addSubview:img];
//    text_show=[[UILabel alloc ]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    //    text_show.backgroundColor=[UIColor lightGrayColor];
//    [view1 addSubview:text_show];
    
    int top=150+10;
    float width=SCREEN_WIDTH/2;
    //2.2
    UIButton *btn_menu=[MyControl createButtonWithFrame:CGRectMake((width-80)/2, top, 80, 40) imageName:nil bgImageName:@"sbts_menu" title:@"" SEL:@selector(sendMessageAction:) target:self];
    btn_menu.tag=1;
    [view1 addSubview:btn_menu];
    
    UIButton *btn_back=[MyControl createButtonWithFrame:CGRectMake(width+(width-80)/2, top, 80, 40) imageName:nil bgImageName:@"sbts_back" title:@"" SEL:@selector(sendMessageAction:) target:self];
    btn_back.tag=2;
    [view1 addSubview:btn_back];
    
    top=top+40+20;
    //2.3 mianban
    UIView *view_mianban=[MyControl createViewWithFrame:CGRectMake((SCREEN_WIDTH-265)/2, top, 265, 265) backColor:[ UIColor whiteColor]];
    [view1 addSubview:view_mianban];
    
    UIImageView *img1=[MyControl createImageViewWithFrame:CGRectMake(0, 0, 265, 265) imageName:@"sbts_backgroup1"];
    [view_mianban addSubview:img1];
    
    UIImageView *img2=[MyControl createImageViewWithFrame:CGRectMake(60, 60, 150, 150) imageName:@"sbts_backgroup2"];
    [view_mianban addSubview:img2];
    
    //top
    UIButton *btn_top=[MyControl createButtonWithFrame:CGRectMake(115, 15, 40, 25) imageName:nil bgImageName:nil title:@"" SEL:@selector(sendMessageAction:) target:self];
    [btn_top setImage:[UIImage imageNamed:@"sbts_top_gra"] forState:UIControlStateNormal];
    [btn_top setImage:[UIImage imageNamed:@"sbts_top_blru"] forState:UIControlStateHighlighted];
    btn_top.tag=3;
    [view_mianban addSubview:btn_top];
    
    //xia
    UIButton *btn_xia=[MyControl createButtonWithFrame:CGRectMake(115, 265-40, 40, 25) imageName:nil bgImageName:nil title:@"xia" SEL:@selector(sendMessageAction:) target:self];
    [btn_xia setImage:[UIImage imageNamed:@"sbts_last_gra"] forState:UIControlStateNormal];
    [btn_xia setImage:[UIImage imageNamed:@"sbts_last_blru"] forState:UIControlStateHighlighted];
    btn_xia.tag=4;
    [view_mianban addSubview:btn_xia];
    
    //left
    UIButton *btn_left=[MyControl createButtonWithFrame:CGRectMake(15, 115, 25, 40) imageName:nil bgImageName:nil title:@"" SEL:@selector(sendMessageAction:) target:self];
    [btn_left setImage:[UIImage imageNamed:@"sbts_left_gra"] forState:UIControlStateNormal];
    [btn_left setImage:[UIImage imageNamed:@"sbts_left_blru"] forState:UIControlStateHighlighted];
    btn_left.tag=5;
    [view_mianban addSubview:btn_left];
    
    //right
    UIButton *btn_right=[MyControl createButtonWithFrame:CGRectMake(265-40, 115, 25, 40) imageName:nil bgImageName:nil title:@"right" SEL:@selector(sendMessageAction:) target:self];
    [btn_right setImage:[UIImage imageNamed:@"sbts_right_gra"] forState:UIControlStateNormal];
    [btn_right setImage:[UIImage imageNamed:@"sbts_right_blru"] forState:UIControlStateHighlighted];
    btn_right.tag=6;
    [view_mianban addSubview:btn_right];
    
    //ok
    UIButton *btn_ok=[MyControl createButtonWithFrame:CGRectMake(85, 85, 100, 100) imageName:nil bgImageName:nil title:@"确认" SEL:@selector(sendMessageAction:) target:self];
    btn_ok.titleLabel.font=[UIFont systemFontOfSize:24];
    [btn_ok setTitleColor:[CommonUseClass getSysColor] forState:UIControlStateNormal];
    btn_ok.tag=7;
    [view_mianban addSubview:btn_ok];
    
    [self initShow];
}

-(void)initShow{
    //0, 0, SCREEN_WIDTH, 150
    float width=SCREEN_WIDTH/16;
    float left=0;
    lab_1=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_1.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_1];
    
    left=left+width;
    lab_2=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_2.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_2];
    
    left=left+width;
    lab_3=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_3.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_3];
    
    left=left+width;
    lab_4=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_4.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_4];
    
    left=left+width;
    lab_5=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_5.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_5];
    
    left=left+width;
    lab_6=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_6.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_6];
    
    left=left+width;
    lab_7=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_7.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_7];
    
    left=left+width;
    lab_8=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_8.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_8];
    
    left=left+width;
    lab_9=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_9.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_9];
    
    left=left+width;
    lab_10=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_10.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_10];
    
    left=left+width;
    lab_11=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_11.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_11];
    
    left=left+width;
    lab_12=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_12.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_12];
    
    left=left+width;
    lab_13=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_13.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_13];
    
    left=left+width;
    lab_14=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_14.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_14];
    
    left=left+width;
    lab_15=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_15.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_15];
    
    left=left+width;
    lab_16=[MyControl createLabelWithFrame:CGRectMake(left, 0, width, 75) Font:24 Text:@""];
    lab_16.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_16];
    
    left=0;
    lab_17=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_17.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_17];
    
    left=left+width;
    lab_18=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_18.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_18];
    
    left=left+width;
    lab_19=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_19.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_19];
    
    left=left+width;
    lab_20=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_20.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_20];
    
    left=left+width;
    lab_21=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_21.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_21];
    
    left=left+width;
    lab_22=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_22.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_22];
    
    left=left+width;
    lab_23=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_23.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_23];
    
    left=left+width;
    lab_24=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_24.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_24];
    
    left=left+width;
    lab_25=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_25.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_25];
    
    left=left+width;
    lab_26=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_26.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_26];
    
    left=left+width;
    lab_27=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_27.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_27];
    
    left=left+width;
    lab_28=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_28.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_28];
    
    left=left+width;
    lab_29=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_29.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_29];
    
    left=left+width;
    lab_30=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_30.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_30];
    
    left=left+width;
    lab_31=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_31.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_31];
    
    left=left+width;
    lab_32=[MyControl createLabelWithFrame:CGRectMake(left, 75, width, 75) Font:24 Text:@""];
    lab_32.textColor=[UIColor whiteColor];
    [view1 addSubview:lab_32];
    
    lab_1.textAlignment=NSTextAlignmentCenter;
    lab_2.textAlignment=NSTextAlignmentCenter;
    lab_3.textAlignment=NSTextAlignmentCenter;
    lab_4.textAlignment=NSTextAlignmentCenter;
    lab_5.textAlignment=NSTextAlignmentCenter;
    lab_6.textAlignment=NSTextAlignmentCenter;
    lab_7.textAlignment=NSTextAlignmentCenter;
    lab_8.textAlignment=NSTextAlignmentCenter;
    lab_9.textAlignment=NSTextAlignmentCenter;
    lab_10.textAlignment=NSTextAlignmentCenter;
    lab_11.textAlignment=NSTextAlignmentCenter;
    lab_12.textAlignment=NSTextAlignmentCenter;
    lab_13.textAlignment=NSTextAlignmentCenter;
    lab_14.textAlignment=NSTextAlignmentCenter;
    lab_15.textAlignment=NSTextAlignmentCenter;
    lab_16.textAlignment=NSTextAlignmentCenter;
    lab_17.textAlignment=NSTextAlignmentCenter;
    lab_18.textAlignment=NSTextAlignmentCenter;
    lab_19.textAlignment=NSTextAlignmentCenter;
    lab_20.textAlignment=NSTextAlignmentCenter;
    lab_21.textAlignment=NSTextAlignmentCenter;
    lab_22.textAlignment=NSTextAlignmentCenter;
    lab_23.textAlignment=NSTextAlignmentCenter;
    lab_24.textAlignment=NSTextAlignmentCenter;
    lab_25.textAlignment=NSTextAlignmentCenter;
    lab_26.textAlignment=NSTextAlignmentCenter;
    lab_27.textAlignment=NSTextAlignmentCenter;
    lab_28.textAlignment=NSTextAlignmentCenter;
    lab_29.textAlignment=NSTextAlignmentCenter;
    lab_30.textAlignment=NSTextAlignmentCenter;
    lab_31.textAlignment=NSTextAlignmentCenter;
    lab_32.textAlignment=NSTextAlignmentCenter;
    
    
    float widthLine=10;
    left=(width-widthLine)/2;
    float topLine=55;
    float heightLine=3;
    line_1=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_1.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_1];
    
    left=left+width;
    line_2=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_2.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_2];
    
    left=left+width;
    line_3=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_3.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_3];
    
    left=left+width;
    line_4=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_4.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_4];
    
    left=left+width;
    line_5=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_5.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_5];
    
    left=left+width;
    line_6=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_6.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_6];
    
    left=left+width;
    line_7=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_7.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_7];
    
    left=left+width;
    line_8=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_8.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_8];
    
    left=left+width;
    line_9=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_9.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_9];
    
    left=left+width;
    line_10=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_10.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_10];
    
    left=left+width;
    line_11=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_11.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_11];
    
    left=left+width;
    line_12=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_12.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_12];
    
    left=left+width;
    line_13=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_13.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_13];
    
    left=left+width;
    line_14=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_14.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_14];
    
    left=left+width;
    line_15=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_15.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_15];
    
    left=left+width;
    line_16=[MyControl createLabelWithFrame:CGRectMake(left, topLine, widthLine, heightLine) Font:24 Text:@""];
    line_16.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_16];
    
    left=(width-widthLine)/2;
    line_17=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_17.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_17];
    
    left=left+width;
    line_18=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_18.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_18];
    
    left=left+width;
    line_19=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_19.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_19];
    
    left=left+width;
    line_20=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_20.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_20];
    
    left=left+width;
    line_21=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_21.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_21];
    
    left=left+width;
    line_22=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_22.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_22];
    
    left=left+width;
    line_23=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_23.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_23];
    
    left=left+width;
    line_24=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_24.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_24];
    
    left=left+width;
    line_25=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_25.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_25];
    
    left=left+width;
    line_26=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_26.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_26];
    
    left=left+width;
    line_27=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_27.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_27];
    
    left=left+width;
    line_28=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_28.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_28];
    
    left=left+width;
    line_29=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_29.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_29];
    
    left=left+width;
    line_30=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_30.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_30];
    
    left=left+width;
    line_31=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_31.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_31];
    
    left=left+width;
    line_32=[MyControl createLabelWithFrame:CGRectMake(left, 75+topLine, widthLine, heightLine) Font:24 Text:@""];
    line_32.backgroundColor=[UIColor whiteColor];
    [view1 addSubview:line_32];
    
    line_1.tag=1001;
    line_2.tag=1002;
    line_3.tag=1003;
    line_4.tag=1004;
    line_5.tag=1005;
    line_6.tag=1006;
    line_7.tag=1007;
    line_8.tag=1008;
    line_9.tag=1009;
    line_10.tag=1010;
    line_11.tag=1011;
    line_12.tag=1012;
    line_13.tag=1013;
    line_14.tag=1014;
    line_15.tag=1015;
    line_16.tag=1016;
    line_17.tag=1017;
    line_18.tag=1018;
    line_19.tag=1019;
    line_20.tag=1020;
    line_21.tag=1021;
    line_22.tag=1022;
    line_23.tag=1023;
    line_24.tag=1024;
    line_25.tag=1025;
    line_26.tag=1026;
    line_27.tag=1027;
    line_28.tag=1028;
    line_29.tag=1029;
    line_30.tag=1030;
    line_31.tag=1031;
    line_32.tag=1032;
    
    [self clearLine];
}

-(void)clearLine{
    line_1.hidden=YES;
    line_2.hidden=YES;
    line_3.hidden=YES;
    line_4.hidden=YES;
    line_5.hidden=YES;
    line_6.hidden=YES;
    line_7.hidden=YES;
    line_8.hidden=YES;
    line_9.hidden=YES;
    line_10.hidden=YES;
    line_11.hidden=YES;
    line_12.hidden=YES;
    line_13.hidden=YES;
    line_14.hidden=YES;
    line_15.hidden=YES;
    line_16.hidden=YES;
    line_17.hidden=YES;
    line_18.hidden=YES;
    line_19.hidden=YES;
    line_20.hidden=YES;
    line_21.hidden=YES;
    line_22.hidden=YES;
    line_23.hidden=YES;
    line_24.hidden=YES;
    line_25.hidden=YES;
    line_26.hidden=YES;
    line_27.hidden=YES;
    line_28.hidden=YES;
    line_29.hidden=YES;
    line_30.hidden=YES;
    line_31.hidden=YES;
    line_32.hidden=YES;
}

@end
