//
//  NFCTagViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/26.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "NFCTagViewController.h"
#import "DKBleNfc.h"
#import "XFDaterView.h"
#import "MaintenanceNFCPartsModel.h"

@interface NFCTagViewController ()<DKBleManagerDelegate, XFDaterViewDelegate>
// NFC 相关
@property (nonatomic, strong) DKBleManager     *bleManager;
@property (nonatomic, strong) DKBleNfcDevice   *bleNfcDevice;
@property (nonatomic, strong) CBPeripheral     *mNearestBle;
@property (nonatomic, strong) NSMutableString  *msgBuffer;
@property (nonatomic, assign) NSInteger lastRssi;
@property (weak, nonatomic) IBOutlet UIButton *selectPartButton;
@property (weak, nonatomic) IBOutlet UITextField *partModelTextField;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;

@property (nonatomic, copy) NSString *nfcNum;

@property (strong, nonatomic) XFDaterView *dater;

@end

@implementation NFCTagViewController

- (void)viewWillDisappear:(BOOL)animated {
    if ( [self.bleManager isConnect]) {
        [self.bleManager cancelConnect];
    }
    self.mNearestBle = nil;
    self.bleManager = nil;
    self.bleNfcDevice = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"NFC标签识别";
    _partLabel.text = _model.PartName;
    [self initNFC];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)submit {
    if ([_selectPartButton.titleLabel.text isEqualToString:@"请选择日期"]) {
        [self showInfo:@"请选择日期"];
    } else if (_partModelTextField.text.length == 0) {
        [self showInfo:@"请填写配件型号"];
    } else if ([_valueLabel.text isEqualToString:@"标签值："]) {
        [self showInfo:@"请扫码标签"];
    } else {
        if ([self.delegate respondsToSelector:@selector(returnNFCData:)]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            
            dic[@"PartName"] = _partLabel.text;
            // 标签值
            dic[@"ElevatorPartNFCId"] = @"";
            dic[@"ElevatorPartNFCIdValue"] = @"";
            // 用户id
            dic[@"MaintenanceUserId"] = [UserService getUserInfo].userId;
            // 固定值
            dic[@"NFCCode"] = @"dianti119-000000001";
            // 标签唯一值
            dic[@"NFCNum"] = _nfcNum;
            // 品牌
            dic[@"ElevatorPartBrand"] = @"";
            // 型号
            dic[@"ElevatorPartModel"] = _selectPartButton.titleLabel.text;
            // 出厂日期
            dic[@"ElevatorPartFactoryDate"] = _selectPartButton.titleLabel.text;
            // 电梯ID
            dic[@"LiftId"] = _liftId;
            // 电梯配件ID
            dic[@"ElevatorPartsId"] = _model.ID;
            // 维保项目ID
            dic[@"MaintenanceItemId"] = _maintenanceItemId;
            // 图片
            dic[@"PhotoUrl"] = @"";
            // 备注
            dic[@"Remark"] = _writeString;
            
            
            [self.delegate returnNFCData:dic];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initNFC {
    self.msgBuffer = [[NSMutableString alloc] init];
    _lastRssi = -100;
    self.mNearestBle = nil;
    
    self.bleManager = [DKBleManager sharedInstance];
    self.bleManager.delegate = self;
    self.bleNfcDevice = [[DKBleNfcDevice alloc] initWithDelegate:self];
    [self fineNearBle];
}

#pragma mark - ---------- NFC 相关 ----------
// 找到最近的ble设备并连接
-(void)fineNearBle {
    self.msgLabel.text = @"正在搜索设备..";
    self.mNearestBle = nil;
    _lastRssi = -100;
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
//                self.msgLabel.text = @"未找到设备！";
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self fineNearBle];
                });
            });
        } else {
            //开始连接设备
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgLabel.text = @"正在连接设备..";
            });
            [self.bleManager connect:self.mNearestBle callbackBlock:^(BOOL isConnectSucceed) {
                if (isConnectSucceed) {
                    //设备连接成功
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.msgBuffer setString:@"设备连接成功！\r\n"];
                        self.msgLabel.text = @"断开连接";
                        //获取设备信息
                        [self getDeviceMsg];
                    });
                }
                else {
                    //设备连接失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.msgLabel.text = @"设备已断开！";
//                        self.navigationItem.title = @"搜索设备";
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
            //获取设备版本
            Byte versionNum = [self.bleNfcDevice getDeviceVersions];
            [self.msgBuffer appendString:@"SDK版本v2.1.0 20170612\r\n"];
            [self.msgBuffer appendString:[NSString stringWithFormat:@"设备版本：%02lx\r\n", (unsigned long)versionNum]];
            [self.msgBuffer appendString:@"蓝牙名称："];
            [self.msgBuffer appendString:[self.bleNfcDevice getDeviceName]];
            [self.msgBuffer appendString:[NSString stringWithFormat:@"\r\n信号强度：%lddB\r\n", (long)_lastRssi]];
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.msgTextView.text = self.msgBuffer;
            });
            
            //获取设备电池电压
            float btVlueMv = [self.bleNfcDevice getDeviceBatteryVoltage];
            [self.msgBuffer appendString:[NSString stringWithFormat:@"设备电池电压：%.2fV\r\n", btVlueMv]];
            if (btVlueMv < 3.6) {
                [self.msgBuffer appendString:@"设备电池电量低，请及时充电！\r\n"];
            }
            else {
                [self.msgBuffer appendString:@"设备电池电量充足！\r\n"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.msgLabel.text = self.msgBuffer;
            });
            
            //开启自动寻卡
            BOOL isSuc = [self.bleNfcDevice startAutoSearchCard:20 cardType:ISO14443_P4];
            if (isSuc) {
                [self.msgBuffer appendString:@"自动寻卡已开启，正在寻卡..\r\n"];
            }
            else {
                [self.msgBuffer appendString:@"不支持自动寻卡\r\n"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.msgTextView.text = self.msgBuffer;
            });
        } @catch (NSException *exception) {
            [self.msgBuffer appendString:exception.reason];
            dispatch_async(dispatch_get_main_queue(), ^{
//                self.msgTextView.text = self.msgBuffer;
            });
        } @finally {
        }
    });
}
//读写卡Demo
- (BOOL)readWriteDemo:(DKCardType)cardType{
    switch (cardType) {
        case DKUltralight_type: {//UL卡
            Ntag21x *ntag21x = [self.bleNfcDevice getCard];
            if (ntag21x != nil) {
                [self.msgBuffer setString:@"寻到Ultralight卡 －>UID:"];
                [self.msgBuffer appendString:[NSString stringWithFormat:@"%@\r\n", ntag21x.uid]];
                [self.msgBuffer appendString:[NSString stringWithFormat:@"%@\r\n", ntag21x.NdefTextRead]];
                NSLog(@"%@", self.msgBuffer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *uid = [NSString stringWithFormat:@"%@", ntag21x.uid];
                    uid = [uid stringByReplacingOccurrencesOfString:@"<" withString:@""];
                    uid = [uid stringByReplacingOccurrencesOfString:@" " withString:@""];
                    uid = [uid stringByReplacingOccurrencesOfString:@">" withString:@""];
                    uid = [uid uppercaseString];
                    
                    self.msgLabel.text = @"开始写入";
                    
//                    Boolean isSuc = [ntag21x NdefTextWrite:self.writeString];
//                    if (!isSuc) {
//                        self.msgLabel.text = @"写入失败";
//                    }
//                    else {
//                        self.msgLabel.text = @"写入成功";
//                    }
                    
                    self.valueLabel.text = [NSString stringWithFormat:@"标签值：\n%@\n唯一值：\n%@", self.writeString, uid];
                    self.nfcNum = uid;
                });
            }
        }
            break;
        default:
            break;
    }
    
    return YES;
}

