//
//  Examine_HomeViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/25.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Examine_HomeViewController.h"
#import <SGPagingView/SGPagingView.h>
#import "Examine_HomeListViewController.h"

@interface Examine_HomeViewController ()<SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;


@end

@implementation Examine_HomeViewController

#pragma mark - ---------- 生命周期 ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"检验任务";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configPageView];
}

- (void)configPageView {
    NSArray *titleArr = @[@"未开始", @"进行中", @"已完成"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.showVerticalSeparator = NO;
    configure.indicatorToBottomDistance = 3;
    configure.titleFont = [UIFont systemFontOfSize:14];
    configure.titleColor = [UIColor lightGrayColor];
    configure.titleSelectedColor = [UIColor colorWithHexString:@"#004E9E"];
    configure.indicatorHeight = 3.0;
    configure.indicatorCornerRadius = 5;
    configure.indicatorColor = [UIColor colorWithHexString:@"#004E9E"];
    configure.showBottomSeparator = NO;
    _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)
                                                    delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.selectedIndex = 0;
    
    NSMutableArray *vcArray = [NSMutableArray array];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        Examine_HomeListViewController *vc = [Examine_HomeListViewController new];
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
