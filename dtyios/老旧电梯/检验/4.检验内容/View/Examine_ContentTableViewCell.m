//
//  Examine_ContentTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Examine_ContentTableViewCell.h"

@implementation Examine_ContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Examine_ContentTableViewCell";
    Examine_ContentTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Examine_ContentTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setExamineResult:(NSString *)examineResult {
    _examineResult = examineResult;
    if ([examineResult isEqualToString:@"符合"]) {
        _leftImageView.image = [UIImage imageNamed:@"老旧电梯-选中"];
        _midImageView.image = [UIImage imageNamed:@"老旧电梯-未选中"];
        _rightImageView.image = [UIImage imageNamed:@"老旧电梯-未选中"];
    } else if ([examineResult isEqualToString:@"不符合"]) {
        _leftImageView.image = [UIImage imageNamed:@"老旧电梯-未选中"];
        _midImageView.image = [UIImage imageNamed:@"老旧电梯-选中"];
        _rightImageView.image = [UIImage imageNamed:@"老旧电梯-未选中"];
    } else {
        _leftImageView.image = [UIImage imageNamed:@"老旧电梯-未选中"];
        _midImageView.image = [UIImage imageNamed:@"老旧电梯-未选中"];
        _rightImageView.image = [UIImage imageNamed:@"老旧电梯-选中"];
    }
    if (_isPreview) {
        _leftButton.enabled = NO;
        _midButton.enabled = NO;
        _rightButton.enabled = NO;
    }
}

- (IBAction)leftAction:(id)sender {
    self.examineResult = @"符合";
    if ([self.delegate respondsToSelector:@selector(changeId:andResult:)]) {
        [self.delegate changeId:_examineCategoryId andResult:_examineResult];
    }
}

- (IBAction)midAction:(id)sender {
    self.examineResult = @"不符合";
    if ([self.delegate respondsToSelector:@selector(changeId:andResult:)]) {
        [self.delegate changeId:_examineCategoryId andResult:_examineResult];
    }
}

- (IBAction)rightAction:(id)sender {
    self.examineResult = @"无此项";
    if ([self.delegate respondsToSelector:@selector(changeId:andResult:)]) {
        [self.delegate changeId:_examineCategoryId andResult:_examineResult];
    }
}

@end
