//
//  complainAdvice.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/10.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "complainAdvice.h"

#import "AppDelegate.h"
#import "CurriculumEntity.h"
#import "CourseDetailedViewController.h"
#import "JSONKit.h"
#import "InteractionTwoViewController.h"
#import "MBProgressHUD.h"
#import "complainDetailViewController.h"
@implementation complainAdvice

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if([_str_type isEqual:@"zc"])
        self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"投诉建议";
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"complainAdviceCell" tableCells_Index:0];
    
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
    NSMutableDictionary *dic_value=(NSMutableDictionary *)value;
    
    complainDetailViewController *ctvc=[[complainDetailViewController alloc] init];
    ctvc.dic_value=dic_value;
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    
    if([_str_type isEqual:@"zc"])
    {
        [self.navigationController pushViewController:ctvc animated:YES];
    }
    else
    {
    [_delegate SchoolCoursePush:ctvc];
    }
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
    [self deleteNoDataImage];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
   
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%i",CourseTableview.PageIndex] forHTTPHeaderField:@"PageIndex"];
     [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:@"20" forHTTPHeaderField:@"PageSize"];
     
     [[AFAppDotNetAPIClient sharedClient]
      GET:@"Advice/GetAdviceList"
      parameters:nil
      progress:^(NSProgress * _Nonnull uploadProgress) {  }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         
         if (CourseTableview.PageIndex==1) {
             [CourseTableview.dataSource removeAllObjects];
         }
         else
         {
             [CourseTableview.dataSource removeLastObject];
         }
         
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                  NSMutableArray* dic_resultValue=[[dic_result objectForKey:@"Data"]objectFromJSONString];
                 
                 CurriculumEntity *entity=[[CurriculumEntity alloc] init];
                 
                 entity.enroll_list=dic_resultValue;
                 if([entity.count isEqualToString:@"0"])
                 {
                     [self NoDataShowImage];
                 }
                 [self init_tableview_hear:entity];
             }
             else
             {
                 [self NoDataShowImage];
             }
         }
         else
         {
             [self NoDataShowImage];
         }
         
         [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"获取投诉建议列表失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
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
        if (entity.enroll_list.count>9) {
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
