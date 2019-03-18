//
//  JYGLListViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/23.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "JYGLListViewController.h"
#import "warningElevatorModel.h"
#import "CommonUseClass.h"
#import "RequestWhere.h"
#import "MyControl.h"

#import "JHChartHeader.h"
#import "UMMobClick/MobClick.h"

//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UIColorRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])

@interface JYGLListViewController ()
{
    NSString *tabSelectIndex;
    bool IsInitselect;
    RequestWhere *_requestWhere;
    
    UIView * bgView;
    UIButton * leftBtn;
    UIButton * centertBtn;
    UIButton * rightBtn;
    UILabel * btnLine;
    
    UIScrollView *sc;
    UIView *_view_pop;
    UIView *_view_Content;
    
    NSMutableArray *SelectCity;
    NSMutableArray *SelectQu;
    NSMutableArray *SelectUserDecp;
    NSMutableArray *SelectMaint;
    NSMutableArray *SelectState;
    
    UILabel *shi_lab;
    
    UILabel *shi_labDetail;
    UILabel *qu_labDetail;
    UILabel *sydw_labDetail;
    UILabel *wbdw_labDetail;
    
    UIButton *shi_labBtn;
    UIButton *qu_labBtn;
    UIButton *sydw_labBtn;
    UIButton *wbdw_labBtn;
    UIButton *chaxunBtn;
    UIButton *chaxunBtn2;
    UIImageView *chaxunImg;
    UILabel *chaxunLab;
    UIView * bgView2;
    UILabel * bgView2_line2;
    
    UIImageView *imageView;
    
    int typeID;
}
@end

@implementation JYGLListViewController

@synthesize app;
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JYGLViewController"];
    
    self.navigationItem.title=@"检测服务";
    self.navigationController.navigationItem.title=@"检测服务";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"JYGLViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 0, 25, 25);
    [button setImage:[UIImage imageNamed:@"scanning_48dp1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button.imageView setContentMode:UIViewContentModeScaleToFill];
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightbtn;
    
//    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
//    left_BarButoon_Item.frame=CGRectMake(0, 0,80,25);
//    //[left_BarButoon_Item setTitle:@"输码进入" forState:UIControlStateNormal];
//    [left_BarButoon_Item setImage: [UIImage imageNamed:@"scanning_48dp"] forState:UIControlStateNormal];
//    [left_BarButoon_Item addTarget:self action:@selector(listBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
//    self.navigationItem.rightBarButtonItems=@[leftItem];
    
    typeID = 0;
    //init
    tabSelectIndex=@"NULL";
    _requestWhere=[[RequestWhere alloc]init];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    IsInitselect=false;
   
    
    
    
    
    
    
    //1
//    UIView *V1=[[UIView alloc]init];
//    V1.frame=CGRectMake(0, 0, bounds_width.size.width, 66);
//    V1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
//    [self.view addSubview:V1];
//
//    UILabel *lab=[MyControl createLabelWithFrame:CGRectMake(0, 10, bounds_width.size.width, 56) Font:18 Text:@"检验列表"];
//    lab.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
//    lab.textColor=[UIColor whiteColor];
//    lab.textAlignment=NSTextAlignmentCenter;
//    [self.view addSubview: lab];
//
//    //1.2
//    chaxunImg = [MyControl createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-40, 24, 30, 30) imageName:@"scanning_48dp"];
//    [self.view addSubview:chaxunImg];
//
//    chaxunBtn = [MyControl createButtonWithFrame:chaxunImg.frame imageName:nil bgImageName:nil title:@"" SEL:@selector(shanBtnClick:) target:self];
//    [chaxunBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    chaxunBtn.tag = 103;
//    [self.view addSubview:chaxunBtn];
//
//
    int defaltHeight=64;
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"JYGLListCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    //CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(chaxunBtn.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
    CourseTableview.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:CourseTableview.tableView];
    
    
    
    
   
    
    
    if (typeID==0) {
        
        [self getSchoolCourse];
    }
    
    
    
}
- (void)shanBtnClick:(UIButton *)btn
{
    QRCodeViewController_JX * cdvc=[[QRCodeViewController_JX alloc] initWithNibName:@"QRCodeViewController_JX" bundle:nil];
    cdvc.Type_ID = @"2";
    cdvc.companyType=@"Ios_ESL_XJLXQYXC";
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:cdvc animated:YES];
    
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
-(void)btnClick:(UIButton*)btn{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        btnLine.frame =CGRectMake( ((btn.tag-100)*SCREEN_WIDTH/3)+(SCREEN_WIDTH/3-60)/2, CGRectGetMaxY(bgView.frame)+1, 60, 2);
    }];
    
    
    if (btn.tag==100) {
        
        typeID=0;
        
        
        [imageView removeFromSuperview];
        //imageView.hidden=YES;
        sc.hidden=YES;
        [self getSchoolCourse];
        
        
        bgView2.frame= CGRectMake(0, 42, SCREEN_WIDTH, 55);
        bgView2_line2.frame= CGRectMake(0, bgView2.frame.size.height-5, SCREEN_WIDTH, 5);
        
        CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(chaxunBtn.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
        
        NSLog(@"===100");
    }
    
    
}

- (void)chaXunBtnClick:(UIButton *)btn
{
    /*
     NSLog(@"====103");
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
    if (typeID==0) {
        
        [self getSchoolCourse];
    }
    
}
-(void)TableRowClick:(UITableItem*)value
{
   
     warningElevatorModel *warnModel=(warningElevatorModel *)value;
     
     JYGLDetailViewController *ctvc=[[JYGLDetailViewController alloc] init];
     ctvc.model=warnModel;
     ctvc.liftNum=warnModel.Lift.LiftNum;
     
     [self.navigationController pushViewController:ctvc animated:YES];
     
    
}
-(void)TableHeaderRowClick:(UITableItem*)value
{
    
}
-(void)pullUpdateData
{
    CourseTableview.PageIndex=1;
    if (typeID==0) {
        
        [self getSchoolCourse];
    }
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
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [XXNet GetURL:GetInspectList header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
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
            NSMutableArray *allTags = [[NSMutableArray alloc]initWithArray:arrData];
                 NSMutableArray *  arr=[[NSMutableArray alloc]init];
                 
                 //                 NSLog(@"allTags==%@",allTags);
                 
                 for (NSMutableDictionary *dic_item in allTags ){
                     warningElevatorModel *model=[[warningElevatorModel alloc] init];
                     
                    model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CreateTime"]];
                     
                     model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                     
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"IsOver"]];
                     model.StatusName=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"CertificateNum"]];
                     
                     //                     NSLog(@"%@",model.TotalLossTime);
                     
                     warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                     
                     lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftNum"]];
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
                 
                 [self performSelector:@selector(doneLoadingTableViewData) withObject:allTags afterDelay:0.1];
            
             
         }
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSError *error) {
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
            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
