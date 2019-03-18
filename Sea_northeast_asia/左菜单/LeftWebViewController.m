//
//  LeftWebViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/22.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "LeftWebViewController.h"
#import "InteractionTwoViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface LeftWebViewController ()

@end

@implementation LeftWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WebLoing=NO;
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    CGRect rect=view_aa.frame;
    [view_aa setBackgroundColor:[UIColor redColor]];
}
-(void)setUrl:(NSString *)url
{
    ConvenienceUrl=[NSString stringWithFormat:@"%@",url];

    
}
-(void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear: animated];
//    CGRect rect=view_aa.frame;

    [view_aa setBackgroundColor:[UIColor redColor]];
    [self initNav_btn:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        [self initwkwebview];
        [(UIScrollView *)[[wkWebView subviews] objectAtIndex:0] setBounces:NO];
        wkWebView.scrollView.bounces = NO;
        wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    else{
        [self initwebview];
        [(UIScrollView *)[[webview subviews] objectAtIndex:0] setBounces:NO];
        webview.scrollView.bounces = NO;
        webview.scrollView.showsHorizontalScrollIndicator = NO;
    }
}
-(void)initNav_btn:(BOOL)add
{
    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
    left_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    [left_BarButoon_Item setImage:[UIImage imageNamed:@"navback.png"] forState:UIControlStateNormal];
    [left_BarButoon_Item addTarget:self action:@selector(navLeftBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
    if (add) {
        UIButton *left_BarButoon_Item1=[[UIButton alloc] init];
        left_BarButoon_Item1.frame=CGRectMake(0, 0,30,22);
        [left_BarButoon_Item1 setTitle:@"关闭" forState:UIControlStateNormal];
        [left_BarButoon_Item1.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [left_BarButoon_Item1 addTarget:self action:@selector(navLeftBtn_Close:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem1 = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item1];
        self.navigationItem.leftBarButtonItems=@[leftItem,leftItem1];
    }
    else
        self.navigationItem.leftBarButtonItems=@[leftItem];
}
-(void)navLeftBtn_Event:(id)sender{
    //保证webview最少加载完成一次
    if (!WebLoing) {
        [self navLeftBtn_Close:sender];
        return;
    }
    if([self.navigationItem.title isEqualToString:@"新闻搜索"])
    {
        [self navLeftBtn_Close:sender];
        return;
    }
    if (wkWebView!=nil) {
        NSString *js = [NSString stringWithFormat: @"closeByQueue()"];
        [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
        }];
    }
    else
    {
        [webview stringByEvaluatingJavaScriptFromString:@"closeByQueue()"];
        
    }
}
-(void)navLeftBtn_Close:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 初始化wkwebview
-(void)initwkwebview
{
    wkWebView= [[WKWebView alloc] initWithFrame:view_aa.frame];
  

    NSURL *url = [[NSURL alloc]initWithString:ConvenienceUrl];
    [wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    // Do any additional setup after loading the view from its nib.
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // web内容处理池
    config.processPool = [[WKProcessPool alloc] init];
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象名称AppModel，当JS通过AppModel来调用时，
    // 我们可以在WKScriptMessageHandler代理中接收到
    [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
    // 导航代理
    wkWebView.navigationDelegate = self;
    // 与webview UI交互代理
    wkWebView.UIDelegate = self;
    
    // 添加KVO监听
    [wkWebView addObserver:self
                forKeyPath:@"loading"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    [wkWebView addObserver:self
                forKeyPath:@"title"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    [wkWebView addObserver:self
                forKeyPath:@"estimatedProgress"
                   options:NSKeyValueObservingOptionNew
                   context:nil];
    [view_aa addSubview:wkWebView];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"AppModel"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSLog(@"%@", message.body);
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"loading");
    } else if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = wkWebView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress: %f", wkWebView.estimatedProgress);
        //        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!wkWebView.loading) {
        WebLoing=YES;
    }
}
#pragma mark - WKNavigationDelegate
//WKNavigtionDelegate来进行页面跳转


// 在发送请求之前，决定是否跳转

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(![ConvenienceUrl isEqualToString:navigationAction.request.URL.absoluteString])
    {
        [self initNav_btn:YES];
    }
    NSString *hostname = navigationAction.request.URL.absoluteString;
    if([hostname rangeOfString:@"Guanbi"].location !=NSNotFound)//_roaldSearchText
    {
        [self navLeftBtn_Close:nil];
         decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"xinwen"].location !=NSNotFound )
    {
        NSArray *arr_messgeInfo=[hostname componentsSeparatedByString:@"xinwen"];
        NSString *srt_url=[NSString stringWithFormat:@"%@%@",Ksdby_api,[arr_messgeInfo objectAtIndex:1]];
        InteractionTwoViewController *ctvc=[[InteractionTwoViewController alloc] init];
        ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height+64);
        [ctvc setUrl:srt_url];
        [self.navigationController pushViewController:ctvc animated:YES];
         decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"urlpageName="].location !=NSNotFound )
    {
        NSArray *arr_messgeInfo=[hostname componentsSeparatedByString:@"urlpageName="];
        NSString *srt_url=[NSString stringWithFormat:@"%@",[arr_messgeInfo objectAtIndex:1]];
        InteractionTwoViewController *ctvc=[[InteractionTwoViewController alloc] init];
        ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height+64);
        [ctvc setUrl:srt_url];
        [self.navigationController pushViewController:ctvc animated:YES];
         decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"urlCall"].location !=NSNotFound)
    {
        NSArray * arr_messgeInfo = [hostname componentsSeparatedByString:@"urlCall"];
        if(arr_messgeInfo.count==2)
        {
            srt_tel=[NSString stringWithFormat:@"tel://%@",[arr_messgeInfo objectAtIndex:1]];
            UIActionSheet *actionSheet =
            [[UIActionSheet alloc] initWithTitle:nil    delegate:self
                               cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                               otherButtonTitles:[NSString stringWithFormat:@"呼叫电话:%@",[arr_messgeInfo objectAtIndex:1]],nil];
            actionSheet.tag=1001;
            [actionSheet showInView:self.view];
        }
        decisionHandler(WKNavigationActionPolicyCancel);

    }
    else    if([hostname rangeOfString:@"initActivityDetail"].location !=NSNotFound)
    {
        //        [self Verification]; 传token
        NSString *js = [NSString stringWithFormat: @"initActivityDetail('')"];
        if (self.app.str_token!=nil) {
            js = [NSString stringWithFormat: @"initActivityDetail('%@')",self.app.str_token];
        }
        [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"openEnrollPage"].location !=NSNotFound)
    {
        NSString *js = [NSString stringWithFormat: @"openEnrollPage('')"];
        if (self.app.str_token!=nil) {
            js = [NSString stringWithFormat: @"openEnrollPage('%@')",self.app.str_token];
        }
        [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"startLogin"].location !=NSNotFound)
    {
        [self loginMethod];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"startEnroll"].location !=NSNotFound)
    {  NSString *js = [NSString stringWithFormat: @"startEnroll('')"];
        if (self.app.str_token!=nil) {
            js = [NSString stringWithFormat: @"startEnroll('%@')",self.app.str_token];
        }
        [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    }    else
        decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"%@", message);
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    NSLog(@"%@", prompt);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


#pragma mark 初始化webview
-(void)initwebview
{
    webview= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height)];
    NSURL *url = [[NSURL alloc]initWithString:ConvenienceUrl];
    webview.delegate=self;
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webview];
}

#pragma mark webviewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *title = [webview  stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title=title;
    WebLoing=YES;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSArray * arr_messgeInfo = [url componentsSeparatedByString:@"Convenience"];//Convenience 是分割字符串的标识
    if(arr_messgeInfo.count==2)
    {
        return NO;
    }
    return YES;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1001) {
        switch (buttonIndex) {
            case 0:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:srt_tel]];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark 弹出登录页面
-(void)loginMethod{
    
    //LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:[Util GetResolution:@"LoginViewController" ] bundle:nil];
    LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav_loginVC=[[ UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav_loginVC animated:YES completion:^{
        
    }];
}
@end
