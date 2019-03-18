//
//  PJGLSaveViewController_outline.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/22.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyControl.h"
#import "AppDelegate.h"
#import "NFCBandClass.h"
#import "CommonUseClass.h"
#import "XXNet.h"
//#import "WKWebViewJavascriptBridge.h"
//#import <JavaScriptCore/JavaScriptCore.h>
#import "CurriculumEntity.h"
#import "MBProgressHUD.h"
#import "PhysicalUnionDetailWebvc.h"
#import "PJGLSaveDetailViewController.h"
#import "UITableViewExViewController.h"
#import "classLiftParts.h"
#import "UITableViewExForDeleteViewController.h"
@interface PJGLSaveViewController_outline : UIViewController<UITableViewExViewDelegate>
{
    UIView *headview;
    UILabel *dtBianHao_2;
    UILabel *dtWeiBao_2;
    UILabel *dtWeiZhi_2;
    UILabel * dtdaima_2;
    
    UIScrollView *sc;
    
    NSDictionary *currDic;
    NSString *currTag;
    
    UIView *view_Content_2;
    UIView *view_Content_back;
    UITextField *tf;
    UIButton *btnNewDianti;
    
    UITableViewExForDeleteViewController *CourseTableview;
    NSString *deleteGuid;
    
    int currCount;
}

@property (strong, nonatomic) NSString *LiftId;
@property (strong, nonatomic) NSString *liftNum;
@property (strong, nonatomic) NSString *InstallationAddress;
@property (strong, nonatomic) NSString *CertificateNum;
@property (strong, nonatomic) classLiftParts *classLiftParts;

@property (nonatomic,strong) AppDelegate *app;
//@property WKWebViewJavascriptBridge *webViewBridge;
@end


