//
//  Task_PartListViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/15.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_PartListViewController.h"
#import "Task_PartModel.h"
#import "Task_PartDetailViewController.h"
#import "Task_RiskPartListViewController.h"

@interface Task_PartListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Task_PartModel *model;
@property (nonatomic, strong) NSMutableArray *remarkArray;

@end

@implementation Task_PartListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"电梯评估部件";
    if (!_isPreview) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(submit)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    [self netRequest];
}

- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    [self showProgress];
    [NetRequest OLD_POST:task_getAssessmentItemByTaskId params:dic callback:^(OldElevatorBaseModel *baseModel) {
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

- (void)submit {
    NSString *remarkKey = [NSString stringWithFormat:@"part_remark_%@", _taskId];
    _remarkArray = [[NSUserDefaults standardUserDefaults] objectForKey:remarkKey];
    if (!_remarkArray) {
        _remarkArray = [NSMutableArray array];
    }
    for (NSInteger i=0; i<_remarkArray.count; i++) {
        NSDictionary *item = _remarkArray[i];
        if (![item[@"DataType"] isEqualToString:@"text"] && ![item[@"DataValue"] containsString:@"Upload"]) {
            [self uploadFile:item index:i];
            return;
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    dic[@"SaveElevatorAssessmentItemEntityList"] = [self getSubmitArray];
    dic[@"SaveElevatorAssessmentPartEntityList"] = _remarkArray;
    [self showProgress];
    [NetRequest OLD_POST:task_checkPartAssessmentItem params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSString *IsTaskComplete = [NSString stringWithFormat:@"%@", baseModel.Data];
            if ([IsTaskComplete isEqualToString:@"1"]) {
                params[@"IsTaskComplete"] = [NSNumber numberWithBool:YES];
            } else {
                params[@"IsTaskComplete"] = [NSNumber numberWithBool:NO];
            }
            if ([IsTaskComplete isEqualToString:@"0"]) {
                [self realSubmit:params andComplete:IsTaskComplete];
            } else if ([IsTaskComplete isEqualToString:@"1"]) {
                [self showAlertController:@"提交之后不可再次修改，确认提交吗？" callBack:^{
                    [self realSubmit:params andComplete:IsTaskComplete];
                }];
            } else if ([IsTaskComplete isEqualToString:@"2"]) {
                [self showInfo:@"未填写任何内容，请填写后再提交"];
            }
            
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
}

- (void)realSubmit:(NSMutableDictionary *)params andComplete:(NSString *)IsTaskComplete {
    [self showProgress];
    [NetRequest OLD_POST:task_savePartAssessment params:params callback:^(OldElevatorBaseModel *baseModel2) {
        if (baseModel2.Success) {
            if ([IsTaskComplete isEqualToString:@"0"]) {
                [self showAlertControllerNoCancel:@"提交成功，请等待其他信息提交！" callBack:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                Task_RiskPartListViewController *vc = [Task_RiskPartListViewController new];
                vc.taskId = self.taskId;
                vc.isPreview = NO;
                [self.navigationController pushViewController:vc animated:YES];
            }
            [self removeLocalCache];
        } else {
            [self showInfo:baseModel2.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error2) {
        [self hideProgress];
    }];
}

#pragma mark - ---------- 上传文件 ----------
- (void)uploadFile:(NSDictionary *)dic index:(NSInteger)index {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"filePath"] = @"UploadFile";
    NSData *data;
    NSString *path;
    NSString *mimeType;
    params[@"fileName"] = dic[@"DataValue"];
    if ([dic[@"DataType"] isEqualToString:@"img"]) {
        path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath], dic[@"DataValue"]];
        mimeType = @"image/png";
        data = [NSData dataWithContentsOfFile:path];
    } else if ([dic[@"DataType"] isEqualToString:@"audio"]) {
        path = [NSString stringWithFormat:@"%@/%@", [FileFunction getSandBoxPath],  dic[@"DataValue"]];
        data = [NSData dataWithContentsOfFile:path];
        mimeType = @"audio/aac";
    } else if ([dic[@"DataType"] isEqualToString:@"video"]) {
        if ([dic[@"DataValue"] containsString:@"video-"]) {
            path = dic[@"DataValue"];
        } else {
            path = [NSString stringWithFormat:@"%@/video/%@", [FileFunction getSandBoxPath], dic[@"DataValue"]];
        }
        data = [NSData dataWithContentsOfFile:path];
        mimeType = @"video/mp4";
    } else {
        [self submit];
    }
    
    [self showProgress];

    [NetRequest OLD_uploadFile:account_uploadFile params:params fileData:data mimeType:mimeType callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            NSString *newUrl = [NSString stringWithFormat:@"%@", baseModel.Data];

            NSString *remarkKey = [NSString stringWithFormat:@"part_remark_%@", self.taskId];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSInteger i=0; i<self.remarkArray.count; i++) {
                NSMutableDictionary *item = [NSMutableDictionary dictionaryWithDictionary:self.remarkArray[i]];
                if ([item[@"DataValue"] isEqualToString:dic[@"DataValue"]]) {
                    item[@"DataValue"] = newUrl;
                }
                [tempArray addObject:item];
            }
            [[NSUserDefaults standardUserDefaults] setObject:tempArray forKey:remarkKey];
            
            BOOL isDel = [FileFunction deleteFileAtPath:path];
            NSLog(@"本地文件删除：%d", isDel);
            [self submit];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"上传文件失败"];
    }];
}

#pragma mark - ---------- 获取提交数组 ----------
- (NSMutableArray *)getSubmitArray {
    NSMutableArray *submitArray = [NSMutableArray array];
    
    for (ElevatorAssessmentClassEntityList *classItem in _model.classArray) {
        for (ElevatorAssessmentPartEntityList *element in classItem.partArray) {
            NSString *key = [NSString stringWithFormat:@"part_%@_%@", _taskId, element.PartId];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
                NSArray *itemArray = [[NSUserDefaults standardUserDefaults] objectForKey:key];
                for (NSDictionary *dic in itemArray) {
                    ElevatorAssessmentItemEntityList *item = [ElevatorAssessmentItemEntityList yy_modelWithDictionary:dic];
                    if (!item.isTitle) {
                        NSMutableDictionary *entity = [NSMutableDictionary dictionary];
                        entity[@"TaskId"] = _taskId;
                        entity[@"CertificateNum"] = _model.CertificateNum;
                        entity[@"InternalNumAndBuildingNum"] = _model.InternalNumAndBuildingNum;
                        entity[@"AssessmentClassId"] = classItem.ClassId;
                        entity[@"AssessmentClassName"] = classItem.ClassName;
                        entity[@"AssessmentPartId"] = element.PartId;
                        entity[@"AssessmentPartName"] = element.PartName;
                        entity[@"AssessmentItemId"] = item.ItemId;
                        entity[@"AssessmentItemName"] = item.ItemName;
                        if (item.IsReform) {
                            if ([StringFunction isBlankString:item.SeverityLevel] || [StringFunction isBlankString:item.ProbabilityLevel]) {
                                continue;
                            }
                            entity[@"SeverityLevel"] = item.SeverityLevel;
                            entity[@"ProbabilityLevel"] = item.ProbabilityLevel;
                        } else {
                            if ([StringFunction isBlankString:item.IdentificationStatus]) {
                                continue;
                            }
                            entity[@"IdentificationStatus"] = item.IdentificationStatus;
                        }
                        entity[@"Solution"] = item.Solution;
                        entity[@"RiskDescription"] = item.RiskDescription;
                        entity[@"IsReform"] = [NSString stringWithFormat:@"%d", item.IsReform];
                        entity[@"Requirement"] = item.Requirement;
                        [submitArray addObject:entity];
                    }
                }
            }
        }
    }
    return submitArray;
}

#pragma mark - ---------- 清空本地数组 ----------
- (void)removeLocalCache {
    for (ElevatorAssessmentClassEntityList *classItem in _model.classArray) {
        for (ElevatorAssessmentPartEntityList *element in classItem.partArray) {
            NSString *key = [NSString stringWithFormat:@"part_%@_%@", _taskId, element.PartId];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:key]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
        }
    }
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
    NSString *saveKey = [NSString stringWithFormat:@"part_%@_%@", _taskId, model.PartId];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:saveKey] || [self checkHasValue:model]) {
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
        if (![StringFunction isBlankString:item.SeverityLevel] ||
            ![StringFunction isBlankString:item.ProbabilityLevel] ||
            ![StringFunction isBlankString:item.IdentificationStatus]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ElevatorAssessmentPartEntityList *model = _model.classArray[indexPath.section].partArray[indexPath.row];
    Task_PartDetailViewController *vc = [Task_PartDetailViewController new];
    vc.isPreview = _isPreview;
    vc.model = [ElevatorAssessmentPartEntityList yy_modelWithJSON:[model yy_modelToJSONObject]];
    vc.classModel = [ElevatorAssessmentClassEntityList yy_modelWithJSON:[_model.classArray[indexPath.section] yy_modelToJSONObject]];
    vc.taskId = _taskId;
    vc.certificateNum = _model.CertificateNum;
    vc.InternalNumAndBuildingNum = _model.InternalNumAndBuildingNum;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
