//
//  NFCSBViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/28.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "NFCSBViewController.h"
#import "MyControl.h"
#import "CommonUseClass.h"
#import "DKBleNfc.h"
#import "NSData+Hex.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "MBProgressHUD.h"

#define SEARCH_BLE_NAME   @"BLE_NFC"
@interface NFCSBViewController ()<DKBleManagerDelegate, DKBleNfcDeviceDelegate,CBCentralManagerDelegate>//
@property (nonatomic, strong) DKBleManager     *bleManager;
@property (nonatomic, strong) DKBleNfcDevice   *bleNfcDevice;
@property (nonatomic, strong) CBPeripheral     *mNearestBle;
@property (nonatomic, strong) UIButton         *doneButton;

@property (nonatomic, strong) NSString  *msgBuffer;
@property(strong,nonatomic)CBCentralManager* CM;
@end

@implementation NFCSBViewController

@synthesize bleManager;
@synthesize doneButton;
@synthesize bleNfcDevice;

NSInteger lastRssi = -100;
Byte      tradeN   = 1;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title=@"标签绑定";
    self.navigationController.navigationItem.title=@"标签绑定";

    self.navigationController.navigationBarHidden = NO;
    
    [self SearchButtonEnter];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    UIImageView *img=[MyControl createImageViewWithFrame:CGRectMake((SCREEN_WIDTH-348)/2, SCREEN_HEIGHT-605, 348, 505) imageName:@"ic_nfc_bind_bg"];
    [self.view addSubview:img];
    
    UILabel *labTitle=[MyControl createLabelWithFrame:CGRectMake(20, SCREEN_HEIGHT-400, SCREEN_WIDTH-40, 40) Font:40 Text:_Title];
    labTitle.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:labTitle];
    
    UILabel *labMemo=[MyControl createLabelWithFrame:CGRectMake(20, SCREEN_HEIGHT-300, SCREEN_WIDTH-40, 40) Font:18 Text:_Memo];
    labMemo.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:labMemo];
    
    lab_sb=[MyControl createLabelWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20) Font:15 Text:@""];
    [self.view addSubview:lab_sb];
    
    //ly

    lastRssi = -100;
    self.mNearestBle = nil;
    
    self.bleManager = [DKBleManager sharedInstance];
    self.bleManager.delegate = self;
    self.bleNfcDevice = [[DKBleNfcDevice alloc] initWithDelegate:self];
