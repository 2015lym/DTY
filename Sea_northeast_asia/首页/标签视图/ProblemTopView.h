//
//  ProblemTopView.h
//  AlumniChat
//
//  Created by xiaoanzi on 15/10/27.
//  Copyright © 2015年 xiaoanzi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ProblemTopViewDelegate <NSObject>
@required
-(void)Problemtop_Btn_New;
-(void)Problemtop_Btn_Area;
-(void)Problemtop_Btn_OnClick:(NSMutableDictionary *)dic_tags sender:(id)sender;
-(void)btn_OnClick_add;
@end
@interface ProblemTopView : UIView
{
    IBOutlet UIScrollView *scoll_view;
    IBOutlet UIImageView *image_bg;
    IBOutlet UIButton *btn_01;
    
    IBOutlet UIButton *btn_02;
    UIButton *BtnOnClick;
    NSMutableArray *Array_btn;//所有按钮的集合
    IBOutlet UIImageView *iamge_ling;
    
    IBOutlet UIButton *btn_add;
    
    
    __weak IBOutlet UILabel *downLine;
}
@property (nonatomic ,strong)id<ProblemTopViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *All_array; //所有标签集合
@property(nonatomic,strong)IBOutlet UIButton *btn_01;
@property(nonatomic,strong)IBOutlet UIButton *btn_02;
@property(nonatomic,strong)IBOutlet UIButton *btn_add;
-(void)initview;
-(void)scrollView_Did_EndDecelerating:(CGFloat)contentOffset;
-(IBAction)Btn_OnClick:(id)sender;
-(IBAction)btn_addLable:(id)sender;
-(void)setBtn_01_title:(NSString *)title;
-(void)setBtn_02_title:(NSString *)title;
@end
