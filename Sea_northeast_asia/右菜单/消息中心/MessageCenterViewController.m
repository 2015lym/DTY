//
//  MessageCenterViewController.m
//  Sea_northeast_asia
//
//  Created by SongAA on 16/8/22.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "InteractionTwoViewController.h"
#import "EventTwoViewController.h"
@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
    left_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    [left_BarButoon_Item setImage:[UIImage imageNamed:@"navback.png"] forState:UIControlStateNormal];
    [left_BarButoon_Item addTarget:self action:@selector(navLeftBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
    self.navigationItem.leftBarButtonItem=leftItem;
     self.navigationItem.title=@"消息中心";
    // Do any additional setup after loading the view.
}
-(void)navLeftBtn_Event:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        [self initwkwebview];
        [(UIScrollView *)[[wkWebView subviews] objectAtIndex:0] setBounces:NO];
        wkWebView.scrollView.bounces = NO;
        wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 初始化wkwebview
-(void)initwkwebview
{
    
    wkWebView= [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, view_Center.frame.size.width, view_Center.frame.size.height)];
    NSURL *url = [[NSURL alloc]initWithString:@"http://192.168.1.111:8103/messageList.html"];
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
    [view_Center addSubview:wkWebView];
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
        //        self.title = wkWebView.title;
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
    if([hostname rangeOfString:@"initMessageList"].location !=NSNotFound)//_roaldSearchText
    {
        NSString *js = [NSString stringWithFormat: @"initMessageList('')"];
        if (self.app.str_token!=nil) {
            js = [NSString stringWithFormat: @"initMessageList('%@')",self.app.str_token];
        }
        [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"getMoreMassage"].location !=NSNotFound)
    {
        NSString *js = [NSString stringWithFormat: @"getMoreMassage('')"];
        if (self.app.str_token!=nil) {
            js = [NSString stringWithFormat: @"getMoreMassage('%@')",self.app.str_token];
        }
        [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"openDetailPage"].location !=NSNotFound)
    {
        NSString *js = [NSString stringWithFormat: @"openDetailPage('')"];
        if (self.app.str_token!=nil) {
            js = [NSString stringWithFormat: @"openDetailPage('%@')",self.app.str_token];
        }
        [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
            NSLog(@"response: %@ error: %@", response, error);
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if([hostname rangeOfString:@"msgToDetail"].location !=NSNotFound)
    {
        NSArray *array = [hostname componentsSeparatedByString:@"&tag="];
        if(array.count>1)
        {
            NSString *str_tag=[array objectAtIndex:1];
            //tag:1活动、2：互动文字、3：互动图片、4：互动资讯
            if ([str_tag isEqualToString:@"1"]) {
                NSString *str_newid=[array objectAtIndex:0];
                NSArray *array_enterId = [str_newid componentsSeparatedByString:@"enterId="];
                str_newid=[array_enterId objectAtIndex:1];
                NSString *srt_url=[NSString stringWithFormat:@"%@activityDetails.html?actId=%@",Ksdby_api,str_newid];
                EventTwoViewController *ctvc=[[EventTwoViewController alloc] init];
                ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
                [ctvc setUrl:srt_url];
                [self.navigationController pushViewController:ctvc animated:YES];
            }
            else if([str_tag isEqualToString:@"2"])
            {
                NSString *str_newid=[array objectAtIndex:0];
                NSArray *array_enterId = [str_newid componentsSeparatedByString:@"enterId="];
                str_newid=[array_enterId objectAtIndex:1];
                NSString *srt_url=[NSString stringWithFormat:@"%@interactDetails_text.html?entranceId=1&interactionId=%@",Ksdby_api,str_newid];
                InteractionTwoViewController *ctvc=[[InteractionTwoViewController alloc] init];
                ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
                [ctvc setUrl:srt_url];
                [self.navigationController pushViewController:ctvc animated:YES];
            }
            else if([str_tag isEqualToString:@"3"])
            {
                NSString *str_newid=[array objectAtIndex:0];
                NSArray *array_enterId = [str_newid componentsSeparatedByString:@"enterId="];
                str_newid=[array_enterId objectAtIndex:1];
                NSString *srt_url=[NSString stringWithFormat:@"%@interactDetails_image.html?entranceId=1&interactionId=%@",Ksdby_api,str_newid];
                InteractionTwoViewController *ctvc=[[InteractionTwoViewController alloc] init];
                ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
                [ctvc setUrl:srt_url];
                [self.navigationController pushViewController:ctvc animated:YES];
            }
            else if([str_tag isEqualToString:@"4"])
            {
                NSString *str_newid=[array objectAtIndex:0];
                NSArray *array_enterId = [str_newid componentsSeparatedByString:@"enterId="];
                str_newid=[array_enterId objectAtIndex:1];
                NSString *srt_url=[NSString stringWithFormat:@"%@newsDetail.html?newsId=%@",Ksdby_api,str_newid];
                InteractionTwoViewController *ctvc=[[InteractionTwoViewController alloc] init];
                ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
                [ctvc setUrl:srt_url];
                [self.navigationController pushViewController:ctvc animated:YES];
            }
        }
         decisionHandler(WKNavigationActionPolicyCancel);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
    NSLog(@"%s", __FUNCTION__);
}
-(void)abcd:(UIViewController *)ctvc
{
    
    
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
    NSLog(@"%@", message);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
