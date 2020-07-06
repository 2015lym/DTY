//
//  SignTableViewCell.m
//  dtyios
//
//  Created by Lym on 2020/6/30.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "SignTableViewCell.h"

@implementation SignTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"SignTableViewCell";
    SignTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (SignTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

@end
