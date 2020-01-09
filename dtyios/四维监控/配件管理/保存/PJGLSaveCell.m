//
//  PJGLSaveCell.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/19.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "PJGLSaveCell.h"
#import "CommonUseClass.h"
@implementation PJGLSaveCell
- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
{
    //return true;
    //1.all set
    self.backgroundColor=[UIColor whiteColor];
    self.currHeight=120;
    //self.selectionStyle= UITableViewCellSelectionStyleNone;
    NSDictionary *dic = (NSDictionary*)aObject_entity;
    
    
    _labName.text=[CommonUseClass FormatString:dic[@"ProductName"]];
    _labNum.text=[CommonUseClass FormatString:dic[@"Model"]];
    
    _labType.text=[CommonUseClass FormatString:dic[@"Brand"]];
    if(![[CommonUseClass FormatString:dic[@"InstallationTime"]] isEqual:@""])
    {
        _labTime.text=[CommonUseClass getDateString: [CommonUseClass FormatString:dic[@"InstallationTime"]]];
    if(_labTime.text.length>16)
       _labTime.text=[_labTime.text substringToIndex:16];
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
