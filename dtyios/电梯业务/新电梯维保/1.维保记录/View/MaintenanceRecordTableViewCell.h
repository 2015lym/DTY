//
//  MaintenanceRecordTableViewCell.h
//  dtyios
//
//  Created by Lym on 2020/6/9.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaintenanceRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MaintenanceRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overLabel;



+ (instancetype)cellWithTableView:(UITableView *)tableview;

@property (nonatomic, strong) MaintenanceRecordModel *model;

@end

NS_ASSUME_NONNULL_END
