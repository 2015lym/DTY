//
//  Examine_WorkTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/5.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Examine_WorkTableViewCell.h"

@implementation Examine_WorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Examine_WorkTableViewCell";
    Examine_WorkTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = (Examine_WorkTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Examine_WorkListModel *)model {
    _model = model;
    _elevatorNumberLabel.text = [NSString stringWithFormat:@"电梯注册代码：%@", model.CertificateNum];
    _addressLabel.text = [NSString stringWithFormat:@"安装地址：%@", model.CommunityDetailedAddress];
    _useTimeLabel.text = [NSString stringWithFormat:@"电梯使用时间：%@年", model.ElevatorUsageTime];
    
    if (!model.UserNameList || model.UserNameList.count == 0) {
        _userLabel.hidden = YES;
    } else {
        _userLabel.hidden = NO;
        NSMutableString *userNames = [NSMutableString stringWithString:@"任务负责人："];
        for (NSString *user in model.UserNameList) {
            [userNames appendString:user];
            [userNames appendString:@"，"];
        }
        _userLabel.text = [userNames substringToIndex:userNames.length - 1];
    }
}

@end
