//
//  videoDetalCell.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/13.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "videoDetalCell.h"

@interface videoDetalCell ()

@end

@implementation videoDetalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
{
    //return true;
    //1.all set
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height+50);
    self.currHeight=80;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    
    //2.data
    NSMutableDictionary *dic_info=[NSMutableDictionary dictionaryWithDictionary:aObject_entity];
    _lblPhone.text=[CommonUseClass FormatString:[dic_info objectForKey:@"Phone"]];
    _lbl_name.text=[CommonUseClass FormatString:[dic_info objectForKey:@"UserName"]];
        _lblRoleName.text=[NSString stringWithFormat:@"(%@)",[CommonUseClass FormatString:[dic_info objectForKey:@"RoleName"]]];
    
    //2.1
    NSString *state=[CommonUseClass FormatString:[dic_info objectForKey:@"State"]];
    NSString *statename=@"";
    if([state isEqual:@"1"])
    {
        statename=@"已接听";
        _lblState.textColor=[UIColor blueColor];
    }
    else if([state isEqual:@"2"])
    {
        statename=@"未接听";
        _lblState.textColor=[UIColor redColor];
    }
    
    _lblState.text=statename;
    return YES;
}

@end
