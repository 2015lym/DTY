//
//  MaintenanceUncheckedTableViewCell.m
//  dtyios
//
//  Created by Lym on 2020/6/10.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceUncheckedTableViewCell.h"

@implementation MaintenanceUncheckedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MaintenanceUncheckedTableViewCell";
    MaintenanceUncheckedTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (MaintenanceUncheckedTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

@end
