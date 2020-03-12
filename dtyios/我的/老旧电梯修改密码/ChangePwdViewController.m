//
//  ChangePwdViewController.m
//  ElevatorRemodelApp
//
//  Created by Lym on 2019/5/8.
//  Copyright © 2019 sinodom. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordTextField;

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
}

- (IBAction)submitAction:(id)sender {
    if (_oldPasswordTextField.text.length == 0) {
        [self showToast:@"请输入旧密码"];
    } else if (_passwordTextField.text.length < 6) {
        [self showToast:@"密码必须大于6位"];
    } else if (![_passwordTextField.text isEqualToString:_repeatPasswordTextField.text]) {
        [self showToast:@"两次输入的密码不一致"];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"Account"] = [UserService getOldUserInfo].Account;
        dic[@"OldPassword"] = _oldPasswordTextField.text;
        dic[@"NewPassword"] = _passwordTextField.text;
        [self showProgress];
        [NetRequest OLD_POST:account_updatePassword params:dic callback:^(OldElevatorBaseModel *baseModel) {
            if (baseModel.Success) {
                [self showSuccess:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showInfo:baseModel.Message];
            }
            [self hideProgress];
        } errorCallback:^(NSError *error) {
            [self hideProgress];
        }];
    }
}

@end
