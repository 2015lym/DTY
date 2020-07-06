//
//  MaintenanceNFCListViewController.m
//  dtyios
//
//  Created by Lym on 2020/7/2.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceNFCListViewController.h"
#import "MaintenanceContentModel.h"
#import "MaintenanceNFCPartsModel.h"
#import "NFCTagViewController.h"
#import "CommonUseClass.h"

#import "MaintenanceNFCListTableViewCell.h"

@interface MaintenanceNFCListViewController ()<NFCTagViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MaintenanceNFCPartsModel *> *partArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MaintenanceNFCListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"识别部件";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
//    _dataArray = [NSMutableArray array];
    [self netRequest];
}

- (void)save {
    if ([self.delegate respondsToSelector:@selector(returnPartsData:andIndexPath:)]) {
        [self.delegate returnPartsData:_item andIndexPath:_indexPath];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)netRequest {
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [UserService getUserInfo].userId;
    [NetRequest GET:@"NPMaintenanceApp/GetElevatorParts" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            self.partArray = [NSMutableArray array];
            for (NSDictionary *dic in [StringFunction stringToJson:baseModel.data]) {
                MaintenanceNFCPartsModel *model = [MaintenanceNFCPartsModel yy_modelWithJSON:dic];
                [self.partArray addObject:model];
            }
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
    }];
}

- (IBAction)addParts:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择配件" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     for (MaintenanceNFCPartsModel *model in _partArray) {
         UIAlertAction *actionSheet = [UIAlertAction actionWithTitle:model.PartName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             NFCTagViewController *vc = [NFCTagViewController new];
             vc.model = model;
             vc.liftId = self.liftId;
             vc.maintenanceItemId = self.item.ItemId;
             vc.delegate = self;
             vc.writeString = [NSString stringWithFormat:@"%@`%@`%@`%@", self.liftId, model.PartName, self.address, [CommonUseClass getCurrentTimes]];
             [self.navigationController pushViewController:vc animated:YES];
         }];
         [alertController addAction:actionSheet];
     }
     
     UIAlertAction *cancelSheet = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
     [alertController addAction:cancelSheet];
     [self presentViewController:alertController animated:YES completion:nil];
}

- (void)returnNFCData:(NSMutableDictionary *)dic {
    AppMaintenanceWorkRecordNfcDtos *nfc = [AppMaintenanceWorkRecordNfcDtos yy_modelWithJSON:dic];
    [_item.nfcs addObject:nfc];
    [self.tableView reloadData];
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
    return _item.nfcs.count;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MaintenanceNFCListTableViewCell *cell = [MaintenanceNFCListTableViewCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.model = _item.nfcs[indexPath.section];
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
