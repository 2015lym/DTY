//
//  ProblemTopView.m
//  AlumniChat
//
//  Created by xiaoanzi on 15/10/27.
//  Copyright © 2015年 xiaoanzi. All rights reserved.
//
#define TabWidth 50
#import "ProblemTopView.h"
#import "Util.h"
@implementation ProblemTopView
@synthesize delegate;
@synthesize btn_01;
@synthesize btn_02;
@synthesize btn_add;
//初始化
-(void)initview
{
//    [self setBackgroundColor:[UIColor redColor]];
    for (UIView *view_header_item in [scoll_view subviews]) {
        if (view_header_item.tag!=1999&&view_header_item.tag!=0&&view_header_item.tag!=-1) {
            [view_header_item removeFromSuperview];
        }
    }
    Array_btn=[NSMutableArray array];
    
    //btn_01
    [Array_btn addObject:btn_01];
    [self Btn_OnClick:btn_01];
    btn_01.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    CGSize detailSize = [btn_01.titleLabel.text sizeWithFont:btn_01.titleLabel.font constrainedToSize:CGSizeMake(200, MAXFLOAT)];
    //按钮大小
    btn_01.frame=CGRectMake(0,0, detailSize.width<TabWidth?TabWidth:detailSize.width,self.frame.size.height-2);
    
    //按钮宽度
    CGRect rect=CGRectMake(btn_01.frame.size.width, 0, 0, 0);
    
    
    //btn_02
    [Array_btn addObject:btn_02];
    //[self Btn_OnClick:btn_01];
    btn_02.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    detailSize = [btn_02.titleLabel.text sizeWithFont:btn_02.titleLabel.font constrainedToSize:CGSizeMake(200, MAXFLOAT)];
    //按钮大小
    btn_02.frame=CGRectMake(btn_01.frame.size.width,0, detailSize.width<TabWidth?TabWidth:detailSize.width,self.frame.size.height-2);
    //按钮宽度
    rect=CGRectMake(btn_02.frame.size.width+btn_01.frame.size.width, 0, 0, 0);

    
    int i=0;
    
    for (NSString *dic in self.All_array ) {
        
        UIButton *btn=[[UIButton alloc]init];
        
        btn.tag=i+1;
        //字号
        btn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [btn addTarget:self action:@selector(Btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [btn setTitleColor:[UIColor colorWithRed:132.f/255.0f green:132.f/255.0f  blue:132.f/255.0f  alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:231.f/255.0 green:109.f/255.0 blue:0.f/255.0 alpha:1] forState:UIControlStateSelected];
        
        NSString *str=[NSString stringWithFormat:@"%@",dic];
        if (str==nil||[str isEqualToString:@"<null>"]) {
            str=@"错误了";
        }
        //按钮的字
        [btn setTitle:str forState:UIControlStateNormal];
        //传过来文字 长度
        CGSize detailSize = [str sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToSize:CGSizeMake(200, MAXFLOAT) ];
        //按钮位置->带下划线的btn起始的btn_01.x圆点+宽+8
        btn.frame=CGRectMake(rect.origin.x+rect.size.width+8, 0, detailSize.width<TabWidth?TabWidth:detailSize.width,self.frame.size.height-2);
        
        rect=btn.frame;
        [Array_btn addObject:btn];
        [scoll_view addSubview:btn];
        scoll_view.contentSize=CGSizeMake(btn.frame.origin.x+btn.frame.size.width, 0);
        i++;
    }
        iamge_ling.frame=CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
}
-(IBAction)Btn_OnClick:(id)sender
{
    if (BtnOnClick) {
        BtnOnClick.selected=NO;
    }
    BtnOnClick=sender;
    
    
   for(UIButton *b in Array_btn)
   {
       b.titleLabel.font = [UIFont systemFontOfSize: 14.0];
   }
   BtnOnClick.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    downLine.frame=CGRectMake(BtnOnClick.frame.origin.x, 40, BtnOnClick.frame.size.width, downLine.frame.size.height);
    
    
    
    BtnOnClick.selected=YES;
    CGRect rect=image_bg.frame;
    
    rect.origin.x=BtnOnClick.frame.origin.x;
    
    rect.origin.y=self.frame.size.height-2.5;
    
    rect.size.width=BtnOnClick.frame.size.width;
    
    [UIView beginAnimations:nil context:nil];
    image_bg.frame=rect;
    [UIView commitAnimations];
    
    [UIImageView setAnimationBeginsFromCurrentState:YES];
    float a = scoll_view.contentSize.width;
    //判断按钮 位置与scoll_View 偏移量
    if (rect.origin.x+rect.size.width+(scoll_view.frame.size.width/2)>a) {
        if (a>=scoll_view.frame.size.width) {
            [scoll_view setContentOffset:CGPointMake(a-scoll_view.frame.size.width, 0) animated:YES];
        }
        
    }
    else
    {
        int originX=CGRectGetMaxX(rect)-rect.size.width-scoll_view.frame.size.width/2+rect.size.width/2;
        if (originX>0) {
            int abc= bounds_width.size.width-scoll_view.frame.size.width;
            [scoll_view setContentOffset:CGPointMake(originX-abc/2, 0) animated:YES];
        }
        else
        {
            [scoll_view setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
    }
    if (BtnOnClick.tag==-1) {
        
        [delegate Problemtop_Btn_New];
        [scoll_view setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (BtnOnClick.tag==0) {
        [delegate Problemtop_Btn_Area];
    }
    else
    {
        [delegate Problemtop_Btn_OnClick:[_All_array objectAtIndex:BtnOnClick.tag-1] sender:BtnOnClick];
    }
}
-(void)scrollView_Did_EndDecelerating:(CGFloat)contentOffset
{
    int tag=(int)contentOffset/bounds_width.size.width;
    tag=tag-1;
    for (UIButton *btn in Array_btn) {
        int btnTag=(int)btn.tag;
        if (tag==btnTag) {
            [self Btn_OnClick:btn];
        }
    }
}
-(IBAction)btn_addLable:(id)sender
{
    [delegate btn_OnClick_add];
    if (btn_add.selected) {
        btn_add.selected=NO;
    }
    else
    {
        btn_add.selected=YES;
    }
}
-(void)setBtn_01_title:(NSString *)title
{
    [btn_01 setTitle:title forState:UIControlStateNormal];
    [btn_01 setTitleColor:[UIColor colorWithRed:132.f/255.0f green:132.f/255.0f  blue:132.f/255.0f  alpha:1] forState:UIControlStateNormal];
    [btn_01 setTitleColor:[UIColor colorWithRed:231.f/255.0 green:109.f/255.0 blue:0.f/255.0 alpha:1] forState:UIControlStateSelected];
    
    CGSize titleSize=[title sizeWithFont:btn_01.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    
    CGRect rect=btn_01.frame;
    
    rect.size.width=titleSize.width;
    
    [btn_01 setFrame:rect];
    
    rect=image_bg.frame;
    
    rect.size.width=btn_01.frame.size.width;
    [image_bg setFrame:rect];
}

-(void)setBtn_02_title:(NSString *)title
{
     btn_02.titleLabel.text=title;
    [btn_02 setTitle:title forState:UIControlStateSelected];
     [btn_02 setTitle:title forState:UIControlStateNormal];
}
@end