self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//搜索、断开连接按键监听
- (void)SearchButtonEnter {
    //如果已经连接设备，则断开连接设备，如果没有连接设备则开始搜索设备，搜到指定名字的设备后开始连接
    if ( [self.bleManager isConnect] ) {
        //[self.bleManager cancelConnect];
    }
    else {
        [self fineNearBle];
    }
}
//找到最近的ble设备并连接
-(void)fineNearBle{
    lab_sb.text = @"正在搜索设备..";
    self.mNearestBle = nil;
    lastRssi = -100;
    [self.bleManager startScan];
    
    return;
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
                lab_sb.text = @"未找到设备！";
            });
        }
        else{
            //开始连接设备
            dispatch_async(dispatch_get_main_queue(), ^{
                lab_sb.text = @"正在连接设备..";
            });
            [self.bleManager connect:self.mNearestBle callbackBlock:^(BOOL isConnectSucceed) {
                if (isConnectSucceed) {
                    //设备连接成功
                    dispatch_async(dispatch_get_main_queue(), ^{
                        lab_sb.text = @"设备连接成功！\r\n";
//                        self.searchButton.titleLabel.text = @"断开连接";
//                        //获取设备信息
//                        [self getDeviceMsg];
                    });
                }
                else {
                    //设备连接失败
                    dispatch_async(dispatch_get_main_queue(), ^{
                        lab_sb.text = @"设备已断开！";
//                        self.searchButton.titleLabel.text = @"搜索设备";
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


            //开启自动寻卡
            BOOL isSuc = [self.bleNfcDevice startAutoSearchCard:20 cardType:ISO14443_P4];
            if (isSuc) {
                self.msgBuffer =@"自动寻卡已开启，正在寻卡..\r\n";
            }
            else {
                self.msgBuffer =@"不支持自动寻卡\r\n";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                lab_sb.text = self.msgBuffer;
            });
        } @catch (NSException *exception) {
            self.msgBuffer =exception.reason;
            dispatch_async(dispatch_get_main_queue(), ^{
                lab_sb.text = self.msgBuffer;
            });
        } @finally {
        }
    });
}

////读到卡片代理回调
//#pragma mark - DKBleNfcDeviceDelegate
//-(void)receiveRfnSearchCard:(BOOL)isblnIsSus cardType:(DKCardType)cardType uid:(NSData *)CardSn ats:(NSData *)bytCarATS{
////    [self.msgBuffer appendString:@"寻到卡片："];
////    [self.msgBuffer appendString:[CardSn description]];
////    [self.msgBuffer appendString:@"\r\n"];
////    [self.msgTextView setText:self.msgBuffer];
//    
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        BOOL isAutoSearchCardFlag = [self.bleNfcDevice isAutoSearchCard];
//        
//        @try {
//            BOOL isSuc = NO;
//            //如果是自动寻卡寻到的卡，寻到卡后，先关闭自动寻卡
//            if (isAutoSearchCardFlag) {
//                //先关掉自动寻卡
//                [self.bleNfcDevice stoptAutoSearchCard];
//                
//                //开始读卡
////                isSuc = [self readWriteDemo:cardType];
//                
//                //读写卡成功，蜂鸣器快响3声
//                if (isSuc) {
//                    [self.bleNfcDevice openBeep:50 offDelay:50 cnt:3];
//                }
//                else {
//                    [self.bleNfcDevice openBeep:100 offDelay:100 cnt:2];
//                }
//                
//                //读卡结束，重新打开自动寻卡
//                int cnt = 0;
//                BOOL autoSearchCardFlag;
//                do {
//                    autoSearchCardFlag = [self.bleNfcDevice startAutoSearchCard:20 cardType:ISO14443_P4];
//                }while (!autoSearchCardFlag && (cnt++ < 3));
//                
//                if (!autoSearchCardFlag) {
//                    self.msgBuffer =[NSString stringWithFormat:@"不支持自动寻卡！\r\n"];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        lab_sb.text = self.msgBuffer;
//                    });
//                }
//            }
//            else {
//                //开始读卡
////                isSuc = [self readWriteDemo:cardType];
//                
//                //如果不是自动寻卡，读卡结束,关闭天线
//                [self.bleNfcDevice closeRf];
//                
//                //读写卡成功，蜂鸣器快响3声
//                if (isSuc) {
//                    [self.bleNfcDevice openBeep:50 offDelay:50 cnt:3];
//                }
//                else {
//                    [self.bleNfcDevice openBeep:100 offDelay:100 cnt:2];
//                }
//            }
//        } @catch (NSException *exception) {
//            self.msgBuffer=[exception reason];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                lab_sb.text = self.msgBuffer;
//            });
//            [self.bleNfcDevice openBeep:100 offDelay:100 cnt:2];
//            
//            if (isAutoSearchCardFlag) {
//                //读卡失败，重新打开自动寻卡
//                int cnt = 0;
//                BOOL autoSearchCardFlag;
//                do {
//                    @try {
//                        autoSearchCardFlag = [self.bleNfcDevice startAutoSearchCard:20 cardType:ISO14443_P4];
//                    }@catch (NSException *exception) {
//                        autoSearchCardFlag = false;
//                    }
//                }while (!autoSearchCardFlag && (cnt++ < 3));
//                
//                if (!autoSearchCardFlag) {
//                    self.msgBuffer =[NSString stringWithFormat:@"不支持自动寻卡！\r\n"];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        lab_sb.text = self.msgBuffer;
//                    });
//                }
//            }
//        } @finally {
//        }
//    });
//}
//
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

///*
// * 函数说明：蓝牙状态回调
// */
//#pragma mark - DKBleManagerDelegate
//-(void)DKCentralManagerDidUpdateState:(CBCentralManager *)central {
//    NSError *error = nil;
//    switch (central.state) {
//        case CBCentralManagerStatePoweredOn://蓝牙打开
//        {
////            //开始搜索设备
////            [self fineNearBle];
//        }
//            break;
//        case CBCentralManagerStatePoweredOff://蓝牙关闭
//        {
//            error = [NSError errorWithDomain:@"CBCentralManagerStatePoweredOff" code:-1 userInfo:nil];
//        }
//            break;
//        case CBCentralManagerStateResetting://蓝牙重置
//        {
//            //pendingInit = YES;
//        }
//            break;
//        case CBCentralManagerStateUnknown://未知状态
//        {
//            error = [NSError errorWithDomain:@"CBCentralManagerStateUnknown" code:-1 userInfo:nil];
//        }
//            break;
//        case CBCentralManagerStateUnsupported://设备不支持
//        {
//            error = [NSError errorWithDomain:@"CBCentralManagerStateUnsupported" code:-1 userInfo:nil];
//        }
//            break;
//        default:
//            break;
//    }
//}
//
////蓝牙连接状态回调
//-(void)DKCentralManagerConnectState:(CBCentralManager *)central state:(BOOL)state{
//    if (state) {
//        NSLog(@"蓝牙连接成功");
//    }
//    else {
//        NSLog(@"蓝牙连接失败");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            lab_sb.text = @"设备已断开！";
////            self.searchButton.titleLabel.text = @"搜索设备";
//        });
//    }
//}

@end
