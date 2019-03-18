//
//  PhysicalUnionDetailWebvc.h
//  Sea_northeast_asia
//
//  Created by wyc on 2018/3/20.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "AppDelegate.h"
#import "CommonUseClass.h"
@interface PhysicalUnionDetailWebvc : UIViewController
{
    int count;
}
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic, retain)NSString *web_url;
@property (nonatomic, retain)NSString *web_title;
@property WKWebViewJavascriptBridge *webViewBridge;
@end
