//
//  JYGLListWebViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "JYGLListWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "PhysicalUnionDetailWebvc.h"
@interface JYGLListWebViewController ()<UIWebViewDelegate> {
    WKWebView *webview;
}

@end

@implementation JYGLListWebViewController

@synthesize app;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearHuanCun];
    
    
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.navigationItem.title =_web_title;// @"帮助";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_RescueOK:) name:@"tongzhi_success" object:nil];
    
    UIButton *right_BarButoon_Item=[[UIButton alloc] init];
    right_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    [right_BarButoon_Item setImage:[UIImage imageNamed:@"dt_scan.png"] forState:UIControlStateNormal];
    [right_BarButoon_Item addTarget:self action:@selector(navRightBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_BarButoon_Item];
    self.navigationItem.rightBarButtonItems=@[rightItem];
    
    
    
    webview = [[WKWebView alloc]init];
    webview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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

-(void)navRightBtn_Event:(id)sender
{
    QRCodeViewController_JX * cdvc=[[QRCodeViewController_JX alloc] initWithNibName:@"QRCodeViewController_JX" bundle:nil];
    cdvc.Type_ID = @"2";
    cdvc.companyType=@"Ios_ESL_XJLXQYXC";
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:cdvc animated:YES];
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
-(void)clearHuanCun
{
    NSLog(@"%s",__FUNCTION__);
    if (@available(iOS 11.0, *)) {
        [webview.configuration.websiteDataStore.httpCookieStore setCookie:nil completionHandler:nil];
    } else {
        // Fallback on earlier versions
    }
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //缓存web清除
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [webview removeObserver:self forKeyPath:@"estimatedProgress"];
    //[super didReceiveMemoryWarning];
    
    self.navigationController.navigationBarHidden = NO;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    
    // 清除所有
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    //// Date from
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    //// Execute
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        // Done
        NSLog(@"清楚缓存完毕");
    }];
    
}

@end
