//
//  readBQViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/11/5.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "readBQViewController.h"
#import "DKBleNfc.h"

#import "NSData+Hex.h"
#import "MyControl.h"
//#define SEARCH_BLE_NAME1   @"BLE_NFC"
@interface readBQViewController ()<DKBleManagerDelegate, DKBleNfcDeviceDelegate>
@property (nonatomic, strong) DKBleManager     *bleManager;
//@property (nonatomic, strong) DKbleNfcDevice  *bleNfcDevice;
@property (nonatomic, strong) DKBleNfcDevice   *bleNfcDevice;
@property (nonatomic, strong) CBPeripheral     *mNearestBle;
@property (nonatomic, strong) UIButton         *doneButton;

@property (nonatomic, strong) NSMutableString  *msgBuffer;
@property (strong, nonatomic)  UITextView *msgTextView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@end

@implementation readBQViewController

@synthesize bleManager;
@synthesize doneButton;
@synthesize bleNfcDevice;

NSInteger lastRssi_read = -100;
Byte      tradeN_read   = 1;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.title=@"读取标签";
    self.navigationController.navigationItem.title=@"读取标签";
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor=[UIColor whiteColor];

    _msgTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [self .view addSubview:_msgTextView];

    if(self.app.nfcCount)
        [self fineNearBle];
}


- (void)viewWillDisappear:(BOOL)animated {
    if ( [self.bleManager isConnect] ) {
        self.searchButton.titleLabel.text = @"正在断开连接..";
        [self.bleManager cancelConnect];
    }
    self.mNearestBle = nil;
    self.bleManager = nil;
    self.bleNfcDevice = nil;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.msgBuffer = [[NSMutableString alloc] init];
    lastRssi_read = -100;
    self.mNearestBle = nil;




    self.bleManager = [DKBleManager sharedInstance];
    self.bleManager.delegate = self;
    self.bleNfcDevice = [[DKBleNfcDevice alloc] initWithDelegate:self];


    //设置设备按键监听
    [self.bleNfcDevice setOonReceiveButtonEnterListenerBlock:^(Byte keyValue) {
        if (keyValue == BUTTON_VALUE_SHORT_ENTER) { //按键短按
            [self.msgBuffer appendString:@"按键短按\r\n"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgTextView.text = self.msgBuffer;
            });
        }
        else if (keyValue == BUTTON_VALUE_LONG_ENTER) { //按键长按
            [_msgBuffer appendString:@"按键长按\r\n"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgTextView.text = self.msgBuffer;
            });
        }
    }];


    //添加键盘完成按键
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem *myBn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem *spaceBn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成",nil) style:UIBarButtonItemStyleDone target:self action:@selector(hideKeyboard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:myBn,spaceBn,doneBn, nil];
    [topView setItems:buttonsArray];
    [self.msgTextView setInputAccessoryView:topView];
    
    [self initWindow];
}