//读到卡片代理回调
#pragma mark - DKBleNfcDeviceDelegate
-(void)receiveRfnSearchCard:(BOOL)isblnIsSus cardType:(DKCardType)cardType uid:(NSData *)CardSn ats:(NSData *)bytCarATS{
    [self.msgBuffer appendString:@"寻到卡片："];
    [self.msgBuffer appendString:[CardSn description]];
    [self.msgBuffer appendString:@"\r\n"];
    
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
                        self.msgLabel.text = self.msgBuffer;
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
                self.msgLabel.text = self.msgBuffer;
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
                        self.msgLabel.text = self.msgBuffer;
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
    
    //过滤信号弱的设备
    if ( [RSSI integerValue] < -60) {
        return;
    }
    
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
            if ([RSSI integerValue] > _lastRssi) {
                self.mNearestBle = peripheral;
            }
        }
        else {
            self.mNearestBle = peripheral;
            _lastRssi = [RSSI integerValue];
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
            //开始搜索设备
            [self fineNearBle];
        }
            break;
        case CBCentralManagerStatePoweredOff://蓝牙关闭
        {
            error = [NSError errorWithDomain:@"CBCentralManagerStatePoweredOff" code:-1 userInfo:nil];
            [self showInfo:@"蓝牙未打开"];
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
        [self showSuccess:@"蓝牙连接成功"];
    } else {
        NSLog(@"蓝牙连接失败");
//        [self showInfo:@"蓝牙连接断开"];
        [self fineNearBle];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.msgTextView.text = @"设备已断开！";
//            self.navigationItem.title = @"搜索设备";
//        });
    }
}



- (IBAction)selectPart:(UIButton *)sender {
    self.dater=[[XFDaterView alloc]initWithFrame:CGRectZero];
    self.dater.delegate=self;
    [self.dater showInView:self.view animated:YES];
}

- (void)daterViewDidClicked:(XFDaterView *)daterView {
    NSLog(@"dateString=%@ timeString=%@",self.dater.dateString,self.dater.timeString);
//    NSString *date = [NSString stringWithFormat:@"%@ %@",self.dater.dateString,self.dater.timeString];
    [_selectPartButton setTitle:self.dater.dateString forState:UIControlStateNormal];
}

- (void)daterViewDidCancel:(XFDaterView *)daterView {
    
}
@end
