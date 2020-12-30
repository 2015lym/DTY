//
//  MaintenanceAuditDetailViewController.m
//  dtyios
//
//  Created by Lym on 2020/7/5.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceAuditDetailViewController.h"
#import "MaintenanceAuditContentModel.h"
#import "MaintenancePhotoTableViewCell.h"
#import "MaintenanceContentModel.h"
#import "MaintenanceNFCListTableViewCell.h"

@interface MaintenanceAuditDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MaintenanceAuditDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"维保内容详情";
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
    if (_model.nfcs.count > 0 && _model.photos.count > 0) {
        return 2 + _model.nfcs.count;
    } else if (_model.nfcs.count > 0 && _model.photos.count == 0) {
        return 1 + _model.nfcs.count;
    } else if (_model.nfcs.count == 0 && _model.photos.count == 0) {
        return 1;
    } else {
        return 2;
    }
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else {
        return 125;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *ideitifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
        }
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = [NSString stringWithFormat:@"维保项目：%@\n基本要求：%@", _model.MaintenanceItemName, _model.MaintenanceItemDesc];;
        return cell;
    } else {
        if (_model.nfcs.count > 0 && _model.photos.count > 0) {
            if (indexPath.section == 1) {
                MaintenancePhotoTableViewCell *cell = [MaintenancePhotoTableViewCell cellWithTableView:tableView];
                cell.isPreview = YES;
                NSMutableArray *photos = [NSMutableArray array];
                for (AppMaintenanceWorkRecordImgDtos *imgModel in _model.photos) {
                    [photos addObject:[imgModel yy_modelToJSONObject]];
                }
                cell.dataArray = photos;
                [cell changeUI];
                return cell;
            } else {
                MaintenanceNFCListTableViewCell *cell = [MaintenanceNFCListTableViewCell cellWithTableView:tableView];
                cell.indexPath = indexPath;
                cell.model = _model.nfcs[indexPath.section - 2];
                cell.rightButton.hidden = YES;
                return cell;
            }
        } else if (_model.nfcs.count > 0 && _model.photos.count == 0) {
            MaintenanceNFCListTableViewCell *cell = [MaintenanceNFCListTableViewCell cellWithTableView:tableView];
            cell.indexPath = indexPath;
            cell.model = _model.nfcs[indexPath.section - 1]; 
            cell.rightButton.hidden = YES;
            return cell;
        } else {
            MaintenancePhotoTableViewCell *cell = [MaintenancePhotoTableViewCell cellWithTableView:tableView];
            cell.isPreview = YES;
            NSMutableArray *photos = [NSMutableArray array];
            for (AppMaintenanceWorkRecordImgDtos *imgModel in _model.photos) {
                [photos addObject:[imgModel yy_modelToJSONObject]];
            }
            cell.dataArray = photos;
            [cell changeUI];
            return cell;
        }
    }
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
