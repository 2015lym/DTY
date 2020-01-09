//
//  WBDCViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/12.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFAppDotNetAPIClient.h"
#import "AppDelegate.h"
#import "CommonUseClass.h"
#import "SZConfigure.h"
#import "SZQuestionCheckBox.h"
#import "DTWBViewController.h"
#import "DTWBWebViewController.h"
@interface WBDCViewController : UIViewController
{
    NSString *UploadDate;
    NSString *InstallationAddress;
    NSString *liftID;
}
@property (nonatomic,strong) AppDelegate *app;
@property (strong, nonatomic) NSString *liftNum;

@property (nonatomic, strong) SZQuestionCheckBox *questionBox;
@property (nonatomic, strong) SZQuestionItem *item;
@end
