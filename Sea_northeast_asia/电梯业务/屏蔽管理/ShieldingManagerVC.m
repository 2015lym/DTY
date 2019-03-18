//
//  ShieldingManagerVC.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/9.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "ShieldingManagerVC.h"
#import "EventCurriculumEntity.h"
#import "XXNet.h"
#import "RequestWhere.h"
@interface ShieldingManagerVC () {
    UIButton *btnSearch;
    RequestWhere *_requestWhere;
    EGOImageView *egoImg;
}

@end

@implementation ShieldingManagerVC
@synthesize app;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title=@"检测服务";
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    UILabel *labSearch = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-80, 20)];
    labSearch.text = @"高级搜索";
    labSearch.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labSearch];
    
    btnSearch = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 5, 40, 30)];
    btnSearch.layer.masksToBounds = YES;
    btnSearch.layer.cornerRadius  = 15;
    [btnSearch setImage:[UIImage imageNamed:@"dt_search.png"] forState:UIControlStateNormal];
    [btnSearch setBackgroundColor:RGBACOLOR(53, 115, 249, 1)];
    [btnSearch addTarget:self action:@selector(btnSearchMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSearch];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btnSearch.frame)+5, SCREEN_WIDTH, 5)];
    line.backgroundColor = GrayColor(238);
    [self.view addSubview:line];
    egoImg = [[EGOImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), 200, 160)];
    egoImg.center = CGPointMake(self.view.center.x,CGRectGetMaxY(line.frame)+80);
    egoImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:egoImg];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(egoImg.frame), SCREEN_WIDTH, 5)];
    line1.backgroundColor = GrayColor(238);
    [self.view addSubview:line1];
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"ShieldManagerCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(line1.frame));
    [self.view addSubview:CourseTableview.tableView];
    [self initMySelect];
    [self RequestNetData];
    [self GetImage];
}
- (void)btnSearchMethod:(UIButton*)sender {
    mySelectView.view.hidden = NO;
}
//高级查询相关
-(void)initMySelect
{
    mySelectView = [[mySelect alloc]initWithNibName:@"mySelect" bundle:nil];
    mySelectView.isPB=1;
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[NSString stringWithFormat:@"%d", CourseTableview.PageIndex] forKey:@"PageIndex"];
    [dicHeader setValue:@"20" forKey:@"PageSize"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [dicHeader setValue:@"2" forKey:@"Type"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId] forKey:@"CityId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId] forKey:@"AddressId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId] forKey:@"UseId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId] forKey:@"MaintDeptId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsShield] forKey:@"IsShield"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.ShieldReasonId] forKey:@"ShieldReasonId"];
    [XXNet GetURL:GetOnlineListUrl header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        NSLog(@"%@",data);
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
- (void)GetImage {
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[NSString stringWithFormat:@"%d", CourseTableview.PageIndex] forKey:@"PageIndex"];
    [dicHeader setValue:@"20" forKey:@"PageSize"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [dicHeader setValue:@"2" forKey:@"Type"];
    [XXNet GetURL:GetOnlineRatesPicUrl header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
        //        NSLog(@"%@",data);
        if ([data[@"Success"]intValue]) {
            NSString *base64String = data[@"Data"];
            NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:base64String options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
            // 将NSData转为UIImage
            UIImage *decodedImage = [UIImage imageWithData: decodeData];
            [self performSelectorOnMainThread:@selector(GetDetailSuccess:) withObject:decodedImage waitUntilDone:NO];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)GetDetailSuccess:(UIImage*)img {
    egoImg.image = img;
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    image.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:image];
//    image.image = img;
}
@end
