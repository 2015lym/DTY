//
//  videoHistroyCell.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/13.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "videoHistroyCell.h"

@interface videoHistroyCell ()

@end

@implementation videoHistroyCell

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
    _lblPhone.text=[CommonUseClass FormatString:[dic_info objectForKey:@"FromPhone"]];
    _lbl_name.text=[CommonUseClass FormatString:[dic_info objectForKey:@"FromUserName"]];
    _lblRoleName.text=[NSString stringWithFormat:@"(%@)",[CommonUseClass FormatString:[dic_info objectForKey:@"FromRoleName"]]];
    
    //2.1time
    NSString *CreateTime=[CommonUseClass FormatString:[dic_info objectForKey:@"CreateTime"]];
    NSString *EndTime=[CommonUseClass FormatString:[dic_info objectForKey:@"EndTime"]];
    if(![CreateTime isEqual:@""]&&![EndTime isEqual:@""])
    {
    //首先创建格式化对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //然后创建日期对象
    NSDate *date1 = [dateFormatter dateFromString:CreateTime];
    NSDate *date = [dateFormatter dateFromString:EndTime];
    
    //计算时间间隔（单位是秒）
    NSTimeInterval time = [date timeIntervalSinceDate:date1];
        _lblTime.text=   [CommonUseClass getMMSSFromSS:[NSString stringWithFormat:@"%f",time]];        
    }
    
    //2.3 img
    NSString *state=[CommonUseClass FormatString:[dic_info objectForKey:@"State"]];
    NSString *statename=@"";
    if([state isEqual:@"0"])
        statename=@"video_history_out";
    else if([state isEqual:@"1"])
        statename=@"video_history_in";
    else if([state isEqual:@"2"])
        statename=@"video_history_no";
    
    _imgHead.image=[UIImage imageNamed:statename];
    
    return YES;
}

@end
