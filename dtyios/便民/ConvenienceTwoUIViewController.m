//
//  ConvenienceTwoUIViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/20.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "ConvenienceTwoUIViewController.h"

@implementation ConvenienceTwoUIViewController

@synthesize webview,wkWebView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addShare_btn];
    

}
-(void)setUrl:(NSString *)url
{
//    NSString *str=[NSString stringWithFormat:@
//            ]
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
    
    
    NSArray * arr_messgeInfo = [ConvenienceUrl componentsSeparatedByString:@"Map"];
    if(arr_messgeInfo.count==2)
    {
        self.navigationItem.title = @"地图";
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    
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
         self.navigationItem.title = wkWebView.title;
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
    /*关闭页面*/
    NSArray * arr_messgeInfo = [hostname componentsSeparatedByString:@"Guanbi"];
    if(arr_messgeInfo.count==2)
    {
        [self nav_backEx];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        arr_messgeInfo = [hostname componentsSeparatedByString:@"urlCall"];
        if(arr_messgeInfo.count==2)
        {
             srt_tel=[NSString stringWithFormat:@"tel://%@",[arr_messgeInfo objectAtIndex:1]];
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil  otherButtonTitles:[NSString stringWithFormat:@"呼叫电话:%@",[arr_messgeInfo objectAtIndex:1]],nil];
            actionSheet.tag=1001;
            [actionSheet showInView:self.view];
          
            decisionHandler(WKNavigationActionPolicyCancel);
          
        }
        else
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
    completionHandler();
    if (message!=nil) {
        NSArray * arr_messgeInfo = [message componentsSeparatedByString:@"."];
        if (arr_messgeInfo.count==2) {
            NSLog(@"%@", message);
            NSLog(@"%@",arr_messgeInfo);
        }
    }
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
    webview= [[UIWebView alloc] init];
    webview.frame= CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
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
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *title = [webview  stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title=title;
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *hostname = [request URL].absoluteString;
    /*关闭页面*/
    NSArray * arr_messgeInfo = [hostname componentsSeparatedByString:@"Guanbi"];
    if(arr_messgeInfo.count==2)
    {
        [self nav_backEx];
        return NO;
    }
    else
    {
        arr_messgeInfo = [hostname componentsSeparatedByString:@"urlCall"];
        if(arr_messgeInfo.count==2)
        {
            NSString *srt_url=[NSString stringWithFormat:@"tel://%@",[arr_messgeInfo objectAtIndex:1]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:srt_url]];
            return NO;
            
        }
        else
            return YES;
    }

}
-(IBAction)nav_back:(id)sender
{
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
-(void)nav_backEx
{
    [super nav_back:nil];
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


@end
