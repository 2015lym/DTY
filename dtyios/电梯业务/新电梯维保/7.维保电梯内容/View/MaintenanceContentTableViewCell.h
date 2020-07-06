//
//  MaintenanceContentTableViewCell.h
//  dtyios
//
//  Created by Lym on 2020/6/24.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppMaintenanceItemDtos;


@protocol MaintenanceContentTableViewCellDelegate <NSObject>

- (void)selectAtIndex:(NSIndexPath *)indexPath;

- (void)nfcAtIndex:(NSIndexPath *)indexPath;

- (void)imageAtIndex:(NSIndexPath *)indexPath;

@end

@interface MaintenanceContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *resultButton;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIButton *button3;

@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, strong) AppMaintenanceItemDtos *model;

@property (nonatomic, weak) id<MaintenanceContentTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
