//
//  RoomTableViewCell.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/27.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "RoomTableViewCell.h"

@implementation RoomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source
{
    self.currHeight = 60;
    
    NSMutableDictionary *dic_info=[NSMutableDictionary dictionaryWithDictionary:aObject_entity];
    
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height+50);
    
    self.lab_Name.text = [NSString stringWithFormat:@"%@",[CommonUseClass FormatString:[dic_info objectForKey:@"RoomName"]]];
    self.lab_Detail.text = [NSString stringWithFormat:@"%@",[CommonUseClass FormatString:[dic_info objectForKey:@"RoomID"]]];
    
    
    
    self.lab_Name.frame = CGRectMake(10, 20, SCREEN_WIDTH/3, 20);
    self.lab_Detail.frame = CGRectMake(SCREEN_WIDTH-200, 20, 180, 20);
    self.lab_Detail.textAlignment = NSTextAlignmentRight;
    self.line.frame = CGRectMake(0, 59, SCREEN_WIDTH, 1);
    self.line.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    
    return YES;
}

@end
