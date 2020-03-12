//
//  Examine_WorkDetailViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/25.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Examine_WorkDetailViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "Old_BaseInfoTableViewCell.h"
#import "Old_ElevatorTableViewCell.h"
#import "Examine_PersonTableViewCell.h"

#import "Part_WorkDetailModel.h"

#import "Examine_ProjectListViewController.h"

@interface Examine_WorkDetailViewController ()
//当前界面的mapView
@property (nonatomic, strong) BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *rightButton;

@property (nonatomic, strong) Part_WorkDetailModel *model;

@end

@implementation Examine_WorkDetailViewController

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

- (void)startExamine {
    if ([self.model.FlowStatusActionsId isEqualToString:@"de82b5b8-4cb0-4f16-91a5-d36f89ac695f"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"TaskId"] = _taskId;
        [NetRequest OLD_POST:examineTask_updateTaskStatus params:dic callback:^(OldElevatorBaseModel *baseModel) {
        } errorCallback:^(NSError *error) {
        }];
    }
    Examine_ProjectListViewController *vc = [Examine_ProjectListViewController new];
    vc.work = self.model;
    vc.taskId = _taskId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)preview {
    Examine_ProjectListViewController *vc = [Examine_ProjectListViewController new];
    vc.work = self.model;
    vc.taskId = _taskId;
    vc.isPreview = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---------- 网络请求 ----------
- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    [self showProgress];
    [NetRequest OLD_POST:examineTask_getTaskDetailById params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.model = [Part_WorkDetailModel yy_modelWithJSON:baseModel.Data];
            if ([self.model.FlowStatusActionsId isEqualToString:@"307ec07f-1fae-4125-88af-11151a0b624e"]) {
                self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"查看"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(preview)];
                self.navigationItem.rightBarButtonItem = self.rightButton;
            } else {
                self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"开始检验"
                                                                style:UIBarButtonItemStylePlain
                                                               target:self
                                                               action:@selector(startExamine)];
                self.navigationItem.rightBarButtonItem = self.rightButton;
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
    } else {
        return 15 + 20.5 + 15 + 15 + (_model.users.count - 1)*8 + _model.users.count*50 + 15;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_model.users && _model.users.count > 0) {
        return 3;
    } else {
        return 2;
    }
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
    } else {
        Examine_PersonTableViewCell *cell = [Examine_PersonTableViewCell cellWithTableView:tableView];
        cell.titleLabel.text = @"任务负责人";
        cell.model = _model;
        return cell;
    }
}
@end
