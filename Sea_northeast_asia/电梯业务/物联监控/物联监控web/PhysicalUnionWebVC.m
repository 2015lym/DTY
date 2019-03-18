//
//  PhysicalUnionWebVC.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/3/16.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "PhysicalUnionWebVC.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "MBProgressHUD.h"
#import "PhysicalUnionDetailWebvc.h"

@interface PhysicalUnionWebVC ()<UIWebViewDelegate> {
    WKWebView *webview;
}

@end

@implementation PhysicalUnionWebVC
@synthesize app;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = [WKUserContentController new];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 6.0;
    configuration.preferences = preferences;
    webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:configuration];
    
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.navigationItem.title =_web_title;// @"帮助";
    //webview = [[WKWebView alloc]init];
    //webview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    webview.UIDelegate = self;
    webview.navigationDelegate=self;
    [self.view addSubview:webview];
    
    _web_url=[NSString stringWithFormat:@"%@%@%@",Ksdby_api_Img,_web_url,app.userInfo.UserID];
    
    NSURL *url = [NSURL URLWithString:_web_url];//@"http://192.168.1.59:8080/WebApp/Monitoring/Index?userid=3922"
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
    [webview loadRequest:request];//加载
    
    
    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:webview];
    [_webViewBridge setWebViewDelegate:self];
    
    [self registerNativeFunctions];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_RescueOK:) name:@"tongzhi_success_wyxc" object:nil];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back_RescueOK:) name:@"tongzhi_back" object:nil];
}

- (void)back_RescueOK:(NSNotification *)text{
     NSString *parm=(NSString *)text.userInfo[@"textOne"];
    
    [_webViewBridge callHandler:@"reload" data:parm responseCallback:^(id responseData) {
        NSLog(@"调用完JS后的回调：%@",responseData);
    }];
}

- (void)tongzhi_RescueOK:(NSNotification *)text{
    [webview reload];
}

// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    //修改字体大小 300%
//    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'" completionHandler:nil];
//
//    //修改字体颜色  #9098b8
//    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#9098b8'" completionHandler:nil];
    
}

#pragma mark - private method
- (void)registerNativeFunctions
{
    [self registScanFunction];
    
    [self registtoastFunction];
    [self registshowloadingFunction];
    [self registhideloadingFunction];
    [self registbackFunction];
    [self registgetUserIDFunction];
    [self registcallFunction];
    [self registreloadFunction];
    
    [self registsignFunction];
}

- (void)registsignFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [_webViewBridge registerHandler:@"sign" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *number=[CommonUseClass FormatString: data];
        DTWBDetailViewController *vc=[[DTWBDetailViewController alloc]init];
        vc.lift_ID =number;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)registreloadFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [_webViewBridge registerHandler:@"reload" handler:^(id data, WVJBResponseCallback responseCallback) {
        [webview reload];
    }];
}

- (void)registcallFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [_webViewBridge registerHandler:@"call" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *number=[CommonUseClass FormatString: data];
        if([number isEqual:@""])
        {
            [CommonUseClass showAlter:@"电话号码为空！"];
            return ;
        }
        else
        {
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",number];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }];
}

- (void)registshowloadingFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [_webViewBridge registerHandler:@"showloading" handler:^(id data, WVJBResponseCallback responseCallback) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }];
}

- (void)registhideloadingFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [_webViewBridge registerHandler:@"hideloading" handler:^(id data, WVJBResponseCallback responseCallback) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)registbackFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [_webViewBridge registerHandler:@"back" handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popViewControllerAnimated:true];
    }];
}

- (void)registgetUserIDFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [_webViewBridge registerHandler:@"getUserID" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback(app.userInfo.UserID);
    }];
}
- (void)registtoastFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [_webViewBridge registerHandler:@"toast" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *str=[CommonUseClass FormatString:data];
        [CommonUseClass showAlter:str];
        //responseCallback(scanResult);
    }];
}


- (void)registScanFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [_webViewBridge registerHandler:@"getWebView" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dic=(NSDictionary *)data;
        [self gotoDetail:dic];
        //responseCallback(scanResult);
    }];
}



-(void )gotoDetail:(NSDictionary *)dic
{
    if(dic.count>=2)
    {
        PhysicalUnionDetailWebvc *detail = [[PhysicalUnionDetailWebvc alloc]init];
        detail.web_url=dic[@"link"];
        detail.web_title=dic[@"title"];
        [self.navigationController pushViewController:detail animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView*)webView {
    
}
-(void)webViewDidFinishLoad:(UIWebView*)webView {

}

-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error {
    NSLog(@"%@",error);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    return YES;
}


@end
