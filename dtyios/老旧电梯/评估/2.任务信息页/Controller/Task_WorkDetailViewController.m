//
//  EnvWorkDetailViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_WorkDetailViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "Task_BaseInfoTableViewCell.h"
#import "Old_ElevatorTableViewCell.h"
#import "Old_PartInfoTableViewCell.h"

#import "Task_WorkDetailModel.h"
#import "Part_EditPreviewViewController.h"

#import "Task_PartListViewController.h"
#import "Task_RiskPartListViewController.h"

@interface Task_WorkDetailViewController ()
//当前界面的mapView
@property (nonatomic, strong) BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Task_WorkDetailModel *model;

@end

@implementation Task_WorkDetailViewController
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
    self.navigationItem.title = @"评估任务信息";
    [self createMapView];
}

- (void)createMapView {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _mapView.zoomLevel = 14;
    //设置mapView的代理
    //    _mapView.delegate = self;
    //将mapView添加到当前视图中
    _tableView.tableHeaderView = _mapView;
}

#pragma mark - ---------- 网络请求 ----------
- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    [self showProgress];
    [NetRequest OLD_POST:task_getTaskMessageDetailsById params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.model = [Task_WorkDetailModel yy_modelWithJSON:baseModel.Data];
            self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.model.Latitude, self.model.Longitude);
            BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.model.Latitude, self.model.Longitude);
            pointAnnotation.title = self.model.CommunityName;
            pointAnnotation.subtitle = self.model.CommunityDetailedAddress;
            [self.mapView addAnnotation:pointAnnotation];
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
        return 365;
    } else if (indexPath.row == 1) {
        return 205;
    } else {
        return 60;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_model.IsCompletePartAssessment) {
        return 4;
    } else {
        return 3;
    }
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        Task_BaseInfoTableViewCell *cell = [Task_BaseInfoTableViewCell cellWithTableView:tableView];
        cell.model = _model;
        return cell;
    } else if (indexPath.row == 1) {
        Old_ElevatorTableViewCell *cell = [Old_ElevatorTableViewCell cellWithTableView:tableView];
        cell.envModel = _model;
        return cell;
    } else {
        Old_PartInfoTableViewCell *cell = [Old_PartInfoTableViewCell cellWithTableView:tableView];
        if (indexPath.row == 2) {
            cell.titleLabel.text = @"电梯评估项目要求";
            cell.leftImageView.image = [UIImage imageNamed:@"老旧电梯-白色小电梯"];
        } else {
            cell.titleLabel.text = @"电梯风险项目对策与措施";
            cell.leftImageView.image = [UIImage imageNamed:@"老旧电梯-风险部件"];
        }
        return cell;
    }
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        Task_PartListViewController *vc = [Task_PartListViewController new];
        vc.taskId = _taskId;
        vc.isPreview = _model.IsCompletePartAssessment;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 3) {
        Task_RiskPartListViewController *vc = [Task_RiskPartListViewController new];
        vc.taskId = _taskId;
        vc.isPreview = _model.IsCompleteRiskComponent;
        vc.communityDetailedAddress = _model.CommunityDetailedAddress;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
