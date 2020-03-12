//
//  Env_RadioTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/12.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Env_RadioTableViewCell.h"

@implementation Env_RadioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Env_RadioTableViewCell";
    Env_RadioTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Env_RadioTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(EnvironmentAssessmentCategoryEntityList *)model {
    _model = model;
    _titleLabel.text = model.CategoryName;
    
    for (int i = 0; i<model.valueArray.count; i++) {
        EnvironmentAssessmentItmeEntity *entity = model.valueArray[i];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 15 + 21 + 10 + i*10 + i*30, SCREEN_WIDTH-80, 30)];
        lbl.font = [UIFont systemFontOfSize:15.0];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.text = entity.ItemTitle;
        [self.contentView addSubview:lbl];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 15 + 21 + 10 + i*10 + i*30, 30,
                                                                   30)];
        btn.tag = 10000 + i;
        [btn addTarget:self action:@selector(selectRadio:) forControlEvents:UIControlEventTouchUpInside];
        if (entity.DataItemValue) {
            [btn setBackgroundImage:[UIImage imageNamed:@"老旧电梯-选中"] forState:UIControlStateNormal];
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:@"老旧电梯-未选中"] forState:UIControlStateNormal];
        }
        [self.contentView addSubview:btn];
    }
}

- (void)selectRadio:(UIButton *)btn {
    for (int i = 0; i<_model.valueArray.count; i++) {
        if (10000+i == btn.tag) {
            [btn setBackgroundImage:[UIImage imageNamed:@"老旧电梯-选中"] forState:UIControlStateNormal];
            if ([self.delegate respondsToSelector:@selector(updateRadio:andIndexPath:)]) {
                [self.delegate updateRadio:btn.tag - 10000 andIndexPath:_indexPath];
            }
        } else {
            UIButton *unSelectBtn = [self.contentView viewWithTag:10000 + i];
            [unSelectBtn setBackgroundImage:[UIImage imageNamed:@"老旧电梯-未选中"] forState:UIControlStateNormal];
        }
    }
}

@end
