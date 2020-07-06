//
//  New_Elevator_MaintenanceViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/3.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "New_Elevator_MaintenanceViewController.h"
#import "Masonry.h"
#import "WorkCollectionView.h"
#import "WorkCollectionViewCell.h"
#import "WorkCollectionReusableView.h"
#import "NewElevatorMaintenanceModel.h"

// 维保记录
#import "MaintenanceRecordViewController.h"
// 待审核工单
#import "MaintenanceUncheckedViewController.h"
// 今日完成（无Tab维保记录页）
#import "MaintenanceRecordNoTabViewController.h"

// 日历
#import "MaintenanceCalendarViewController.h"

// 主管审核
#import "MaintenanceAuditViewController.h"

@interface New_Elevator_MaintenanceViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UILabel *todayMaintenanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueElevatorLabel;
@property (weak, nonatomic) IBOutlet UILabel *pendingReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayCompletedLabel;

@property (nonatomic, strong) WorkCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation New_Elevator_MaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"电梯维保";
    _sectionArray = [NSMutableArray arrayWithObjects:@"电梯维保", nil];
    if (_isCheck) {
        _backView.hidden = YES;
        _dataArray = [NSMutableArray arrayWithObjects:@"维保审核", nil];
    } else {
        _dataArray = [NSMutableArray arrayWithObjects:@"维保计划", @"维保记录", @"临时工单", nil];
        [self netRequest];
    }
    [self createCollectionView];
}

- (void)netRequest {
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [UserService getUserInfo].userId;
    [NetRequest GET:@"NPMaintenanceApp/GetLiftMaintenanceStatusStatistics" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            NewElevatorMaintenanceModel *model = [NewElevatorMaintenanceModel yy_modelWithJSON:baseModel.data];
            self.todayMaintenanceLabel.text = [NSString stringWithFormat:@"（%ld）", model.MaintenanceToday];
            self.overdueElevatorLabel.text = [NSString stringWithFormat:@"（%ld）", model.OverdueElevator];
            self.pendingReviewLabel.text = [NSString stringWithFormat:@"（%ld）", model.PendingReview];
            self.todayCompletedLabel.text = [NSString stringWithFormat:@"（%ld）", model.Completed];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
    }];
}

#pragma mark - ---------- 创建collectionView ----------
- (void)createCollectionView {
    if (_isCheck) {
        _collectionView = [[WorkCollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
    } else {
        _collectionView = [[WorkCollectionView alloc] init];
//        _collectionView = [[WorkCollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/3, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - SCREEN_WIDTH/3)];
    }
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    if (!_isCheck) {
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView.mas_bottom);
            make.bottom.equalTo(self.view.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
        }];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sectionArray.count;
}

#pragma mark - ---------- item数量 ----------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- Cell的内容 ----------
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId"
                                                                             forIndexPath:indexPath];
    cell.titleLabel.text = _dataArray[indexPath.row];
    cell.itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"维保-%@", _dataArray[indexPath.row]]];
    [cell hyb_addCornerRadius:5];
    return cell;
}

#pragma mark - ---------- Cell的点击事件 ----------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if(indexPath.item == 0) {
            if (_isCheck) {
                MaintenanceAuditViewController *vc = [MaintenanceAuditViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                // 维保计划
                MaintenanceCalendarViewController *vc = [MaintenanceCalendarViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else if (indexPath.item == 1) {
            // 维保记录
            MaintenanceRecordViewController *vc = [MaintenanceRecordViewController new];
             [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.item == 2) {
            // 临时工单
            MaintenanceRecordNoTabViewController *vc = [MaintenanceRecordNoTabViewController new];
            vc.navigationItem.title = @"临时工单";
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        
    }
}

#pragma mark - ---------- 头视图 ----------
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        WorkCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableId" forIndexPath:indexPath];
        header.titleLabel.text = _sectionArray[indexPath.section];
        reusableView = header;
    }
    //如果是头视图
    return reusableView;
}
// 今日保养
- (IBAction)action1:(id)sender {
    MaintenanceRecordNoTabViewController *vc = [MaintenanceRecordNoTabViewController new];
    vc.navigationItem.title = @"今日保养";
    vc.workStatus = 6;
    [self.navigationController pushViewController:vc animated:YES];
}

// 超期电梯
- (IBAction)action2:(id)sender {
    MaintenanceRecordNoTabViewController *vc = [MaintenanceRecordNoTabViewController new];
    vc.navigationItem.title = @"超期工单";
    vc.workStatus = 7;
    [self.navigationController pushViewController:vc animated:YES];
}

// 待审核
- (IBAction)action3:(id)sender {
    MaintenanceRecordNoTabViewController *vc = [MaintenanceRecordNoTabViewController new];
    vc.navigationItem.title = @"待审核工单";
    vc.workStatus = 8;
    [self.navigationController pushViewController:vc animated:YES];
}

// 今日完成
- (IBAction)action4:(id)sender {
    MaintenanceRecordNoTabViewController *vc = [MaintenanceRecordNoTabViewController new];
    vc.navigationItem.title = @"已完成工单";
    vc.workStatus = 5;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
