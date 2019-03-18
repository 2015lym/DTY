//
//  rescueList.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/8.
//  Copyright © 2016年 SongQues. All rights reserved.
//
#import "EventCurriculumEntity.h"
#import "rescueList.h"
#import "warningElevatorModel.h"

#import "MBProgressHUD.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@implementation rescueList
{
    UILabel *line;
}
@synthesize app;
NSMutableArray* rescueArrays ;

UIButton *iClickBtn ;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    rescueArrays=[[NSMutableArray alloc]init];
    [rescueArrays addObject:@"未接单"];
    [rescueArrays addObject:@"已接单"];

    
    //static dispatch_once_t onceToken=0;
   // dispatch_once(&onceToken, ^{
        for (NSUInteger i = 0; i < rescueArrays.count; i++){
            //let btnC = self.addButtonMethod(i)
            //self.view.addSubview(btnC)
             UIButton  *btnC = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnC setTitle:[rescueArrays objectAtIndex:i] forState:UIControlStateNormal];
            btnC.tag=i+2;
            [self addButtonMethod:btnC c:i];
            [self.view addSubview:btnC];

        }
    
    
   UILabel * line1=[[UILabel alloc]init];
    line1.frame=CGRectMake(0, 29, bounds_width.size.width, 1);
    line1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line1];
    
    line=[[UILabel alloc]init];
    line.frame=CGRectMake(((bounds_width.size.width/2)-50)/2, 28, 50, 2);
    line.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [self.view addSubview:line];
    //});
    
    //self.addTableMetho()
    
    
    //注册通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"RefreshSignUp" object:nil];
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"rescueListCell" tableCells_Index:0];
    
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 83;
    //CourseTableview.tableView.scrollEnabled = NO;
    //tableView的frame
    CourseTableview.tableView.frame =CGRectMake(self.view.frame.origin.x, 30, self.view.frame.size.width, self.view.frame.size.height-145) ;
    // Do any additional setup after loading the view.
    //    CourseTableview.tableView.frame = self.view.frame;
    //CourseTableview.tableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:CourseTableview.tableView];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self requestAnimationData];
}
#pragma mark - PeopleNearbyViewController

-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
}

-(void)pullUpdateData
{
    CourseTableview.PageIndex=1;
    [CourseTableview doneLoadingTableViewData];
}
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
    */
}

-(void)TableRowClick:(UITableItem*)value
{
    
    warningElevatorModel *warnmodel=(warningElevatorModel *)value;
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:warnmodel,@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_warn" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
-(void)TableHeaderRowClick:(UITableItem*)value
{
    
}

-(void)init_tableview_hear:(EventCurriculumEntity *)entity
{
    
    if (entity.enroll_list.count) {
        
        
        for (NSMutableDictionary *dic_item in entity.enroll_list ) {
             warningElevatorModel *warnmodel=(warningElevatorModel *)dic_item;
            if(iClickBtn.tag==2)
            {
                if([warnmodel.RescueType isEqual:@"1"])continue;
            }
            else
            {
                 if([warnmodel.RescueType isEqual:@"0"])continue;
            }
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



/*
private func addTableMetho(){
    let rescueTable = UITableView(frame: CGRectMake(0 , 30,self.view.frame.size.width , self.view.frame.size.height - 174) , style: UITableViewStyle.Plain)
    rescueTable.separatorStyle = UITableViewCellSeparatorStyle.None
    rescueTable.delegate=self
    rescueTable.dataSource=self
    self.view.addSubview(rescueTable)
}
 */
- (void)addButtonMethod: (UIButton*) b c: (int) c{
    if (b.tag == 2) {
        b.selected = true;
        iClickBtn=b;
    }
    
    b.adjustsImageWhenHighlighted = false;
    b.frame=CGRectMake((float)c*kWidth*0.5, 0, kWidth*0.5, 30);
    b.titleLabel.font=[UIFont systemFontOfSize:13];
    //[b setBackgroundImage:[UIImage imageNamed:@"backt"] forState:UIControlStateSelected];
    //[b setBackgroundImage:[UIImage imageNamed:@"selectBack"] forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"#3574fa"] forState:UIControlStateSelected];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(sendBtnIndex:) forControlEvents:UIControlEventTouchUpInside];

}


- (void) sendBtnIndex:(id)sender{
    //1.
    UIButton *btn= (UIButton *)sender;
    iClickBtn.selected = false;
    btn.selected=true;

    if (btn.tag == 2 ){
        line.frame=CGRectMake(((bounds_width.size.width/2)-50)/2, 28, 50, 2);
    }else{
        line.frame=CGRectMake(bounds_width.size.width/2+((bounds_width.size.width/2)-50)/2, 28, 50, 2);
    }
    iClickBtn=btn;
    
    
    //2.数据
    [self dataBind];
}

- (void) dataBind{
   
    [CourseTableview.dataSource removeAllObjects];
   
    EventCurriculumEntity *entity=[[EventCurriculumEntity alloc] init];
    entity.enroll_list=_arr;
    entity.page=@"1";
    entity.pagecount=@"1";
    entity.count=@"1";
    [self init_tableview_hear:entity];
    [self doneLoadingTableViewData];

}

// MARK:- 大头针的网络请求数据
- (void)requestAnimationData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _arr=[[NSMutableArray alloc]init];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:app.userInfo.UserID forKey:@"UserId"];
    [dic_args setObject:@"-1" forKey:@"PhoneId"];
    
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%i",1] forHTTPHeaderField:@"PageIndex"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:@"20" forHTTPHeaderField:@"PageSize"];
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:@"Task/GetTaskList"
     
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"state"] intValue];
             if (state_value==0) {
                  NSMutableArray*allTags=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 
                 for (NSMutableDictionary *dic_item in allTags ){
                     //warningElevatorModel
                     warningElevatorModel *model=[[warningElevatorModel alloc] init];
                     model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CreateTime"]];
                     model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                     model.LiftId=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftId"]] ;
                     model.StatusName=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"StatusName"]];
                     model.RescueType=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"RescueType"]];
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"TotalLossTime"]];
                     NSDictionary* dic_item3=[dic_item objectForKey:@"Lift"];
                     warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                     lift.BaiduMapXY=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapXY"]];
                     lift.BaiduMapZoom=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"BaiduMapZoom"]];
                     lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"LiftNum"]];
                     lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"InstallationAddress"]];
                     lift.AddressPath=[NSString stringWithFormat:@"%@",[dic_item3 objectForKey:@"AddressPath"]];
                     
                     model.Lift=lift;
                     [_arr addObject:model];
                     
                     
                 }
                 [self dataBind];
                 //[MBProgressHUD showSuccess:[NSString stringWithFormat:@"共%lu%@",(unsigned long)allTags.count,@"个救援内容!"] toView:nil];
             }
             else
             {
                 [self showAlter:@"获取列表失败！"];
             }
         }
         else
         {
             [self showAlter:@"获取列表失败！"];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取列表失败！"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}
-(void)showAlter:(NSString *)massage{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:massage
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
    
}
@end
