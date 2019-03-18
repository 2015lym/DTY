//
//  JYGLListWebViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "AppDelegate.h"
#import "QRCodeViewController_JX.h"
@interface JYGLListWebViewController : UIViewController
@property (nonatomic,strong) AppDelegate *app;
@property WKWebViewJavascriptBridge *webViewBridge;
@property NSString *web_url;
@property NSString *web_title;
@end
