//
//  JYGLListCell.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/24.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "JYGLListCell.h"
#import "warningElevatorModel.h"
@interface JYGLListCell ()

@end

@implementation JYGLListCell

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
    self.currHeight=100;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    
    //2.data
    warningElevatorModel *warnmodel=(warningElevatorModel *)aObject_entity;
    
    //103438
    _labID.text=warnmodel.Lift. LiftNum;
    _labID.layer.masksToBounds = YES; //没这句话它圆不起来
    _labID.layer.cornerRadius = 5; //设置图片圆角的尺度
    
    //已安装
    NSString *zt=@"未完成";
    if([warnmodel.TotalLossTime isEqual:@"1"])
        zt=@"已完成";
    _labStatus.text=[NSString stringWithFormat:@"检验状态：%@", zt];
    
    
    //后面的地址
    _labAddr.text=warnmodel.Lift.InstallationAddress;
    //_labStatus.text=@"";
    
    //2.1 CreateTime 并且计算 totalTime
    //上面的日期
    NSArray *Time = [warnmodel.CreateTime componentsSeparatedByString:@"."];
    NSArray *cTime = [[Time objectAtIndex:0] componentsSeparatedByString:@"T"];
    if(![[cTime objectAtIndex:0] isEqual:@"<null>"]&&![[cTime objectAtIndex:0] isEqual:@""])
        _labDate.text=[NSString stringWithFormat:@"%@ %@",  [cTime objectAtIndex:0], [cTime objectAtIndex:1]];
    else
        _labDate.text=@"";
    
    UIImageView *img=[[UIImageView alloc]init];
    img.image=[UIImage imageNamed:@"Data_time"];
    img.frame=CGRectMake(bounds_width.size.width-155, _labDate.frame.origin.y+5, 15, 15);
    [self.contentView addSubview:img];
    
    
    //3.frame
    _labBack.frame=CGRectMake(_labBack.frame.origin.x, _labBack.frame.origin.y, bounds_width.size.width-3,_labBack.frame.size.height);
    _viewRight.frame=CGRectMake(_viewRight.frame.origin.x, _viewRight.frame.origin.y, bounds_width.size.width-50,_viewRight.frame.size.height);
    _labLine.frame=CGRectMake(_labLine.frame.origin.x, _labLine.frame.origin.y, bounds_width.size.width,_labLine.frame.size.height);
    _labStatus.frame=CGRectMake(_labStatus.frame.origin.x, _labStatus.frame.origin.y, bounds_width.size.width-73-52,_labStatus.frame.size.height);
    _labAddr.frame=CGRectMake(_labAddr.frame.origin.x, _labAddr.frame.origin.y, bounds_width.size.width-120,_labAddr.frame.size.height);
    _labDate.frame=CGRectMake(bounds_width.size.width-_labDate.frame.size.width-10, _labDate.frame.origin.y, _labDate.frame.size.width,_labDate.frame.size.height);
    _labTime.frame=CGRectMake(bounds_width.size.width-70-53-30, _labTime.frame.origin.y, 70,_labTime.frame.size.height);
    return YES;
    
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
