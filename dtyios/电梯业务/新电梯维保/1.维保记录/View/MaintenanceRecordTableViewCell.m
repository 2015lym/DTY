//
//  MaintenanceRecordTableViewCell.m
//  dtyios
//
//  Created by Lym on 2020/6/9.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceRecordTableViewCell.h"

@implementation MaintenanceRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_tagLabel hyb_addCornerRadius:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MaintenanceRecordTableViewCell";
    MaintenanceRecordTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (MaintenanceRecordTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

@end
