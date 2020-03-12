//
//  Examine_PersonTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/10.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Examine_PersonTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation Examine_PersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Examine_PersonTableViewCell";
    Examine_PersonTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Examine_PersonTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(Part_WorkDetailModel *)model {
    _model = model;
    NSArray *dataArray = _model.adminUsers;
    if ([_titleLabel.text isEqualToString:@"任务负责人"]) {
        dataArray = _model.users;
    }
    
    for (int i=0; i<dataArray.count; i++) {
        UserListModel *user = dataArray[i];
        
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15 + 17.5 + i*8 + i*35, 15, 15)];
        imgv.image = [UIImage imageNamed:@"老旧电梯-负责人"];
        [self.peopleView addSubview:imgv];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(30 + 15, 15 + 17.5 + i*8 + i*35, SCREEN_WIDTH - 30 - 15 - 30 - 80 , 15)];
        lbl.font = [UIFont systemFontOfSize:13.0];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.text = [NSString stringWithFormat:@"%@  %@", user.UserName, user.UserTelephone];
        [self.peopleView addSubview:lbl];
        
        
        UIImageView *signImgv = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 95, 15 + i*8 + i*50, 80, 50)];
        signImgv.image = [UIImage imageNamed:@"老旧电梯-负责人"];
        NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", old_base, user.UserSignUrl];
        NSURL *pathUrl = [NSURL URLWithString:imageUrl];
        [signImgv sd_setImageWithURL:pathUrl placeholderImage:[UIImage imageNamed:@"占位图"]];
        [self.peopleView addSubview:signImgv];
    }
    _peopleViewHeight.constant = 15 + (dataArray.count - 1)*8 + dataArray.count*50 + 15;
}

@end
