//
//  Old_WorkListViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_WorkListViewController.h"
#import "Old_WorkTableViewCell.h"
#import "Old_WorkDetailViewController.h"
#import "MJRefresh.h"
#import "Part_WorkListModel.h"

@interface Old_WorkListViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation Old_WorkListViewController

#pragma mark - ---------- 生命周期 ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(netRequest)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self netRequest];
}

#pragma mark - ---------- 每个Section的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
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

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Old_WorkTableViewCell *cell = [Old_WorkTableViewCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Part_WorkListModel *model = _dataArray[indexPath.row];
    Old_WorkDetailViewController *vc = [Old_WorkDetailViewController new];
    vc.taskId = model.Id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"FlowStatusActionsId"] = [NSString stringWithFormat:@"%ld", _workStatus];
    
    if (_textField.text.length > 0) {
        dic[@"KeyWord"] = _textField.text;
    }
    [self showProgress];
    [NetRequest OLD_POST:reformTask_getTaskManageByFlowStatusActionsId params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.dataArray = [NSMutableArray array];
            for (NSDictionary *dic in [StringFunction stringToJson:baseModel.Data]) {
                Part_WorkListModel *model = [Part_WorkListModel yy_modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
        [self.tableView.mj_header endRefreshing];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self.tableView.mj_header endRefreshing];
    }];
}
@end
