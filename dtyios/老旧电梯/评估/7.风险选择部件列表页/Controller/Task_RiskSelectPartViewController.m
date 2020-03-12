//
//  Task_RiskSelectPartViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/24.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_RiskSelectPartViewController.h"
#import "Task_RiskPartModel.h"

#import "Task_RiskPartSelectTableViewCell.h"
#import "Task_RiskSelectPartDetailViewController.h"

@interface Task_RiskSelectPartViewController ()<Task_RiskPartSelectTableViewCellDelegate, Task_RiskSelectPartDetailViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Task_RiskPartModel *model;
@property (nonatomic, strong) NSMutableArray<PartsCategoryEntityList *> *dataArray;
@property (nonatomic, copy) NSString *saveKey;

@end

@implementation Task_RiskSelectPartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择部件";
    _saveKey = [NSString stringWithFormat:@"riskpart_%@_%@", _taskId, _itemId];
    if (!_isPreview) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(save)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    [self netRequest];
}

- (void)save {
    if ([self.delegate respondsToSelector:@selector(reloadTableViewAtIndexPath:)]) {
        [self.delegate reloadTableViewAtIndexPath:_indexPath];
    }
    [self showSuccess:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    [self showProgress];
    [NetRequest OLD_POST:task_getPartsByTaskId params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.model = [Task_RiskPartModel yy_modelWithJSON:baseModel.Data];
            self.dataArray = [NSMutableArray array];
            for (PartsCategoryEntityList *class in self.model.categorykArray) {
                [self.dataArray addObject:class];
                for (PartsCategoryEntityList *item in class.categorykArray) {
                    [self.dataArray addObject:item];
                    for (PartsCategoryEntityList *subItem in item.categorykArray) {
                        [self.dataArray addObject:subItem];
                    }
                }
            }
            if ([[NSUserDefaults standardUserDefaults] objectForKey:self.saveKey]) {
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:self.saveKey]];
                if (tempArray.count == self.dataArray.count) {
                    self.dataArray = [NSMutableArray array];
                    for (NSDictionary *dic in tempArray) {
                        [self.dataArray addObject:[PartsCategoryEntityList yy_modelWithDictionary:dic]];
                    }
                } else {
                    [self showInfo:@"选项发生变化，本地缓存已清空!"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.saveKey];
                }
            } else {
                for (NSInteger i=0; i<self.dataArray.count; i++) {
                    PartsCategoryEntityList *entity = self.dataArray[i];
                    for (NSDictionary *dic in self.lastArray) {
                        if ([entity.Id isEqualToString:dic[@"CategoryId"]] && [self.itemId isEqualToString:dic[@"AssessmentItemId"]]) {
                            NSMutableArray *tempArray = [NSMutableArray array];
                            for (NSDictionary *itemDic in dic[@"PartAttributeEntityList"]) {
                                [tempArray addObject:[PartAttributeEntityList yy_modelWithDictionary:itemDic]];
                            }
                            self.dataArray[i].dataArray = tempArray;
                        }
                    }
                }
            }
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
        [self.tableView reloadData];
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
    return 44;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartsCategoryEntityList *model = _dataArray[indexPath.row];
    Task_RiskPartSelectTableViewCell *cell = [Task_RiskPartSelectTableViewCell cellWithTableView:tableView];
    if (_isPreview || [self checkHasValue:model]) {
        model.hasValue = YES;
    } else {
        model.hasValue = NO;
    }
    cell.isPreview = _isPreview;
    cell.model = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (BOOL)checkHasValue:(PartsCategoryEntityList *)model {
    for (PartAttributeEntityList *item in model.dataArray) {
        if (![StringFunction isBlankString:item.PartAttributeValue]) {
            return YES;
        }
    }
    return NO;
}

- (void)selectAction:(kRiskPartSelectType)type andIndexPath:(NSIndexPath *)indexPath {
    PartsCategoryEntityList *model = _dataArray[indexPath.row];
    if (type == kSelect || type == kChanage) {
        Task_RiskSelectPartDetailViewController *vc = [Task_RiskSelectPartDetailViewController new];
        vc.isPreview = _isPreview;
        vc.itemArray = [PartsCategoryEntityList yy_modelWithJSON:[model yy_modelToJSONObject]].itemArray;
        vc.dataArray = [PartsCategoryEntityList yy_modelWithJSON:[model yy_modelToJSONObject]].dataArray;
        vc.indexPath = indexPath;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self showAlertController:@"是否要删除该项目？" callBack:^{
            for (NSInteger i=0; i<model.dataArray.count; i++) {
                self.dataArray[indexPath.row].dataArray[i].PartAttributeValue = @"";
            }
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            NSInteger num = 0;
            for (PartsCategoryEntityList *model in self.dataArray) {
                if (model.hasValue) {
                    num = num + 1;
                    break;
                }
            }
            if (num == 0) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.saveKey];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:[self.dataArray yy_modelToJSONObject] forKey:self.saveKey];
            }
            if ([self.delegate respondsToSelector:@selector(reloadTableViewAtIndexPath:)]) {
                [self.delegate reloadTableViewAtIndexPath:self.indexPath];
            }
        }];
    }
}

- (void)saveData:(NSMutableArray<PartAttributeEntityList *> *)dataArray andIndexPath:(NSIndexPath *)indexPath {
    _dataArray[indexPath.row].dataArray = dataArray;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[NSUserDefaults standardUserDefaults] setObject:[_dataArray yy_modelToJSONObject] forKey:_saveKey];
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
