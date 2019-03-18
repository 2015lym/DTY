//
//  LiftHelpViewController.h
//  Sea_northeast_asia
//
//  Created by SinodomMac on 17/4/1.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "UIViewControllerEx.h"
#import <WebKit/WebKit.h>
#import "WXShareViewController.h"
#import "appDelegate.h"



@interface LiftHelpViewController : UIViewController<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate,UIWebViewDelegate>
{
 

    int YJBJCount;
    float Longitude;
    float Latitude;
}

@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) NSString *GSName;
@property (nonatomic,strong) NSDictionary *dic_data;
@end
