//
//  InteractionTwoViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UIViewControllerEx.h"
#import <WebKit/WebKit.h>
#import "WXShareViewController.h"
@interface InteractionTwoViewController : UIViewControllerEx<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate,UIWebViewDelegate>
{
    WKWebView *wkWebView;
    UIWebView *webview;
    NSString *ConvenienceUrl;
    NSString *currTitle;
    
    WXShareViewController *wxshare;
    UIButton *btn_share;
}
-(void)setUrl:(NSString *)url;
//分享资讯和互动的信息。
@property(nonatomic,strong) NSString *infoTitle;
@property(nonatomic,strong) NSString *infoMemo;
@property(nonatomic,strong) NSString *infoImage;
@property(nonatomic,strong) NSString *infoUrl;
@end
