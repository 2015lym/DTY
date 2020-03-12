//
//  Part_BindViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Part_BindViewController.h"
#import "Part_BindTableViewCell.h"

#import "BaseQrCodeViewController.h"
#import "PartUtils.h"

@interface Part_BindViewController ()<Part_BindTableViewCellDelegate, LBXScanViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSIndexPath *indexPath;

@end

@implementation Part_BindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"待更换部件";
    _dataArray = [NSMutableArray array];
    if (_isBind) {
        [self addBaseData];
        [self initUnBind];
    } else {
        [self initChange];
    }
    if (_dataArray.count == 0) {
        [self addBaseData];
    }
}

- (void)initUnBind {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(saveOrSubmit)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)initChange {
    for (BindPartModel *model in _partsArray) {
        [_dataArray addObject:model];
    }
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(saveOrSubmit)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)addBaseData {
    NSMutableArray *tempArray = [PartUtils getPartsArray:_taskId partId:_elevatorPartRecordId];
    if (tempArray.count == 0) {
        BindPartModel *model = [[BindPartModel alloc] initWithTaskId:_taskId andElevatorPartRecordId:_elevatorPartRecordId];
        [_dataArray addObject:model];
    } else {
        for (NSDictionary *dic in tempArray) {
            BindPartModel *model = [BindPartModel yy_modelWithDictionary:dic];
            [_dataArray addObject:model];
        }
    }
}


- (void)saveOrSubmit {
    for (int i = 0; i<_dataArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        BindPartModel *model = _dataArray[indexPath.row];
        NSLog(@"taskId：%@ elevatorPartRecordId：%@", _taskId, _elevatorPartRecordId);
        if (model.ProductNumber.length == 0) {
            [self showInfo:@"请填写完整"];
            return;
        }
        if (([model.NfcNumber isEqualToString:@"请扫描"] || model.NfcNumber.length == 0) &&
            ([model.QRCode isEqualToString:@"请扫描"] || model.QRCode.length == 0)) {
            [self showInfo:@"请填写完整"];
            return;
        }
    }
    if (_isBind) {
        [PartUtils saveParts:_taskId partId:_elevatorPartRecordId data:_dataArray];
        [self showSuccess:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"TaskManageId"] = _taskId;
        dic[@"IsBind"] = @"false";
        dic[@"SaveConstructionElevatorPartEntityList"] = [_dataArray yy_modelToJSONObject];
        NSLog(@"%@", dic);
        [self showProgress];
        [NetRequest OLD_POST:reformTask_saveConstructionPart params:dic callback:^(OldElevatorBaseModel *baseModel) {
            if (baseModel.Success) {
                [self showSuccess:@"保存成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self showInfo:baseModel.Message];
            }
            [self hideProgress];
        } errorCallback:^(NSError *error) {
            [self hideProgress];
        }];
    }
    
}

- (IBAction)addItem:(id)sender {
    BindPartModel *model = [[BindPartModel alloc] initWithTaskId:_taskId andElevatorPartRecordId:_elevatorPartRecordId];
    [_dataArray addObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataArray.count - 1 inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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


#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Part_BindTableViewCell *cell = [Part_BindTableViewCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.model = _dataArray[indexPath.row];
    return cell;
}

- (void)updateText:(NSString *)Id andIndexPath:(NSIndexPath *)indexPath {
    BindPartModel *model = _dataArray[indexPath.row];
    model.ProductNumber = Id;
    _dataArray[indexPath.row] = model;
}

- (void)deleteAtIndex:(NSIndexPath *)indexPath {
    [_dataArray removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)getQrcodeAtIndex:(NSIndexPath *)indexPath {
    BaseQrCodeViewController *vc = [BaseQrCodeViewController new];
    vc.delegate = self;
    _indexPath = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scanResultWithArray:(NSArray<LBXScanResult *> *)array {
    LBXScanResult *result = array.firstObject;
    BindPartModel *model = _dataArray[_indexPath.row];
    model.QRCode = result.strScanned;
    model.ProductNumber = result.strScanned;
    _dataArray[_indexPath.row] = model;
    [_tableView reloadRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