-(void)initWindow{
    viewThis=[MyControl createViewWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 220) backColor:[UIColor whiteColor]];
    [self .view addSubview:viewThis];
    labMemo=[MyControl createLabelWithFrame:CGRectMake(10, 40*0, SCREEN_WIDTH, 40) Font:15 Text:@"标签值"];
    [viewThis addSubview:labMemo];
    lab_bh=[MyControl createLabelWithFrame:CGRectMake(10, 30*1, SCREEN_WIDTH, 30) Font:15 Text:@"电梯编号:"];
    [viewThis addSubview:lab_bh];
    lab_zcdm=[MyControl createLabelWithFrame:CGRectMake(10, 30*2, SCREEN_WIDTH, 30) Font:15 Text:@"注册代码:"];
    [viewThis addSubview:lab_zcdm];
    lab_name=[MyControl createLabelWithFrame:CGRectMake(10, 30*3, SCREEN_WIDTH, 30) Font:15 Text:@"配件名称:"];
    [viewThis addSubview:lab_name];
    lab_dz=[MyControl createLabelWithFrame:CGRectMake(10, 30*4, SCREEN_WIDTH, 30) Font:15 Text:@"电梯地址:"];
    [viewThis addSubview:lab_dz];
    lab_time=[MyControl createLabelWithFrame:CGRectMake(10, 30*5, SCREEN_WIDTH, 30) Font:15 Text:@"绑定时间:"];
    [viewThis addSubview:lab_time];
    lab_id=[MyControl createLabelWithFrame:CGRectMake(10, 30*6, SCREEN_WIDTH, 30) Font:15 Text:@"唯一值:"];
    [viewThis addSubview:lab_id];
    
    //2.
    viewServer=[MyControl createViewWithFrame:CGRectMake(0, 50+220+10, SCREEN_WIDTH, 260) backColor:[UIColor whiteColor]];
    [self .view addSubview:viewServer];
    
    UILabel * ser_labMemo=[MyControl createLabelWithFrame:CGRectMake(10, 40*0, SCREEN_WIDTH, 40) Font:15 Text:@"服务器值"];
    [viewServer addSubview:ser_labMemo];
    
    ser_lab_bh=[MyControl createLabelWithFrame:CGRectMake(10, 30*1, SCREEN_WIDTH, 30) Font:15 Text:@""];
    [viewServer addSubview:ser_lab_bh];
    ser_lab_zcdm=[MyControl createLabelWithFrame:CGRectMake(10, 30*2, SCREEN_WIDTH, 30) Font:15 Text:@""];
    [viewServer addSubview:ser_lab_zcdm];
    ser_lab_name=[MyControl createLabelWithFrame:CGRectMake(10, 30*3, SCREEN_WIDTH, 30) Font:15 Text:@""];
    [viewServer addSubview:ser_lab_name];
    ser_lab_dz=[MyControl createLabelWithFrame:CGRectMake(10, 30*4, SCREEN_WIDTH, 30) Font:15 Text:@""];
    [viewServer addSubview:ser_lab_dz];
    ser_lab_time=[MyControl createLabelWithFrame:CGRectMake(10, 30*5, SCREEN_WIDTH, 30) Font:15 Text:@""];
    [viewServer addSubview:ser_lab_time];
    ser_lab_id=[MyControl createLabelWithFrame:CGRectMake(10, 30*6, SCREEN_WIDTH, 30) Font:15 Text:@""];
   [viewServer addSubview:ser_lab_id];
}

-(void)getDataAndReturn:(NSData *)oldid forValue:(NSString *)value{

    //1.show
    [self.msgBuffer setString:@"读取数据成功!"];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.msgTextView.text = self.msgBuffer;
    });
    
    //2.id
    NSString *newid2=[NSString stringWithFormat:@"%@",oldid ];
    NSString *newid = [newid2 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    newid = [newid stringByReplacingOccurrencesOfString:@" " withString:@""];
    newid = [newid stringByReplacingOccurrencesOfString:@">" withString:@""];
    newid=[newid uppercaseString];

    //3.show
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:newid,@"newid",value,@"value", nil];
    [self performSelectorOnMainThread:@selector(showValue_this:) withObject:dict waitUntilDone:YES];
    
    //4.show server
    [self getServerData:newid];
   
    
}

-(void)showValue_this:(NSDictionary *)dic{
    NSString *newid=dic[@"newid"];
    NSString *value=dic[@"value"];
     //3.value//999997`10020030040050060070`轿顶钢丝绳`华盾大数据研究院1号楼`2018-11-02 13:36:43
    NSArray *s = [value componentsSeparatedByString:@"`"];
    if(s.count>=5)
    {
        lab_bh.text=[@"电梯编号: " stringByAppendingString:[s objectAtIndex:0]];
        lab_zcdm.text=[@"注册代码: " stringByAppendingString:[s objectAtIndex:1]];
        lab_name.text=[@"配件名称: " stringByAppendingString:[s objectAtIndex:2]];
        lab_dz.text=[@"电梯地址: " stringByAppendingString:[s objectAtIndex:3]];
        lab_time.text=[@"绑定时间: " stringByAppendingString:[s objectAtIndex:4]];
        lab_id.text=[@"唯一值: " stringByAppendingString:newid];
        lab_name.hidden=NO;
        lab_dz.hidden=NO;
        lab_time.hidden=NO;
        lab_id.hidden=NO;
        viewThis.frame=CGRectMake(0, 50, SCREEN_WIDTH, 220);
        viewServer.frame=CGRectMake(0, 50+220+10, SCREEN_WIDTH, 220);
    }
    else
    {
        lab_bh.text=[@"标签值: " stringByAppendingString:value];
        lab_zcdm.text=[@"唯一值: " stringByAppendingString:newid];
        lab_name.hidden=YES;
        lab_dz.hidden=YES;
        lab_time.hidden=YES;
        lab_id.hidden=YES;
        viewThis.frame=CGRectMake(0, 50, SCREEN_WIDTH, 120);
        viewServer.frame=CGRectMake(0, 50+120+10, SCREEN_WIDTH, 220);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) hideKeyboard {
    [doneButton removeFromSuperview];
    [self.msgTextView resignFirstResponder];

}


//搜索、断开连接按键监听
- (IBAction)SearchButtonEnter:(id)sender {
    //如果已经连接设备，则断开连接设备，如果没有连接设备则开始搜索设备，搜到指定名字的设备后开始连接
    if ( [self.bleManager isConnect] ) {
        self.searchButton.titleLabel.text = @"正在断开连接..";
        [self.bleManager cancelConnect];
    }
    else {
        [self fineNearBle];
    }
}

//找到最近的ble设备并连接
-(void)fineNearBle{

    self.searchButton.titleLabel.text = @"正在搜索设备..";
    self.msgTextView.text = @"正在搜索设备..";
    self.mNearestBle = nil;
    lastRssi_read = -100;
    [self.bleManager startScan];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int searchCnt = 0;
        while ((self.mNearestBle == nil) && (searchCnt++ < 5000) && ([self.bleManager isScanning])) {
            [NSThread sleepForTimeInterval:0.001f];
        }
        [NSThread sleepForTimeInterval:1.0f];
        [self.bleManager stopScan];
        if (self.mNearestBle == nil) {
            //开始连接设备
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgTextView.text = @"未找到设备！";
                [self fineNearBle];
            });
        }
        else{
            //开始连接设备
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgTextView.text = @"正在连接设备..";
            });
            [self.bleManager connect:self.mNearestBle callbackBlock:^(BOOL isConnectSucceed) {
                if (isConnectSucceed) {
                    //设备连接成功
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.msgBuffer setString:@"设备连接成功！\r\n"];
                        self.msgTextView.text = self.msgBuffer;
                        self.searchButton.titleLabel.text = @"断开连接";
                        //获取设备信息
                        [self getDeviceMsg];
                    });
                }
                else {
                    //设备连接失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.msgTextView.text = @"设备已断开！";
                        self.searchButton.titleLabel.text = @"搜索设备";
                    });
                }
            }];
        }

    });
}

