//
//  MaintenancePhotoTableViewCell.h
//  多张照片选择简单DEMO
//
//  Created by Lym on 16/8/1.
//  Copyright © 2016年 Lym. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppMaintenanceItemDtos;

@interface MaintenancePhotoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *dataArray;                  //图片数组


@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *partId;


@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, strong) AppMaintenanceItemDtos *model;

- (void)changeUI;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
