//
//  LiftHelpViewController.m
//  Sea_northeast_asia
//
//  Created by SinodomMac on 17/4/1.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "LiftHelpViewController.h"

@interface LiftHelpViewController ()
{
    WKWebView *webview;
}
@end

@implementation LiftHelpViewController
@synthesize app;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    self.navigationItem.title=[_dic_data objectForKey:@"Name"];;
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [self initwebview];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initwebview
{
    webview= [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height-64)];
    
    NSString *str= [_dic_data objectForKey:@"url"];

    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [[NSURL alloc]initWithString:str];
    //webview.delegate=self;
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webview];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL * url = [request URL];
    
    NSString *str=[url scheme];
    if ([[url scheme] isEqualToString:@"getUserID"]) {
        NSArray *params =[url.query componentsSeparatedByString:@"&"];
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (NSString *paramStr in params) {
            NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
            if (dicArray.count > 1) {
                NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [tempDic setObject:decodeValue forKey:dicArray[0]];
            }
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"方式一" message:@"这是OC原生的弹出窗" delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
        [alertView show];
        NSLog(@"tempDic:%@",tempDic);
        return NO;
    }
    
    return YES;
}
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}





@end
