//
//  Task_PartDetailViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/17.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_PartDetailViewController.h"
#import "Task_PartDetailTableViewCell.h"
#import "Task_PartDetailLevelTableViewCell.h"
#import "Task_RemarkTableViewCell.h"

@interface Task_PartDetailViewController ()<TaskPartDetailDelegate, RemarkDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<ElevatorAssessmentItemEntityList *> *dataArray;
@property (nonatomic, copy) NSString *saveKey;

@property (nonatomic, strong) Task_RemarkTableViewCell *remarkCell;
@property (nonatomic, strong) NSMutableArray *remarkArray;
@property (nonatomic, copy) NSString *remarkString;
@property (nonatomic, copy) NSString *remarkKey;

@end

@implementation Task_PartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"电梯评估项目";
    _saveKey = [NSString stringWithFormat:@"part_%@_%@", _taskId, _model.PartId];
    _remarkKey = [NSString stringWithFormat:@"part_remark_%@", _taskId];
    
    if (!_isPreview) {
        for (ElevatorAssessmentItemEntityList *entity in _model.itemArray) {
            if (entity.CreateUserId && ![entity.CreateUserId isEqualToString:[UserService getOldUserInfo].UserId]) {
                _isPreview = YES;
                break;
            }
        }
    }
    
    // 预览清缓存、非预览显示保存
    if (_isPreview) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:_saveKey];
    } else {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(checkSave)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    [self configData];
    [self configRemarkData];
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
}

- (void)configRemarkData {
    _remarkArray = [NSMutableArray arrayWithArray:[_model.remarkArray yy_modelToJSONObject]];
    if (_isPreview) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:_remarkKey];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_remarkKey]) {
        _remarkArray = [NSMutableArray array];
        NSArray *localRemarkArray = [[NSUserDefaults standardUserDefaults] objectForKey:_remarkKey];
        for (NSDictionary *dic in localRemarkArray) {
            if ([dic[@"AssessmentPartId"] isEqualToString:_model.PartId]) {
                if ([dic[@"DataType"] isEqualToString:@"text"]) {
                    _remarkString = dic[@"DataValue"];
                } else {
                    [_remarkArray addObject:dic];
                }
            }
        }
    }
}

- (void)checkSave {
    for (ElevatorAssessmentItemEntityList *item in _dataArray) {
        if (!item.isTitle) {
            if (item.IsReform) {
                if (![StringFunction isBlankString:item.SeverityLevel] && ![StringFunction isBlankString:item.ProbabilityLevel]) {
                    [self save];
                    return;
                } else if (([StringFunction isBlankString:item.SeverityLevel] && ![StringFunction isBlankString:item.ProbabilityLevel]) ||
                           (![StringFunction isBlankString:item.SeverityLevel] && [StringFunction isBlankString:item.ProbabilityLevel])) {
                    [self showAlertControllerNoCancel:@"严重程度或失效概率等级未填写完全，请填写！" callBack:nil];
                    return;
                }
            } else {
                if (![StringFunction isBlankString:item.IdentificationStatus]) {
                    [self save];
                    return;
                }
            }
        }
    }
    [self showAlertControllerNoCancel:@"未填写任何信息，请填写！" callBack:nil];
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setObject:[_dataArray yy_modelToJSONObject] forKey:_saveKey];
    
    // 备注
    NSArray *localRemarkArray = [[NSUserDefaults standardUserDefaults] objectForKey:_remarkKey];
    NSMutableArray *saveRemarkArray = [NSMutableArray array];
    
    // 把不是本组件的备注添加进来
    for (NSDictionary *dic in localRemarkArray) {
        if (![dic[@"AssessmentPartId"] isEqualToString:_model.PartId]) {
            [saveRemarkArray addObject:dic];
        }
    }
    
    for (NSDictionary *dic in _remarkArray) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        mdic[@"TaskId"] = _taskId;
        mdic[@"CertificateNum"] = _certificateNum;
        mdic[@"InternalNumAndBuildingNum"] = _InternalNumAndBuildingNum;
        mdic[@"AssessmentClassId"] = _classModel.ClassId;
        mdic[@"AssessmentClassName"] = _classModel.ClassName;
        mdic[@"AssessmentPartId"] = _model.PartId;
        mdic[@"AssessmentPartName"] = _model.PartName;
        mdic[@"DataType"] = dic[@"DataType"];
        mdic[@"DataValue"] = dic[@"DataValue"];
        [saveRemarkArray addObject:mdic];
    }
    if (_remarkString && _remarkString.length > 0) {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        mdic[@"TaskId"] = _taskId;
        mdic[@"CertificateNum"] = _certificateNum;
        mdic[@"InternalNumAndBuildingNum"] = _InternalNumAndBuildingNum;
        mdic[@"AssessmentClassId"] = _classModel.ClassId;
        mdic[@"AssessmentClassName"] = _classModel.ClassName;
        mdic[@"AssessmentPartId"] = _model.PartId;
        mdic[@"AssessmentPartName"] = _model.PartName;
        mdic[@"DataType"] = @"text";
        mdic[@"DataValue"] = _remarkString;
        [saveRemarkArray addObject:mdic];
    }
    if (saveRemarkArray.count > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:saveRemarkArray forKey:_remarkKey];
    }
    [self showSuccess:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
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
    // row 从 0 开始，count 从 1 开始
    if (indexPath.row == _dataArray.count) {
        return 400;
    } else {
        ElevatorAssessmentItemEntityList *model = _dataArray[indexPath.row];
        if (model.isTitle) {
            return 44;
        } else {
            return [self getCellHeight:model];
        }
    }
}

