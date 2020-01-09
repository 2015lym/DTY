//
//  InteractionViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "InteractionViewController.h"
#import "PushTextViewController.h"
#import "PushImageViewController.h"
#import "Util.h"

#import <TZImagePickerController.h>
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "JSONKit.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface InteractionViewController ()<TZImagePickerControllerDelegate>
{
    NSMutableArray * _selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;

}
@end

@implementation InteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self setupLocationManager];
    // Do any additional setup after loading the view from its nib.
    ConvenienceUrl=[NSString stringWithFormat:@"%@interact.html",Ksdby_api];
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
    /*相册需要用的*/
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"Refresh" object:nil];
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
-(void)setUrl:(NSString *)url
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self.tabBarController.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];
    self.tabBarController.navigationItem.title=@"互动";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >8.0) {
        wkWebView.frame=CGRectMake(0, 0, view_content.frame.size.width, view_content.frame.size.height);
    }
    else{
        webview.frame=CGRectMake(0, 0,view_content.frame.size.width, view_content.frame.size.height);
    }
    
//    NSURL *url = [[NSURL alloc]initWithString:ConvenienceUrl];
//    if(webview!=nil)
//    {
//        [webview loadRequest:[NSURLRequest requestWithURL:url]];
//    }
//    else
//    {
//        [wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
//    }


}
-(void)navRightBtn_Event
{
    [self checkTOKEN];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1001) {
        switch (buttonIndex) {
            case 0:
            {
                [self pickPhotoButtonClick];
            }
                break;
            case 1:
            {
                PushTextViewController *ptvc=[[PushTextViewController alloc] initWithNibName:[Util GetResolution:@"PushTextViewController"] bundle:nil];
                [self.tabBarController.navigationController pushViewController:ptvc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}



#pragma mark TOKEN验证是否失效
-(void)checkTOKEN
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    
    if(super.app.str_token==nil ||[super.app.str_token isEqualToString:@""])
    {
        [self checkTOKEN_ERR];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    NSString *token=super.app.str_token;
    
    [dic_args setObject:token forKey:@"access_token"];
    [dic_args setObject:@"code" forKey:@"response_type"];
    [dic_args setObject:@"verToken" forKey:@"redirect_uri"];
    [dic_args setObject:@"{\"isToken\":true,\"param\":{}}" forKey:@"state"];
    
    [[AFAppDotNetAPIClient sharedClient_token]
     POST:@"apiDataByAccessToken.php"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         if(dic_result.count>0)
         {
             NSString *status=[dic_result objectForKey:@"status"];
             NSString *message=[dic_result objectForKey:@"message"];
             
             if(message!=nil&&[message isEqualToString:@"token验证成功！"])
             {
                 UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil  otherButtonTitles:@"照片",@"纯文本",nil];
                 actionSheet.tag=1001;
                 [actionSheet showInView:self.view];
             }
             else
             {
                 [self checkTOKEN_ERR];
                 
             }
         }else
         {
             [self checkTOKEN_ERR];
         }
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self checkTOKEN_ERR];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}
-(void)checkTOKEN_ERR
{
    [self initAlertViewEx:@"登录信息已过期，请重新登录！"];
    super.app.str_token=@"";
    NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
    [dic_oAuth removeObjectForKey:@"str_token"];
    [dic_oAuth removeObjectForKey:@"username"];
    [dic_oAuth removeObjectForKey:@"nikename"];
    [dic_oAuth removeObjectForKey:@"pwd"];
    [dic_oAuth removeObjectForKey:@"uhead"];
    [self loginMethod];
}

-(void)initAlertViewEx:(NSString *)str_message
{
    UIAlertView *alert=[[UIAlertView alloc]
                        initWithTitle:@"提示"
                        message:str_message
                        delegate:nil
                        cancelButtonTitle:@"确定"
                        otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark 弹出登录页面
-(void)loginMethod{
    
    //LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:[Util GetResolution:@"LoginViewController" ] bundle:nil];
    LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav_loginVC=[[ UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav_loginVC animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 初始化wkwebview
-(void)initwkwebview
{
    
    wkWebView= [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
        //        self.title = wkWebView.title;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"progress: %f", wkWebView.estimatedProgress);
        //        self.progressView.progress = self.webView.estimatedProgress;
    }
    
    // 加载完成
    if (!wkWebView.loading) {
        // 手动调用JS代码
        // 每次页面完成都弹出来，大家可以在测试时再打开
        [self doneLoadingTableViewData];
    }
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *hostname = navigationAction.request.URL.absoluteString;
    NSArray * arr_messgeInfo = [hostname componentsSeparatedByString:@"Hudong"];//Hudong 区分表示
    if(arr_messgeInfo.count==2)
    {
        NSString *srt_url=[NSString stringWithFormat:@"%@%@",Ksdby_api,[arr_messgeInfo objectAtIndex:1]];
        InteractionTwoViewController *ctvc=[[InteractionTwoViewController alloc] init];
        ctvc.view.frame=bounds_width;
        [ctvc setUrl:srt_url];
        [self.tabBarController.navigationController pushViewController:ctvc animated:YES];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
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
    NSArray * arr_messgeInfo = [url componentsSeparatedByString:@"Hudong"];//Hudong 是分割字符串的标识
    if(arr_messgeInfo.count==2)
    {
        
        return NO;
    }
    return YES;
}

#pragma mark 获取照片列表

- (void)pickPhotoButtonClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:8 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePickerVc.selectedAssets = [NSMutableArray array]; // optional, 可选的
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
     imagePickerVc.navigationBar.barTintColor = NAV_BACKGROUNDCOLOR;
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
     imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
#pragma mark TZImagePickerControllerDelegate
#pragma mark 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}
#pragma mark 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    PushImageViewController *ptvc=[[PushImageViewController alloc] initWithNibName:[Util GetResolution:@"PushImageViewController"] bundle:nil];
    ptvc.Arr_image=[NSMutableArray arrayWithArray:photos];
    ptvc.Arr_Assets=[NSMutableArray arrayWithArray:assets];
    [self.tabBarController.navigationController pushViewController:ptvc animated:YES];
}
#pragma mark 用户选择好了视频
/*
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    _layout.itemCount = _selectedPhotos.count;
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    [_collectionView reloadData];
    _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}
 */
#pragma mark NotificationCenter method
-(void)notificationAction:(NSNotification *)notification{
    NSURL *url = [[NSURL alloc]initWithString:ConvenienceUrl];
    if(webview!=nil)
    {
        [webview loadRequest:[NSURLRequest requestWithURL:url]];
    }
    else
    {
        [wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    }
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
