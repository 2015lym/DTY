//
//  SchoolCourseViewController.m
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "EventCourseViewController.h"
#import "AppDelegate.h"
#import "EventCurriculumEntity.h"
#import "CourseDetailedViewController.h"
#import "JSONKit.h"
#import "InteractionTwoViewController.h"
#import "MBProgressHUD.h"
#import "EventTwoViewController.h"
#import "signUpViewController.h"
@interface EventCourseViewController ()

@end

@implementation EventCourseViewController
@synthesize dic_school_info;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:100]];
    
    
    //注册通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"RefreshSignUp" object:nil];
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"EventCourseTableViewCell1" tableCells_Index:0];
    
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 210;
    
    //tableView的frame
    CourseTableview.tableView.frame = self.view.frame;;
    // Do any additional setup after loading the view.
//    CourseTableview.tableView.frame = self.view.frame;
    
    [self.view addSubview:CourseTableview.tableView];
    
    [self getSchoolCourse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)tongzhi:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"textOne"]);
    cell=text.userInfo[@"textTwo"];
    NSString *str=cell.btnArea.titleLabel.text;
    [cell.btnArea setTitle:@"已报名" forState:UIControlStateNormal];
 
    NSMutableArray *arr=CourseTableview.dataSource;
    NSMutableDictionary *dic= arr[0];
    dic objectForKey:@"isEnroll"
    //ctvc.actId=text.userInfo[@"textOne"];
    NSIndexPath *te=[NSIndexPath indexPathForRow:2 inSection:0];//刷新第一个section的第二行
    [CourseTableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationMiddle];
 
}
*/

-(void)pullUpdateData
{
    CourseTableview.PageIndex=1;
    [self getSchoolCourse];
}
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
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

#pragma mark TablviewDelegateEX
-(void)TableRowClickCell:(UITableItem *)value forcell:(UITableViewCellEx *)cell
{
    NSMutableDictionary *dic_value=(NSMutableDictionary *)value;
    
    /*
     CampusTwoListViewController *campusTLVC=[[CampusTwoListViewController alloc] initWithNibName:[Util GetResolution:@"CampusTwoListViewController"] bundle:nil];
     campusTLVC.srt_url=[NSString stringWithFormat:@"%@enroll_detail.html?enrollId=%@&userId=%@&type=%@&jumpFlag=2",SchoolsURl,[dic_value objectForKey:@"enrollId"],self.app.userInfoEntity.rid,[dic_school_info objectForKey:@"type"]];
     [_delegate SchoolCoursePush:campusTLVC];
     */
    
    
    NSString *str_newid=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"actId"]];
    NSString *srt_url=[NSString stringWithFormat:@"%@activityDetails.html?actId=%@",Ksdby_api,str_newid];
    EventTwoViewController *ctvc=[[EventTwoViewController alloc] init];
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    ctvc.cell=cell;
    NSString *str=ctvc.cell.btnArea.titleLabel.text;
    
    //分享
    ctvc.infoUrl=[NSString stringWithFormat:@"%@activityDetails_share.html?actId=%@",Ksdby_api,str_newid];
    ctvc.infoTitle=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"actTitle"]];
    ctvc.infoMemo=@"";
    ctvc.infoImage=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"actImage"]];
   //分享

    
    [ctvc setUrl:srt_url];
    [_delegate SchoolCoursePush:ctvc];
    //[self.navigationController pushViewController:ctvc animated:YES];
    //decisionHandler(WKNavigationActionPolicyCancel);
}

-(void)TableRowClick:(UITableItem*)value
{
    /*
    NSMutableDictionary *dic_value=(NSMutableDictionary *)value;
   
    
    
    NSString *str_newid=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"actId"]];
    NSString *srt_url=[NSString stringWithFormat:@"%@activityDetails.html?actId=%@",Ksdby_api,str_newid];
    EventTwoViewController *ctvc=[[EventTwoViewController alloc] init];
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    [ctvc setUrl:srt_url];
    [_delegate SchoolCoursePush:ctvc];
   
*/
}
-(void)TableHeaderRowClick:(UITableItem*)value
{
    
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

   // currTag=  _tag;
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:[NSString stringWithFormat:@"%i",CourseTableview.PageIndex] forKey:@"pageNo"];
    if(super.app.str_token !=nil)
    [dic_args setObject:super.app.str_token forKey:@"access_token"];
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/Activity/getActivityList"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
              
              int state_value=[[dic_result objectForKey:@"state"] intValue];
               NSDictionary* dic_resultValue=[dic_result objectForKey:@"result"];
              if (state_value==0) {
              EventCurriculumEntity *entity=[[EventCurriculumEntity alloc] init];
              entity.enroll_list=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"activities"]];
              entity.page=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"page"]];
              entity.pagecount=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"pagecount"]];
              entity.count=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"count"]];
              
              if([entity.count isEqualToString:@"0"])
              {
                  [self NoDataShowImage];
              }

              [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
//              [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

              
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
          
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"获取活动列表失败！"
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


-(void)init_tableview_hear:(EventCurriculumEntity *)entity
{
    
    if (entity.enroll_list.count) {
        
       
        for (NSMutableDictionary *dic_item in entity.enroll_list ) {
            
       
         [CourseTableview.dataSource addObject:dic_item];
            
        }
        if (entity.enroll_list.count>19) {
            [CourseTableview.dataSource addObject:@"加载中……"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
