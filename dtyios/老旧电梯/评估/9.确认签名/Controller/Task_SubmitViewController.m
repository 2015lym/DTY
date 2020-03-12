//
//  Task_SubmitViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_SubmitViewController.h"
#import "SignViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Task_RiskPartModel.h"

@interface Task_SubmitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *riskLevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *riskNumLabel1;
@property (weak, nonatomic) IBOutlet UILabel *riskNumLabel2;
@property (weak, nonatomic) IBOutlet UILabel *riskNumLabel3;

@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@property (nonatomic, copy) NSString *imageUrl;

@end

@implementation Task_SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"签名";
    _signImageView.hidden = YES;
    _numberLabel.text = [NSString stringWithFormat:@"注册代码：%@", _model.CertificateNum];
    _addressLabel.text = [NSString stringWithFormat:@"安装地址：%@", _communityDetailedAddress];
    _codeLabel.text = [NSString stringWithFormat:@"内部编号及楼牌号：%@", _model.InternalNumAndBuildingNum];

    _riskNumLabel1.text = [NSString stringWithFormat:@"Ⅰ级风险项目：%ld", _model.PrimaryRiskProjectNum];
    _riskNumLabel2.text = [NSString stringWithFormat:@"II级风险项目：%ld", _model.SecondaryRiskProjectsNum];
    _riskNumLabel3.text = [NSString stringWithFormat:@"ⅠII级风险项目：%ld", _model.TertiaryRiskProjectNum];
    
    if (_model.PrimaryRiskProjectNum > 3) {
        _riskLevelLabel.text = @"电梯风险等级：I";
    } else {
        if (_model.SecondaryRiskProjectsNum < 5 && _model.PrimaryRiskProjectNum == 0) {
            _riskLevelLabel.text = @"电梯风险等级：III";
        } else {
            _riskLevelLabel.text = @"电梯风险等级：II";
        }
    }
    
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (IBAction)sign:(id)sender {
    if ([UserService getOldUserInfo].UserSign.length > 0) {
        _signImageView.hidden = NO;
        _imageUrl = [NSString stringWithFormat:@"%@/%@", old_base, [UserService getOldUserInfo].UserSign];
        NSURL *pathUrl = [NSURL URLWithString:_imageUrl];
        [_signImageView sd_setImageWithURL:pathUrl];
    } else {
        [self showAlertController:@"您还未设置签名，是否去设置？" callBack:^{
            SignViewController *vc = [SignViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
}

- (void)submit {
    if (!_imageUrl) {
        [self showInfo:@"请签名"];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"TaskId"] = _model.TaskId;
        dic[@"ElevatorRiskLevel"] = [_riskLevelLabel.text componentsSeparatedByString:@"："][1];
        dic[@"UserSign"] = [UserService getOldUserInfo].UserSign;
        dic[@"SaveElevatorAssessmentItemEntityList"] = [self getEntityArray];
        dic[@"SavePartsCategoryEntityList"] = [self getPartsArray];
        [self showProgress];
        [NetRequest OLD_POST:task_saveParts params:dic callback:^(OldElevatorBaseModel *baseModel) {
            if (baseModel.Success) {
                [self showSuccess:@"提交成功"];
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            } else {
                [self showInfo:baseModel.Message];
            }
            [self hideProgress];
        } errorCallback:^(NSError *error) {
            [self hideProgress];
        }];
    }
}

- (NSMutableArray *)getEntityArray {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (ElevatorAssessmentClassEntityList *class in _model.classArray) {
        for (ElevatorAssessmentPartEntityList *part in class.partArray) {
            NSString *saveKey = [NSString stringWithFormat:@"riskpart_text_%@_%@", _model.TaskId, part.PartId];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:saveKey]) {
                NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:saveKey]];
                for (NSDictionary *dic in tempArray) {
                    ElevatorAssessmentItemEntityList *item = [ElevatorAssessmentItemEntityList yy_modelWithDictionary:dic];
                    if (!item.isTitle) {
                        if ([StringFunction isBlankString:item.RiskDescription] || [StringFunction isBlankString:item.Solution]) {
                            continue;
                        }
                        NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                        mdic[@"AssessmentClassId"] = class.ClassId;
                        mdic[@"AssessmentClassName"] = class.ClassName;
                        mdic[@"AssessmentPartId"] = part.PartId;
                        mdic[@"AssessmentPartName"] = part.PartName;
                        mdic[@"AssessmentItemId"] = item.ItemId;
                        mdic[@"AssessmentItemName"] = item.ItemName;
                        [dataArray addObject:mdic];
                    }
                }
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:saveKey];
            }
        }
    }
    return dataArray;
}

- (NSMutableArray *)getPartsArray {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (ElevatorAssessmentClassEntityList *class in _model.classArray) {
        for (ElevatorAssessmentPartEntityList *part in class.partArray) {
            for (ElevatorAssessmentItemEntityList *item in part.itemArray) {
                NSString *saveKey = [NSString stringWithFormat:@"riskpart_%@_%@", _model.TaskId, item.ItemId];
                if ([[NSUserDefaults standardUserDefaults] objectForKey:saveKey]) {
                    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:saveKey]];
                    for (NSDictionary *dic in tempArray) {
                        PartsCategoryEntityList *entity = [PartsCategoryEntityList yy_modelWithDictionary:dic];
                        if ([self checkHasValue:entity]) {
                            
                            NSMutableArray *idArray = [NSMutableArray array];
                            for (PartAttributeEntityList *model in entity.dataArray) {
                                if ([idArray containsObject:model.ElevatorPartRecordId]) {
                                    continue;
                                } else {
                                    [idArray addObject:model.ElevatorPartRecordId];
                                }
                            }
                            for (NSString *ElevatorPartRecordId in idArray) {
                                NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
                                mdic[@"TaskId"] = _model.TaskId;
                                mdic[@"CertificateNum"] = _model.CertificateNum;
                                mdic[@"InternalNumAndBuildingNum"] = _model.InternalNumAndBuildingNum;
                                mdic[@"AssessmentItemId"] = item.ItemId;
                                mdic[@"AssessmentItemName"] = item.ItemName;
                                mdic[@"AssessmentItemRequirement"] = item.Requirement;
                                mdic[@"CategoryId"] = entity.Id;
                                mdic[@"PartName"] = entity.CategoryName;
                                mdic[@"VarietyCode"] = entity.VarietyCode;
                                mdic[@"SavePartAttributeEntityList"] = [self getItemArray:entity andId:ElevatorPartRecordId];
                                [dataArray addObject:mdic];
                            }
                        }
                    }
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:saveKey];
                }
            }
        }
    }
    return dataArray;
}

- (BOOL)checkHasValue:(PartsCategoryEntityList *)model {
    for (PartAttributeEntityList *item in model.dataArray) {
        if (![StringFunction isBlankString:item.PartAttributeValue]) {
            return YES;
        }
    }
    return NO;
}

- (NSMutableArray *)getItemArray:(PartsCategoryEntityList *)model andId:(NSString *)ElevatorPartRecordId {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PartAttributeEntityList *item in model.dataArray) {
        if ([item.ElevatorPartRecordId isEqualToString:ElevatorPartRecordId]) {
            if ([StringFunction isBlankString:item.PartAttributeValue]) {
                item.PartAttributeValue = @"";
            }
            item.PartName = model.CategoryName;
            [dataArray addObject:[item yy_modelToJSONObject]];
        }
    }
    return dataArray;
}

@end
