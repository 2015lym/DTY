//
//  Old_WorkViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_WorkViewController.h"
#import <SGPagingView/SGPagingView.h>
#import "Old_WorkListViewController.h"

@interface Old_WorkViewController ()<SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;

@end

@implementation Old_WorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"施工任务";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self configPageView];
}

- (void)configPageView {
    NSArray *titleArr = @[@"未开始", @"进行中", @"已完成"];
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
        Old_WorkListViewController *vc = [Old_WorkListViewController new];
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
