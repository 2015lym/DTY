//
//  InteractionCourseViewController.m
//  Sea_northeast_asia
//
//  Created by Macinstosh on 16/8/30.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "InteractionCourseViewController.h"
#import "AppDelegate.h"
#import "CurriculumEntity.h"
#import "CourseDetailedViewController.h"
#import "JSONKit.h"
#import "InteractionTwoViewController.h"

@interface InteractionCourseViewController ()

@end

@implementation InteractionCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:100]];
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"InteractionCourseTableViewCell" tableCells_Index:0];
    
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 155;
    
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
    
    
    NSString *str_newid=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"interactionId"]];
    NSString *type=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"type"]];
    NSString *srt_url=[NSString stringWithFormat:@"%@interactDetails_text.html?entranceId=1&interactionId=%@",Ksdby_api,str_newid];
    
    if([type isEqualToString:@"2"])
    {
        srt_url=[NSString stringWithFormat:@"%@interactDetails_image.html?entranceId=1&interactionId=%@",Ksdby_api,str_newid];
        
    }
    InteractionTwoViewController *ctvc=[[InteractionTwoViewController alloc] init];
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    
    //分享
    if([type isEqualToString:@"2"])
    {
        ctvc.infoUrl=[NSString stringWithFormat:@"%@interactDetails_image_share.html?interactionId=%@",Ksdby_api,str_newid];
    }
    else
    { ctvc.infoUrl=[NSString stringWithFormat:@"%@interactDetails_text_share.html?interactionId=%@",Ksdby_api,str_newid];
    }
    ctvc.infoTitle=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"title"]];
    ctvc.infoMemo=@"";//[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"summary"]];
    if([type isEqualToString:@"2"])
    {
        ctvc.infoImage=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"picUrl"]];
    }
    else
    {ctvc.infoImage=@"";}
    //分享
    
    
    [ctvc setUrl:srt_url];
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
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/Interaction/getInteracts"
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
                 entity.enroll_list=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"interacts"]];
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
                                                       message:@"获取互动列表失败！"
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
}@end

