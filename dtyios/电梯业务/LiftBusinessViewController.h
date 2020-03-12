//
//  LiftBusinessViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/18.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "complainAdvice.h"
#import "TZTGViewController.h"
#import "wyxcListViewController.h"
#import "YJFXMainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DTWBWebViewController.h"
#import "Util.h"
#import "WYXCListWebViewController.h"
#import "NFCListViewController.h"
#import "AppDelegate.h"
#import "WXJLListWebViewController.h"
#import "WZHMainViewController.h"
@interface LiftBusinessViewController : UIViewControllerEx

@property (weak, nonatomic) IBOutlet UIButton *BJYLW;
@property (nonatomic,strong) AppDelegate *app;
- (IBAction)BJYLWClick:(id)sender;
- (IBAction)DTWBClick:(id)sender;

@end
