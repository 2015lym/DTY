//
//  WXJLListWebViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/4/28.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "AppDelegate.h"
#import "QRCodeViewController.h"
#import "QRCodeViewController_WXJL.h"

@interface WXJLListWebViewController : UIViewController
@property (nonatomic,strong) AppDelegate *app;
@property WKWebViewJavascriptBridge *webViewBridge;
@property NSString *web_url;
@property NSString *web_title;
@end
