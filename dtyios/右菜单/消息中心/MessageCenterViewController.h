//
//  MessageCenterViewController.h
//  Sea_northeast_asia
//
//  Created by SongAA on 16/8/22.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "UIViewControllerEx.h"
#import "AppDelegate.h"
@interface MessageCenterViewController : UIViewControllerEx<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>
{
    IBOutlet UIView *view_Center;
    WKWebView *wkWebView;
    NSString *ConvenienceUrl;
}
@end
