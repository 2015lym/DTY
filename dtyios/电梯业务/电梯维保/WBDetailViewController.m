//
//  WBDetailViewController.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/4/7.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "WBDetailViewController.h"
#import "warningElevatorModel.h"
#import "CommonUseClass.h"
#import "RequestWhere.h"
#import "MyControl.h"

//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UIColorRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])
@interface WBDetailViewController ()
{
    RequestWhere *_requestWhere;
    NSString *tabSelectIndex;
    NSString *code_lab;
    UILabel *label_2;
}
@end

@implementation WBDetailViewController
@synthesize app;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=@"维保历史";
    //self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    NSLog(@"_liftNum==%@",_liftNum);
    
    tabSelectIndex = @"3";
    _requestWhere=[[RequestWhere alloc]init];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self getSchoolCourse];
    
//    UILabel *labe_1 = [MyControl createLabelWithFrame:CGRectMake(0, 10, 120, 20) Font:15 Text:@"本年度维保数：0"];
//    labe_1.textColor = [UIColor colorWithHexString:@"#3574fa"];
//    labe_1.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:labe_1];
//
//    label_2 = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(labe_1.frame), 10, SCREEN_WIDTH/2, 20) Font:15 Text:nil];
//    label_2.textColor = [UIColor colorWithHexString:@"#3574fa"];
//    label_2.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label_2];
    
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"SBAZCell4" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-0);
    [self.view addSubview:CourseTableview.tableView];
    
}
#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
}
-(void)TableRowClick:(UITableItem*)value
{
    warningElevatorModel *warnmodel=(warningElevatorModel *)value;
    DTWBDetailViewController *vc = [[DTWBDetailViewController alloc] init];
    vc.lift_ID = warnmodel.ID;
    //vc.dataDic = warnmodel;
    [self.navigationController pushViewController:vc animated:YES];
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
-(void)getSchoolCourse
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%i",CourseTableview.PageIndex] forHTTPHeaderField:@"PageIndex"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:@"20" forHTTPHeaderField:@"PageSize"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId]forHTTPHeaderField:@"CityId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId]forHTTPHeaderField:@"AddressId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId]forHTTPHeaderField:@"MaintDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId]forHTTPHeaderField:@"UseDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsInstallation]forHTTPHeaderField:@"IsInstallation"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsOnline]forHTTPHeaderField:@"IsOnline"];
    NSString * liftstr = [_liftNum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:@"Check/GetNewCheckHistoryList"//GetCheckHistoryList
     parameters:@{@"LiftNum":liftstr}
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
         
     }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         //         NSLog(@"success:%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
                  NSLog(@"dic_result==%@",dic_result);
         
         code_lab = [NSString stringWithFormat:@"%@",[dic_result objectForKey:@"Code"]];
         
         label_2.text = [NSString stringWithFormat:@"本年应维保数：%@",code_lab];
         
         
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
                 NSMutableArray *  allTags=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 NSMutableArray *  arr=[[NSMutableArray alloc]init];
                 
                NSLog(@"allTags==%@",allTags);
                 
                 for (NSMutableDictionary *dic_item in allTags ){
                     
                     warningElevatorModel *model=[[warningElevatorModel alloc] init];
                     model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CreateTime"]];
                     model.UseConfirmTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"InspectionNextDate"]];
                     model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                     
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintenancePeriod"]];
                     
                     warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                     
                     lift.LiftNum=_liftNum;//[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftNum"]];
                     lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"InstallationAddress"]];
                     
                     
                     model.Lift=lift;
                     [arr addObject:model];
                 }
                 
                 [MBProgressHUD showSuccess:[NSString stringWithFormat:@"读取：%lu%@",(unsigned long)allTags.count,@"条数据!"] toView:nil];
                 
                 
                 CurriculumEntity *entity=[[CurriculumEntity alloc] init];
                 
                 entity.enroll_list=arr;
                 
                 //                 NSLog(@"=====%@",entity.enroll_list);
                 
                 
                 if([entity.count isEqualToString:@"0"])
                 {
                     
                 }
                 [self init_tableview_hear:entity];
             }
             else
             {
                 
             }
         }
         
         [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"获取列表失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
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
            //[CourseTableview.dataSource addObject:@"无更多数据"];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
