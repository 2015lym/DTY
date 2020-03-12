//
//  Env_WorkTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Env_WorkTableViewCell.h"

@implementation Env_WorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Env_WorkTableViewCell";
    Env_WorkTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Env_WorkTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Env_WorkListModel *)model {
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"项目名称：%@", model.CommunityName];
    _addressLabel.text = model.CommunityDetailedAddress;
    _elevatorNumberLabel.text = [NSString stringWithFormat:@"电梯数量：%@", model.NumberOfUnitElevators];
}
@end
