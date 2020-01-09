//
//  PhysicalUnionWebVC.h
//  Sea_northeast_asia
//
//  Created by wyc on 2018/3/16.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "AppDelegate.h"
#import "CommonUseClass.h"
#import "DTWBDetailViewController.h"
@interface PhysicalUnionWebVC : UIViewController
{
    int count;
}
@property (nonatomic,strong) AppDelegate *app;
@property WKWebViewJavascriptBridge *webViewBridge;
@property NSString *web_url;
@property NSString *web_title;
@end
