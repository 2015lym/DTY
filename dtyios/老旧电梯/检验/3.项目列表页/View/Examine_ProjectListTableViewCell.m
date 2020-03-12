//
//  Examine_ProjectListTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Examine_ProjectListTableViewCell.h"

@implementation Examine_ProjectListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Examine_ProjectListTableViewCell";
    Examine_ProjectListTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Examine_ProjectListTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(ExamineProjectListModel *)model {
    _model = model;
    _titleLabel.text = model.CategoryNameTwo;
    if (model.hasValue) {
        _clearButton.hidden = NO;
        _completeLabel.text = @"已填写";
    } else {
        _clearButton.hidden = YES;
        _completeLabel.text = @"未填写";
    }

}

- (void)setIsPreview:(BOOL)isPreview {
    _isPreview = isPreview;
    if (isPreview) {
        _clearButton.hidden = YES;
    }
}

- (IBAction)clearAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clearActionIndex:)]) {
        [self.delegate clearActionIndex:_indexPath];
    }
}

@end
