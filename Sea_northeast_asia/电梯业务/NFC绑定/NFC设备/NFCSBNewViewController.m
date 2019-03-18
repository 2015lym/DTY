//
//  ViewController.m
//  ble_nfc_sdk
//
//  Created by sahmoL on 16/6/22.
//  Copyright © 2016年 Lochy. All rights reserved.
//

#import "NFCSBNewViewController.h"
#import "DKBleNfc.h"

#import "NSData+Hex.h"
#import "MyControl.h"
#define SEARCH_BLE_NAME   @"BLE_NFC"

@interface NFCSBNewViewController () <DKBleManagerDelegate, DKBleNfcDeviceDelegate>
@property (nonatomic, strong) DKBleManager     *bleManager;
//@property (nonatomic, strong) DKbleNfcDevice  *bleNfcDevice;
@property (nonatomic, strong) DKBleNfcDevice   *bleNfcDevice;
@property (nonatomic, strong) CBPeripheral     *mNearestBle;
@property (nonatomic, strong) UIButton         *doneButton;

@property (nonatomic, strong) NSMutableString  *msgBuffer;
@property (strong, nonatomic)  UITextView *msgTextView;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@end

@implementation NFCSBNewViewController
@synthesize bleManager;
@synthesize doneButton;
@synthesize bleNfcDevice;

NSInteger lastRssi = -100;
Byte      tradeN   = 1;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title=@"NFC标签绑定";
    self.navigationController.navigationItem.title=@"NFC标签绑定";
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

-(void)listBtn_help:(id)sender{
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_index,@"index", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_NFCSBPic" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //5.close
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.msgBuffer = [[NSMutableString alloc] init];
    lastRssi = -100;
    self.mNearestBle = nil;
    
    
    if(![[CommonUseClass FormatString: _index] isEqual:@""])
    {
        UIButton *left_BarButoon_Item_help=[[UIButton alloc] init];
        left_BarButoon_Item_help.frame=CGRectMake(0, 0,60,32);//42
        [left_BarButoon_Item_help setTitle:@"拍照" forState:UIControlStateNormal];
        [left_BarButoon_Item_help addTarget:self action:@selector(listBtn_help:) forControlEvents:UIControlEventTouchUpInside];
        UIView *leftCustomView1 = [[UIView alloc] initWithFrame: left_BarButoon_Item_help.frame];
        [leftCustomView1 addSubview: left_BarButoon_Item_help];
        UIBarButtonItem *leftItem_help = [[UIBarButtonItem alloc] initWithCustomView:leftCustomView1];
        
        self.navigationItem.rightBarButtonItems=@[leftItem_help];
    }
    
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
    
    UIImageView *img=[MyControl createImageViewWithFrame:CGRectMake((SCREEN_WIDTH-348)/2, SCREEN_HEIGHT-605, 348, 505) imageName:@"ic_nfc_bind_bg"];
    [self.view addSubview:img];
    
    UILabel *labTitle=[MyControl createLabelWithFrame:CGRectMake(20, SCREEN_HEIGHT-400, SCREEN_WIDTH-40, 60) Font:24 Text:_Title];
    labTitle.textAlignment=NSTextAlignmentCenter;
    labTitle.numberOfLines=2;
    [self.view addSubview:labTitle];
    
    labMemo=[MyControl createLabelWithFrame:CGRectMake(20, SCREEN_HEIGHT-290, SCREEN_WIDTH-40, 50) Font:18 Text:_Memo];
    labMemo.textAlignment=NSTextAlignmentCenter;
    labMemo.numberOfLines=2;
    [self.view addSubview:labMemo];
    
    labMemo1=[MyControl createLabelWithFrame:CGRectMake(20, SCREEN_HEIGHT-260, SCREEN_WIDTH-40, 40) Font:18 Text:@""];
    labMemo1.textAlignment=NSTextAlignmentCenter;
    labMemo1.numberOfLines=2;
    [self.view addSubview:labMemo1];

}