//获取设备信息
-(void)getDeviceMsg {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try {
            //            //获取设备版本
            //            Byte versionNum = [self.bleNfcDevice getDeviceVersions];
            //            [self.msgBuffer appendString:@"SDK版本v2.1.0 20180122\r\n"];
            //            [self.msgBuffer appendString:[NSString stringWithFormat:@"设备版本：%02lx\r\n", (unsigned long)versionNum]];
            //            [self.msgBuffer appendString:@"蓝牙名称："];
            //            [self.msgBuffer appendString:[self.bleNfcDevice getDeviceName]];
            //            [self.msgBuffer appendString:[NSString stringWithFormat:@"\r\n信号强度：%lddB\r\n", (long)lastRssi]];
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                self.msgTextView.text = self.msgBuffer;
            //            });
            //
            //            //获取设备电池电压
            //            float btVlueMv = [self.bleNfcDevice getDeviceBatteryVoltage];
            //            [self.msgBuffer appendString:[NSString stringWithFormat:@"设备电池电压：%.2fV\r\n", btVlueMv]];
            //            if (btVlueMv < 3.6) {
            //                [self.msgBuffer appendString:@"设备电池电量低，请及时充电！\r\n"];
            //            }
            //            else {
            //                [self.msgBuffer appendString:@"设备电池电量充足！\r\n"];
            //            }
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                self.msgTextView.text = self.msgBuffer;
            //            });

            //开启自动寻卡
            BOOL isSuc = [self.bleNfcDevice startAutoSearchCard:20 cardType:ISO14443_P4];
            if (isSuc) {
                [self.msgBuffer appendString:@"正在寻卡..\r\n"];
            }
            else {
                [self.msgBuffer appendString:@"不支持自动寻卡\r\n"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgTextView.text = self.msgBuffer;
            });
        } @catch (NSException *exception) {
            [self.msgBuffer appendString:exception.reason];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgTextView.text = self.msgBuffer;
            });
        } @finally {
        }
    });
}

//读写卡Demo
-(BOOL)readWriteDemo:(DKCardType)cardType{
    switch (cardType) {

        case DKUltralight_type: {//UL卡
            Ntag21x *ntag21x = [self.bleNfcDevice getCard];
            if (ntag21x != nil) {

//                if([_type isEqual: @"write"])
//                {
//                    [self.msgBuffer setString:@"开始写入\r\n"];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.msgTextView.text = self.msgBuffer;
//                    });
//
//                    NSString *value=@"dianti119-000000001";
//                    Boolean isSuc = [ntag21x NdefTextWrite:@"dianti119-000000001"];
//                    if (!isSuc) {
//                        [self.msgBuffer appendString:@"写入失败\r\n"];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            self.msgTextView.text = self.msgBuffer;
//                        });
//                    }
//                    else {
//                        [self.msgBuffer appendString:@"写入成功\r\n"];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            self.msgTextView.text = self.msgBuffer;
//                        });
//                        [self SubmitData:ntag21x.uid forValue:value];
//                    }
//                }
//                else
//                {
                    [self.msgBuffer setString:@"开始读数据\r\n"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.msgTextView.text = self.msgBuffer;
                    });

                    NSString *text = [ntag21x NdefTextRead];

                    [self getDataAndReturn:ntag21x.uid forValue:text];
//                }
            }
        }
            break;



        default:
            break;
    }

    return YES;
}


