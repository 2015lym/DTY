//
//  WBDCViewController_WZH.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFAppDotNetAPIClient.h"
#import "AppDelegate.h"
#import "CommonUseClass.h"
#import "SZConfigure.h"
#import "SZQuestionCheckBox_WZH.h"
#import "DTWBViewController.h"
#import "DTWBWebViewController_WZH.h"
@interface WBDCViewController_WZH : UIViewController
{
    NSString *UploadDate;
    NSString *InstallationAddress;
    NSString *liftID;
    NSString *ID;//维保任务ID（首次维保为0，调用SaveNFCCheckDetails接口时传入ID）
}
@property (nonatomic,strong) AppDelegate *app;
@property (strong, nonatomic) NSString *liftNum;

@property (nonatomic, strong) SZQuestionCheckBox_WZH *questionBox;
@property (nonatomic, strong) SZQuestionItem *item;
@end
