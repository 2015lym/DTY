//
//  EventTwoViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UIViewControllerEx.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "EventCourseTableViewCell.h"
#import "WXShareViewController.h"
@interface EventTwoViewController : UIViewControllerEx <WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate,UIWebViewDelegate>
{
    WKWebView *wkWebView;
    UIWebView *webview;
    NSString *ConvenienceUrl;
    
    WXShareViewController *wxshare;
    UIButton *btn_share;
}

-(void)setUrl:(NSString *)url;
@property (nonatomic,strong)   EventCourseTableViewCell *cell;

//分享资讯和互动的信息。
@property(nonatomic,strong) NSString *infoTitle;
@property(nonatomic,strong) NSString *infoMemo;
@property(nonatomic,strong) NSString *infoImage;
@property(nonatomic,strong) NSString *infoUrl;
@end
