//
//  WYXCListWebViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/4/25.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "AppDelegate.h"
#import "QRCodeViewController.h"
#import "QRCodeViewController_WYXC.h"
@interface WYXCListWebViewController : UIViewController
@property (nonatomic,strong) AppDelegate *app;
@property WKWebViewJavascriptBridge *webViewBridge;
@property NSString *web_url;
@property NSString *web_title;
@end
