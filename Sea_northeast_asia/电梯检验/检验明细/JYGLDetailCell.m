//
//  JYGLDetailCell.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/24.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "JYGLDetailCell.h"
#import "warningElevatorModel.h"
@interface JYGLDetailCell ()
{
    NSDictionary * warnmodel;
}
@end

@implementation JYGLDetailCell

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
    self.currHeight=220;
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    
    //2.data
    warnmodel=(NSDictionary *)aObject_entity;
    _labTitle.text=[NSString stringWithFormat:@"%@、%@", [warnmodel objectForKey:@"ID"] ,[warnmodel objectForKey:@"StepName"]];
    _labConcent.text=[CommonUseClass FormatString: [warnmodel objectForKey:@"Remark"]];
    NSString *str_time=[CommonUseClass FormatString:[warnmodel objectForKey:@"CreateTime1"]];
    if(str_time.length>16)
    str_time=[str_time substringToIndex:16];
    _labDate.text = [str_time stringByReplacingOccurrencesOfString:@"T" withString:@" "];;
   
    _labName.text=[CommonUseClass FormatString:[warnmodel objectForKey:@"UserName"]];
    
    _lab_back1.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _lab_back1.layer.borderWidth=1.0f;
    _lab_back1.layer.masksToBounds = YES;
    _lab_back1.layer.cornerRadius = 4;
   
    
    _lab_back2.layer.borderColor= [UIColor colorWithHexString:@"#3574fa"].CGColor;
    _lab_back2.layer.borderWidth=1.0f;
    _lab_back2.layer.masksToBounds = YES;
    _lab_back2.layer.cornerRadius = 4;
    
    _viewRight.frame=CGRectMake((bounds_width.size.width-120)/2
                                , _viewRight.frame.origin.y, 100, _viewRight.frame.size.height);
   
    [_btn_look addTarget:self action:@selector(dianZanBtn:) forControlEvents:UIControlEventTouchUpInside];

    return YES;
    
}
- (void)setFrame:(CGRect)frame
{
    float width=bounds_width.size.width;
    
    frame.size.width = width;
    [super setFrame:frame];
    
}
- (void)dianZanBtn:(UIButton *)sender {
    
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsPhoto"]] isEqual:@"1"] )
    {
        if([[CommonUseClass FormatString: [warnmodel objectForKey:@"PhotoUrl"]] isEqual:@""])
        {
            return;
        }
        else
        {
            [self showImage:[CommonUseClass FormatString: [warnmodel objectForKey:@"PhotoUrl"]]];
        }
    }
    if([[CommonUseClass FormatString: [warnmodel objectForKey:@"IsVideo"]] isEqual:@"1"])
       {
       if([[CommonUseClass FormatString: [warnmodel objectForKey:@"VideoPath"]] isEqual:@""])
       {
        return;
       }
    else
    {
        [self showVideo:[CommonUseClass FormatString: [warnmodel objectForKey:@"VideoPath"]]];
    }
       }
    
    
    
}
#pragma mark video
-(void)showVideo:(NSString *)PhotoUrl{
    PhotoUrl= [PhotoUrl stringByReplacingOccurrencesOfString:@"~" withString:Ksdby_api_Img];
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:PhotoUrl,@"textOne",self,@"textTwo", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"showVideo" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
#pragma mark 查看大图


-(void)showImage1:(UIImage *)img{
    item=[[UIImageView alloc]initWithImage:img];
    
    int counts = 1;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:counts];
    
    // 替换为中等尺寸图片
    MJPhoto *photo = [[MJPhoto alloc] init];
    UIImage *currImage=item.image;
    photo.image=currImage;
    photo.srcImageView=item;
    [photos addObject:photo];
    
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.isShowBar=YES;
    [browser show];
    
    
    //[self.navigationController pushViewController:browser animated:YES];//
    
}

-(void)showImage:(NSString *)PhotoUrl{
    
    // 替换为中等尺寸图片
    PhotoUrl= [PhotoUrl stringByReplacingOccurrencesOfString:@"~" withString:Ksdby_api_Img];
    UIImage *img=[UIImage imageWithData:[NSData
                                         dataWithContentsOfURL:[NSURL URLWithString:PhotoUrl]]];
    [self showImage1:img];
    
    
    
    
//    int counts = 1;
//    // 1.封装图片数据
//    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:counts];
//
//        // 替换为中等尺寸图片
//    PhotoUrl= [PhotoUrl stringByReplacingOccurrencesOfString:@"~" withString:Ksdby_api_Img];
//
//
//
//    //添加 字典，将label的值通过key值设置传递
//    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:PhotoUrl,@"textOne",self,@"textTwo", nil];
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"showImage" object:nil userInfo:dict];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    

    
}
@end
