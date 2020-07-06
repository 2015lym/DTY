//
//  MaintenanceAuditContentTableViewCell.h
//  dtyios
//
//  Created by Lym on 2020/6/29.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaintenanceAuditContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaintenanceAuditContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, strong) MaintenanceAuditContentModel *model;

@end

NS_ASSUME_NONNULL_END
