
//
//  CourseHearView.m
//  AlumniChat
//
//  Created by SongQues on 16/7/1.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "CourseHearView.h"
#import "EGOImageView.h"
#import "InteractionTwoViewController.h";
@implementation CourseHearView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIView *)initview:(NSMutableArray *)arr
{
    arr_data=arr;
    self.backgroundColor=[UIColor whiteColor];
    float height_s=bounds_width.size.width/320;
     CGRect rect=CGRectMake(0, 0, bounds_width.size.width, 150*height_s);
    NSMutableArray *arr_imageUrl=[NSMutableArray array];
    NSMutableArray *arr_imageTitle=[NSMutableArray array];
    for (int i=0;i<arr.count;i++)  {
        if(i>=_showCount)break;
        NSMutableDictionary *dic_item=[arr objectAtIndex:i];

         NSMutableArray *newsImageList=[NSMutableArray arrayWithArray:[dic_item objectForKey:@"newsImageList"]];
        if(newsImageList.count>0)
        {
        NSMutableDictionary *dic_image=newsImageList[0];
         NSString *str_url=[NSString stringWithFormat:@"%@",[dic_image objectForKey:@"address"]];
        //NSString *str_url=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"newsImage"]];
        NSURL *imageurl=[NSURL URLWithString:str_url];

        [arr_imageUrl addObject:imageurl];
        }
        [arr_imageTitle addObject:[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"newsTitle"]]];
        
    }
    rect.size.height=rect.size.height+10;
    UIImageView *image_ling=[[UIImageView alloc] init];
    image_ling.frame=CGRectMake(0, rect.size.height-5, bounds_width.size.width, 5);
    image_ling.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"view_BackgroundColor"]];
    [self addSubview:image_ling];
    [self setFrame:rect];
    [self initSDCycleScrollView:rect _imagesURLStrings:arr_imageUrl _imagesTitles:arr_imageTitle];
    return self;
}
-(void)initSDCycleScrollView:(CGRect)frame _imagesURLStrings:(NSMutableArray *)imagesURLStrings _imagesTitles:(NSMutableArray *) imagesTitles
{
    UIImage *currimage=[UIImage imageNamed:@"placeholder.png"];
    bannerView = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:nil placeholderImage:currimage];
    bannerView.imageURLStringsGroup = imagesURLStrings;
    bannerView.titlesGroup=imagesTitles;
    bannerView.titleLabelTextColor=[UIColor whiteColor];
    bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    bannerView.delegate = self;
    bannerView.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    bannerView.placeholderImage = [UIImage imageNamed:@"placeholder.png"];
    [self addSubview:bannerView];
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSMutableDictionary *dic_value=arr_data[index];
    NSString *str_newid=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"newsId"]];
    NSString *srt_url=[NSString stringWithFormat:@"%@newsDetail.html?newsId=%@",Ksdby_api,str_newid];
    InteractionTwoViewController *ctvc=[[InteractionTwoViewController alloc] init];
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    [ctvc setUrl:srt_url];
    
    
    //分享
    ctvc.infoUrl=[NSString stringWithFormat:@"%@newsDetail_share.html?newsId=%@",Ksdby_api,str_newid];
    ctvc.infoTitle=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"newsTitle"]];
    ctvc.infoMemo=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"summary"]];
    ctvc.infoImage=@"";
    NSMutableArray *newsImageList=[NSMutableArray arrayWithArray:[dic_value objectForKey:@"newsImageList"]];
    if(newsImageList.count>0)
    {
        NSMutableDictionary *dic_image=newsImageList[0];
        ctvc.infoImage=[NSString stringWithFormat:@"%@",[dic_image objectForKey:@"address_x"]];
    }
    //分享

    
     [_delegate CourseHearOnClick:ctvc];
}
@end