- (CGFloat)getCellHeight:(ElevatorAssessmentItemEntityList *)model {
    CGFloat height = 15;
    CGRect titleRect = [model.Requirement boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    height += titleRect.size.height;
    if (model.IsReform) {
        height += 15 + 18 + 25 + 18 + 15;
    } else {
        height += 15 + 18 + 15;
    }
    height += 15;
    return height;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count + 1;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _dataArray.count) {
        _remarkCell = [Task_RemarkTableViewCell cellWithTableView:tableView];
        _remarkCell.isPreview = _isPreview;
        _remarkCell.model = _model;
        if (!_isPreview) {
            _remarkCell.delegate = self;
            _remarkCell.dataArray = _remarkArray;
            _remarkCell.textView.text = _remarkString;
            _remarkCell.toolBar.hidden = NO;
            _remarkCell.textView.editable = YES;
            [_remarkCell changeUI];
        }
        return _remarkCell;
    } else {
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
            if (model.IsReform) {
                Task_PartDetailLevelTableViewCell *cell = [Task_PartDetailLevelTableViewCell cellWithTableView:tableView];
                cell.isPreview = _isPreview;
                cell.model = model;
                cell.indexPath = indexPath;
                cell.delegate = self;
                return cell;
            } else {
                Task_PartDetailTableViewCell *cell = [Task_PartDetailTableViewCell cellWithTableView:tableView];
                cell.isPreview = _isPreview;
                cell.model = model;
                cell.indexPath = indexPath;
                cell.delegate = self;
                return cell;
            }
        }
    }
}

- (void)selectAction:(kTaskType)type andIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *actionArray;
    if (type == IdentificationStatus) {
        actionArray = [NSMutableArray arrayWithObjects:@"符合", @"不符合", nil];
    } else if (type == ProbabilityLevel) {
        actionArray = [NSMutableArray arrayWithObjects:@"频繁", @"很可能", @"偶尔", @"极少", @"不大可能", @"不可能", nil];
    } else {
        actionArray = [NSMutableArray arrayWithObjects:@"高", @"中", @"低", @"可忽略", nil];
    }
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i=0; i<actionArray.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:actionArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *value = [NSString stringWithFormat:@"%ld", i + 1];
            if (type == IdentificationStatus) {
                self.dataArray[indexPath.row].IdentificationStatus = value;
            } else if (type == ProbabilityLevel) {
                self.dataArray[indexPath.row].ProbabilityLevel = value;
            } else {
                self.dataArray[indexPath.row].SeverityLevel = value;
            }
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [actionSheet addAction:action];
    }
    UIAlertAction *cancelSheet = [UIAlertAction actionWithTitle:@"清空" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSString *value = @"";
        if (type == IdentificationStatus) {
            self.dataArray[indexPath.row].IdentificationStatus = value;
        } else if (type == ProbabilityLevel) {
            self.dataArray[indexPath.row].ProbabilityLevel = value;
        } else {
            self.dataArray[indexPath.row].SeverityLevel = value;
        }
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    [actionSheet addAction:cancelSheet];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)changeData:(NSMutableArray *)array type:(NSString *)type text:(NSString *)text {
    if ([type isEqualToString:@"remark"]) {
        _remarkArray = array;
    } else {
        _remarkString = text;
    }
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
