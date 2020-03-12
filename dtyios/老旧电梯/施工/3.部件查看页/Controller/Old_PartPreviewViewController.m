//
//  Old_PartPreviewViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_PartPreviewViewController.h"
#import "Old_PartPreviewTableViewCell.h"

#import "Part_PreviewModel.h"

@interface Old_PartPreviewViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation Old_PartPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待更换部件";
    [self netRequest];
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
    Old_PartPreviewTableViewCell *cell = [Old_PartPreviewTableViewCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
