//
//  TZTGViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/15.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "TZTGViewController.h"
#import "EventCurriculumEntity.h"
#import "XXNet.h"
#import "RequestWhere.h"
#import "CurriculumEntity.h"
@interface TZTGViewController (){
    UIButton *btnSearch;
}


@end

@implementation TZTGViewController

@synthesize app;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title=@"通知通告";
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"TZTGCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:CourseTableview.tableView];
   
    [self RequestNetData];
}

- (void)RequestNetData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[NSString stringWithFormat:@"%d", CourseTableview.PageIndex] forKey:@"PageIndex"];
    [dicHeader setValue:@"20" forKey:@"PageSize"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [XXNet GetURL:GetArticleListURL header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            if (CourseTableview.PageIndex==1) {
                [CourseTableview.dataSource removeAllObjects];
            }
            else
            {
                [CourseTableview.dataSource removeLastObject];
            }
            NSString *str_json = data[@"Data"];
            NSArray *arrData = [str_json objectFromJSONString];
            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:arrData];
            CurriculumEntity *entity=[[CurriculumEntity alloc] init];
            
            entity.enroll_list=arr;
            [self init_tableview_hear:entity];
            [CourseTableview.tableView reloadData];
            [CourseTableview doneLoadingTableViewData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
}
-(void)TableRowClick:(UITableItem*)value
{
    NSMutableDictionary *dic_value=(NSMutableDictionary *)value;
    
    TZTGDetailViewController *detal=[[TZTGDetailViewController alloc]init];
    detal.ID=[dic_value objectForKey:@"ID"];
     [self.navigationController pushViewController:detal animated:YES];
}

-(void)pullUpdateData
{
    CourseTableview.PageIndex=1;
    [self RequestNetData];
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
            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
