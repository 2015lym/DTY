//
//  Part_BindTableViewCell.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/13.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Part_BindTableViewCell.h"

@implementation Part_BindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _idTextField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"Part_BindTableViewCell";
    Part_BindTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (Part_BindTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (IBAction)deleteAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteAtIndex:)]) {
        [self.delegate deleteAtIndex:_indexPath];
    }
}

- (IBAction)getQrCodeAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(getQrcodeAtIndex:)]) {
        [self.delegate getQrcodeAtIndex:_indexPath];
    }
}

- (void)setModel:(BindPartModel *)model {
    _model = model;
    _idTextField.text = model.ProductNumber;
    _nfcLabel.text = model.NfcNumber;
    _codeLabel.text = model.QRCode;
    if (_model.NfcNumber.length == 0) {
        _nfcLabel.text = @"请扫描";
    }
    if (_model.QRCode.length == 0) {
        _codeLabel.text = @"请扫描";
    }
    if (_indexPath.row == 0) {
        _deleteButton.hidden = YES;
    } else {
        _deleteButton.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _idTextField.text = textField.text;
    if ([self.delegate respondsToSelector:@selector(updateText:andIndexPath:)]) {
        [self.delegate updateText:textField.text andIndexPath:_indexPath];
    }
}

@end
