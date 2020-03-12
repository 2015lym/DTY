//
//  Examine_ProjectListViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/26.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Examine_ProjectListViewController.h"
#import "ExamineProjectListModel.h"
#import "Examine_ProjectListTableViewCell.h"
#import "Examine_ContentViewController.h"
#import "Examine_SubmitViewController.h"
#import "Examine_RecordModel.h"
#import "ExamineUtils.h"

@interface Examine_ProjectListViewController ()<Examine_ProjectListTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *netArray;


@property (nonatomic, strong) NSMutableArray *nextArray;

@end

@implementation Examine_ProjectListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self netRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"检验项目";
    if (!_isPreview) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(next)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

- (void)next {
    Examine_SubmitViewController *vc = [Examine_SubmitViewController new];
    vc.taskId = _taskId;
    vc.work = _work;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---------- 网络请求 ----------
- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    [self showProgress];
    [NetRequest OLD_POST:examineTask_getExamineProject params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.dataArray = [NSMutableArray array];
            self.nextArray = [NSMutableArray array];
            self.netArray = [NSMutableArray array];
            for (NSDictionary *recordDic in [StringFunction stringToJson:baseModel.Data][@"ExamineRecordList"]) {
                Examine_RecordModel *record = [Examine_RecordModel yy_modelWithDictionary:recordDic];
                [self.netArray addObject:record];
            }
            
            for (NSDictionary *dic in [StringFunction stringToJson:baseModel.Data][@"ExamineCategoryList"]) {
                ExamineProjectListModel *model = [ExamineProjectListModel yy_modelWithDictionary:dic];
                if (model.CategoryLevel == 1 || model.CategoryLevel == 2) {
                    if ([ExamineUtils getExaminesArray:self.taskId categoryId:model.Id].count > 0) {
                        model.hasValue = YES;
                    } else {
                        model.hasValue = NO;
                        NSMutableArray *localSaveArray = [NSMutableArray array];
                        for (Examine_RecordModel *record in self.netArray) {
                            if ([model.CategoryNameTwo isEqualToString:record.CategoryNameTwo]) {
                                model.hasValue = YES;
                                if (record.CreateUserId && ![record.CreateUserId isEqualToString:[UserService getOldUserInfo].UserId]) {
                                    model.isPreview = YES;
                                }
                                
                                [localSaveArray addObject:record];
                            }
                        }
                        [ExamineUtils saveExamines:self.taskId categoryId:model.Id data:localSaveArray];
                    }
                    [self.dataArray addObject:model];
                } else {
                    [self.nextArray addObject:model];
                }
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
    return 1;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamineProjectListModel *model = _dataArray[indexPath.row];
    if (model.CategoryLevel == 1) {
        static NSString *ideitifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
        }
        cell.textLabel.text = model.CategoryNameOne;
        return cell;
    } else {
        Examine_ProjectListTableViewCell *cell = [Examine_ProjectListTableViewCell cellWithTableView:tableView];
        cell.model = model;
        cell.indexPath = indexPath;
        cell.delegate = self;
        if (_isPreview) {
            cell.isPreview = YES;
        }
        return cell;
    }
}

- (void)clearActionIndex:(NSIndexPath *)indexPath {
    [self showAlertController:@"确定清空填写的内容吗？" callBack:^{
        ExamineProjectListModel *model = self.dataArray[indexPath.row];
        [ExamineUtils saveExamines:self.taskId categoryId:model.Id data:[NSMutableArray array]];
        model.hasValue = NO;
        self.dataArray[indexPath.row] = model;
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];

}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ExamineProjectListModel *nextModel = _dataArray[indexPath.row];
    if (nextModel.CategoryLevel == 2) {
        Examine_ContentViewController *vc = [Examine_ContentViewController new];
        vc.taskId = _taskId;
        vc.model = nextModel;
        
        NSMutableArray *itemArray = [NSMutableArray array];
        for (ExamineProjectListModel *model in _nextArray) {
            if ([model.CategoryNameTwo isEqualToString:nextModel.CategoryNameTwo]) {
                [itemArray addObject:model];
            }
        }
        vc.allArray = itemArray;
        vc.isPreview = _isPreview;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
