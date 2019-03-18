//
//  PersonChangePWDViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/7/26.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFAppDotNetAPIClient.h"
#import "appDelegate.h"
@import AFNetworking;
@interface PersonChangePWDViewController : UIViewController
{
    __weak IBOutlet UITextField *pwdOld;
    IBOutlet UITextField *pwdNew;
    __weak IBOutlet UITextField *pwdReNew;
    BOOL isBtnOnCilck;
}
@property (nonatomic,strong) AppDelegate *app;
@end
