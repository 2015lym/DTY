//
//  PhysicalUnionDetailWebvc.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/3/20.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "PhysicalUnionDetailWebvc.h"
#import <JavaScriptCore/JavaScriptCore.h>



#import "AppDelegate.h"
@interface PhysicalUnionDetailWebvc ()<UIWebViewDelegate> {
    WKWebView *webview;
}

@end

@implementation PhysicalUnionDetailWebvc
@synthesize app;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _web_title;
     app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    webview = [[WKWebView alloc]init];
    webview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:webview];
//    webview.delegate = self;
//    webview.scalesPageToFit = YES;
    webview.UIDelegate = self;
    webview.navigationDelegate=self;
    NSString *str_url = _web_url;//@"http://192.168.1.59:8080/WebApp/Maintenance/Index?userid=3922";
    NSURL *url = [NSURL URLWithString:str_url];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建
    [webview loadRequest:request];//加载
    
    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:webview];
    [_webViewBridge setWebViewDelegate:self];
    [self registerNativeFunctions];
}


-(void)webViewDidFinishLoad:(UIWebView*)webView {
//    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
//    [context evaluateScript:alertJS];//通过oc方法调用js的alert

}

-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error {
    NSLog(@"%@",error);
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    requestString = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([requestString hasPrefix:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [webView goBack];
    }
    return YES;
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
        
        if(![[CommonUseClass FormatString: data] isEqual:@""])
        {
            //添加 字典，将label的值通过key值设置传递
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[CommonUseClass FormatString: data],@"textOne", nil];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_back" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
