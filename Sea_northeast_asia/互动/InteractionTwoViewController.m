//
//  InteractionTwoViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "InteractionTwoViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
@interface InteractionTwoViewController ()

@end

@implementation InteractionTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addShare_btn];
    [self setupLocationManager];
    // Do any additional setup after loading the view from its nib.
}


#pragma mark 加入分享按钮
-(void)addShare_btn
{
    btn_share=[[UIButton alloc] init];
    btn_share.frame=CGRectMake(0, 0, 20, 20);
    //[btn_share setTitle:@"分享" forState:UIControlStateNormal];
    [btn_share setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [btn_share addTarget:self action:@selector(btn_share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *add_Item = [[UIBarButtonItem alloc] initWithCustomView:btn_share];
    NSArray *actionButtonItems = @[add_Item];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

-(IBAction)btn_share:(id)sender
{
    CGRect rect2;
    if (wxshare!=nil) {
        return;
    }
    wxshare=[[WXShareViewController alloc]init];
    wxshare.shareurl=_infoUrl;
    wxshare.type=@"问答";
    wxshare.wxshareDelegate=self;
    wxshare.wxtitle=_infoTitle;
    wxshare.wxMemo=_infoMemo;
    wxshare.wxImage=_infoImage;
    CGFloat heigth=[UIScreen mainScreen ].bounds.size.height;
    rect2=wxshare.view.frame=self.view.frame;
    rect2.origin.y=heigth-rect2.size.height-64;
    wxshare.view.frame=
    CGRectMake(0,heigth+rect2.size.height, rect2.size.width, rect2.size.height);
    [self.view addSubview:wxshare.view];
    [UIView beginAnimations:nil context:NULL];
    wxshare.view.frame=rect2;
    [UIView commitAnimations];
}

-(void)btn_Cancel
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect2;
        rect2=wxshare.view.frame;
        CGFloat heigth=[UIScreen mainScreen ].bounds.size.height;
        wxshare.view.frame=
        CGRectMake(0,heigth+rect2.size.height, rect2.size.width, rect2.size.height);
    } completion:^(BOOL finished) {
        [wxshare.view removeFromSuperview];
        wxshare=nil;
        wxshare.wxshareDelegate=nil;
        wxshare.shareurl=@"";
        wxshare.type=@"";
    }];
    
}

-(void)setUrl:(NSString *)url
{
    ConvenienceUrl=[NSString stringWithFormat:@"%@",url];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >8.0) {
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
-(void)viewWillAppear:(BOOL)animated
{
        [[self.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];

    //    self.tabBarController.navigationItem.title=@"便民查询";
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >8.0) {
    //        wkWebView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    }
    //    else{
    //        webview.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 初始化wkwebview
-(void)initwkwebview
{
    
    wkWebView= [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
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
    [self.view addSubview:wkWebView];
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
        currTitle=wkWebView.title;
        self.navigationItem.title = currTitle;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress: %f", wkWebView.estimatedProgress);
        //        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!wkWebView.loading) {
        // 手动调用JS代码
        // 每次页面完成都弹出来，大家可以在测试时再打开
    }
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *hostname = navigationAction.request.URL.absoluteString;
    if([hostname rangeOfString:@"openCommentPage"].location !=NSNotFound)
    {
        NSString *js = [NSString stringWithFormat: @"openCommentPage('')"];
        if (self.app.str_token!=nil) {
            js = [NSString stringWithFormat: @"openCommentPage('%@')",self.app.str_token];
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
    else if([hostname rangeOfString:@"startComment"].location !=NSNotFound)
    {
        NSString *js = [NSString stringWithFormat: @"startComment('')"];
        if (self.app.str_token!=nil) {
            js = [NSString stringWithFormat: @"startComment('%@')",self.app.str_token];
        }
        [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"Guanbi"].location !=NSNotFound)
    {
        [super nav_back:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        
        if([hostname rangeOfString:@"commentList"].location !=NSNotFound)
        {
            self.navigationItem.title=@"评论列表";
        }
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
    NSLog(@"%s", __FUNCTION__);
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       // completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    NSLog(@"%s", __FUNCTION__);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
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
    if([title isEqualToString:@"校园咨讯"])
    {
        NSString *str = [webview stringByEvaluatingJavaScriptFromString:@" isPraised();"];
        if ([str isEqualToString:@"1"]) {
            NSLog(@"JS返回值：%@",str);
        }
    }
    else
    {
        
    }
    
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接失败!" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}
#pragma mark 弹出登录页面
-(void)loginMethod{
    
    //LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:[Util GetResolution:@"LoginViewController" ] bundle:nil];
    LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav_loginVC=[[ UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav_loginVC animated:YES completion:^{
        
    }];
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
-(void)nav_back:(id)sender
{
    self.navigationItem.title=currTitle;
    if (wkWebView!=nil) {
        NSString *js = [NSString stringWithFormat: @"closeByQueue()"];
        [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            if (error!=nil) {
                [super nav_back:nil];
            }
        }];
    }
    else
    {
        [webview stringByEvaluatingJavaScriptFromString:@"closeByQueue()"];
        
    }
}


@end
