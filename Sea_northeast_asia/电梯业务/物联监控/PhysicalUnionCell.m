//
//  PhysicalUnionCell.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "PhysicalUnionCell.h"
#import "CommonUseClass.h"
@implementation PhysicalUnionCell
- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
{
    //return true;
    //1.all set
    self.backgroundColor=[UIColor whiteColor];
    self.currHeight=117;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    NSDictionary *dic = (NSDictionary*)aObject_entity;
    NSString *str_time = [CommonUseClass FormatString:dic[@"UpdateDatetime"]];
    self.labAddress.text = [CommonUseClass FormatString:dic[@"InstallationAddress"]];
    self.labNum.text = [CommonUseClass FormatString:dic[@"LiftNum"]];
    self.labShield.text = [NSString stringWithFormat:@"状态:%@",[CommonUseClass FormatString:dic[@"MaintenancePeriod"]]];
    //2.data
    if ([str_time isEqualToString:@""]) {
        self.imgtime.hidden = YES;
    }
    else {
        str_time = [[str_time componentsSeparatedByString:@" "]firstObject];
        str_time = [str_time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        str_time = [str_time substringToIndex:16];
    }
    self.labTime.text = str_time;
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
