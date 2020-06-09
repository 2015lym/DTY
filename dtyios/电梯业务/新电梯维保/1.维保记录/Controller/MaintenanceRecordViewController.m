//
//  MaintenanceRecordViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "MaintenanceRecordViewController.h"
#import <SGPagingView/SGPagingView.h>
#import "MaintenanceRecordListViewController.h"

@interface MaintenanceRecordViewController ()<SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;

@end

@implementation MaintenanceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"维保记录";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dt_scan"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(scanCode)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self configPageView];
}

- (void)scanCode {
    
}

- (void)configPageView {
    NSArray *titleArr = @[@"全部", @"未进行", @"进行中", @"待审核", @"已完成"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorToBottomDistance = 3;
    configure.titleFont = [UIFont systemFontOfSize:14];
    configure.titleColor = [UIColor lightGrayColor];
    configure.titleSelectedColor = [UIColor colorWithHexString:@"#004E9E"];
    configure.indicatorHeight = 3.0;
    configure.indicatorCornerRadius = 5;
    configure.indicatorColor = [UIColor colorWithHexString:@"#004E9E"];
    _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
                                                    delegate:self titleNames:titleArr configure:configure];
    _pageTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 0;
    
    NSMutableArray *vcArray = [NSMutableArray array];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        MaintenanceRecordListViewController *vc = [MaintenanceRecordListViewController new];
        vc.workStatus = i + 1;
        [vcArray addObject:vc];
        [self addChildViewController:vc];
    }
    
    _pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0,
                                                                                               44,
                                                                                               SCREEN_WIDTH,
                                                                                               SCREEN_HEIGHT - 44 - kTopHeight)
                                                                           parentVC:self
                                                                           childVCs:vcArray];
    _pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.view addSubview:_pageContentCollectionView];
}

#pragma mark - 头部视图 delegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.view endEditing:YES];
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.view endEditing:YES];
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}



@end
