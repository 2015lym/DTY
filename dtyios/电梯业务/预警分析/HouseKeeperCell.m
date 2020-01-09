//
//  HouseKeeperCell.m
//  Sea_northeast_asia
//
//  Created by SinodomMac02 on 17/3/27.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "HouseKeeperCell.h"

@implementation HouseKeeperCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    self.currHeight=44;
    
    NSMutableDictionary *dic_info=[NSMutableDictionary dictionaryWithDictionary:aObject_entity];
    
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height);
    self.line.frame=CGRectMake(0, 43, bounds_width.size.width, 1);
    self.imgView.frame=CGRectMake(bounds_width.size.width-30, 11.5, 20, 20);
    self.advisor.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"Name"]];

    self.imgView.image=[UIImage imageNamed:@"ic_arrow_right"];
    self.imgView_type.image=[UIImage imageNamed:[dic_info objectForKey:@"img"]];
    
    
    return YES;
    
}

@end