-(void)getDataAndReturn:(NSData *)oldid forValue:(NSString *)value{
    
    //1.id
    NSString *newid2=[NSString stringWithFormat:@"%@",oldid ];
    NSString *newid = [newid2 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    newid = [newid stringByReplacingOccurrencesOfString:@" " withString:@""];
    newid = [newid stringByReplacingOccurrencesOfString:@">" withString:@""];
    newid=[newid uppercaseString];
    
    //2.value
    NSString *newValue  =value;
    //[[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    
    //3.show
    [self.msgBuffer appendString:[NSString stringWithFormat:@"返回:%@\r\n", newid]];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.msgTextView.text = self.msgBuffer;
    });
    
    //4.tz
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:newid,@"textId",newValue,@"textValue", _index,@"index",_NFCCode,@"NFCCode",_NFCNum,@"NFCNum",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_NFCSB" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //5.close
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
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
    lastRssi = -100;
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
                
                if([_type isEqual: @"write"])
                {
                    [self.msgBuffer setString:@"开始写入\r\n"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.msgTextView.text = self.msgBuffer;
                    });
                    
                    NSString *value=@"dianti119-000000001";
                    Boolean isSuc = [ntag21x NdefTextWrite:@"dianti119-000000001"];
                    if (!isSuc) {
                        [self.msgBuffer appendString:@"写入失败\r\n"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.msgTextView.text = self.msgBuffer;
                        });
                    }
                    else {
                        [self.msgBuffer appendString:@"写入成功\r\n"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.msgTextView.text = self.msgBuffer;
                        });
                        [self SubmitData:ntag21x.uid forValue:value];
                    }
                }
                else if([_type isEqual: @"writeDetail"])
                {
                    [self.msgBuffer setString:@"开始写入\r\n"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.msgTextView.text = self.msgBuffer;
                    });
                    
                    NSString *value=_writeString;
                    Boolean isSuc = [ntag21x NdefTextWrite:_writeString];
                    if (!isSuc) {
                        [self.msgBuffer appendString:@"写入失败\r\n"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.msgTextView.text = self.msgBuffer;
                        });
                    }
                    else {
                        [self.msgBuffer appendString:@"写入成功\r\n"];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.msgTextView.text = self.msgBuffer;
                        });
                        [self getDataAndReturn:ntag21x.uid forValue:value];
                    }
                }
                else
                {
                [self.msgBuffer setString:@"开始读数据\r\n"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.msgTextView.text = self.msgBuffer;
                });
                
                NSString *text = [ntag21x NdefTextRead];
                
                [self getDataAndReturn:ntag21x.uid forValue:text];
                }
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
            if ([RSSI integerValue] > lastRssi) {
                self.mNearestBle = peripheral;
            }
        }
        else {
            self.mNearestBle = peripheral;
            lastRssi = [RSSI integerValue];
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


- (void)SubmitData:(NSData *)oldid forValue:(NSString *)value
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    //1.id
    NSString *newid2=[NSString stringWithFormat:@"%@",oldid ];
    NSString *newid = [newid2 stringByReplacingOccurrencesOfString:@"<" withString:@""];
    newid = [newid stringByReplacingOccurrencesOfString:@" " withString:@""];
    newid = [newid stringByReplacingOccurrencesOfString:@">" withString:@""];
    newid=[newid uppercaseString];
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:newid,@"newid",value,@"value", nil];
    [self performSelectorOnMainThread:@selector(showValue:) withObject:dict waitUntilDone:YES];
    
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:newid forKey:@"NFCNum"];
    [dicHeader setValue:value forKey:@"NFCCode"];
    [dicHeader setValue:self.app.userInfo.UserID forKey:@"UserId"];
    
    [XXNet PostURL:@"NFC/SaveCheckNfc" header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(showMessage:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(showMessage:) withObject:data[@"Message"] waitUntilDone:YES];
        }
    } failure:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(showMessage:) withObject:MessageResult waitUntilDone:YES];
    }];
}

- (void)showValue:(NSDictionary *)dic{
    labMemo.text=[NSString stringWithFormat: @"标签值：%@",dic[@"value"] ];
    labMemo.hidden=false;
    labMemo1.text=[NSString stringWithFormat: @"唯一值：%@",dic[@"newid"] ];
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
