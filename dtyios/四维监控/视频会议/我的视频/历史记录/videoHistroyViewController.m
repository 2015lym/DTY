//
//  videoHistroyViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/13.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "videoHistroyViewController.h"
#import "CurriculumEntity.h"
@interface videoHistroyViewController ()

@end

@implementation videoHistroyViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"videoHistroyCell" tableCells_Index:0];
    
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 60;
    
    //tableView的frame
    CourseTableview.tableView.frame = self.view.frame;;
    // Do any additional setup after loading the view.
    CourseTableview.tableView.frame = self.view.frame;
    
    [self.view addSubview:CourseTableview.tableView];
    
    [self getSchoolCourse];
    
    
}


#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
    [self getSchoolCourse];
}
-(void)TableRowClick:(UITableItem*)value
{
    NSMutableDictionary *warnModel=(NSMutableDictionary *)value;
    
    videoDetailViewController *ctvc=[[videoDetailViewController alloc] init];
    ctvc.dic_info=warnModel;



    [_delegate SchoolCoursePush:ctvc];
}
-(void)TableHeaderRowClick:(UITableItem*)value
{
    
}
-(void)pullUpdateData
{
    CourseTableview.PageIndex=1;
    [self getSchoolCourse];
}
#pragma mark - PeopleNearbyViewController
-(void)startFristLoadData
{
    [CourseTableview viewFrashData];
}
- (void)doneLoadingTableViewData
{
    [CourseTableview.tableView reloadData];
    [CourseTableview doneLoadingTableViewData];
    CourseTableview.max_Cell_Star=YES;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)getSchoolCourse
{
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/GetAppAlarmRoomRecord?userID=%@&userName=%@",app.userInfo.UserID,_keyword];
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [XXNet GetURL:currUrl header:nil parameters:nil succeed:^(NSDictionary *data) {
        
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(selectDataOk:) withObject:@"" waitUntilDone:YES];
            if (CourseTableview.PageIndex==1) {
                [CourseTableview.dataSource removeAllObjects];
            }
            else
            {
                [CourseTableview.dataSource removeLastObject];
            }
            
            NSString *str_json = data [@"Data"];
            NSMutableArray *array_newJS = [str_json objectFromJSONString];
            
            CurriculumEntity *entity=[[CurriculumEntity alloc] init];
            entity.enroll_list=array_newJS;
            NSLog(@"++++++%@",entity.enroll_list);
            [self init_tableview_hear:entity];
            [self performSelector:@ selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:@"查询失败" waitUntilDone:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:MessageResult waitUntilDone:YES];
        
    }];
    
}

-(void)selectDataOk:(NSString *)msg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)selectDataErr:(NSString *)msg
{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)deleteNoDataImage
{
    UIView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
}

-(void)NoDataShowImage
{
    UIView *view=[[UIView alloc ]initWithFrame:CGRectMake(0, 60, 320, 130)];
    //UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake((bounds_width.size.width-218)/2, 0, 218, 100)];
    //image.image=[UIImage imageNamed:@"NoData.png"];
    //[view addSubview:image];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((bounds_width.size.width-80)/2, 100, 80, 30)];
    label.text=@"暂无数据";
    label.textAlignment=NSTextAlignmentCenter;
    [label setTextColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]];
    [view addSubview:label];
    
    [CourseTableview.view addSubview:view];
    view.tag=3000;
}

-(void)init_tableview_hear:(CurriculumEntity *)entity
{
    if (entity.enroll_list.count) {
        
        for (NSMutableDictionary *dic_item in entity.enroll_list ) {
            [CourseTableview.dataSource addObject:dic_item];
            
        }
        if (entity.enroll_list.count>19) {
            [CourseTableview.dataSource addObject:@"加载中……"];
        }
        else
        {
            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
    }
}
-(void)CourseHearOnClick:(UIViewController *)vc
{
    [_delegate SchoolCoursePush:vc];
}

@end
