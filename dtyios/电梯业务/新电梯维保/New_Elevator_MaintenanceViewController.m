//
//  New_Elevator_MaintenanceViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/3.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "New_Elevator_MaintenanceViewController.h"
#import "WorkCollectionView.h"
#import "WorkCollectionViewCell.h"
#import "WorkCollectionReusableView.h"

// 维保记录
#import "MaintenanceRecordViewController.h"
// 超期工单
#import "MaintenanceOverOrderViewController.h"

#import "MaintenanceCalendarViewController.h"

@interface New_Elevator_MaintenanceViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) WorkCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation New_Elevator_MaintenanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"电梯维保";
    _sectionArray = [NSMutableArray arrayWithObjects:@"电梯维保", nil];
    _dataArray = [NSMutableArray arrayWithObjects:@"维保计划", @"维保记录", @"临时工单", nil];
    [self createCollectionView];
}

#pragma mark - ---------- 创建collectionView ----------
- (void)createCollectionView {
    _collectionView = [[WorkCollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/3, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - SCREEN_WIDTH/3)];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
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
//    cell.itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"业务-%@", _dataArray[indexPath.row]]];
    cell.itemImageView.image = [UIImage imageNamed:@"业务-维修记录"];
    [cell hyb_addCornerRadius:5];
    return cell;
}

#pragma mark - ---------- Cell的点击事件 ----------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if(indexPath.item == 0) {
            MaintenanceCalendarViewController *vc = [MaintenanceCalendarViewController new];
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
- (IBAction)action1:(id)sender {
    MaintenanceRecordViewController *vc = [MaintenanceRecordViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)action2:(id)sender {
    MaintenanceOverOrderViewController *vc = [MaintenanceOverOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)action3:(id)sender {
}

- (IBAction)action4:(id)sender {
}
@end
