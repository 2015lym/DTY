//
//  TZTGDetailViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/17.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CommonUseClass.h"
@interface TZTGDetailViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webview;
    UIScrollView *mainScrollView;
}
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) NSString *ID;
@end
