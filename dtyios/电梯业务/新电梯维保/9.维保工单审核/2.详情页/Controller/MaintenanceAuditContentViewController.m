//
//  MaintenanceAuditContentViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/29.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceAuditContentViewController.h"
#import "MaintenanceAuditContentTableViewCell.h"
#import "MaintenanceRecordModel.h"
#import "MaintenanceAuditContentModel.h"
#import "MaintenanceSignViewController.h"
#import "MaintenanceRefuseOrderViewController.h"
#import "MaintenanceAuditDetailViewController.h"

@interface MaintenanceAuditContentViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MaintenanceAuditContentModel *>* dataArray;
@end

@implementation MaintenanceAuditContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"维保内容";
    [self netRequest];
}

- (void)netRequest {
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [UserService getUserInfo].userId;
    dic[@"workOrderId"] = _workOrderId;
    [NetRequest GET:@"NPMaintenanceApp/GetMaintenanceWorkRecordByWorkOrderId" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            self.dataArray = [NSMutableArray array];
            for (NSDictionary *dic in [StringFunction stringToJson:baseModel.data]) {
                [self.dataArray addObject:[MaintenanceAuditContentModel yy_modelWithJSON:dic]];
            }
            [self.tableView reloadData];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
    }];
}


#pragma mark - ---------- 每个Section的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count + 1;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else {
        MaintenanceAuditContentModel *item = _dataArray[indexPath.section - 1];
        NSInteger height = 16 + 18 + 8 + item.users.count * 25;
        if (item.nfcs.count > 0) {
            height += 25;
        }
        if (item.photos.count > 0) {
            height += 25;
        }
        return height;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ideitifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = [self getCellContent];
        return cell;
    } else {
        MaintenanceAuditContentTableViewCell *cell = [MaintenanceAuditContentTableViewCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        cell.model = _dataArray[indexPath.section - 1];
        return cell;
    }
}

- (NSString *)getCellContent {
    NSMutableString *peopleList = [[NSMutableString alloc] init];
    for (NSDictionary *dic in _model.MaintenanceUserNameList) {
        [peopleList appendString:dic[@"MaintenanceUserName"]];
        [peopleList appendString:@"、"];
    }
    return [NSString stringWithFormat:@"维保人：%@\n维保日期：%@\n维保单位：%@\n注册代码：%@", peopleList, [_model.BeginMaintenanceTime stringByReplacingOccurrencesOfString:@"T" withString:@" "], _model.MaintDeptName, _model.CertificateNum];
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MaintenanceAuditContentModel *model = _dataArray[indexPath.section - 1];
    MaintenanceAuditDetailViewController *vc = [MaintenanceAuditDetailViewController new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)reject:(id)sender {
    MaintenanceRefuseOrderViewController *vc = [MaintenanceRefuseOrderViewController new];
    vc.isCheck = YES;
    vc.workOrderId = _model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)agree:(id)sender {
    MaintenanceSignViewController *vc = [MaintenanceSignViewController new];
    vc.isCheck = YES;
    vc.workOrderId = _model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
