//
//  Examine_SubmitViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Examine_SubmitViewController.h"
#import "SignViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "ExamineUtils.h"

@interface Examine_SubmitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@property (nonatomic, copy) NSString *imageUrl;

@end

@implementation Examine_SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"签名";
    _signImageView.hidden = YES;
    _numberLabel.text = [NSString stringWithFormat:@"注册代码：%@", _work.CertificateNum];
    _areaLabel.text = [NSString stringWithFormat:@"所在小区：%@", _work.CommunityName];
    _addressLabel.text = [NSString stringWithFormat:@"小区地址：%@", _work.CommunityDetailedAddress];
    _buildNumberLabel.text = [NSString stringWithFormat:@"内部编号及楼牌号：%@", _work.InternalNumAndBuildingNum];

    NSMutableString *userNames = [NSMutableString stringWithString:@"检验负责人："];
    for (UserListModel *user in _work.adminUsers) {
        [userNames appendString:user.UserName];
        [userNames appendString:@"，"];
    }
    _userLabel.text = [userNames substringToIndex:userNames.length - 1];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (IBAction)sign:(id)sender {
    if ([UserService getOldUserInfo].UserSign.length > 0) {
        _signImageView.hidden = NO;
        _imageUrl = [NSString stringWithFormat:@"%@/%@", old_base, [UserService getOldUserInfo].UserSign];
        NSURL *pathUrl = [NSURL URLWithString:_imageUrl];
        [_signImageView sd_setImageWithURL:pathUrl];
    } else {
        [self showAlertController:@"您还未设置签名，是否去设置？" callBack:^{
            SignViewController *vc = [SignViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

- (void)submit {
    if (!_imageUrl) {
        [self showInfo:@"请签名"];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"TaskManageId"] = _taskId;
        dic[@"PhotoUrl"] = [UserService getOldUserInfo].UserSign;
        dic[@"ExamineRecordList"] = [ExamineUtils getAllExaminesArray:_taskId];
        NSLog(@"%@", dic);
        [self showProgress];
        [NetRequest OLD_POST:examineTask_saveExamine params:dic callback:^(OldElevatorBaseModel *baseModel) {
            if (baseModel.Success) {
                [self showSuccess:@"提交成功"];
                [self.navigationController popToRootViewControllerAnimated:YES];
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
