//
//  RepairRecordCell.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "RepairRecordCell.h"
#import "UILabel+Extension.h"
@implementation RepairRecordCell
@synthesize lab1,lab2,lab3,labNum,labTime,labAddress;
- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
{
    //return true;
    //1.all set
    self.backgroundColor=[UIColor whiteColor];
    self.currHeight=100;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    NSDictionary *dic = (NSDictionary*)aObject_entity;
    //2.data
    labAddress.text = dic[@"InstallationAddress"];
    labNum.text     = dic[@"LiftNum"];
    labTime.text    = dic[@"CreateTime"];
    lab1.frame = CGRectMake(10, 14, 76, 20);
    labNum.frame = CGRectMake(10, CGRectGetMaxY(lab1.frame)+20, 76, 22);
    lab2.frame = CGRectMake(CGRectGetMaxX(lab1.frame)+10, 10, 1, self.frame.size.height-25);
    lab3.frame = CGRectMake(CGRectGetMaxX(lab2.frame)+10, 8, 70, 20);
    CGFloat h = [labAddress getSpaceLabelHeight:labAddress.text withWidh:self.frame.size.width-labAddress.frame.origin.x-10 Font:13];
    labAddress.frame = CGRectMake(lab3.frame.origin.x, CGRectGetMaxY(lab3.frame)+8, self.frame.size.width-labAddress.frame.origin.x-10, h);
    _img1.frame = CGRectMake(lab3.frame.origin.x, CGRectGetMaxY(labAddress.frame), 15, 15);
    labTime.frame = CGRectMake(CGRectGetMaxX(_img1.frame)+10, _img1.frame.origin.y, labAddress.frame.size.width-25, 20);
    _labbottom.frame = CGRectMake(0, CGRectGetMaxY(labTime.frame)+10, SCREEN_WIDTH, 5);
    self.currHeight = CGRectGetMaxY(_labbottom.frame);
    return YES;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
