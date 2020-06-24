//
//  MaintenanceGetQRCodeViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/4/18.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "MaintenanceGetQRCodeViewController.h"

@interface MaintenanceGetQRCodeViewController ()

@end

@implementation MaintenanceGetQRCodeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.libraryType = SLT_Native;
        self.scanCodeType = SCT_QRCode;
        self.isNeedScanImage = NO;
        //设置扫码区域参数
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        
        //扫码框中心位置与View中心位置上移偏移像素(一般扫码框在视图中心位置上方一点)
        style.centerUpOffset = 44;
        //扫码框周围4个角的类型设置为在框的上面,可自行修改查看效果
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
        
        //扫码框周围4个角绘制线段宽度
        style.photoframeLineW = 6;
        
        //扫码框周围4个角水平长度
        style.photoframeAngleW = 24;
        
        //扫码框周围4个角垂直高度
        style.photoframeAngleH = 24;
        
        
        //动画类型：网格形式，模仿支付宝
        style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
        
        //动画图片:网格图片
        style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_part_net"];;
        
        //扫码框周围4个角的颜色
        style.colorAngle = [UIColor colorWithRed:65./255. green:174./255. blue:57./255. alpha:1.0];
        
        //是否显示扫码框
        style.isNeedShowRetangle = YES;
        //扫码框颜色
        style.colorRetangleLine = [UIColor colorWithRed:247/255. green:202./255. blue:15./255. alpha:1.0];
        
        //非扫码框区域颜色(扫码框周围颜色，一般颜色略暗)
        //必须通过[UIColor colorWithRed: green: blue: alpha:]来创建，内部需要解析成RGBA
        style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        self.style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫描二维码";
}

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array {
    LBXScanResult *result = array.firstObject;
    
//    MaintenanceWorkTemplateNodes *curNode;
//    for (MaintenanceWorkTemplateNodes *node in self.dataArray) {
//        if (node.sortCode == 1) {
//            curNode = node;
//        }
//    }
//    curNode.actionValue = result.strScanned;
//    
//    self.workModel = [NodeUtils replaceHistories:self.workModel templateNode:curNode];
//    NSString *page = [NodeUtils pushPageWithArgumentValue:self.argumentValue model:self.workModel];
//    [NodeUtils saveModel:self.workModel];
//    if ([page isEqualToString:@"NFC"]) {
//        MaintenanceContentViewController *vc = [MaintenanceContentViewController new];
//        vc.workModel = self.workModel;
//        vc.statusValue = self.argumentValue;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

@end
