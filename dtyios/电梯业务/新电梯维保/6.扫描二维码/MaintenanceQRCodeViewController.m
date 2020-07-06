//
//  MaintenanceQRCodeViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/4/18.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "MaintenanceQRCodeViewController.h"
#import "MaintenanceGetQRCodeViewController.h"
#import "MaintenanceContentViewController.h"

@interface MaintenanceQRCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation MaintenanceQRCodeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"工作流程节点";
}

- (IBAction)scanAction:(id)sender {
    MaintenanceGetQRCodeViewController *vc = [MaintenanceGetQRCodeViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)nextPage:(id)sender {
    [self showAlertController:@"是否跳过该节点" callBack:^{
        MaintenanceContentViewController *vc = [MaintenanceContentViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
