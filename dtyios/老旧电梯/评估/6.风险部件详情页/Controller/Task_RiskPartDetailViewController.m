//
//  Task_RiskPartDetailViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/23.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_RiskPartDetailViewController.h"
#import "Task_RiskPartDetailTableViewCell.h"
#import "Task_RiskPartDetailTableViewCell2.h"
#import "Task_TextViewController.h"
#import "Task_RiskSelectPartViewController.h"
#import "Task_RiskSelectPartPreviewViewController.h"

@interface Task_RiskPartDetailViewController ()<RiskTaskPartDetailDelegate, Task_TextViewControllerDelegate, Task_RiskSelectPartViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<ElevatorAssessmentItemEntityList *> *dataArray;
@property (nonatomic, copy) NSString *saveKey;

@property (nonatomic, strong) NSMutableArray *nextPartArray;

@end

@implementation Task_RiskPartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评估意见及建议";
    _saveKey = [NSString stringWithFormat:@"riskpart_text_%@_%@", _taskId, _model.PartId];
    if (!_isPreview) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(checkSave)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }

    [self netRequest];
}

- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    [self showProgress];
    [NetRequest OLD_POST:task_getElevatorPartRecordByTaskId params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.nextPartArray = [NSMutableArray arrayWithArray:[StringFunction stringToJson:baseModel.Data]];
            [self configData];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
        [self.tableView reloadData];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
}


- (void)checkSave {
    for (ElevatorAssessmentItemEntityList *item in _dataArray) {
        if (!item.isTitle) {
            if (![StringFunction isBlankString:item.RiskDescription] && ![StringFunction isBlankString:item.Solution]) {
                [self save];
                return;
            } else if (([StringFunction isBlankString:item.RiskDescription] && ![StringFunction isBlankString:item.Solution]) ||
                       (![StringFunction isBlankString:item.RiskDescription] && [StringFunction isBlankString:item.Solution])) {
                [self showAlertControllerNoCancel:@"有风险描述或对策措施未填写完全，请填写！" callBack:nil];
                return;
            }
        }
    }
    [self showAlertControllerNoCancel:@"未填写任何信息，请填写！" callBack:nil];
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setObject:[_dataArray yy_modelToJSONObject] forKey:_saveKey];
    [self showSuccess:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ---------- 配置数据 ----------
- (void)configData {
    _dataArray = [NSMutableArray array];
    for (ElevatorAssessmentItemEntityList *item in _model.itemArray) {
        NSInteger num = 0;
        for (ElevatorAssessmentItemEntityList *dataItem in _dataArray) {
            if ([item.ItemName isEqualToString:dataItem.ItemName]) {
                num++;
                break;
            }
        }
        if (num == 0) {
            ElevatorAssessmentItemEntityList *tempItem = [ElevatorAssessmentItemEntityList new];
            tempItem.ItemName = item.ItemName;
            tempItem.isTitle = YES;
            [_dataArray addObject:tempItem];
        }
        [_dataArray addObject:item];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_saveKey]) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:_saveKey]];
        if (tempArray.count == _dataArray.count) {
            _dataArray = [NSMutableArray array];
            for (NSDictionary *dic in tempArray) {
                [_dataArray addObject:[ElevatorAssessmentItemEntityList yy_modelWithDictionary:dic]];
            }
        } else {
            [self showInfo:@"选项发生变化，本地缓存已清空!"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:_saveKey];
        }
    }
    [self.tableView reloadData];
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
    ElevatorAssessmentItemEntityList *model = _dataArray[indexPath.row];
    if (model.isTitle) {
        return 44;
    } else {
        return [self getCellHeight:model];
    }
}

- (CGFloat)getCellHeight:(ElevatorAssessmentItemEntityList *)model {
    CGFloat height = 15;
    CGRect titleRect = [model.Requirement boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    height += titleRect.size.height;
    if (_isPreview && ![self checkHasPart:model]) {
        height += 8 + 16 + 8 + 16 + 15 + 18 + 25 + 18 + 25;
    } else {
        height += 8 + 16 + 8 + 16 + 15 + 18 + 25 + 18 + 25 + 18 + 25;
    }
    height += 15;
    return height;
}

- (BOOL)checkHasPart:(ElevatorAssessmentItemEntityList *)model {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"riskpart_%@_%@", _taskId, model.ItemId]]) {
        return YES;
    } else {
        for (NSDictionary *dic in _nextPartArray) {
            if ([dic[@"AssessmentItemId"] isEqualToString:model.ItemId]) {
                return YES;
            }
        }
        return NO;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ElevatorAssessmentItemEntityList *model = _dataArray[indexPath.row];
    if (model.isTitle) {
        static NSString *ideitifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = model.ItemName;
        cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        return cell;
    } else {
        if (_isPreview && ![self checkHasPart:model]) {
            Task_RiskPartDetailTableViewCell2 *cell = [Task_RiskPartDetailTableViewCell2 cellWithTableView:tableView];
            cell.taskId = _taskId;
            cell.nextPartArray = _nextPartArray;
            cell.model = model;
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
        } else {
            Task_RiskPartDetailTableViewCell *cell = [Task_RiskPartDetailTableViewCell cellWithTableView:tableView];
            cell.taskId = _taskId;
            cell.nextPartArray = _nextPartArray;
            cell.model = model;
            cell.indexPath = indexPath;
            cell.delegate = self;
            return cell;
        }
    }
}

- (void)selectAction:(kRiskTaskType)type andIndexPath:(NSIndexPath *)indexPath {
    ElevatorAssessmentItemEntityList *model = _dataArray[indexPath.row];
    if (type == PartInfo) {
        if (_isPreview) {
            Task_RiskSelectPartPreviewViewController *vc = [Task_RiskSelectPartPreviewViewController new];
            vc.lastArray = _nextPartArray;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            Task_RiskSelectPartViewController *vc = [Task_RiskSelectPartViewController new];
            vc.isPreview = _isPreview;
            vc.taskId = _taskId;
            vc.itemId = model.ItemId;
            vc.indexPath = indexPath;
            vc.lastArray = _nextPartArray;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        Task_TextViewController *vc = [Task_TextViewController new];
        vc.indexPath = indexPath;
        vc.delegate = self;
        vc.isPreview = _isPreview;
        vc.navigationItem.title = type == RiskDescription ? @"问题描述及风险" : @"对策与措施";
        vc.previewString = type == RiskDescription ? model.RiskDescription : model.Solution;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)saveText:(NSString *)text andTitle:(NSString *)title andIndexPath:(NSIndexPath *)indexPath {
    if ([title isEqualToString:@"问题描述及风险"]) {
        _dataArray[indexPath.row].RiskDescription = text;
    } else {
        _dataArray[indexPath.row].Solution = text;
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadTableViewAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
