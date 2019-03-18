//
//  RepairRecordVC.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "RepairRecordVC.h"
#import "EventCurriculumEntity.h"
#import "XXNet.h"
#import "RepairRecordDetailVC.h"
#import "RequestWhere.h"
@interface RepairRecordVC () {
    RequestWhere *_requestWhere;
    UIButton *btnSearch;
}

@end

@implementation RepairRecordVC
@synthesize app;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title=@"维修记录";
    self.navigationController.navigationBarHidden = NO;
}

- (void)shanBtnClick:(UIButton *)btn
{
    QRCodeViewController_WXJL * cdvc=[[QRCodeViewController_WXJL alloc] initWithNibName:@"QRCodeViewController_JX" bundle:nil];
    cdvc.Type_ID = @"2";
    cdvc.companyType=@"Ios_ESL_XJLXQYXC";
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:cdvc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [self RequestNetData];
    
    UILabel *labSearch = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-80, 30)];
    labSearch.text = @"高级搜索";
    labSearch.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labSearch];
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setImage:[UIImage imageNamed:@"scanning_48dp1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button.imageView setContentMode:UIViewContentModeScaleToFill];
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightbtn;
    
    btnSearch = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 10, 40, 30)];
    btnSearch.layer.masksToBounds = YES;
    btnSearch.layer.cornerRadius  = 15;
    [btnSearch setImage:[UIImage imageNamed:@"dt_search.png"] forState:UIControlStateNormal];
    [btnSearch setBackgroundColor:RGBACOLOR(53, 115, 249, 1)];
    [btnSearch addTarget:self action:@selector(btnSearchMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSearch];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btnSearch.frame)+10, SCREEN_WIDTH, 5)];
    line.backgroundColor = GrayColor(238);
    [self.view addSubview:line];
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"RepairRecordCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-55);
    [self.view addSubview:CourseTableview.tableView];
    [self initMySelect];
}
- (void)btnSearchMethod:(UIButton*)sender {
    mySelectView.view.hidden = NO;
}
//高级查询相关
-(void)initMySelect
{
    mySelectView = [[mySelect alloc]initWithNibName:@"mySelect" bundle:nil];
    mySelectView.view.frame = CGRectMake(0, 55, bounds_width.size.width,bounds_width.size.height);
    [self.view addSubview:mySelectView.view];
    
    mySelectView.view.hidden=YES;
    
    //13.2注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MySelect_Cancel:) name:@"tongzhi_MySelect_Cancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MySelect_Do:) name:@"tongzhi_MySelect_Do" object:nil];
}

- (void)MySelect_Cancel:(NSNotification *)text{
    mySelectView.view.hidden=YES;
}
- (void)MySelect_Do:(NSNotification *)text{
    _requestWhere=(RequestWhere *)text.userInfo[@"textOne"];
    mySelectView.view.hidden=YES;
    [self RequestNetData];
}

- (void)RequestNetData {
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[NSString stringWithFormat:@"%d", CourseTableview.PageIndex] forKey:@"PageIndex"];
    [dicHeader setValue:@"20" forKey:@"PageSize"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId] forKey:@"CityId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId] forKey:@"AddressId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId] forKey:@"UseId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId] forKey:@"MaintDeptId"];
    [XXNet GetURL:RepairRecordUrl header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
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
        
    }];
}

#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
}
-(void)TableRowClick:(UITableItem*)value
{
    NSLog(@"%@",(NSDictionary*)value);
    RepairRecordDetailVC *repair = [[RepairRecordDetailVC alloc]init];
    repair.dicData = (NSDictionary*)value;
    [self.navigationController pushViewController:repair animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
