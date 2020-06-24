//
//  MaintenanceRecordNoTabViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/9.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceRecordNoTabViewController.h"
#import "MaintenanceRecordTableViewCell.h"
#import "MJRefresh.h"
#import "MaintenanceRecordModel.h"
#import "MaintenanceOrderDetailViewController.h"

@interface MaintenanceRecordNoTabViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MaintenanceRecordNoTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(netRequest)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self netRequest];
}

- (IBAction)search:(id)sender {
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
    return [self getCellHeight:_dataArray[indexPath.row]];
}

- (CGFloat)getCellHeight:(MaintenanceRecordModel *)model {
    CGFloat height = 15;
    height += 16 + 10 + 18 + 8;
    model.DetailAddress = [model.DetailAddress stringByReplacingOccurrencesOfString:@"\r" withString:@"a"];
    model.DetailAddress = [model.DetailAddress stringByReplacingOccurrencesOfString:@"\n" withString:@"a"];
    model.DetailAddress = [model.DetailAddress stringByReplacingOccurrencesOfString:@" " withString:@"a"];
    CGRect titleRect = [model.DetailAddress boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 108, 1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    height += titleRect.size.height;
    height += 8 + 16 + 8 + 16;
    height += 16;
    return height;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MaintenanceRecordTableViewCell *cell = [MaintenanceRecordTableViewCell cellWithTableView:tableView];
    cell.overLabel.hidden = YES;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MaintenanceRecordModel *model = _dataArray[indexPath.row];
    MaintenanceOrderDetailViewController *vc = [MaintenanceOrderDetailViewController new];
    if (model.MaintenanceWorkOrderStatusId == 1) {
        vc.orderType = todo;
    } else if (model.MaintenanceWorkOrderStatusId == 2) {
        vc.orderType = doing;
    } else if (model.MaintenanceWorkOrderStatusId == 3) {
        vc.orderType = checking;
    } else if (model.MaintenanceWorkOrderStatusId == 4) {
        vc.orderType = signing;
    } else {
        vc.orderType = done;
    }
    vc.workOrderId = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)netRequest {
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"UserId"] = [UserService getUserInfo].userId;
    dic[@"WorkOrderStatus"] = [NSString stringWithFormat:@"%ld", _workStatus];
    
    if (_textField.text.length > 0) {
        dic[@"CertificateNum"] = _textField.text;
    }
    [NetRequest GET:@"NPMaintenanceApp/GetMaintenanceWorkOrdersPage" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            self.dataArray = [NSMutableArray array];
            for (NSDictionary *dic in [StringFunction stringToJson:baseModel.data]) {
                MaintenanceRecordModel *model = [MaintenanceRecordModel yy_modelWithJSON:dic];
                model.workStatus = self.workStatus;
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
@end
