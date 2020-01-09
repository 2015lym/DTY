//
//  NormalTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/3/26.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "NormalTableViewCell.h"

@implementation NormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"NormalTableViewCell";
    NormalTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (NormalTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}
@end
