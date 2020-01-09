//
//  SchoolCourseViewController.m
//  AlumniChat
//
//  Created by SongQues on 16/6/15.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "FacListViewController.h"
#import "AppDelegate.h"
#import "CurriculumEntity.h"
#import "CourseDetailedViewController.h"
#import "JSONKit.h"
#import "InteractionTwoViewController.h"

#import "ConvenienceTwoUIViewController.h"
//#import "CampusTwoListViewController.h"
@interface FacListViewController ()

@end

@implementation FacListViewController
@synthesize dic_school_info;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:1.0f]];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"FacListCourseTableViewCell" tableCells_Index:0];
    
    //代理
    CourseTableview.delegateCustom=self;
    CourseTableview.delegateMap=self;
    //行高
    CourseTableview.currHeight= 116;
    
    //tableView的frame
    CourseTableview.tableView.frame = self.view.frame;;
    // Do any additional setup after loading the view.
    CourseTableview.tableView.frame = self.view.frame;
    CourseTableview.tableView.backgroundColor=[UIColor clearColor];
    CourseTableview.view.backgroundColor=[UIColor clearColor];
    [self.view addSubview:CourseTableview.tableView];
    CourseTableview.PageIndex=1;
    
     _entity=[[FacListCurriculumEntity alloc] init];
    [self setupLocationManager];
}
- (void)tongzhi:(NSNotification *)text{
    NSLog(@"%@",text.userInfo[@"textOne"]);
    
    NSString *srt_url=[NSString stringWithFormat:@"%@bigBaiduMap.html?longitude=%@&latitude=%@",Ksdby_api,text.userInfo[@"textOne"],text.userInfo[@"textTwo"]];
    ConvenienceTwoUIViewController *ctvc=[[ConvenienceTwoUIViewController alloc] init];
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    
    
    [ctvc setUrl:srt_url];
    [_delegate SchoolCoursePush:ctvc];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TablviewDelegateEX
-(void)TableRowClickCell:(UITableItem*)value forcell:(UITableViewCell*) cell;
{
    
}
-(void)MoreRecord

{
    CourseTableview.PageIndex+=1;
    [self getSchoolCourse];
}


-(void)TableRowClick:(UITableItem*)value
{
    NSMutableDictionary *dic_value=(NSMutableDictionary *)value;
   
    
    
    NSString *str_newid=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"facId"]];
    NSString *srt_url=[NSString stringWithFormat:@"%@facilitateDetails.html?facId=%@",Ksdby_api,str_newid];
    ConvenienceTwoUIViewController *ctvc=[[ConvenienceTwoUIViewController alloc] init];
    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    
    
   
     //分享
     ctvc.infoUrl=[NSString stringWithFormat:@"%@facilitateDetails_share.html?facId=%@",Ksdby_api,str_newid];
     ctvc.infoTitle=[NSString stringWithFormat:@"%@",[dic_value objectForKey:@"facTitle"]];
     ctvc.infoMemo=@"";
     ctvc.infoImage=@"";
     NSMutableArray *newsImageList=[NSMutableArray arrayWithArray:[dic_value objectForKey:@"imgsArray"]];
     if(newsImageList.count>0)
     {
     NSMutableDictionary *dic_image=newsImageList[0];
     ctvc.infoImage=[NSString stringWithFormat:@"%@",[dic_image objectForKey:@"address_x"]];
     }
     //分享
    

    
    [ctvc setUrl:srt_url];
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
    
    [self deleteNoDataImage];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    NSString *currType= [_tag objectForKey:@"tagId"];
    NSString *curraddress= [_tag objectForKey:@"address"];
    
    NSString *currSort=@"0";
    if(_sort!=nil )currSort=[_sort objectForKey:@"tagId"];
    
    NSString *currTag1=@"0";
    if(_types!=nil )currTag1=[_types objectForKey:@"tagId"];
    
    NSString *currCityCode=@"643";
    if(_area!=nil )currCityCode=[_area objectForKey:@"tagId"];
    
    
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:[NSString stringWithFormat:@"%i",CourseTableview.PageIndex] forKey:@"pageNo"];
    [dic_args setObject:currType forKey:@"type"];
    [dic_args setObject:currSort forKey:@"sort"];
    [dic_args setObject:currTag1 forKey:@"tag"];
    [dic_args setObject:currCityCode forKey:@"cityCode"];
    [dic_args setObject:curraddress forKey:@"address"];
    

    if(checkinLocation!=nil)
    {
        
        [dic_args setObject:[NSString stringWithFormat:@"%f", checkinLocation.coordinate.longitude] forKey:@"longitude"];

        [dic_args setObject:[NSString stringWithFormat:@"%f",checkinLocation.coordinate.latitude] forKey:@"latitude"];
   
    }
    
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/Facilitate/getFacilitates"
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
          NSString *state_value=[dic_result objectForKey:@"status"];
           NSDictionary* dic_resultValue=[dic_result objectForKey:@"result"];
          if ([state_value isEqualToString:@"OK"]) {
              NSString *arr=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"type"]];
              if (arr.length>0) {
                  _entity.adver_list=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"type"]];
              }
              NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
              [d1 setObject:@"0" forKey:@"tagId"];
              [d1 setObject:@"全部" forKey:@"tagName"];
              [ _entity.adver_list insertObject:d1 atIndex:0];
              
          _entity.enroll_list=[NSMutableArray arrayWithArray:[dic_resultValue objectForKey:@"facilitates"]];
          _entity.page=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"page"]];
          _entity.pagecount=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"pagecount"]];
          _entity.count=[NSString stringWithFormat:@"%@",[dic_resultValue objectForKey:@"count"]];
              
              if([_entity.count isEqualToString:@"0"])
              {
                  [self NoDataShowImage];
              }

          [self init_tableview_hear:_entity];
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
                                                       message:@"获取便民列表失败！"
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



-(void)init_tableview_hear:(FacListCurriculumEntity *)entity
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

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [super locationManager:manager didUpdateLocations:locations];
    
   
   CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:locations[0] completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error) {
             NSLog(@"error: %@",error.description);
             [self getSchoolCourse];
         }
         else{
             NSLog(@"placemarks count %lu",(unsigned long)placemarks.count);
             for (CLPlacemark *placeMark in placemarks)
             {
                 city=placeMark.locality;
                 city= [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
                
                 
                 //添加 字典，将label的值通过key值设置传递
                 NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:city,@"textOne", nil];
                 //创建通知
                 NSNotification *notification =[NSNotification notificationWithName:@"tongzhiCity" object:nil userInfo:dict];
                 //通过通知中心发送通知
                 [[NSNotificationCenter defaultCenter] postNotification:notification];
                 [self getSchoolCourse];
              }
             if (city==nil) {
                     [self getSchoolCourse];
             }
         }
         
     }];
    
    //[self getSchoolCourse];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //NSLog(@"无法获得定位信息");
    [super locationManager:manager didFailWithError:error];
    
    
    
    
    [self getSchoolCourse];
}
-(void)baiduMapPush:(NSString *)longitude for: (NSString *)latitude
{
    
}

@end
