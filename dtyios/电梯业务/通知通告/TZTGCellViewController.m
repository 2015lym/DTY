//
//  TZTGCellViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/15.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "TZTGCellViewController.h"
#import "CommonUseClass.h"
@interface TZTGCellViewController ()

@end

@implementation TZTGCellViewController

- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
{
    //return true;
    //1.all set
    self.backgroundColor=[UIColor whiteColor];
    self.currHeight=90;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    NSDictionary *dic = (NSDictionary*)aObject_entity;
    NSString *str_time = [CommonUseClass FormatString:dic[@"CreateTime"]];
    self.labAddress.text = [CommonUseClass FormatString:dic[@"Title"]];
    NSDictionary *dic1=dic[@"NoticeTypeName"];
    str_time=[str_time substringToIndex:16];
    self.labTime.text = [str_time stringByReplacingOccurrencesOfString:@"T" withString:@" "];;
    
    //2.data
    if ([str_time isEqualToString:@""]) {
        self.imgtime.hidden = YES;
    }
    
    NSString *str=[CommonUseClass FormatString:dic1[@"DictCode"]];
    NSString *str1=@"TZ";
    if([str  isEqual:str1] )
    {
        
    }
    else
    {
        _imgtime.image=[UIImage imageNamed:@"tztg_proclamation"];
        self.labNum.text =[CommonUseClass FormatString:dic1[@"DictName"]];;
    }
    
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
