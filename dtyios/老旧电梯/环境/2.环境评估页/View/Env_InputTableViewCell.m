//
//  Env_InputTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Env_InputTableViewCell.h"

@implementation Env_InputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Env_InputTableViewCell";
    Env_InputTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Env_InputTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(EnvironmentAssessmentCategoryEntityList *)model {
    _model = model;
    _titleLabel.text = model.CategoryName;
    _textField.text = model.value;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _textField.text = textField.text;
    if ([self.delegate respondsToSelector:@selector(updateText:andIndexPath:)]) {
        [self.delegate updateText:textField.text andIndexPath:_indexPath];
    }
}

@end
