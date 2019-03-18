//
//  wyxcDetailViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/17.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "wyxcDetailViewController.h"
#import "warningElevatorModel.h"
#import "CommonUseClass.h"
#import "RequestWhere.h"
#import "MyControl.h"
#import "EventCurriculumEntity.h"
#import "DTWBDetailClass.h"
#import "DTWBStepClass.h"
#import "DTWBUserClass.h"
//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UIColorRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])

@interface wyxcDetailViewController ()
{
    RequestWhere *_requestWhere;
    NSString *tabSelectIndex;
    NSString *code_lab;
    UILabel *label_2;
    
    NSString *Longitude ;
    NSString *Latitude ;
    
}
@end

@implementation wyxcDetailViewController

@synthesize app;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=@"巡查详细";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    tabSelectIndex = @"3";
    _requestWhere=[[RequestWhere alloc]init];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    [self getSchoolCourse];
    
    
    
    [self requestOneBignNeedleByID:_lift_ID];
    
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"DTWBDetailCell" tableCells_Index:0];
    //代理
    
    //    CourseTableview.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _mapView.showMapScaleBar = YES;
    //    _mapView.layer.shadowOpacity = 0.5;// 阴影透明度
    //    _mapView.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    //    _mapView.layer.shadowRadius = 5;// 阴影扩散的范围控制
    //    _mapView.layer.shadowOffset = CGSizeMake(1, 1);// 阴影的范围
    //    _mapView.layer.borderWidth = 1;
    //    _mapView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //    _mapView.layer.masksToBounds = YES; //没这句话它圆不起来
    //    _mapView.layer.cornerRadius = 5; //设置图片圆角的尺度
    [view addSubview: _mapView];
    
    CourseTableview.tableView.tableHeaderView = view;
    
    CourseTableview.delegateCustom=self;
    //行高
    //    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:CourseTableview.tableView];
    
    
}

- (void)addAnnotation:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //do something...:)
        NSLog(@"dddddddd");
    }
}