-(NSString *) getString:(Byte )byte {
    NSString *str;
    Byte  bytes[] ={byte};
    NSData *data=[[NSData alloc] initWithBytes:bytes length:1];
    str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return str;
}

//发送指令
- (IBAction)readWriteButton:(id)sender {
    if ( ![self.bleManager isConnect] ) {
        self.msgTextView.text = @"设备未连接！请先连接设备！";
        return;
    }

    //寻卡一次
    [self.bleNfcDevice requestRfmSearchCard:DKCardTypeDefault callbackBlock:nil];
}





//读到卡片代理回调
#pragma mark - DKBleNfcDeviceDelegate
-(void)receiveRfnSearchCard:(BOOL)isblnIsSus cardType:(DKCardType)cardType uid:(NSData *)CardSn ats:(NSData *)bytCarATS{
    [self.msgBuffer appendString:@"寻到卡片："];
    [self.msgBuffer appendString:[CardSn description]];
    [self.msgBuffer appendString:@"\r\n"];
    [self.msgTextView setText:self.msgBuffer];


    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isAutoSearchCardFlag = [self.bleNfcDevice isAutoSearchCard];

        @try {
            BOOL isSuc = NO;
            //如果是自动寻卡寻到的卡，寻到卡后，先关闭自动寻卡
            if (isAutoSearchCardFlag) {
                //先关掉自动寻卡
                [self.bleNfcDevice stoptAutoSearchCard];

                //开始读卡
                isSuc = [self readWriteDemo:cardType];

                //读写卡成功，蜂鸣器快响3声
                if (isSuc) {
                    [self.bleNfcDevice openBeep:50 offDelay:50 cnt:3];
                }
                else {
                    [self.bleNfcDevice openBeep:100 offDelay:100 cnt:2];
                }

                //读卡结束，重新打开自动寻卡
                int cnt = 0;
                BOOL autoSearchCardFlag;
                do {
                    autoSearchCardFlag = [self.bleNfcDevice startAutoSearchCard:20 cardType:ISO14443_P4];
                }while (!autoSearchCardFlag && (cnt++ < 3));

                if (!autoSearchCardFlag) {
                    [self.msgBuffer appendString:[NSString stringWithFormat:@"不支持自动寻卡！\r\n"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.msgTextView.text = self.msgBuffer;
                    });
                }
            }
            else {
                //开始读卡
                isSuc = [self readWriteDemo:cardType];

                //如果不是自动寻卡，读卡结束,关闭天线
                [self.bleNfcDevice closeRf];

                //读写卡成功，蜂鸣器快响3声
                if (isSuc) {
                    [self.bleNfcDevice openBeep:50 offDelay:50 cnt:3];
                }
                else {
                    [self.bleNfcDevice openBeep:100 offDelay:100 cnt:2];
                }
            }
        } @catch (NSException *exception) {
            [self.msgBuffer appendString:[exception reason]];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgTextView.text = self.msgBuffer;
            });
            [self.bleNfcDevice openBeep:100 offDelay:100 cnt:2];

            if (isAutoSearchCardFlag) {
                //读卡失败，重新打开自动寻卡
                int cnt = 0;
                BOOL autoSearchCardFlag;
                do {
                    @try {
                        autoSearchCardFlag = [self.bleNfcDevice startAutoSearchCard:20 cardType:ISO14443_P4];
                    }@catch (NSException *exception) {
                        autoSearchCardFlag = false;
                    }
                }while (!autoSearchCardFlag && (cnt++ < 3));

                if (!autoSearchCardFlag) {
                    [self.msgBuffer appendString:[NSString stringWithFormat:@"不支持自动寻卡！\r\n"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.msgTextView.text = self.msgBuffer;
                    });
                }
            }
        } @finally {
        }
    });
}

/*
 * 函数说明：蓝牙搜索回调
 */
