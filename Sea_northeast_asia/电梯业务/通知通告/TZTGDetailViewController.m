//
//  TZTGDetailViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/17.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "TZTGDetailViewController.h"
#import "XXNet.h"
#import "CurriculumEntity.h"
@interface TZTGDetailViewController ()

@end

@implementation TZTGDetailViewController
@synthesize app;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title=@"通知通告详情";
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    mainScrollView=[[UIScrollView alloc]init];
    mainScrollView.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
    [self .view addSubview:mainScrollView];
    [self RequestNetData];
}

- (void)RequestNetData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    NSMutableDictionary *dicP = [[NSMutableDictionary alloc]init];
    [dicP setValue:app.userInfo.UserID forKey:@"UserId"];
    [dicP setValue:_ID forKey:@"ID"];

    [XXNet GetURL:GetArticleURL header:dicHeader parameters:dicP succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            NSString *str_json = data[@"Data"];
            NSDictionary *_dic_value = [str_json objectFromJSONString];
            
            webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
            webview.scrollView.scrollEnabled=NO;
            webview.delegate=self;
            NSString *newStr=[CommonUseClass FormatString:[_dic_value objectForKey:@"Content"]];
            [webview loadHTMLString:newStr baseURL:nil];
            [mainScrollView addSubview:webview];
            
//            NSString *str_json = data[@"Data"];
//            NSArray *arrData = [str_json objectFromJSONString];
//            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:arrData];
            
            
            
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //[webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#f3f3f5'"];
    //方法2
    CGRect  frameWeb = webView.frame;
    frameWeb.size.width = bounds_width.size.width;
    frameWeb.size.height = 1;
    webView.frame = frameWeb;
    frameWeb.size.height = webView.scrollView.contentSize.height;
    frameWeb.size.width = webView.scrollView.contentSize.width;
    NSLog(@"frame = %@", [NSValue valueWithCGRect:frameWeb]);
    webView.frame = frameWeb;
    
//    view_yzxx.frame=CGRectMake(0, frameWeb.size.height, bounds_width.size.width, 140);
//    
//    viewtab1.frame=CGRectMake(0, 40, bounds_width.size.width,  viewtab1.frame.origin.y+webView.frame.size.height+140);
//    
//    tabviewHeight=viewtab1.frame.origin.y+webView.frame.size.height+40+140;
//    viewtab.frame=CGRectMake(0, viewtab.frame.origin.y,viewtab.frame.size.width, tabviewHeight);
    mainScrollView.contentSize=CGSizeMake(frameWeb.size.width,  frameWeb.size.height+60);
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
