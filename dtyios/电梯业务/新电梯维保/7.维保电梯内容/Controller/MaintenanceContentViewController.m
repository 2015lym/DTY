//
//  MaintenanceContentViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/24.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceContentViewController.h"
#import "MaintenanceContentTableViewCell.h"
#import "MaintenanceContentModel.h"
#import "MaintenanceSignViewController.h"
#import "MaintenanceNFCListViewController.h"
#import "MaintenancePhotoViewController.h"

@interface MaintenanceContentViewController ()<MaintenanceContentTableViewCellDelegate, MaintenanceNFCListViewControllerDelegate, MaintenancePhotoViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MaintenanceContentModel *model;

@end

@implementation MaintenanceContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _typeName;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self netRequest];
}

- (void)netRequest {
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [UserService getUserInfo].userId;
    dic[@"workOrderId"] = _workOrderId;
    dic[@"maintenanceTypeId"] = _maintenanceTypeId;
    [NetRequest GET:@"NPMaintenanceApp/GetMaintenanceItem" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            self.model = [MaintenanceContentModel yy_modelWithJSON:baseModel.data];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self.tableView reloadData];
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
    }];
}

#pragma mark - ---------- 每个Section的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
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
    return self.model.itemArray.count;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppMaintenanceItemDtos *item = _model.itemArray[indexPath.section];
    CGFloat height = 109;
    if (item.IsNFC) height += 44;
    if (item.IsPhoto) height += 44;
    return height;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MaintenanceContentTableViewCell *cell = [MaintenanceContentTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = _model.itemArray[indexPath.section];
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)selectAtIndex:(NSIndexPath *)indexPath {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i=0; i<_model.resultArray.count; i++) {
        AppMaintenanceWorkResultDtos *item = _model.resultArray[i];
        UIAlertAction *action = [UIAlertAction actionWithTitle:item.ResultName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.model.itemArray[indexPath.section].ResultName = item.ResultName;
            self.model.itemArray[indexPath.section].ResultId = item.WorkResultId;
            self.model.itemArray[indexPath.section].MaintenanceUserId = [UserService getUserInfo].userId;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [actionSheet addAction:action];
    }
    UIAlertAction *cancelSheet = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelSheet];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)nfcAtIndex:(NSIndexPath *)indexPath {
    NSLog(@"NFC");
    AppMaintenanceItemDtos *item = _model.itemArray[indexPath.section];
    MaintenanceNFCListViewController *vc = [MaintenanceNFCListViewController new];
    vc.item = item;
    vc.liftId = _model.LiftId;
    vc.address = _address;
    vc.indexPath = indexPath;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)returnPartsData:(AppMaintenanceItemDtos *)item andIndexPath:(NSIndexPath *)indexPath {
    _model.itemArray[indexPath.section].nfcs = item.nfcs;
    [self.tableView reloadData];
}

- (void)imageAtIndex:(NSIndexPath *)indexPath {
    NSLog(@"Photo");
    AppMaintenanceItemDtos *item = _model.itemArray[indexPath.section];
    MaintenancePhotoViewController *vc = [MaintenancePhotoViewController new];
    vc.item = item;
    vc.indexPath = indexPath;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)returnPhotoData:(NSMutableArray *)array andIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        AppMaintenanceWorkRecordImgDtos *photo = [AppMaintenanceWorkRecordImgDtos yy_modelWithJSON:dic];
        [tempArray addObject:photo];
    }
    _model.itemArray[indexPath.section].photos = tempArray;
    [self.tableView reloadData];
}

- (void)submit {
    MaintenanceSignViewController *vc = [MaintenanceSignViewController new];
    NSMutableArray *itemArray = [NSMutableArray array];
    for (AppMaintenanceItemDtos *item in _model.itemArray) {
        if (item.ResultName && item.ResultId) {
            [itemArray addObject:item];
        } else {
            item.ResultName = @"合格";
            item.ResultId = 1;
            [itemArray addObject:item];
        }
    }
    if (itemArray.count == 0) {
        [self showInfo:@"请至少选择一项"];
        return;
    }
    MaintenanceContentModel *tempModel = [MaintenanceContentModel yy_modelWithJSON:[_model yy_modelToJSONObject]];
    tempModel.itemArray = itemArray;
    tempModel.AppMaintenanceWorkOrderRemarkDtos = [NSMutableArray array];
    
    for (int i=0; i<tempModel.itemArray.count; i++) {
        AppMaintenanceItemDtos *item = tempModel.itemArray[i];
        NSMutableArray *nfcArray = [NSMutableArray array];
        for (AppMaintenanceWorkRecordNfcDtos *nfc in item.nfcs) {
            if ((nfc.ElevatorPartNFCId.length > 0 && nfc.ElevatorPartNFCIdValue.length > 0) ||
                 (nfc.ElevatorPartNFCId.length == 0 && nfc.ElevatorPartNFCIdValue.length == 0)) {
                [nfcArray addObject:nfc];
            }
        }
        tempModel.itemArray[i].nfcs = nfcArray;
    }
    
    vc.maintenanceModel = tempModel;
    vc.isCheck = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
