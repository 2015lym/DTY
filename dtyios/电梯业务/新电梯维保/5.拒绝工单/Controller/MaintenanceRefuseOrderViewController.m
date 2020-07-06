//
//  MaintenanceRefuseOrderViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/12.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceRefuseOrderViewController.h"

@interface MaintenanceRefuseOrderViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation MaintenanceRefuseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"拒绝工单";
}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"%@", textView.text);
}

- (IBAction)submit:(id)sender {
    if (_textView.text.length == 0) {
        [self showInfo:@"请填写意见"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [UserService getUserInfo].userId;
    dic[@"UserId"] = [UserService getUserInfo].userId;
    dic[@"WorkOrderId"] = self.workOrderId;
    dic[@"AuditOpinion"] = _textView.text;
    [NetRequest POST:@"NPMaintenanceApp/SaveMaintenanceWorkOrderAudit" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            [self showSuccess:@"提交成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
    }];
}

@end
