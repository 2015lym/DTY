//
//  DTWBWebViewController_WZH.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "AppDelegate.h"
#import "QRCodeViewController_WZH.h"
@interface DTWBWebViewController_WZH : UIViewController
@property (nonatomic,strong) AppDelegate *app;
@property WKWebViewJavascriptBridge *webViewBridge;
@property NSString *web_url;
@property NSString *web_title;
@end
