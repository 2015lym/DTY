//
//  rescueListCell.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/9.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "rescueListCell.h"
#import "warningElevatorModel.h"
@implementation rescueListCell
{
    warningElevatorModel *warnmodel;
}
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
  //1.all set
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height+50);
    self.currHeight=120;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    
    //2.data
    warnmodel=(warningElevatorModel *)aObject_entity;
    _labID.text=warnmodel.Lift. LiftNum;
    _labID.layer.masksToBounds = YES; //没这句话它圆不起来
    _labID.layer.cornerRadius = 5; //设置图片圆角的尺度
    _labStatus.text=warnmodel.StatusName;
    if([warnmodel.StatusName isEqual:@"<null>"])_labStatus.text=@"";
    _labAddr.text=[warnmodel.Lift.AddressPath stringByAppendingString:warnmodel.Lift.InstallationAddress];
    //2.1CreateTime 并且 计算totalTime
    _labTotalTime.text=[warnmodel.TotalLossTime stringByAppendingString:@"分钟"];
    _labDate.text=[warnmodel.CreateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
   
    
    
    
   //3.frame
    _labBack.frame=CGRectMake(_labBack.frame.origin.x, _labBack.frame.origin.y, bounds_width.size.width-3,_labBack.frame.size.height);
     _viewRight.frame=CGRectMake(_viewRight.frame.origin.x, _viewRight.frame.origin.y, bounds_width.size.width-50,_viewRight.frame.size.height);
      _labLine.frame=CGRectMake(_labLine.frame.origin.x, _labLine.frame.origin.y, bounds_width.size.width,_labLine.frame.size.height);
   _labStatus.frame=CGRectMake(_labStatus.frame.origin.x, _labStatus.frame.origin.y, bounds_width.size.width-73-52,_labStatus.frame.size.height);
     _labAddr.frame=CGRectMake(_labAddr.frame.origin.x, _labAddr.frame.origin.y, bounds_width.size.width-73-52,_labAddr.frame.size.height);
    
    
    UIButton *btn_picture=[MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH-40, self.currHeight-35, 30, 30) imageName:@"" bgImageName:@"wyxc_camera" title:@"" SEL:@selector(btnClick_picture:) target:self];
    [self.contentView addSubview:btn_picture];
    
    return YES;
}
- (void)btnClick_picture:(UIButton *)btn
{
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:warnmodel.LiftId,@"guid",warnmodel.ID,@"TaskId", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_showPicture" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)setFrame:(CGRect)frame
{
    float width=bounds_width.size.width;
    
    frame.size.width = width;
    [super setFrame:frame];
    
}

-(void)btnPressedArea:(id)sender
{
    
    UIButton *myBtn = (UIButton *)sender;
    //[_delegate baiduMapPush:longitude for:latitude];
    NSString *tag= [NSString stringWithFormat:@"%ld",(long)myBtn.tag];
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:tag,@"textOne",self,@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhiSignUp" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
}

@end
