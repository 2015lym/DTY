//
//  YJFXMainViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/18.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "YJFXMainViewController.h"
#import "Util.h"
#import "CommonUseClass.h"
#import "EventCurriculumEntity.h"
#import "HTTPSessionManager.h"




@interface YJFXMainViewController ()

@end

@implementation YJFXMainViewController

@synthesize app;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.navigationItem.title=@"预警分析";
    
    
    CourseTableview=[[UITableViewExForDeleteViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"HouseKeeperCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    CourseTableview.tableView.scrollEnabled=NO;
    //行高
    CourseTableview.currHeight= 44;
    CourseTableview.tableView.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:CourseTableview.tableView];
    
    
    //CourseTableview.haveDeleteQX=NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"tongzhi_SelectPark" object:nil];
    //刷新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_Refresh2" object:nil];
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    NSMutableDictionary *dict1=[[NSMutableDictionary alloc]init];
    [dict1 setObject:@"救援平均到场时间" forKey:@"Name"];
    [dict1 setObject:@"yjfx_comprehensive" forKey:@"img"];
    [dict1 setObject:[Ksdby_api_Img stringByAppendingString:[NSString stringWithFormat:@"/WebApp/Statistics/RescueTime?UserId=%@",app.userInfo.UserID]] forKey:@"url"];
    NSMutableDictionary *dict2=[[NSMutableDictionary alloc]init];
    [dict2 setObject:@"电梯年限" forKey:@"Name"];
    [dict2 setObject:@"yjfx_elevator" forKey:@"img"];
    [dict2 setObject:[Ksdby_api_Img stringByAppendingString:[NSString stringWithFormat:@"/WebApp/Statistics/ElevatorAge?UserId=%@",app.userInfo.UserID]] forKey:@"url"];
    NSMutableDictionary *dict3=[[NSMutableDictionary alloc]init];
    [dict3 setObject:@"本月超期未检电梯数量" forKey:@"Name"];
    [dict3 setObject:@"yjfx_overdue" forKey:@"img"];
    [dict3 setObject:[Ksdby_api_Img stringByAppendingString:[NSString stringWithFormat:@"/WebApp/Statistics/Overdue?UserId=%@",app.userInfo.UserID]] forKey:@"url"];
    NSMutableDictionary *dict4=[[NSMutableDictionary alloc]init];
    [dict4 setObject:@"无纸化维保电梯数量" forKey:@"Name"];
    [dict4 setObject:@"yjfx_maintenance" forKey:@"img"];
    [dict4 setObject:[Ksdby_api_Img stringByAppendingString:[NSString stringWithFormat:@"/WebApp/Statistics/MaintenanceRatio?UserId=%@",app.userInfo.UserID]] forKey:@"url"];
    NSMutableDictionary *dict5=[[NSMutableDictionary alloc]init];
    [dict5 setObject:@"报警总数" forKey:@"Name"];
    [dict5 setObject:@"yjfx_police" forKey:@"img"];
    [dict5 setObject:[Ksdby_api_Img stringByAppendingString:[NSString stringWithFormat:@"/WebApp/Statistics/AlarmRatio?UserId=%@",app.userInfo.UserID]] forKey:@"url"];
    
    [array addObject:dict1];
    [array addObject:dict2];
    [array addObject:dict3];
    [array addObject:dict4];
    [array addObject:dict5];
    
    EventCurriculumEntity *entity=[[EventCurriculumEntity alloc] init];
    entity.enroll_list=array;
    
    [self init_tableview_hear:entity];
    
    
}



- (void)InfoNotificationAction:(NSNotification *)notification
{
    NSLog(@"notification==%@",notification.userInfo);
    
}
- (void)tongzhi_warn:(NSNotification *)text
{
    CourseTableview.PageIndex=1;
    //    [self getSchoolCourse];
}

- (void)navRightBtn_Event
{
    //    AddHouseViewController *vc = [AddHouseViewController new];
    //    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TablviewDelegateEX


#pragma mark 选中行

-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
    //    [self getSchoolCourse];
}



-(void)TableRowClick:(UITableItem*)value
{
    NSMutableDictionary *dic_value=(NSMutableDictionary *)value;
    
    LiftHelpViewController *detal=[[LiftHelpViewController alloc]init];
    detal.dic_data=dic_value;
    [self.navigationController pushViewController:detal animated:YES];
   
    
    
}

-(void)pullUpdateData
{
    CourseTableview.PageIndex=1;
    //    [self getSchoolCourse];
}
- (void)doneLoadingTableViewData
{
    [CourseTableview.tableView reloadData];
    [CourseTableview doneLoadingTableViewData];
    CourseTableview.max_Cell_Star=YES;
}


-(void)btnSelect:(int)indexPath{
    
    NSMutableDictionary *dic_value= [CourseTableview.dataSource objectAtIndex:indexPath];
    
    
}


//缓存处理
-(void)cc:(NSDictionary *)dict
{
    [self doneLoadingTableViewData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)init_tableview_hear:(EventCurriculumEntity *)entity
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
            //            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
        
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
