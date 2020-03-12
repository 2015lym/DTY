//
//  Part_EditPreviewViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Part_EditPreviewViewController.h"
#import "Part_EditTableViewCell.h"
#import "Part_NoEditTableViewCell.h"

#import "Part_BindViewController.h"
#import "Part_BackReasonViewController.h"

#import "Part_PreviewModel.h"
#import "PartUtils.h"

@interface Part_EditPreviewViewController ()<Part_EditCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation Part_EditPreviewViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self netRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待更换部件";
    if (!_hideSubmit) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(submit)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

#pragma mark - ---------- 网络请求 ----------
- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskId"] = _taskId;
    [self showProgress];
    [NetRequest OLD_POST:reformTask_getElevatorPartRecordByTaskId params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.dataArray = [NSMutableArray array];
            for (NSDictionary *dic in [StringFunction stringToJson:baseModel.Data]) {
                Part_PreviewModel *model = [Part_PreviewModel yy_modelWithJSON:dic];
                model.isComplete = self.isComplete;
                if (!self.hideSubmit && [PartUtils getPartsArray:model.TaskManageId partId:model.Id].count > 0) {
                    model.localBind = YES;
                }
                [self.dataArray addObject:model];
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

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Part_PreviewModel *model = _dataArray[indexPath.row];
    NSMutableArray *valueArray = [NSMutableArray arrayWithArray:model.entityArray];
    for (BindPartModel *part in model.parts) {
        PartAttributeEntityListModel *e1 = [PartAttributeEntityListModel new];
        e1.PartAttributeName = @"部件编码";
        e1.PartAttributeValue = part.ProductNumber;
        [valueArray addObject:e1];
        PartAttributeEntityListModel *e2 = [PartAttributeEntityListModel new];
        if (part.QRCode.length > 0) {
            e2.PartAttributeName = @"激光二维码";
            e2.PartAttributeValue = part.QRCode;
            
        } else {
            e2.PartAttributeName = @"nfc编码";
            e2.PartAttributeValue = part.NfcNumber;
        }
        [valueArray addObject:e2];
        if (part.QRCode.length > 0 && part.NfcNumber.length > 0) {
            PartAttributeEntityListModel *e3 = [PartAttributeEntityListModel new];
            e3.PartAttributeName = @"nfc编码";
            e3.PartAttributeValue = part.NfcNumber;
            [valueArray addObject:e3];
        }
        
    }
    return 15 + 21 + 8 + valueArray.count*8 + valueArray.count*14.5 + 15;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Part_PreviewModel *model = _dataArray[indexPath.row];
    if ([model.FlowStatusName containsString:@"未绑定"] ||
        [model.FlowStatusName containsString:@"已绑定"] ||
        [model.FlowStatusName containsString:@"已出库"]) {
        Part_EditTableViewCell *cell = [Part_EditTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.model = _dataArray[indexPath.row];
        cell.indexPath = indexPath;
        return cell;
    } else {
        Part_NoEditTableViewCell *cell = [Part_NoEditTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.model = _dataArray[indexPath.row];
        cell.indexPath = indexPath;
        return cell;
    }
}

- (void)cellEditAction:(EditAction)action andIndexPath:(NSIndexPath *)indexPath {
    Part_PreviewModel *model = _dataArray[indexPath.row];
    if (action == edit_bind || action == edit_change || action == edit_out) {
        Part_BindViewController *vc = [Part_BindViewController new];
        vc.taskId = _taskId;
        vc.elevatorPartRecordId = model.Id;
        if (action == edit_bind) {
            vc.isBind = YES;
        } else {
            vc.isBind = NO;
        }
        vc.partsArray = model.parts;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (action == edit_back) {
        Part_BackReasonViewController *vc = [Part_BackReasonViewController new];
        vc.model = model;
        vc.isPreview = NO;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (action == edit_reason) {
        Part_BackReasonViewController *vc = [Part_BackReasonViewController new];
        vc.model = model;
        vc.isPreview = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)submit {
    for (Part_PreviewModel *model in _dataArray) {
        if (!model.localBind) {
            [self showInfo:@"请填写完整"];
            return;
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TaskManageId"] = _taskId;
    dic[@"IsBind"] = @"true";
    dic[@"SaveConstructionElevatorPartEntityList"] = [PartUtils getAllPartsArray:_taskId];
    NSLog(@"%@", dic);
    [self showProgress];
    [NetRequest OLD_POST:reformTask_saveConstructionPart params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            [self showSuccess:@"保存成功"];
            [PartUtils clearAllPartsData:self.taskId];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
}

@end
