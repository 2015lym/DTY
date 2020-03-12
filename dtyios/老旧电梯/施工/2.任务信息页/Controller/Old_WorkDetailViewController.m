//
//  Old_WorkDetailViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_WorkDetailViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "Old_BaseInfoTableViewCell.h"
#import "Old_ElevatorTableViewCell.h"
#import "Old_PartInfoTableViewCell.h"
#import "Old_PersonTableViewCell.h"

#import "Old_PartPreviewViewController.h"
#import "Old_PartListViewController.h"

#import "Part_WorkDetailModel.h"
#import "Part_EditPreviewViewController.h"


@interface Old_WorkDetailViewController ()
//当前界面的mapView
@property (nonatomic, strong) BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Part_WorkDetailModel *model;

@end

@implementation Old_WorkDetailViewController
#pragma mark - ---------- 生命周期 ----------
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [_mapView viewWillAppear];
    [self netRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [_mapView viewWillDisappear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"施工任务信息";
    [self createMapView];
}

- (void)createMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _mapView.zoomLevel = 14;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(41.756371, 123.415261);
    //设置mapView的代理
    //    _mapView.delegate = self;
    //将mapView添加到当前视图中
    _tableView.tableHeaderView = _mapView;
}

- (void)startWork {
    Old_PartListViewController *vc = [Old_PartListViewController new];
    vc.taskId = _taskId;
    vc.isStart = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)check {
    Old_PartListViewController *vc = [Old_PartListViewController new];
    vc.taskId = _taskId;
    vc.isStart = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---------- 网络请求 ----------
- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    [self showProgress];
    [NetRequest OLD_POST:reformTask_getTaskMessageDetailsById params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.model = [Part_WorkDetailModel yy_modelWithJSON:baseModel.Data];
            if (![self.model.FlowStatusName isEqualToString:@"已指派-未绑定"] &&
                ![self.model.FlowStatusName isEqualToString:@"已指派-已绑定"] &&
                ![self.model.FlowStatusName isEqualToString:@"已完成"]) {
                UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"开始施工"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(startWork)];
                self.navigationItem.rightBarButtonItem = rightButton;
            } else if ([self.model.FlowStatusName isEqualToString:@"已完成"]) {
                UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"查看"
                                                                                style:UIBarButtonItemStylePlain
                                                                               target:self
                                                                               action:@selector(check)];
                self.navigationItem.rightBarButtonItem = rightButton;
            }
            [self.tableView reloadData];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
}

#pragma mark - ---------- 每个Section的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 320;
    } else if (indexPath.row == 1) {
        return 205;
    } else if (indexPath.row == 2) {
        return 60;
    } else if (indexPath.row == 3) {
        return 15 + 20.5 + 15 + 15 + (_model.users.count - 1)*8 + _model.users.count*14.5 + 15;
    } else {
        return 15 + 20.5 + 15 + 15 + (_model.adminUsers.count - 1)*8 + _model.adminUsers.count*14.5 + 15;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        Old_BaseInfoTableViewCell *cell = [Old_BaseInfoTableViewCell cellWithTableView:tableView];
        cell.model = _model;
        return cell;
    } else if (indexPath.row == 1) {
        Old_ElevatorTableViewCell *cell = [Old_ElevatorTableViewCell cellWithTableView:tableView];
        cell.model = _model;
        return cell;
    } else if (indexPath.row == 2) {
        Old_PartInfoTableViewCell *cell = [Old_PartInfoTableViewCell cellWithTableView:tableView];
        return cell;
    } else {
        Old_PersonTableViewCell *cell = [Old_PersonTableViewCell cellWithTableView:tableView];
        if (indexPath.row == 3) {
            cell.titleLabel.text = @"任务负责人";
        } else {
            cell.titleLabel.text = @"部件管理员";
        }
        cell.model = _model;
        return cell;
    }
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        Old_PartPreviewViewController *vc = [Old_PartPreviewViewController new];
        vc.taskId = _taskId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
