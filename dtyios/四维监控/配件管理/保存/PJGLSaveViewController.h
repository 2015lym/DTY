//
//  PJGLSaveViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyControl.h"
#import "AppDelegate.h"
#import "NFCBandClass.h"
#import "CommonUseClass.h"
#import "XXNet.h"
//#import "WKWebViewJavascriptBridge.h"
//#import <JavaScriptCore/JavaScriptCore.h>
#import "CurriculumEntity.h"

#import "PhysicalUnionDetailWebvc.h"
#import "PJGLSaveDetailViewController.h"
#import "UITableViewExViewController.h"
#import "classLiftParts.h"
#import "PJGLSaveViewController_outline.h"
#import "UITableViewExForDeleteViewController.h"
@import CoreNFC;
@interface PJGLSaveViewController : UIViewController<NFCNDEFReaderSessionDelegate,UITableViewExViewDelegate>
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
    NSString *PartsTypeId;
    NSString *PartsTypeName;
    
    UITextField *tf;
    UIButton *btnNewDianti;
    
     UITableViewExForDeleteViewController *CourseTableview;
    NSString *deleteGuid;
}

@property (strong, nonatomic) NSString *LiftId;
@property (strong, nonatomic) NSString *liftNum;
@property (strong, nonatomic) NSString *InstallationAddress;
@property (strong, nonatomic) NSString *CertificateNum;
@property (strong, nonatomic) classLiftParts *classLiftParts;

@property (nonatomic,strong) AppDelegate *app;
//@property WKWebViewJavascriptBridge *webViewBridge;
@end
