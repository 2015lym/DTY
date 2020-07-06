//
//  MainViewController_dtjy.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/23.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MainViewDelegate.h"
#import "Util.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@interface MainViewController_dtjy : UITabBarController<MainViewDelegate,LeftViewDelegate,RightViewDelegate>
{
    UIView *view_tabBar;
    UIButton *btn_Current;
    UIImage *image_btnCurrent;
    BOOL isloadview;
    
    UIView *view_badge_2001;
    UIView *view_badge_2002;
    UIView *view_badge_2003;
    UIView *view_badge_2004;
    UILabel *lab_badge_2001;
    UILabel *lab_badge_2002;
    UILabel *lab_badge_2003;
    UILabel *lab_badge_2004;
    
    UIImageView *image_badge_2001;
    UIImageView *image_badge_2002;
    UIImageView *image_badge_2003;
    UIImageView *image_badge_2004;
    
    UIButton *btn_left1;
    UIButton *btn_left2;
    UIButton *btn_left3;
    UIButton *btn_left4;
    
    UILabel *lab_1;
    UILabel *lab_2;
    UILabel *lab_3;
    UILabel *lab_4;
    
    UIButton *left_BarButton_Item;
    UILabel *lab_Item;
    UIBarButtonItem *addItem;
    UIButton *right_BarButoon_Item;
    UIBarButtonItem *rightItem;
    UIBarButtonItem *rightItem1;
    LeftViewController * lableVC;
    RightViewController * rightVC;
    BOOL isMessage;
}
@property (nonatomic,strong) AppDelegate *app;
-(void)pushWebview:(NSString *)url info:(NSDictionary *)info;
-(void)setIsMessage:(BOOL)message;
@end
