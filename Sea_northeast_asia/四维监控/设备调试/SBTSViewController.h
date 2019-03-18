//
//  SBTSViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/5.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MBProgressHUD+Add.h"
#import "SBTSModel.h"

#import "AppDelegate.h"
@interface SBTSViewController : UIViewController<UIAlertViewDelegate>
{
    NSData *data_old;
    
    UILabel *line;
    int tabCurrent;
    UIAlertView *waittingAlert;
    
    UILabel *lab_wifi;
    UILabel *lab_tcp;
    UILabel *lab_auth;
    
    //view2
    UILabel *lab_sbCode;
    UILabel *lab_zcCode;
    UITextField *tf_zcCode;
    UILabel *lab_dz;
    SBTSModel *sbtsModel;
    UILabel *lab_wbState;
    NSString *wbState_state;
    
    //view1
    UILabel *lineCursor;
    int lineCursorCount;
    CADisplayLink *link;
    
    UILabel *lab_1;
    UILabel *lab_2;
    UILabel *lab_3;
    UILabel *lab_4;
    UILabel *lab_5;
    UILabel *lab_6;
    UILabel *lab_7;
    UILabel *lab_8;
    UILabel *lab_9;
    UILabel *lab_10;
    UILabel *lab_11;
    UILabel *lab_12;
    UILabel *lab_13;
    UILabel *lab_14;
    UILabel *lab_15;
    UILabel *lab_16;
    UILabel *lab_17;
    UILabel *lab_18;
    UILabel *lab_19;
    UILabel *lab_20;
    UILabel *lab_21;
    UILabel *lab_22;
    UILabel *lab_23;
    UILabel *lab_24;
    UILabel *lab_25;
    UILabel *lab_26;
    UILabel *lab_27;
    UILabel *lab_28;
    UILabel *lab_29;
    UILabel *lab_30;
    UILabel *lab_31;
    UILabel *lab_32;
    
    UILabel *line_1;
    UILabel *line_2;
    UILabel *line_3;
    UILabel *line_4;
    UILabel *line_5;
    UILabel *line_6;
    UILabel *line_7;
    UILabel *line_8;
    UILabel *line_9;
    UILabel *line_10;
    UILabel *line_11;
    UILabel *line_12;
    UILabel *line_13;
    UILabel *line_14;
    UILabel *line_15;
    UILabel *line_16;
    UILabel *line_17;
    UILabel *line_18;
    UILabel *line_19;
    UILabel *line_20;
    UILabel *line_21;
    UILabel *line_22;
    UILabel *line_23;
    UILabel *line_24;
    UILabel *line_25;
    UILabel *line_26;
    UILabel *line_27;
    UILabel *line_28;
    UILabel *line_29;
    UILabel *line_30;
    UILabel *line_31;
    UILabel *line_32;
    
}

@property (nonatomic,strong) AppDelegate *app;
@end
