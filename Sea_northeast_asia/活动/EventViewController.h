//
//  EventViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UINavViewControllerEx.h"
#import <WebKit/WebKit.h>
#import "EventTwoViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface EventViewController : UINavViewControllerEx<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate,UIWebViewDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>
{
    WKWebView *wkWebView;
    UIWebView *webview;
    IBOutlet UIView *view_content;
    NSString *ConvenienceUrl;
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIScrollView *sv;
    BOOL _reloading;
}
@end