#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
}
-(void)TableRowClick:(UITableItem*)value
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
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setValue:_lift_ID forKey:@"ID"];
    
    [XXNet GetURL:GetPropertyCheckURL header:dicHeader parameters:dic succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            NSString *str_json = data[@"Data"];
            NSDictionary *all_Dict = [str_json objectFromJSONString];
                 
                 NSString *LongitudeAndLatitude = [NSString stringWithFormat:@"%@",[all_Dict objectForKey:@"LongitudeAndLatitude"]];
                 
                 NSArray *temp=[LongitudeAndLatitude componentsSeparatedByString:@","];
                 
                 Longitude = [temp firstObject];
                 Latitude = [temp lastObject];
                 
                 NSLog(@"%@==%@",Longitude,Latitude);
                 
                 
                 NSString *userName = [NSString stringWithFormat:@"%@",[[all_Dict objectForKey:@"User"] objectForKey:@"UserName"]];
                 
                 NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                 [user setObject:userName forKey:@"userName"];
                 
                 NSMutableArray *allTags = [NSMutableArray arrayWithArray:[all_Dict objectForKey:@"PropertyCheckDetails"]];
                 NSMutableArray *  arr=[[NSMutableArray alloc]init];
            
            [self PointAnnotationAdd:nil forZoom:15];
                 
                 for (NSMutableDictionary *dic_item in allTags ){
                     
                     DTWBDetailClass *model=[[DTWBDetailClass alloc] init];
                     
                     model.CheckDate=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CheckDate"]];
                     model.IsPassed=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"IsPassed"]] ;
                     model.PhotoUrl=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"PhotoUrl"]] ;
                     model.Remark=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"Remark"]] ;
                     
                     DTWBStepClass *step=[[DTWBStepClass alloc]init];
                     
                     step.IsActive=[NSString stringWithFormat:@"%@",[[dic_item objectForKey:@"PropertyStep"] objectForKey:@"IsActive"]];
                     step.IsTakePhoto=[NSString stringWithFormat:@"%@",[[dic_item objectForKey:@"PropertyStep"] objectForKey:@"IsTakePhoto"]];
                     step.StepDesc=[NSString stringWithFormat:@"%@",[[dic_item objectForKey:@"PropertyStep"] objectForKey:@"StepDesc"]];
                     step.StepName=[NSString stringWithFormat:@"%@",[[dic_item objectForKey:@"PropertyStep"] objectForKey:@"StepName"]];
                     step.Sort=[NSString stringWithFormat:@"%@",[[dic_item objectForKey:@"Step"] objectForKey:@"PropertyStep"]];
                     
                     model.Step=step;
                     
                     [arr addObject:model];
                     
                 }
                 
                 [MBProgressHUD showSuccess:[NSString stringWithFormat:@"读取：%lu%@",(unsigned long)allTags.count,@"条数据!"] toView:nil];
                 
                 
                 CurriculumEntity *entity=[[CurriculumEntity alloc] init];
                 
                 entity.enroll_list=arr;
                 
                 
                 if([entity.count isEqualToString:@"0"])
                 {
                     
                 }
                 [self init_tableview_hear:entity];
                     }
         
         [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
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
-(void)OneBignNeedle:(warningElevatorModel *) _warningElevatorModel{
    //1
    //[self PointAnnotationAdd:_warningElevatorModel forZoom:15];
}
//添加一个地图点
-(void)PointAnnotationAdd:(warningElevatorModel*)model forZoom:(int)zoom
{
    //NSArray *s = [model.Lift.BaiduMapXY componentsSeparatedByString:@","];
    //    if(![self isBlankString :model.Lift.BaiduMapXY] &&s.count==2){
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
    double f0=[Longitude doubleValue];
    double f1=[Latitude doubleValue];
    
    //NSLog(@"%ld==%ld",f0,f1);
    
    
    CLLocationCoordinate2D coor=CLLocationCoordinate2DMake(f1, f0);
    if(zoom==0)
    {
        BMKCoordinateSpan span;
        //计算地理位置的跨度
        span.latitudeDelta = 10.0f;
        span.longitudeDelta = 10.0f;
        //得出数据的坐标区域
        BMKCoordinateRegion viewRegion ;
        viewRegion.center=coor;
        viewRegion.span=span;
        
        _mapView.region=viewRegion;
    }
    else
    {
        //得出数据的坐标区域
        BMKCoordinateRegion viewRegion ;
        viewRegion.center=coor;
        
        
        _mapView.region=viewRegion;
        
        [_mapView setZoomEnabled:YES];
        [_mapView setZoomLevel:19];
        
        
    }
    pointAnnotation.coordinate = coor;
    //pointAnnotation.title = model.Lift.LiftNum;
    //pointAnnotation.subtitle = model.Lift.InstallationAddress;
    
//    NSString *str=@"1,";//1为电梯2为维保
//    str=[str stringByAppendingString:model.Lift.LiftNum];
//    str=[str stringByAppendingString:@","];
//    str=[str stringByAppendingString:model.Lift.InstallationAddress];
//    pointAnnotation.subtitle =str;
    
    [_mapView addAnnotation:pointAnnotation];
    //    }
    //    else
    //    {
    //        //[MBProgressHUD showError:@"有一条纪录无坐标信息!" toView:nil];
    //    }
    
}


// MARK:- 一个大头针的网络请求数据闭包调用方法
- (void)requestOneBignNeedleByID:(NSString *)TaskID
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *string = [@"Task/GetTask?id=" stringByAppendingString:TaskID];
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         //         NSLog(@"%@",dic_result);
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"state"] intValue];
             if (state_value==0) {
                 NSDictionary* dic_item=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 
                 
                 
                 //warningElevatorModel
                 warningElevatorModel *model=[[warningElevatorModel alloc] init];
                 model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CreateTime"]];
                 model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                 model.LiftId=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftId"]] ;
                 
                 NSDictionary* dic_item3=[dic_item objectForKey:@"Lift"];
                 
                 
                 warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                 lift.BaiduMapXY=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapXY"]];
                 lift.BaiduMapZoom=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapZoom"]];
                 lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftNum"]];
                 lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"InstallationAddress"]];
                 lift.AddressPath=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"AddressPath"]];
                 model.Lift=lift;
                 model.StatusName=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"StatusName"]];
                 if([model.StatusName isEqual:@"<null>"])
                 {model.StatusName=@"";}
                 
                 model.StatusId=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"StatusId"]];
                 model.RescueType=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueType"]];
                 model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"TotalLossTime"]];
                 model.MaintArriveTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintArriveTime"]];
                 
                 //选择一个大头针
                 lift.CertificateNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"CertificateNum"]];
                 lift.MachineNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"MachineNum"]];
                 lift.CustomNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"CustomNum"]];
                 lift.Brand=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"Brand"]];
                 lift.Model=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"Model"]];
                 
                 /*
                  //使用场所
                  NSString* arr_LiftSiteDict=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftSiteDict"]];
                  if(![arr_LiftSiteDict isEqual:@"<null>"])
                  {
                  NSDictionary* dic_LiftSiteDict=[dic_item3 objectForKey:@"LiftSiteDict"];
                  lift.LiftSiteDict=[NSString stringWithFormat:@"%@",[dic_LiftSiteDict objectForKey:@"DictName"]];
                  }
                  
                  
                  //电梯类型
                  NSString* arr_LiftTypeDict=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftTypeDict"]];
                  if(![arr_LiftTypeDict isEqual:@"<null>"])
                  {
                  NSDictionary* dic_LiftTypeDict=[dic_item3 objectForKey:@"LiftTypeDict"];
                  lift.LiftTypeDict=[NSString stringWithFormat:@"%@",[dic_LiftTypeDict objectForKey:@"DictName"]];
                  }
                  
                  //使用单位
                  NSString* arr_UseDepartment=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"UseDepartment"]];
                  if(![arr_UseDepartment isEqual:@"<null>"])
                  {
                  NSDictionary* dic_UseDepartment=[dic_item3 objectForKey:@"UseDepartment"];
                  lift.UseDepartment=[NSString stringWithFormat:@"%@",[dic_UseDepartment objectForKey:@"DeptName"]];
                  }
                  //管理人员
                  lift.UseUsers=[dic_item3 objectForKey:@"UseUsers"];
                  //维保人员
                  lift.MaintUsers=[dic_item3 objectForKey:@"MaintUsers"];
                  
                  //维保单位
                  NSString* arr_MaintenanceDepartment=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"MaintenanceDepartment"]];
                  if(![arr_MaintenanceDepartment isEqual:@"<null>"])
                  {
                  NSDictionary* dic_MaintenanceDepartment=[dic_item3 objectForKey:@"MaintenanceDepartment"];
                  lift.MaintenanceDepartment=[NSString stringWithFormat:@"%@",[dic_MaintenanceDepartment objectForKey:@"DeptName"]];
                  }
                  //任务来源
                  NSString* arr_SourceDict=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"SourceDict"]];
                  if(![arr_SourceDict isEqual:@"<null>"])
                  {
                  NSDictionary* dic_SourceDict=[dic_item objectForKey:@"SourceDict"];
                  model.SourceDict=[NSString stringWithFormat:@"%@",[dic_SourceDict objectForKey:@"DictName"]];
                  }
                  //救援人员
                  NSString* arr_RemedyUser=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RemedyUser"]];
                  if(![arr_RemedyUser isEqual:@"<null>"])
                  {
                  NSDictionary* dic_RemedyUser=[dic_item objectForKey:@"RemedyUser"];
                  
                  NSString *userName=[NSString stringWithFormat:@"%@",[dic_RemedyUser objectForKey:@"UserName"]];
                  NSString *Mobile=[NSString stringWithFormat:@"%@",[dic_RemedyUser objectForKey:@"Mobile"]];
                  model.RemedyUserPhone=Mobile;
                  if(![model.RemedyUserPhone isEqual:@"<null>"]&&![model.RemedyUserPhone isEqual:@""])
                  {
                  model.RemedyUser = [userName stringByAppendingString:@"("];
                  model.RemedyUser  = [model.RemedyUser  stringByAppendingString:Mobile];
                  model.RemedyUser  = [model.RemedyUser  stringByAppendingString:@")"];
                  }
                  model.RemedyUserId=[dic_item objectForKey:@"ID"];
                  
                  NSString* arr_RemedyUserDept=[NSString stringWithFormat:@"%@",[dic_RemedyUser objectForKey:@"Dept"]];
                  if(![arr_RemedyUserDept isEqual:@"<null>"])
                  {
                  NSDictionary* dic_RemedyUserDept=[dic_RemedyUser objectForKey:@"Dept"];
                  
                  model.RemedyUserDeptName=[NSString stringWithFormat:@"%@",[dic_RemedyUserDept objectForKey:@"DeptName"]];
                  }
                  }
                  
                  //故障原因
                  NSString* arr_ReasonDict=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ReasonDict"]];
                  if(![arr_ReasonDict isEqual:@"<null>"])
                  {
                  NSDictionary* dic_ReasonDict=[dic_item objectForKey:@"ReasonDict"];
                  
                  model.ReasonDict=[NSString stringWithFormat:@"%@",[dic_ReasonDict objectForKey:@"DictName"]];
                  }
                  
                  //救援方法
                  NSString* arr_RemedyDict=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RemedyDict"]];
                  if(![arr_RemedyDict isEqual:@"<null>"])
                  {
                  NSDictionary* dic_RemedyDict=[dic_item objectForKey:@"RemedyDict"];
                  
                  model.RemedyDict=[NSString stringWithFormat:@"%@",[dic_RemedyDict objectForKey:@"DictName"]];
                  }
                  */
                 
                 
                 model.UseConfirmTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UseConfirmTime"]];
                 model.RescueNumber=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueNumber"]];
                 model.RescuePhone=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescuePhone"]];
                 model.Content=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"Content"]];
                 model.RescueCompleteTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueCompleteTime"]];
                 model.MaintConfirmTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintConfirmTime"]];
                 [self OneBignNeedle:model];
                 
                 
             }
             else
             {
                 [self showAlter:@"获取数据失败！"];
             }
             
         }
         else
         {
             [self showAlter:@"获取数据失败！"];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取数据失败！"];
     }];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}





-(void)showAlter:(NSString *)massage{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:massage
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
    
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
