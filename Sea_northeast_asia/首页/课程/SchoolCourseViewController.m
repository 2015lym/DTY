//
//  SchoolCourseViewController.m
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "SchoolCourseViewController.h"
#import "AppDelegate.h"
#import "CurriculumEntity.h"
#import "CourseDetailedViewController.h"
#import "JSONKit.h"
#import "InteractionTwoViewController.h"
#import "MBProgressHUD.h"
//#import "CampusTwoListViewController.h"
@interface SchoolCourseViewController ()

@end

@implementation SchoolCourseViewController
@synthesize dic_school_info;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"CourseTableViewCell" tableCells_Index:0];
    
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 80;
    
    //tableView的frame
    CourseTableview.tableView.frame = self.view.frame;;
    // Do any additional setup after loading the view.
    CourseTableview.tableView.frame = self.view.frame;
    
    [self.view addSubview:CourseTableview.tableView];
    
    [self getSchoolCourse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
   
    /*
    CampusTwoListViewController *campusTLVC=[[CampusTwoListViewController alloc] initWithNibName:[Util GetResolution:@"CampusTwoListViewController"] bundle:nil];
    campusTLVC.srt_url=[NSString stringWithFormat:@"%@enroll_detail.html?enrollId=%@&userId=%@&type=%@&jumpFlag=2",SchoolsURl,[dic_value objectForKey:@"enrollId"],self.app.userInfoEntity.rid,[dic_school_info objectForKey:@"type"]];
    [_delegate SchoolCoursePush:campusTLVC];
     */
    
    
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
    
    [_delegate SchoolCoursePush:ctvc];
    //[self.navigationController pushViewController:ctvc animated:YES];
    //decisionHandler(WKNavigationActionPolicyCancel);

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

    currTag=  _tag;
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:[NSString stringWithFormat:@"%i",CourseTableview.PageIndex] forKey:@"pageNo"];
    [dic_args setObject:currTag forKey:@"tagId"];
    if(_area !=nil )
    {
    [dic_args setObject:_area forKey:@"cityCode"];
    }
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/News/newsListex"
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
          CurriculumEntity *entity=[[CurriculumEntity alloc] init];
          entity.adver_list=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"news_list"]];
          entity.enroll_list=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"news_list"]];
          entity.page=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"page"]];
          entity.pagecount=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"pagecount"]];
          entity.count=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"count"]];
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
                                                       message:@"获取资讯列表失败！"
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
    int count=0;
        if(CourseTableview.PageIndex==1)
     {
        count=1;
         if([currTag isEqualToString:@"-1"])
         {
             count=5;
         }

    if (entity.adver_list.count>0) {
        HeaderView =[[CourseHearView alloc] init];
        HeaderView .showCount=count;
        HeaderView.delegate=self;
        CourseTableview.tableView.tableHeaderView=[HeaderView initview:entity.adver_list];
        
    }
     }
    
    if (entity.enroll_list.count) {
        
        int i=0;
        for (NSMutableDictionary *dic_item in entity.enroll_list ) {
            
       
            i=i+1;
            if(i <=count)
            {continue;}
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
