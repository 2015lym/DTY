//
//  HomeViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/27.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavViewControllerEx.h"
#import "ProblemTopView.h"
#import "LableTopViewController.h"
#import "AFAppDotNetAPIClient.h"
#import "LeftWebViewController.h"
#import "appDelegate.h"
//#import "HomeShowPersonDelegate.h"
#import "SchoolCourseViewController.h"
#import "SelectSchoolViewController.h"
@interface HomeViewController : UINavViewControllerEx<ProblemTopViewDelegate,LableTopViewDelegate,SchoolCourseDelegate,UIScrollViewDelegate,SelectAreaDelegate>
{
    
    __weak IBOutlet UIView *areachang;
    IBOutlet UIView *topview;
    ProblemTopView *prolemtopview;
    LableTopViewController *lableTopVC;
    UIImageView *imageView_title;
    
    UICollectionView *firstCollection;
    UIScrollView *scrollView;
    //课程
    int currPage;
    SchoolCourseViewController *scvc;
   
    SchoolCourseViewController *scvc_area;
    NSString *areaId1;
    NSString *areaName1;
    NSString *str_CachePath_AreasAll;
    NSString *DWareaId;
    NSString *DWareaName;
    
    NSMutableArray* scvcs;

    
    
    
    NSMutableArray* allTags;
    NSMutableArray* tags;
    
    NSString * str_CachePath_TagsSelect;//缓存标签路径
    NSString * str_CachePath_TagsAll;//缓存标签路径
    
    UIButton *currButton;
}
-(void)refRefshView;
-(void)loginMethod;
- (IBAction)areachangeClick:(id)sender;

@property(nonatomic,strong)NSMutableArray *lable_info;
@property (nonatomic,strong) AppDelegate *app;
@end
