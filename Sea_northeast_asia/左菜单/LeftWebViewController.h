//
//  LeftWebViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/22.
//  Copyright © 2016年 SongQues. All rights reserved.
//


#import <WebKit/WebKit.h>
#import "UIViewControllerEx.h"
@interface LeftWebViewController : UIViewControllerEx<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate,UIWebViewDelegate,UIActionSheetDelegate>
{
    WKWebView *wkWebView;
    UIWebView *webview;
    NSString *ConvenienceUrl;
    BOOL WebLoing;
    NSString *srt_tel;
    IBOutlet UIView *view_aa;
}
-(void)setUrl:(NSString *)url;

@end
