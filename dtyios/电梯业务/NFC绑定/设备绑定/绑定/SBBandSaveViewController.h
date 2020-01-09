//
//  SBBandSaveViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/8/30.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyControl.h"
#import "AppDelegate.h"
#import "NFCBandClass.h"
#import "CommonUseClass.h"
#import "XXNet.h"
@interface SBBandSaveViewController : UIViewController
{
    UIView *headview;
    UILabel *dtBianHao_2;
    UILabel *dtWeiBao_2;
    UILabel *dtWeiZhi_2;
    
    UIScrollView *sc;
    
    NSDictionary *currDic;
    NSString *currTag;
    
    UIView *view_Content_2;
    UIView *view_Content_back;
    UITextField *tf;
    UIButton *btnNewDianti;
    
    UILabel *selectLabel_bhvalue;
    UILabel *selectLabel_dzvalue;
}

@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *liftNum;
@property (nonatomic,strong) NSString *liftID;
@property (strong, nonatomic) NSString *InstallationAddress;
@property (strong, nonatomic) NSString *UploadDate;
@property (strong, nonatomic) NSArray *nfcList;
@property (nonatomic,strong) AppDelegate *app;
@end
