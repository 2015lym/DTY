//
//  AloneWBListVC.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/2/27.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "AloneWBListVC.h"
#import "warningElevatorModel.h"
#import "DTWBDetailViewController.h"
#import "RequestWhere.h"
@interface AloneWBListVC () {
    RequestWhere *_requestWhere;
}

@end

@implementation AloneWBListVC
@synthesize app;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=@"维保确认";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    
    [self getSchoolCourse];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _requestWhere=[[RequestWhere alloc]init];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"SBAZCell3" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:CourseTableview.tableView];
    //[self getSchoolCourse];
}
#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
    [self getSchoolCourse];
}
-(void)TableRowClick:(UITableItem*)value
{
    warningElevatorModel *warnmodel=(warningElevatorModel *)value;
    DTWBDetailViewController *vc = [[DTWBDetailViewController alloc] init];
    vc.lift_ID = warnmodel.ID;
    vc.dataDic = warnmodel;
//    vc.lift_ID = [NSString stringWithFormat:@"%@",[(NSDictionary*)value objectForKey:@"ID"]];
//    vc.dataDic = (NSDictionary*)value;
    vc.from = @"alone";
    [self.navigationController pushViewController:vc animated:YES];
    
    
    /*
     warningElevatorModel *warnModel=(warningElevatorModel *)value;
     
     handleDetailViewController *ctvc=[[handleDetailViewController alloc] init];
     ctvc.warnModel=warnModel;
     ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
     
     
     [_delegate SchoolCoursePush:ctvc];
     */
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
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:@"Check/GetUseCheckList"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
     }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
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
                 NSMutableArray *  allTags=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 NSMutableArray *  arr=[[NSMutableArray alloc]init];
                 for (NSMutableDictionary *dic_item in allTags ){
                     warningElevatorModel *model=[[warningElevatorModel alloc] init];
                     
                     model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CheckDate"]];
                     model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                     
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"IsPassed"]];
                     
                     NSString *type=@"";
                     NSString *CType=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CType"]];
                     if ([CType isEqual:@"0"])
                             type = @"半月维保";
                      else   if ([CType isEqual:@"2"])
                             type = @"季度维保";
                      else   if ([CType isEqual:@"3"])
                             type = @"半年维保";
                       else  if ([CType isEqual:@"4"])
                             type = @"年度维保";
                     
                     if([model.TotalLossTime isEqual:@"1"])
                     {model.TotalLossTime=@"合格";}
                     else{model.TotalLossTime=@"不合格";}
                     model.TotalLossTime=[NSString stringWithFormat:@"%@(%@)",model.TotalLossTime,type];
                     
                     warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                     
                     NSLog(@"dic_item==%@",dic_item);
                     
                     lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftNum"]];
                     
                     lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"InstallationAddress"]];
                     model.RescueType=@"维保结果：";
                     model.Lift=lift;
                     
//                     NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//                     [dic setValue:model.CreateTime forKey:@"CreateTime"];
//                     [dic setValue:model.ID forKey:@"ID"];
//                     [dic setValue:model.TotalLossTime forKey:@"TotalLossTime"];
//                     NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
//
//                     [dic1 setValue:lift.LiftNum forKey:@"LiftNum"];
//                     [dic1 setValue:lift.InstallationAddress forKey:@"InstallationAddress"];
//                     [dic setValue:model.RescueType forKey:@"RescueType"];
//                     [dic setValue:dic1 forKey:@"Lift"];
                     
                     
                     [arr addObject:model];
                 }
                 
                 [MBProgressHUD showSuccess:[NSString stringWithFormat:@"读取：%lu%@",(unsigned long)allTags.count,@"条数据!"] toView:nil];
                 CurriculumEntity *entity=[[CurriculumEntity alloc] init];
                 entity.enroll_list=arr;
                 if([entity.count isEqualToString:@"0"]){ }
                 [self init_tableview_hear:entity];
             }
             else{ }
         }
         else{ }
         
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
        else {
            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
