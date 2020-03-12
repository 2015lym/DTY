//
//  Env_EditViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Env_EditViewController.h"
#import "Env_SelectViewController.h"

#import "Env_FormModel.h"

#import "Env_InputTableViewCell.h"
#import "Env_RadioTableViewCell.h"

@interface Env_EditViewController ()<EnvFormDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Env_FormModel *model;
@end

@implementation Env_EditViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self formatData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"环境评估";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self netRequest];
}

- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"MaintenanceId"] = _maintenanceId;
    [self showProgress];
    [NetRequest OLD_POST:task_getEnvironmentAssessmentEntityByTaskId params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.model = [Env_FormModel yy_modelWithJSON:baseModel.Data];
            [self formatData];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
}

- (void)formatData {
    for (int i=0; i<self.model.categoryArray.count; i++) {
        NSArray *subArray = self.model.categoryArray[i].itemArray;
        for (int j=0; j<subArray.count; j++) {
            EnvironmentAssessmentCategoryEntityList *subItem = subArray[j];
            if ([subItem.ControlType isEqualToString:@"checkbox"]) {
                NSMutableString *mString = [NSMutableString string];
                for (EnvironmentAssessmentItmeEntity *formItem in subItem.valueArray) {
                    if (formItem.DataItemValue && formItem.DataItemValue.length > 0) {
                        [mString appendString:formItem.DataItemValue];
                        [mString appendString:@","];
                    }
                }
                if (mString.length > 1) {
                    self.model.categoryArray[i].itemArray[j].value = [mString substringToIndex:mString.length - 1];
                } else {
                    self.model.categoryArray[i].itemArray[j].value = @"";
                }
            } else {
                for (EnvironmentAssessmentItmeEntity *formItem in subItem.valueArray) {
                    if (formItem.DataItemValue && formItem.DataItemValue.length > 0) {
                        self.model.categoryArray[i].itemArray[j].value = formItem.DataItemValue;
                        break;
                    }
                }
            }
        }
    }
    [self.tableView reloadData];
}

- (void)submit {
    NSMutableArray *entityList = [NSMutableArray array];
    for (EnvironmentAssessmentCategoryParentEntityList *category in _model.categoryArray) {
        for (EnvironmentAssessmentCategoryEntityList *item in category.itemArray) {
            if ([item.ControlType isEqualToString:@"text"]) {
                // 空字符串不提交
                if (item.valueArray[0].DataItemValue && item.valueArray[0].DataItemValue.length > 0) {
                    [entityList addObject:[self getSubmitDic:item andSubItem:item.valueArray[0]]];
                }
            } else {
                for (EnvironmentAssessmentItmeEntity *subItem in item.valueArray) {
                    if (subItem.DataItemValue && subItem.DataItemValue.length > 0) {
                       [entityList addObject:[self getSubmitDic:item andSubItem:subItem]];
                    }
                }
            }
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"MaintenanceId"] = _maintenanceId;
    dic[@"SaveEnvironmentAssessmentItmeEntityList"] = entityList;    
    [self showProgress];
    [NetRequest OLD_POST:task_saveEnvironmentAssessment params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            [self showSuccess:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
}

- (NSMutableDictionary *)getSubmitDic:(EnvironmentAssessmentCategoryEntityList *)item
                           andSubItem:(EnvironmentAssessmentItmeEntity *)subItem {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"MaintenanceId"] = _maintenanceId;
    dic[@"CommunityName"] = _model.CommunityName;
    dic[@"CommunityDetailedAddress"] = _model.CommunityDetailedAddress;
    dic[@"AssessmentCategoryId"] = item.Id;
    dic[@"AssessmentCategoryName"] = item.CategoryName;
    dic[@"AssessmentItmeId"] = subItem.Id;
    dic[@"ItemTitle"] = subItem.ItemTitle;
    dic[@"ItemValue"] = subItem.DataItemValue;
    dic[@"ItemUnit"] = subItem.ItemUnit;
    dic[@"SortCode"] = subItem.SortCode;
    return dic;
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
    label.text = [NSString stringWithFormat:@"   %@", _model.categoryArray[section].CategoryName];
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
    return _model.categoryArray.count;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EnvironmentAssessmentCategoryEntityList *model = _model.categoryArray[indexPath.section].itemArray[indexPath.row];
    if ([model.ControlType isEqualToString:@"select"]) {
        return 44;
    } else if ([model.ControlType isEqualToString:@"checkbox"]) {
        return 44;
    } else if ([model.ControlType isEqualToString:@"radio"]) {
        return 15 + 21 + 10 + model.valueArray.count*10 + model.valueArray.count*30 + 15;
    } else {
        return 100;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _model.categoryArray[section].itemArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EnvironmentAssessmentCategoryEntityList *model = _model.categoryArray[indexPath.section].itemArray[indexPath.row];
    if ([model.ControlType isEqualToString:@"select"] || [model.ControlType isEqualToString:@"checkbox"]) {
        static NSString *ideitifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
        }
        cell.textLabel.text = model.CategoryName;
        cell.detailTextLabel.text = model.value;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } else if ([model.ControlType isEqualToString:@"radio"]) {
        Env_RadioTableViewCell *cell = [Env_RadioTableViewCell cellWithTableView:tableView];
        cell.model = model;
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    } else {
        Env_InputTableViewCell *cell = [Env_InputTableViewCell cellWithTableView:tableView];
        cell.model = model;
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
}

- (void)updateText:(NSString *)text andIndexPath:(NSIndexPath *)indexPath {
    _model.categoryArray[indexPath.section].itemArray[indexPath.row].valueArray.firstObject.DataItemValue = text;
}

- (void)updateRadio:(NSInteger)number andIndexPath:(NSIndexPath *)indexPath {
    NSInteger arrayCount = _model.categoryArray[indexPath.section].itemArray[indexPath.row].valueArray.count;
    for (int i=0; i<arrayCount; i++) {
        if (i == number) {
            NSString *value = _model.categoryArray[indexPath.section].itemArray[indexPath.row].valueArray[i].ItemValue;
            _model.categoryArray[indexPath.section].itemArray[indexPath.row].valueArray[i].DataItemValue = value;
        } else {
            _model.categoryArray[indexPath.section].itemArray[indexPath.row].valueArray[i].DataItemValue = nil;
        }
    }
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EnvironmentAssessmentCategoryEntityList *model = _model.categoryArray[indexPath.section].itemArray[indexPath.row];
    if ([model.ControlType isEqualToString:@"select"] || [model.ControlType isEqualToString:@"checkbox"]) {
        Env_SelectViewController *vc = [Env_SelectViewController new];
        vc.model = model;
        vc.isMultiple = [model.ControlType isEqualToString:@"checkbox"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
    }
}

@end

