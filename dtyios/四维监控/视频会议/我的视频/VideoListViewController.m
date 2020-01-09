//
//  VideoListViewController.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/8/11.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "VideoListViewController.h"
#import "Util.h"
#import "CommonUseClass.h"
#import "EventCurriculumEntity.h"
#import "HTTPSessionManager.h"
#import "RoomClass.h"
#import "AddPeopleViewController.h"

@interface VideoListViewController ()

@end

@implementation VideoListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title=@"房间列表";
    self.view.backgroundColor = [UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    UIButton* right_BarButoon_Item=[[UIButton alloc] init];
    right_BarButoon_Item.frame=CGRectMake(0, 0,40,35);
    [right_BarButoon_Item setTitle:@"发起" forState: UIControlStateNormal];
    [right_BarButoon_Item addTarget:self action:@selector(navRightBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_BarButoon_Item];
    self.navigationItem.rightBarButtonItems=@[rightItem];
    
    
    CourseTableview=[[UITableViewExForDeleteViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"RoomTableViewCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:CourseTableview.tableView];
    
    //CourseTableview.haveDeleteQX=NO;
    
    
    [self getSchoolCourse];
    
}

- (void)navRightBtn_Event:(UIButton*)btn
{
    AddPeopleViewController *vc = [[AddPeopleViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
    [self getSchoolCourse];
}
-(void)TableRowClick:(UITableItem*)value
{
}
-(void)pullUpdateData
{
    CourseTableview.PageIndex=1;
    [self getSchoolCourse];
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
    
    
    NSString *currUrl;
    currUrl=[NSString stringWithFormat:@"PageService/Base_MultiplayerVideo/%@/%@/GetPagesMultiplayerVideo",@"",app.userInfo.UserID];
    
    RoomClass *_search=[[RoomClass alloc]init];
    //    _search.Guid = app.userInfo.userGuid;
    
    NSString *strstr=[CommonUseClass classToJson:_search];
    
    [HTTPSessionManager
     post:currUrl
     parameters:strstr
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Status"];
         
         if([success longLongValue]!=0)
         {
             [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:nil waitUntilDone:NO];
             return ;
         }
         else
         {
             
             if (CourseTableview.PageIndex==1) {
                 [CourseTableview.dataSource removeAllObjects];
             }
             else
             {
                 [CourseTableview.dataSource removeLastObject];
             }
             
             NSMutableArray *array=[NSMutableArray arrayWithArray:[dic_result objectForKey:@"Results"]];
             
             EventCurriculumEntity *entity=[[EventCurriculumEntity alloc] init];
             entity.enroll_list=array;
             
             [self init_tableview_hear:entity];
             
             [self performSelectorOnMainThread:@selector(cc:) withObject:data waitUntilDone:NO];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:nil waitUntilDone:NO];
     }];
    
}

-(void)selectDataErr:(NSDictionary *)dict
{
    [CommonUseClass showAlter:MessageResult];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)cc:(id)data
{
    [self doneLoadingTableViewData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)NoDataShowImage
{
    UIView *view=[[UIView alloc ]initWithFrame:CGRectMake(0, 60, 320, 130)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((bounds_width.size.width-80)/2, 100, 80, 30)];
    label.text=@"暂无数据";
    label.textAlignment=NSTextAlignmentCenter;
    [label setTextColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]];
    [view addSubview:label];
    
    [CourseTableview.view addSubview:view];
    view.tag=3000;
}


//加载
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
            [CourseTableview.dataSource addObject:@"无更多数据"];
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
