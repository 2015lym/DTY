//
//  PersonChangeNikenameViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/7/26.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFAppDotNetAPIClient.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
@import AFNetworking;
@interface PersonChangeNikenameViewController : UIViewController
{
    IBOutlet UITextField *nikeName;
    BOOL isBtnOnCilck;
}
@property (nonatomic,strong) AppDelegate *app;
@end
