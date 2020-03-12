//
//  Old_PartListTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/12.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Old_PartListTableViewCell.h"

@implementation Old_PartListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Old_PartListTableViewCell";
    Old_PartListTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Old_PartListTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (IBAction)unfold:(UIButton *)sender {
    _unfoldButton.selected = !_unfoldButton.selected;
    if (_unfoldButton.selected) {
        _model.isUnfold = YES;
    } else {
        _model.isUnfold = NO;
    }
    if ([self.delegate respondsToSelector:@selector(unfoldAction:andIndex:)]) {
        [self.delegate unfoldAction:_model.isUnfold andIndex:_indexPath];
    }
}

- (IBAction)clearAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clearActionIndex:)]) {
        [self.delegate clearActionIndex:_indexPath];
    }
}

- (void)setModel:(Part_PreviewModel *)model {
    _model = model;
    _titleLabel.text = model.PartName;
    
    NSMutableArray *valueArray = [NSMutableArray arrayWithArray:model.entityArray];
    for (BindPartModel *part in model.parts) {
        PartAttributeEntityListModel *e1 = [PartAttributeEntityListModel new];
        e1.PartAttributeName = @"部件编码";
        e1.PartAttributeValue = part.ProductNumber;
        [valueArray addObject:e1];
        PartAttributeEntityListModel *e2 = [PartAttributeEntityListModel new];
        if (part.QRCode.length > 0) {
            e2.PartAttributeName = @"激光二维码";
            e2.PartAttributeValue = part.QRCode;
            
        } else {
            e2.PartAttributeName = @"nfc编码";
            e2.PartAttributeValue = part.NfcNumber;
        }
        [valueArray addObject:e2];
        if (part.QRCode.length > 0 && part.NfcNumber.length > 0) {
            PartAttributeEntityListModel *e3 = [PartAttributeEntityListModel new];
            e3.PartAttributeName = @"nfc编码";
            e3.PartAttributeValue = part.NfcNumber;
            [valueArray addObject:e3];
        }
    }
    PartAttributeEntityListModel *pp = [PartAttributeEntityListModel new];
    pp.PartAttributeName = @"备注/零件";
    pp.PartAttributeValue = model.RemarksParts;
    [valueArray addObject:pp];
    
    for (int i=0; i<valueArray.count; i++) {
        PartAttributeEntityListModel *entity = valueArray[i];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 8 + i*8 + i*14.5, SCREEN_WIDTH-60, 14.5)];
        lbl.font = [UIFont systemFontOfSize:13.0];
        lbl.textColor = [UIColor lightGrayColor];
        lbl.text = [NSString stringWithFormat:@"%@：%@", entity.PartAttributeName, entity.PartAttributeValue];
        [self.bottomView addSubview:lbl];
    }
    _bottomViewHeight.constant = 8 + model.entityArray.count*8 + model.entityArray.count*14.5 + 15;
    
    if (_model.isUnfold) {
        _bottomView.hidden = NO;
        _unfoldButton.selected = YES;
    } else {
        _bottomView.hidden = YES;
        _unfoldButton.selected = NO;
    }
    if (_model.localRemark) {
        _clearButton.hidden = NO;
        _completeLabel.text = @"已填写";
    } else {
        _clearButton.hidden = YES;
        _completeLabel.text = @"未填写";
    }
    if (_isPreview) {
        _clearButton.hidden = YES;
        _completeLabel.hidden = YES;
    }
}

@end
