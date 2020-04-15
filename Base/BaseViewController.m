//
//  BaseViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/5/17.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - ---------- SVProgressHUD ----------
- (void)showProgress {
    _isShow = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __weak typeof(self) weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf hideProgress];
        });
    });
}

- (void)hideProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.isShow = NO;
    });
}


- (void)showSuccess:(NSString *)string {
    [SVProgressHUD isVisible];
    [SVProgressHUD showSuccessWithStatus:string];
    [SVProgressHUD dismissWithDelay:1];
}

- (void)showInfo:(NSString *)string {
    [SVProgressHUD showInfoWithStatus:string];
    [SVProgressHUD dismissWithDelay:1];
}

@end
