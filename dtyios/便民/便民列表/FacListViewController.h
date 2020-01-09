//
//  SchoolCourseViewController.h
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "UIViewControllerEx.h"
#import "UITableViewExViewController.h"

#import "AFAppDotNetAPIClient.h"
#import "SchoolCourseDelegate.h"
#import "FacListCurriculumEntity.h"
#import "baiduMap.h"
@interface FacListViewController : UIViewControllerEx<UITableViewExViewDelegate,baiduMapDelegate>
{
    UITableViewExViewController *CourseTableview;
    
    NSString *currTag;
    NSString *city;
    
    //int updataCount;
}
@property(nonatomic,strong)NSMutableDictionary *tag;
@property(nonatomic,strong)NSMutableDictionary *sort;
@property(nonatomic,strong)NSMutableDictionary *area;
@property(nonatomic,strong)NSMutableDictionary *types;
@property(nonatomic,strong)FacListCurriculumEntity *entity;


@property(nonatomic,weak)id<SchoolCourseDelegate> delegate;
@property(nonatomic,strong)NSMutableDictionary *dic_school_info;

-(void)pullUpdateData;
@end
