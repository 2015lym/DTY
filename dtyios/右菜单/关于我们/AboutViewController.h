//
//  AboutViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/8/1.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UIViewControllerEx.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "JSONKit.h"
@interface AboutViewController : UIViewControllerEx <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate,UIWebViewDelegate>
{
    WKWebView *wkWebView;
    UIWebView *webview;
    NSString *ConvenienceUrl;
}
@end
