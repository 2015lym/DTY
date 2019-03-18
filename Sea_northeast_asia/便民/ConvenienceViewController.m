//
//  ConvenienceViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "ConvenienceViewController.h"

@interface ConvenienceViewController ()

@end

@implementation ConvenienceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    [self setupLocationManager];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >8.0) {
        [self initwkwebview];
//        [(UIScrollView *)[[wkWebView subviews] objectAtIndex:0] setBounces:NO];
//        wkWebView.scrollView.bounces = NO;
//        wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    }
    else{
        [self initwebview];
        [(UIScrollView *)[[webview subviews] objectAtIndex:0] setBounces:NO];
        webview.scrollView.bounces = NO;
        webview.scrollView.showsHorizontalScrollIndicator = NO;
    }
    sv= (UIScrollView *)[[wkWebView subviews] objectAtIndex:0];
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *egview =
        [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - sv.bounds.size.height, sv.frame.size.width, sv.bounds.size.height)];
        egview.delegate = self;
        [sv addSubview:egview];
        //        [egview setimagehiend];
        _refreshHeaderView = egview;
        egview=nil;
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
    sv.delegate=self;

}
-(void)viewWillAppear:(BOOL)animated
{
    [[self.tabBarController.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];
   self.tabBarController.navigationItem.title=@"便民查询";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >8.0) {
        wkWebView.frame=CGRectMake(0, 0, view_content.frame.size.width, view_content.frame.size.height);
    }
    else{
        webview.frame=CGRectMake(0, 0, view_content.frame.size.width, view_content.frame.size.height);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 初始化wkwebview
-(void)initwkwebview
{
    
    wkWebView= [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, view_content.frame.size.width, view_content.frame.size.height)];
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@facilitate.html",Ksdby_api]];
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
    [view_content addSubview:wkWebView];
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
    }
    
    // 加载完成
    if (!wkWebView.loading) {
        CLLocation *checkinLocation1=self->checkinLocation;
        NSString *Provinces1=self->Provinces;
        NSString *City1=self->City;
        BOOL is=YES;
        if(Provinces1!=nil)
        {
           Provinces1= [Provinces1 stringByReplacingOccurrencesOfString:@"省" withString:@""];
        }
        else
            is=NO;
        if(City1!=nil)
        {
            City1= [City1 stringByReplacingOccurrencesOfString:@"市" withString:@""];
            
        }
        else
            is=NO;
        if (is) {
            NSLog(@"纬度:%f",checkinLocation1.coordinate.latitude);
            NSLog(@"经度:%f",checkinLocation1.coordinate.longitude);
            NSString *js = [NSString stringWithFormat: @"postStr('%f,%f,%@,%@')",checkinLocation1.coordinate.longitude,checkinLocation1.coordinate.latitude,Provinces1,City1];
            [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                NSLog(@"response: %@ error: %@", response, error);
            }];
        }
        else
        {
            NSString *js = [NSString stringWithFormat: @"postStr('')"];
            [wkWebView evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                NSLog(@"response: %@ error: %@", response, error);
            }];
        }
        [self doneLoadingTableViewData];
  }
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *hostname = navigationAction.request.URL.absoluteString;
    NSArray * arr_messgeInfo = [hostname componentsSeparatedByString:@"Convenience"];
    if(arr_messgeInfo.count==2)
    {
        NSString *srt_url=[NSString stringWithFormat:@"%@%@",Ksdby_api,[arr_messgeInfo objectAtIndex:1]];
        ConvenienceTwoUIViewController *ctvc=[[ConvenienceTwoUIViewController alloc] init];
        ctvc.view.frame=bounds_width;
        [ctvc setUrl:srt_url];
        [self.tabBarController.navigationController pushViewController:ctvc animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
     decisionHandler(WKNavigationActionPolicyAllow);
    }
//    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
//        && ![hostname containsString:@".baidu.com"]) {
//        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
//        
//        decisionHandler(WKNavigationActionPolicyCancel);
//    } else {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
    
//    ÷NSLog(@"%s", __FUNCTION__);
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
    [self doneLoadingTableViewData];
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
    webview= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, view_content.frame.size.width, view_content.frame.size.height)];
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@facilitate.html",Ksdby_api]];
    
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
    NSString *title = [webview  stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title=title;
    /*加载完成调用js*/
    CLLocation *checkinLocation1=self->checkinLocation;
    NSString *Provinces1=self->Provinces;
    NSString *City1=self->City;
    if(Provinces1!=nil)
    {
        Provinces1= [Provinces1 stringByReplacingOccurrencesOfString:@"省" withString:@""];
    }
    if(City1!=nil)
    {
        City1= [City1 stringByReplacingOccurrencesOfString:@"市" withString:@""];
    }
    NSLog(@"纬度:%f",checkinLocation1.coordinate.latitude);
    NSLog(@"经度:%f",checkinLocation1.coordinate.longitude);
    NSString *js = [NSString stringWithFormat: @"postStr('%f,%f,%@,%@')",checkinLocation1.coordinate.longitude,checkinLocation1.coordinate.latitude,Provinces1,City1 ];
    
    [webview stringByEvaluatingJavaScriptFromString:js];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *hostname = request.URL.absoluteString;
    NSArray * arr_messgeInfo = [hostname componentsSeparatedByString:@"Convenience"];
    if(arr_messgeInfo.count==2)
    {
        NSString *srt_url=[NSString stringWithFormat:@"%@%@",Ksdby_api,[arr_messgeInfo objectAtIndex:1]];
        ConvenienceTwoUIViewController *ctvc=[[ConvenienceTwoUIViewController alloc] init];
        ctvc.view.frame=bounds_width;
        [ctvc setUrl:srt_url];
        [self.tabBarController.navigationController pushViewController:ctvc animated:YES];
        return NO;
    }
    else
    {
        return YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 定位获取
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [super locationManager:manager didUpdateLocations:locations];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"无法获得定位信息");
}

#pragma mark - EGORefreshTableHeaderDelegate Methods
//下拉控件刷新触发事件
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    if (_reloading==NO) {
        [self reloadTableViewDataSource];
    }
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading;
    // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    if (!wkWebView.loading)
    {
        [wkWebView loadRequest:[NSURLRequest requestWithURL:wkWebView.URL]];
    }
    else
    {
        [self doneLoadingTableViewData];
        return;
    }
    
    
    _reloading = YES;
    
}
//请求结束函数。在这里要关闭下拉的视图.并更新表视图
- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    
    NSLog(@"stop loading");
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:sv];
    
}
@end
