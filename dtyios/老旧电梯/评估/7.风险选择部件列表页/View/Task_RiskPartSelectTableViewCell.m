//
//  Task_RiskPartSelectTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/25.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_RiskPartSelectTableViewCell.h"

@implementation Task_RiskPartSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Task_RiskPartSelectTableViewCell";
    Task_RiskPartSelectTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Task_RiskPartSelectTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(PartsCategoryEntityList *)model {
    _model = model;
    if (model.CategoryLevel == 1) {
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabelLeading.constant = 15;
    } else if (model.CategoryLevel == 2) {
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:16];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabelLeading.constant = 30;
    } else {
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:15];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabelLeading.constant = 45;
    }
    [_selectButton hyb_addCornerRadius:5];
    [_changeButton hyb_addCornerRadius:5];
    [_deleteButton hyb_addCornerRadius:5];
    
    if (_isPreview) {
        [_selectButton setTitle:@"查看" forState:UIControlStateNormal];
        _selectButton.hidden = NO;
        _changeButton.hidden = YES;
        _deleteButton.hidden = YES;
    } else {
        if (model.hasValue) {
            _selectButton.hidden = YES;
            _changeButton.hidden = NO;
            _deleteButton.hidden = NO;
        } else {
            _selectButton.hidden = NO;
            _changeButton.hidden = YES;
            _deleteButton.hidden = YES;
        }
    }

    _titleLabel.text = model.CategoryName;
}

- (IBAction)selectAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectAction:andIndexPath:)]) {
        [self.delegate selectAction:kSelect andIndexPath:_indexPath];
    }
}

- (IBAction)changeAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectAction:andIndexPath:)]) {
        [self.delegate selectAction:kChanage andIndexPath:_indexPath];
    }
}

- (IBAction)deleteAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectAction:andIndexPath:)]) {
        [self.delegate selectAction:kDelete andIndexPath:_indexPath];
    }
}

@end
