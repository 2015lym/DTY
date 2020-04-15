//
//  SXTView.m
//  dtyios
//
//  Created by Lym on 2020/4/9.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "SXTView.h"

@implementation SXTView

- (IBAction)typeSelect:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"网络" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.selectTypeBtn setTitle:@"网络" forState:UIControlStateNormal];
        self.textField.enabled = YES;
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"模拟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.selectTypeBtn setTitle:@"模拟" forState:UIControlStateNormal];
        self.textField.enabled = NO;
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    //相当于之前的[actionSheet show];
    [self.viewController presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)search:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sxtSearchDelegate)]) {
        [self.delegate sxtSearchDelegate];
    }
}

- (IBAction)submit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sxtSubmitDelegate)]) {
        [self.delegate sxtSubmitDelegate];
    }
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
