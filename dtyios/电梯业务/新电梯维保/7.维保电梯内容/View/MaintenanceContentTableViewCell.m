//
//  MaintenanceContentTableViewCell.m
//  dtyios
//
//  Created by Lym on 2020/6/24.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceContentTableViewCell.h"
#import "MaintenanceContentModel.h"

@implementation MaintenanceContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview {
    static NSString *cellID = @"MaintenanceContentTableViewCell";
    MaintenanceContentTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = (MaintenanceContentTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(AppMaintenanceItemDtos *)model {
    _model = model;
    _titleLabel.text = [NSString stringWithFormat:@"%ld. %@", _indexPath.section + 1,model.MaintenanceItemName];
    _contentLabel.text = model.MaintenanceItemDesc;
    
    if ([StringFunction isBlankString:model.ResultName]) {
        [_resultButton setTitle:@"维保结果：请选择" forState:UIControlStateNormal];
    } else {
        [_resultButton setTitle:[NSString stringWithFormat:@"维保结果：%@", model.ResultName] forState:UIControlStateNormal];
    }
    
    if (!model.IsNFC && model.IsPhoto) {
        _view3.hidden = YES;
        if (model.photos.count > 0) {
            [_button2 setTitle:[NSString stringWithFormat:@"已上传%ld张照片", model.photos.count] forState:UIControlStateNormal];
        } else {
            [_button2 setTitle:@"需上传照片" forState:UIControlStateNormal];
        }
    }
    if (!model.IsNFC && !model.IsPhoto) {
        _view2.hidden = YES;
        _view3.hidden = YES;
    }
    if (model.IsNFC && model.nfcs.count > 0) {
        NSInteger discernNum = 0;
        for (AppMaintenanceWorkRecordNfcDtos *nfc in model.nfcs) {
            if ((nfc.ElevatorPartNFCId.length > 0 && nfc.ElevatorPartNFCIdValue.length > 0) ||
                 (nfc.ElevatorPartNFCId.length == 0 && nfc.ElevatorPartNFCIdValue.length == 0)) {
                discernNum += 1;
            }
        }
        if (discernNum == 0) {
            [_button2 setTitle:@"NFC码未识别" forState:UIControlStateNormal];
        } else {
            [_button2 setTitle:[NSString stringWithFormat:@"NFC 已识别%ld/%ld", discernNum, model.nfcs.count] forState:UIControlStateNormal];
        }
    }
    
    if (model.IsNFC && model.IsPhoto) {
        if (model.photos.count > 0) {
            [_button3 setTitle:[NSString stringWithFormat:@"已上传%ld张照片", model.photos.count] forState:UIControlStateNormal];
        } else {
            [_button3 setTitle:@"需上传照片" forState:UIControlStateNormal];
        }
    }
    
}

- (IBAction)selectResult:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectAtIndex:)]) {
        [self.delegate selectAtIndex:_indexPath];
    }
}
- (IBAction)selectButton:(UIButton *)sender {
    if ([sender.titleLabel.text containsString:@"NFC"]) {
        if ([self.delegate respondsToSelector:@selector(nfcAtIndex:)]) {
            [self.delegate nfcAtIndex:_indexPath];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(imageAtIndex:)]) {
            [self.delegate imageAtIndex:_indexPath];
        }
    }
    
}

@end