#pragma mark - DKBleManagerDelegate
-(void)DKScannerCallback:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {

    NSData *facturerData = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];
    Byte *facturerDataBytes = (Byte *) [facturerData bytes];
    NSLog(@"工厂信息字段：%@", facturerData);

    //if ([peripheral.name isEqualToString:SEARCH_BLE_NAME]) {
    //通过广播数据过滤蓝牙设备
    if ( (facturerData != nil)
        && (facturerData.length > 4)
        && (facturerDataBytes[0] == 0x01)
        && (facturerDataBytes[1] == 0x7f)
        && (facturerDataBytes[2] == 0x54)
        && (facturerDataBytes[3] == 0x50)) {
        NSLog(@"搜到设备：%@ %@", peripheral, RSSI);
        if (self.mNearestBle != nil) {
            if ([RSSI integerValue] > lastRssi_read) {
                self.mNearestBle = peripheral;
            }
        }
        else {
            self.mNearestBle = peripheral;
            lastRssi_read= [RSSI integerValue];
        }
    }
}

/*
 * 函数说明：蓝牙状态回调
 */
#pragma mark - DKBleManagerDelegate
-(void)DKCentralManagerDidUpdateState:(CBCentralManager *)central {
    NSError *error = nil;
    switch (central.state) {
        case CBCentralManagerStatePoweredOn://蓝牙打开
        {
            self.app.nfcCount=1;
            //开始搜索设备
            [self fineNearBle];
        }
            break;
        case CBCentralManagerStatePoweredOff://蓝牙关闭
        {
            error = [NSError errorWithDomain:@"CBCentralManagerStatePoweredOff" code:-1 userInfo:nil];
        }
            break;
        case CBCentralManagerStateResetting://蓝牙重置
        {
            //pendingInit = YES;
        }
            break;
        case CBCentralManagerStateUnknown://未知状态
        {
            error = [NSError errorWithDomain:@"CBCentralManagerStateUnknown" code:-1 userInfo:nil];
        }
            break;
        case CBCentralManagerStateUnsupported://设备不支持
        {
            error = [NSError errorWithDomain:@"CBCentralManagerStateUnsupported" code:-1 userInfo:nil];
        }
            break;
        default:
            break;
    }
}

//蓝牙连接状态回调
-(void)DKCentralManagerConnectState:(CBCentralManager *)central state:(BOOL)state{
    if (state) {
        NSLog(@"蓝牙连接成功");
    }
    else {
        NSLog(@"蓝牙连接失败");
        dispatch_async(dispatch_get_main_queue(), ^{
            self.msgTextView.text = @"设备已断开！";
            self.searchButton.titleLabel.text = @"搜索设备";
        });
    }
}
-(void)init_server
{
    ser_lab_bh.text=@"";
    ser_lab_zcdm.text=@"";
    ser_lab_name.text=@"";
    ser_lab_dz.text=@"";
    ser_lab_time.text=@"";
    ser_lab_id.text=@"";
}

- (void)getServerData:(NSData *)oldid
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelectorOnMainThread:@selector(init_server) withObject:nil waitUntilDone:YES];

    NSString *url=[NSString stringWithFormat: @"LiftParts/GetTL_LiftPartsNFC?NFCNum=%@",oldid];

    [XXNet GetURL:url header:nil parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(showValue_server:) withObject:data[@"Data"] waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(showMessage:) withObject:data[@"Message"] waitUntilDone:YES];
        }
    } failure:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(showMessage:) withObject:MessageResult waitUntilDone:YES];
    }];
}

- (void)showValue_server:(NSString *)s{
    NSDictionary * dic= [s objectFromJSONString];
    ser_lab_bh.text=[NSString stringWithFormat:@"电梯编号: %@",[dic objectForKey:@"LiftNum"]];
    ser_lab_zcdm.text=[NSString stringWithFormat:@"注册代码: %@",dic[@"CertificateNum"]];
    ser_lab_name.text=[NSString stringWithFormat:@"配件名称: %@",dic[@"ProductName"]];
    ser_lab_dz.text=[NSString stringWithFormat:@"电梯地址: %@",dic[@"InstallationAddress"]];
    ser_lab_time.text=[NSString stringWithFormat:@"初始化时间: %@",[CommonUseClass getDateString:  dic[@"CreateTime"]]];
    ser_lab_id.text=[NSString stringWithFormat:@"唯一值: %@",dic[@"NFCNum"]];
}

- (void)showMessage:(NSString *)msg{
    [self.msgBuffer setString:msg];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.msgTextView.text = self.msgBuffer;
    });
    [MBProgressHUD showSuccess:msg toView:nil];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
