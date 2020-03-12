//
//  YMTableViewCell.h
//  多张照片选择简单DEMO
//
//  Created by Lym on 16/8/1.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemarkDelegate.h"
#import "Part_PreviewModel.h"

@interface YMTableViewCell : UITableViewCell

@property (nonatomic, weak) id<RemarkDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;                  //图片数组


@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *partId;


@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, strong) Part_PreviewModel *model;

- (void)changeUI;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
