//
//  BaseViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/5/17.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController
@property (nonatomic, assign) BOOL isShow;
- (void)showProgress;
- (void)hideProgress;
// 成功提示
- (void)showSuccess:(NSString *)string;

// 普通、失败提示
- (void)showInfo:(NSString *)string;
@end
