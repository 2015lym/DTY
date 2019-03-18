//
//  CourseTableViewCell.m
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "EventCourseTableViewCell.h"
#import <CoreText/CoreText.h>
#import "signUpViewController.h"
@implementation EventCourseTableViewCell

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
    NSMutableDictionary *dic_info=[NSMutableDictionary dictionaryWithDictionary:aObject_entity];
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height+50);
    
    lab_title.text=[NSString stringWithFormat:@"  %@",[dic_info objectForKey:@"actTitle"]];
    lab_start.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"actStart"]];
     lab_end.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"actEnd"]];
     lab_nameCount.text=[NSString stringWithFormat:@"已有%@人报名",[dic_info objectForKey:@"encount"]];
    
    
         //self.frame=CGRectMake(0, 0, bounds_width.size.width, 217);
    
    //self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,217);
    //self.contentView.frame = [UIScreen mainScreen].bounds;
    self.currHeight=217;
    lab_title.frame=CGRectMake(lab_title.frame.origin.x+10, lab_title.frame.origin.y, bounds_width.size.width-20,lab_title.frame.size.height);
    image_Header.frame=CGRectMake(image_Header.frame.origin.x+10, image_Header.frame.origin.y, bounds_width.size.width-30,image_Header.frame.size.height);
     lab_back.frame=CGRectMake(lab_back.frame.origin.x+10, lab_back.frame.origin.y, bounds_width.size.width-20,lab_back.frame.size.height);
    
       memoView.frame=CGRectMake(bounds_width.size.width-142, memoView.frame.origin.y, memoView.frame.size.width,memoView.frame.size.height);

    
    image_Header.image=[UIImage imageNamed:@"placeholder.png"];
    [image_Header setupView:[UIImage imageNamed:@"placeholder.png"] delegate:nil];
    NSString *str_url=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"actImage"]];
    NSURL *imageurl=[NSURL URLWithString:str_url];
    image_Header.imageURL=imageurl;
    
   self.selectionStyle= UITableViewCellSelectionStyleNone;
  
    //报名
    NSString *str_isEnd=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"isEnd"]];
        NSString *str_actId=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"actId"]];
     NSString *str_isEnroll=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"isEnroll"]];
    _btnArea =[[UIButton alloc]init];
    // 设置事件
    
    _btnArea .frame=CGRectMake(10, 120, 112, 35) ;
    _btnArea.backgroundColor=[UIColor blueColor];
    _btnArea.layer.masksToBounds = YES; //没这句话它圆不起来
    _btnArea.layer.cornerRadius = 5; //设置图片圆角的尺度
    _btnArea.tag=[str_actId intValue];
    [memoView addSubview:_btnArea];
    if([str_isEnd isEqualToString:@"1"])
    {
        [_btnArea setTitle:@"已结束" forState:UIControlStateNormal];
        
        [_btnArea setBackgroundColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]] ;

    }
    else if ([str_isEnroll isEqualToString:@"1"])
    {
        [_btnArea setTitle:@"已报名" forState:UIControlStateNormal];
        [_btnArea setBackgroundColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]] ;
    }
    else
    {
        [_btnArea setTitle:@"立即报名" forState:UIControlStateNormal];
        [_btnArea setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:128.f/255.f blue:0.f/255.f alpha:1]] ;
        [_btnArea addTarget:self action:@selector(btnPressedArea:) forControlEvents:UIControlEventTouchUpInside];
    }
    
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
