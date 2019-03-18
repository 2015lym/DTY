//
//  SelectSchoolViewController.h
//  AlumniChat
//
//  Created by xiaoanzi on 15-3-24.
//  Copyright (c) 2015年 xiaoanzi. All rights reserved.
//

#import "UIViewControllerEx.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "SchoolEntity.h"
#import "SectionsViewController.h"
#import "UserInfoEntity.h"
#import "MBProgressHUD.h"
@protocol SelectAreaDelegate <NSObject>

@required
-(void)returnAreainfo:(NSString *)areaId forAreaname :(NSString *)areaName;
@end
@interface SelectSchoolViewController : UIViewControllerEx<UITableViewDataSource,UITableViewDelegate>//,SecondViewControllerDelegate
{
    IBOutlet UITableView *table_view;
    IBOutlet UIView *view_Content;
    IBOutlet UIView *view_SchoolF;
    IBOutlet UIView *view_SchoolR;
    IBOutlet UITextField *text_select;
    IBOutlet UILabel *lab_school;
    FMDatabase *fmdDB;
    
    NSMutableArray *arr_data;
    NSMutableArray *arr_data_name;
    NSMutableArray *dic_data;
    
    NSMutableArray *select_data;
    
    NSString *str_schoolID;
    NSString *str_shcoolName;
    
    NSMutableArray *allCity;
    NSString *str_CachePath_AreasAll;
    NSString *str_CachePath_select;//经常选择的城市
}
@property (nonatomic,strong)SchoolEntity *schoolEntity;
@property (nonatomic,strong)UserInfoEntity *userInfoEntity;
@property (nonatomic,strong)id<SelectAreaDelegate> delegate;
@property(nonatomic)BOOL IsNearby;

@property(nonatomic,strong)NSMutableArray *arr_school;//培训机构
@property(nonatomic,strong)NSString *currAreaId;//定位城市
@property(nonatomic,strong)NSString *currAreaName;//定位城市
@end
