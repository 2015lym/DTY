//
//  wyxcListViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/17.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "wyxcListViewController.h"
#import "warningElevatorModel.h"
#import "CommonUseClass.h"
#import "RequestWhere.h"
#import "MyControl.h"
#import "QRCodeViewController.h"
#import "WBDetailViewController.h"
#import "JHChartHeader.h"
#import "DTWBDetailViewController.h"

//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UIColorRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])
@interface wyxcListViewController ()
{
    NSString *tabSelectIndex;
    bool IsInitselect;
    RequestWhere *_requestWhere;
    

    
    
    UIScrollView *sc;
    
   
    UIButton *chaxunBtn;
    UIButton *chaxunBtn2;
    
    UIImageView *chaxunImg;
    UILabel *chaxunLab;
    UIView * bgView2;
    UILabel * bgView2_line2;
    
    
    UIView *imageView;
    
    int typeID;
    JHPieChart *pie;
}

@end

@implementation wyxcListViewController

@synthesize app;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=@"物业巡检";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_success" object:nil];
    
    typeID = 0;
    //init
    tabSelectIndex=@"";
    _requestWhere=[[RequestWhere alloc]init];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    IsInitselect=false;
   
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setImage:[UIImage imageNamed:@"scanning_48dp1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button.imageView setContentMode:UIViewContentModeScaleToFill];
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightbtn;
    
    
    
    //2
    bgView2= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView2];
    bgView2_line2= [[UILabel alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 5)];
    bgView2_line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView2 addSubview:bgView2_line2];
    
    
    
    chaxunImg = [MyControl createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 72, 42) imageName:@"dt_search.png"];
    [self.view addSubview:chaxunImg];
    
    chaxunLab=[[UILabel alloc]initWithFrame:CGRectMake(bounds_width.size.width-92-70, 7, 70, 30)];
    chaxunLab.textColor=[UIColor grayColor];
    chaxunLab.text=@"高级查询";
    [self.view addSubview:chaxunLab];
    
    
    
    chaxunBtn = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 80, 40) imageName:nil bgImageName:nil title:@"" SEL:@selector(chaXunBtnClick:) target:self];
    [chaxunBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //chaxunBtn.backgroundColor = [UIColor colorWithRed:0 green:119/255.0 blue:250/255.0 alpha:1.0];
    [self.view addSubview:chaxunBtn];
    
    chaxunBtn.frame = CGRectMake(SCREEN_WIDTH-90, 0, 80, 40);
    chaxunImg.frame = CGRectMake(SCREEN_WIDTH-90, 0, 72, 42);
    chaxunLab.frame = CGRectMake(chaxunLab.frame.origin.x, 7,chaxunLab.frame.size.width, chaxunLab.frame.size.height);
    
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"wyxcCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(chaxunBtn.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
    [self.view addSubview:CourseTableview.tableView];
    
    
    
   
    
    
    [self getSchoolCourse];
    
    //高级查询相关
    [self initMySelect];
}

- (void)shanBtnClick:(UIButton *)btn
{
    QRCodeViewController_WYXC * cdvc=[[QRCodeViewController_WYXC alloc] initWithNibName:@"QRCodeViewController_JX" bundle:nil];
    cdvc.Type_ID = @"2";
    cdvc.companyType=@"Ios_ESL_XJLXQYXC";
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:cdvc animated:YES];
    
}

//高级查询相关
-(void)initMySelect
{
    mySelectView = [[mySelect alloc]initWithNibName:@"mySelect" bundle:nil];
    mySelectView.view.frame = CGRectMake(0, 36, bounds_width.size.width, bounds_width.size.height-36 );
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
    
        [self getSchoolCourse];
    
}
//高级查询相关


- (void)tongzhi_warn:(NSNotification *)text
{
    [MBProgressHUD show:@"提交成功" icon:nil view:self.view];
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if(touch.view.tag==1000)
    {
        return NO;
    }
    
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

-(void)navRightBtn_Event:(id)sender
{
    NSLog(@"二维码");
    
    
    QRCodeViewController * cdvc=[[QRCodeViewController alloc] initWithNibName:@"QRCodeViewController" bundle:nil];
    [self.navigationController pushViewController:cdvc animated:YES];
}



- (void)chaXunBtnClick:(UIButton *)btn
{
    /*
     sc.hidden = NO;
     imageView.hidden=YES;
     [self ShowSelect];
     [self initSelect];
     [self CloseAllClassIfication];
     */
    [mySelectView initSelect];
    mySelectView.view.hidden=false;
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
    
    
        
        wyxcDetailViewController *vc = [[wyxcDetailViewController alloc] init];
        vc.lift_ID = warnmodel.ID;
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

#pragma mark getData


-(void)getSchoolCourse
{

    

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[NSString stringWithFormat:@"%d", CourseTableview.PageIndex] forKey:@"PageIndex"];
    [dicHeader setValue:@"20" forKey:@"PageSize"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId] forKey:@"CityId"];
    [dicHeader setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId] forKey:@"AddressId"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [XXNet GetURL:GetPropertyChecksURL header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
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
            NSMutableArray *  arr=[[NSMutableArray alloc]init];
            
          
            
            for (NSMutableDictionary *dic_item in arrData ){
                warningElevatorModel *model=[[warningElevatorModel alloc] init];
                model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CheckDate"]];
                model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                
                model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"IsPassed"]];
                
                warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                
                NSLog(@"dic_item==%@",dic_item);
                
                lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftNum"]];
                
                lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"InstallationAddress"]];
                
                
                model.RescueType=@"维保状态：";
                
                
                
                model.Lift=lift;
                [arr addObject:model];
            }
            
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"读取：%lu%@",(unsigned long)arrData.count,@"条数据!"] toView:nil];
            
            
            CurriculumEntity *entity=[[CurriculumEntity alloc] init];
            
            entity.enroll_list=arr;
            
            NSLog(@"=====%@",entity.enroll_list);
            
            
            if([entity.count isEqualToString:@"0"])
            {
                
            }
            [self init_tableview_hear:entity];
            
        }
        else
        {
            
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
            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
    }
}



@end
