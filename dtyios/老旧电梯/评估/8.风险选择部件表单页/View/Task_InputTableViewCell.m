//
//  Task_InputTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/11.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_InputTableViewCell.h"

@implementation Task_InputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Task_InputTableViewCell";
    Task_InputTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Task_InputTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(NSMutableDictionary *)model {
    _model = model;
    _titleLabel.text = model[@"PartAttributeName"];
    _textField.text = model[@"PartAttributeValue"];
    
    if (_indexPath.section == 0) {
        _deleteButton.hidden = YES;
    } else {
        if (_indexPath.row == 0) {
            _deleteButton.hidden = NO;
        } else {
            _deleteButton.hidden = YES;
        }
    }
    if (_isPreview) {
        _textField.enabled = NO;
        _deleteButton.hidden = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _textField.text = textField.text;
    if ([self.delegate respondsToSelector:@selector(updateText:andIndexPath:)]) {
        [self.delegate updateText:textField.text andIndexPath:_indexPath];
    }
}

- (IBAction)deleteSection:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteSectionAtIndexPath:)]) {
        [self.delegate deleteSectionAtIndexPath:_indexPath];
    }
}

@end
