//
//  Task_RiskPartListViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/22.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_RiskPartListViewController.h"
#import "Task_PartModel.h"
#import "Task_RiskPartDetailViewController.h"

#import "Task_SubmitViewController.h"

@interface Task_RiskPartListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Task_PartModel *model;

@end

@implementation Task_RiskPartListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        self.navigationItem.title = @"电梯风险部件";
    if (self.navigationController.viewControllers.count > 4) {
        NSArray *navArr = [NSArray arrayWithObjects:
                           self.navigationController.viewControllers.firstObject,
                           self.navigationController.viewControllers[1],
                           self.navigationController.viewControllers[2],
                           self, nil];
        [self.navigationController setViewControllers:navArr animated:YES];
    }
    if (!_isPreview) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(next)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    [self netRequest];
}

- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    if (_isPreview) {
        dic[@"IsComplete"] = @"true";
    }
    [self showProgress];
    [NetRequest OLD_POST:task_getElevatorRiskPartByTaskId params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.model = [Task_PartModel yy_modelWithJSON:baseModel.Data];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
        [self.tableView reloadData];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
}

- (void)next {
    Task_SubmitViewController *vc = [Task_SubmitViewController new];
    vc.communityDetailedAddress = _communityDetailedAddress;
    vc.model = _model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---------- 每个Section的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    label.text = [NSString stringWithFormat:@"   %ld.%@", section + 1, _model.classArray[section].ClassName];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.textColor = [UIColor darkGrayColor];
    return label;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _model.classArray.count;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.classArray[section].partArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ElevatorAssessmentPartEntityList *model = _model.classArray[indexPath.section].partArray[indexPath.row];
    static NSString *ideitifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
    }
    cell.textLabel.text = model.PartName;
    NSString *saveKey = [NSString stringWithFormat:@"riskpart_text_%@_%@", _taskId, model.PartId];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:saveKey] || _isPreview || [self checkHasValue:model]) {
        cell.detailTextLabel.text = @"已填写";
    } else {
        cell.detailTextLabel.text = @"未填写";
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)checkHasValue:(ElevatorAssessmentPartEntityList *)model {
    for (ElevatorAssessmentItemEntityList *item in model.itemArray) {
        if (![StringFunction isBlankString:item.RiskDescription] ||
            ![StringFunction isBlankString:item.Solution]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ElevatorAssessmentPartEntityList *model = _model.classArray[indexPath.section].partArray[indexPath.row];
    Task_RiskPartDetailViewController *vc = [Task_RiskPartDetailViewController new];
    vc.model = [ElevatorAssessmentPartEntityList yy_modelWithJSON:[model yy_modelToJSONObject]];
    vc.classModel = [ElevatorAssessmentClassEntityList yy_modelWithJSON:[_model.classArray[indexPath.section] yy_modelToJSONObject]];
    vc.taskId = _taskId;
    vc.certificateNum = _model.CertificateNum;
    vc.internalNumAndBuildingNum = _model.InternalNumAndBuildingNum;
    if (_isPreview) {
        vc.isPreview = YES;
    } else {
        vc.isPreview = NO;
        for (ElevatorAssessmentItemEntityList *item in model.itemArray) {
            if (item.CreateUserId && ![item.CreateUserId isEqualToString:[UserService getOldUserInfo].UserId]) {
                vc.isPreview = YES;
                break;
            }
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
