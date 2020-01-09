//
//  InteractionViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UINavViewControllerEx.h"
#import <WebKit/WebKit.h>
#import "InteractionTwoViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface InteractionViewController : UINavViewControllerEx<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate,UIWebViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate,EGORefreshTableHeaderDelegate>
{
    WKWebView *wkWebView;
    UIWebView *webview;
    IBOutlet UIView *view_content;
    NSString *ConvenienceUrl;
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIScrollView *sv;
    BOOL _reloading;
}
-(void)navRightBtn_Event;
@end
