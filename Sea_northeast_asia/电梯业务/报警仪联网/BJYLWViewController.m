//
//  BJYLWViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/23.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "BJYLWViewController.h"
#import "warningElevatorModel.h"
#import "CommonUseClass.h"
#import "RequestWhere.h"

@interface BJYLWViewController ()
{
    int tabSelectIndex;
    bool IsInitselect;
    RequestWhere *_requestWhere;
    
    NSMutableArray *SelectCity;
    NSMutableArray *SelectQu;
    NSMutableArray *SelectUserDecp;
    NSMutableArray *SelectMaint;
    NSMutableArray *SelectState;
    
    NSMutableArray *SelectPB;
}
@end

@implementation BJYLWViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init
    tabSelectIndex=0;
    _requestWhere=[[RequestWhere alloc]init];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self tab_Init];
    IsInitselect=false;
    [self CloseSelect];
    [self CloseAllClassIfication];
    
    //UITapGestureRecognizer
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    tapGesture.delegate=self;
    [_scrollView addGestureRecognizer:tapGesture];

    //init frame
    _scrollView.frame=CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, bounds_width.size.width, bounds_width.size.height-36);
    _scrollView.backgroundColor = [UIColor redColor];
    _view1.frame=CGRectMake(_view1.frame.origin.x, _view1.frame.origin.y, bounds_width.size.width, bounds_width.size.height-36);
     _view1Head.frame=CGRectMake(_view1Head.frame.origin.x, _view1Head.frame.origin.y, bounds_width.size.width, _view1Head.frame.size.height);
    _view1List.frame=CGRectMake(_view1List.frame.origin.x, _view1List.frame.origin.y, bounds_width.size.width, bounds_width.size.height-36-_view1List.frame.origin.x);
     _chart1.frame=CGRectMake((bounds_width.size.width-_chart1.frame.size.width)/2, _chart1.frame.origin.y, _chart1.frame.size.width, _chart1.frame.size.height);
    //_btnSelect.frame=CGRectMake(bounds_width.size.width-8-_btnSelect.frame.size.width, _btnSelect.frame.origin.y, _btnSelect.frame.size.width, _btnSelect.frame.size.height);
    _btnSelect.frame=CGRectMake(bounds_width.size.width-8-60,0, 60, 42);
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 42, bounds_width.size.width, 1)];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_view1Head addSubview:line];
    _imgSelect.frame=_btnSelect.frame;
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(bounds_width.size.width-54-20-70, _btnSelect.frame.origin.y+7, 70, 30)];
    lab.textColor=[UIColor grayColor];
    lab.text=@"高级查询";
    [_view1Head addSubview:lab];
    
    //init Data
    [self InitList];
    
    //高级查询相关
    [self initMySelect];
   
}
//高级查询相关
-(void)initMySelect
{
    mySelectView = [[mySelect alloc]initWithNibName:@"mySelect" bundle:nil];
    mySelectView.isHaveState=1;
    mySelectView.stateAll=@"安装状态(全部)";
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
    [self getSchoolCoursePic];
}
//高级查询相关

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=@"报警仪联网";
    self.navigationController.navigationBarHidden = NO;
}

-(void)InitList{
    _view1List.backgroundColor=[UIColor groupTableViewBackgroundColor];
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"SBAZCell" tableCells_Index:0];
    
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(_view1List.frame.origin.x, 5, bounds_width.size.width, bounds_width.size.height-36-_view1List.frame.origin.x-5);
    // Do any additional setup after loading the view.
    CourseTableview.tableView.frame = CGRectMake(_view1List.frame.origin.x, 5, bounds_width.size.width, bounds_width.size.height-36-_view1List.frame.origin.x-5);
    
    [_view1List addSubview:CourseTableview.tableView];
    
    [self getSchoolCourse];
    [self getSchoolCoursePic];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)Actiondo:(UITapGestureRecognizer *)gesture
{
    
    [self CloseAllClassIfication];
    /*
    [_txtPeopleCount resignFirstResponder];
    [_txtPeoplePhone resignFirstResponder];
    [_txtConter resignFirstResponder];
    [_txtYY resignFirstResponder];
    [_txtJJ resignFirstResponder];
    */
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

#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
    [self getSchoolCourse];
}
-(void)TableRowClick:(UITableItem*)value
{
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
-(void)getSchoolCoursePic
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%i",1] forHTTPHeaderField:@"PageIndex"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:@"999999" forHTTPHeaderField:@"PageSizeRate"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",tabSelectIndex]forHTTPHeaderField:@"Type"];
    
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId]forHTTPHeaderField:@"CityId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId]forHTTPHeaderField:@"AddressId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId]forHTTPHeaderField:@"MaintDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId]forHTTPHeaderField:@"UseDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsInstallation]forHTTPHeaderField:@"IsInstallation"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsOnline]forHTTPHeaderField:@"IsOnline"];

    
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:@"Online/GetOnlineRatesPic"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         
         
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                 //NSMutableArray *  allTags=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 
                 NSData *_decodedImageData = [[NSData alloc] initWithBase64Encoding:[dic_result objectForKey:@"Data"] ];
                 
                 UIImage *_decodedImage = [UIImage imageWithData:_decodedImageData];
                 _chart1.image=_decodedImage;
             }
             else
             {
                 
             }
         }
         else
         {
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"获取图表失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
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
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",tabSelectIndex]forHTTPHeaderField:@"Type"];
    
    NSLog(@"tabSelectIndex==%d",tabSelectIndex);
    
    
     [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId]forHTTPHeaderField:@"CityId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId]forHTTPHeaderField:@"AddressId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId]forHTTPHeaderField:@"MaintDeptId"];
     [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId]forHTTPHeaderField:@"UseDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsInstallation]forHTTPHeaderField:@"IsInstallation"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsOnline]forHTTPHeaderField:@"IsOnline"];
    
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:@"Online/GetOnlineList"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         NSLog(@"success:%@",responseObject);
         
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
                     model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UpdateDatetime"]];
                     model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                     
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintenancePeriod"]];
                    
                     NSLog(@"%@",model.TotalLossTime);
                     
                     warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                     
                     lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftNum"]];
                     lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"InstallationAddress"]];
                     
                     
                     model.Lift=lift;
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
             else
             {
                 
             }
         }
         else
         {
             
         }
         
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
        else
        {
            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
    }
}

#pragma mark tab_about_start
- (void)tab_Init {
    float width=bounds_width.size.width/2;
    _tab_line.frame=CGRectMake(_tab_line.frame.origin.x, _tab_line.frame.origin.y, bounds_width.size.width, _tab_line.frame.size.height);
    _tab_lblSBAZ.frame=CGRectMake(_tab_lblSBAZ.frame.origin.x, _tab_lblSBAZ.frame.origin.y, width, _tab_lblSBAZ.frame.size.height);
    _tab_LWZT.frame=CGRectMake(width, _tab_LWZT.frame.origin.y, width, _tab_LWZT.frame.size.height);
    _tab_btnSBAZ.frame=CGRectMake(_tab_btnSBAZ.frame.origin.x, _tab_btnSBAZ.frame.origin.y, width, _tab_btnSBAZ.frame.size.height);
     _tab_btnLWZT.frame=CGRectMake(width, _tab_btnLWZT.frame.origin.y, width, _tab_btnLWZT.frame.size.height);
     _tab_lineSelect.frame=CGRectMake((width-60)/2, _tab_lineSelect.frame.origin.y, 60, _tab_lineSelect.frame.size.height);
}

- (void)tab_Select:(int)index {
    mySelectView.view.hidden=YES;
    
    float width=bounds_width.size.width/2;
    switch (index) {
        case 1:
            _tab_lineSelect.frame=CGRectMake((width-60)/2, _tab_lineSelect.frame.origin.y, 60, _tab_lineSelect.frame.size.height);
            break;
        case 2:
            _tab_lineSelect.frame=CGRectMake((width-60)/2+width, _tab_lineSelect.frame.origin.y, 60, _tab_lineSelect.frame.size.height);
            break;
            
        default:
            break;
    }
}

- (IBAction)tab_btnSBAZClick:(id)sender {
    [self tab_Select:1];
    _lblState.text=@"安装状态";
    
    CourseTableview.PageIndex=1;
    tabSelectIndex=0;
    [self InitSelect];
    [self getSchoolCourse];
    [self getSchoolCoursePic];

}

- (IBAction)tab_btnLWZTClick:(id)sender {
    [self tab_Select:2];
    _lblState.text=@"在线状态";
    
    CourseTableview.PageIndex=1;
    tabSelectIndex=1;
    [self InitSelect];
    [self getSchoolCourse];
    [self getSchoolCoursePic];
}
//tab about end


#pragma mark event
- (IBAction)btnSelectClick:(id)sender {
    
     /*
     [self ShowSelect];
     [self initSelect];
     [self CloseAllClassIfication];
      */
    
    mySelectView.tabSelectIndex=tabSelectIndex;
    if(tabSelectIndex==0)
        mySelectView.stateAll=@"安装状态(全部)";
    else
        mySelectView.stateAll=@"在线状态(全部)";
    [mySelectView initSelect];
    mySelectView.view.hidden=false;
}

#pragma mark ClassIficationDelegate
-(void)CloseAllClassIfication
{
    [view_ification_02 removeFromSuperview];
    view_ification_02=nil;
    _view_pop.hidden=true;
}

-(void)ColesTypeView:(UIView *)typeView
{
    if(typeView ==view_ification_02)
    {
        if (view_ification_02!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_02.frame;
                rect.size.height=0;
                view_ification_02.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_02 removeFromSuperview];
                view_ification_02=nil;
            }];
        }
    }
    
}
-(void)Cell_OnClick:(id)Content typeView:(UIView *)typeView
{
    ClassIfication *currClass=(ClassIfication *)typeView;
    if(typeView ==view_ification_02)
    {
        if(currClass.table_view.tag==1)
            {
                _txtCity.text=[Content objectForKey:@"tagName"];
                _txtCity.tag=[[Content objectForKey:@"tagId"] intValue];
                
                //qu
                SelectQu=[[NSMutableArray alloc]init];
                NSMutableDictionary *d4 = [NSMutableDictionary dictionaryWithCapacity:2];
                [d4 setObject:@"0" forKey:@"tagId"];
                [d4 setObject:@"全部" forKey:@"tagName"];
                [SelectQu addObject:d4];
                
                _txtQu.text=@"全部" ;
                _txtQu.tag=0;

                [self initQu:_txtCity.tag];
                
                //decp
                SelectUserDecp=[[NSMutableArray alloc]init];
                NSMutableDictionary *d5 = [NSMutableDictionary dictionaryWithCapacity:2];
                [d5 setObject:@"0" forKey:@"tagId"];
                [d5 setObject:@"全部" forKey:@"tagName"];
                [SelectUserDecp addObject:d5];
                
                _txtUserDept.text=@"全部" ;
                _txtUserDept.tag=0;

                [self initUserDecp:_txtCity.tag byDistrictId: 0];
                
                //decp
                SelectMaint=[[NSMutableArray alloc]init];
                NSMutableDictionary *d6 = [NSMutableDictionary dictionaryWithCapacity:2];
                [d6 setObject:@"0" forKey:@"tagId"];
                [d6 setObject:@"全部" forKey:@"tagName"];
                [SelectMaint addObject:d6];
                
                _txtMaintDept.text=@"全部" ;
                _txtMaintDept.tag=0;
                
                [self initMaint:_txtCity.tag byDistrictId: 0];
            }
            else if(currClass.table_view.tag==2)
            {
                _txtQu.text=[Content objectForKey:@"tagName"];
                _txtQu.tag=[[Content objectForKey:@"tagId"] intValue];
                
                //decp
               SelectUserDecp=[[NSMutableArray alloc]init];
                NSMutableDictionary *d5 = [NSMutableDictionary dictionaryWithCapacity:2];
                [d5 setObject:@"0" forKey:@"tagId"];
                [d5 setObject:@"全部" forKey:@"tagName"];
                [SelectUserDecp addObject:d5];
                
                _txtUserDept.text=@"全部" ;
                _txtUserDept.tag=0;
                
                [self initUserDecp:_txtCity.tag byDistrictId: _txtQu.tag];
               
                //decp
                SelectMaint=[[NSMutableArray alloc]init];
                NSMutableDictionary *d6 = [NSMutableDictionary dictionaryWithCapacity:2];
                [d6 setObject:@"0" forKey:@"tagId"];
                [d6 setObject:@"全部" forKey:@"tagName"];
                [SelectMaint addObject:d6];
                
                _txtMaintDept.text=@"全部" ;
                _txtMaintDept.tag=0;
                
                [self initMaint:_txtCity.tag byDistrictId: _txtQu.tag];
            }
            else if(currClass.table_view.tag==3)
            {
                _txtUserDept.text=[Content objectForKey:@"tagName"];
                _txtUserDept.tag=[[Content objectForKey:@"tagId"] intValue];
               
            }
            else if(currClass.table_view.tag== 4)
            {
                 _txtMaintDept.text=[Content objectForKey:@"tagName"];
                _txtMaintDept.tag=[[Content objectForKey:@"tagId"] intValue];
                
            }
        else if(currClass.table_view.tag== 5)
        {
                _txtState.text=[Content objectForKey:@"tagName"];
                _txtState.tag=[[Content objectForKey:@"tagId"] intValue];
            
        }
        
        if (view_ification_02!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_02.frame;
                rect.size.height=0;
                view_ification_02.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_02 removeFromSuperview];
                view_ification_02=nil;
            }];
        }
        
        
    }
    _view_pop.hidden=true;
    
}


#pragma mark 下拉列表相关
- (void)ShowSelect
{
    _viewSelect.hidden=false;
}
- (void)CloseSelect
{
    _viewSelect.hidden=true;
}

-(void)InitSelect
{
    _txtCity.text= @"全部";
    _txtCity.tag=0;
    _txtQu.text=@"全部" ;
    _txtQu.tag=0;
    _txtUserDept.text=@"全部" ;
    _txtUserDept.tag=0;
    _txtMaintDept.text=@"全部" ;
    _txtMaintDept.tag=0;
    _txtState.text=@"全部" ;
    _txtState.tag=0;
    
    _requestWhere=[[RequestWhere alloc]init];
}

- (void)initSelectFrame
{
     _viewSelect.frame=CGRectMake(_viewSelect.frame.origin.x, _viewSelect.frame.origin.y, bounds_width.size.width, _viewSelect.frame.size.height);
    float width=bounds_width.size.width/2;
    
    _txtCity.frame=CGRectMake(_txtCity.frame.origin.x, _txtCity.frame.origin.y, width-20-34-20, _txtCity.frame.size.height);
    _btnCity.frame=CGRectMake(_txtCity.frame.origin.x, _txtCity.frame.origin.y, width-20-34-20, _txtCity.frame.size.height);
    
    _lblQu.frame=CGRectMake(width, _lblQu.frame.origin.y, _lblQu.frame.size.width, _lblQu.frame.size.height);
    _txtQu.frame=CGRectMake(width+34, _txtQu.frame.origin.y, width-20-34-20, _txtQu.frame.size.height);
    _btnQu.frame=CGRectMake(width+34, _txtQu.frame.origin.y, width-20-34-20, _txtQu.frame.size.height);
    
     _txtUserDept.frame=CGRectMake(_txtUserDept.frame.origin.x, _txtUserDept.frame.origin.y, bounds_width.size.width-91-10, _txtUserDept.frame.size.height);
    _btnUserDept.frame=CGRectMake(_txtUserDept.frame.origin.x, _txtUserDept.frame.origin.y, bounds_width.size.width-91-10, _txtUserDept.frame.size.height);
    
    _txtMaintDept.frame=CGRectMake(_txtMaintDept.frame.origin.x, _txtMaintDept.frame.origin.y, bounds_width.size.width-91-10, _txtMaintDept.frame.size.height);
    _btnMaintDept.frame=CGRectMake(_btnMaintDept.frame.origin.x, _btnMaintDept.frame.origin.y, bounds_width.size.width-91-10, _btnMaintDept.frame.size.height);
    
    _txtState.frame=CGRectMake(_txtState.frame.origin.x, _txtState.frame.origin.y, bounds_width.size.width-91-10, _txtState.frame.size.height);
    _btnState.frame=CGRectMake(_btnState.frame.origin.x, _btnState.frame.origin.y, bounds_width.size.width-91-10, _btnState.frame.size.height);
    
   
     _btnClear.frame=CGRectMake(width- _btnClear.frame.size.width/2, _btnClear.frame.origin.y, _btnClear.frame.size.width, _btnClear.frame.size.height);
     _btnDo.frame=CGRectMake(bounds_width.size.width-8-_btnDo.frame.size.width, _btnDo.frame.origin.y, _btnDo.frame.size.width, _btnDo.frame.size.height);

}
- (void)initSelect
{
    if(!IsInitselect)
    {
        [self initSelectFrame];
        SelectCity=[[NSMutableArray alloc]init];
        NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d1 setObject:@"0" forKey:@"tagId"];
        [d1 setObject:@"全部" forKey:@"tagName"];
        [SelectCity addObject:d1];
        
        SelectUserDecp=[[NSMutableArray alloc]init];
        NSMutableDictionary *d2 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d2 setObject:@"0" forKey:@"tagId"];
        [d2 setObject:@"全部" forKey:@"tagName"];
        [SelectUserDecp addObject:d2];

        SelectMaint=[[NSMutableArray alloc]init];
        NSMutableDictionary *d3 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d3 setObject:@"0" forKey:@"tagId"];
        [d3 setObject:@"全部" forKey:@"tagName"];
        [SelectMaint addObject:d3];
        
        SelectState=[[NSMutableArray alloc]init];
        NSMutableDictionary *d4 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d4 setObject:@"0" forKey:@"tagId"];
        [d4 setObject:@"全部" forKey:@"tagName"];
        [SelectState addObject:d4];
        
        [self initCity];
        [self initUserDecp:0 byDistrictId: 0];
        [self initMaint:0 byDistrictId: 0];
        [self initState];
    }
    IsInitselect=true;
}
//city
- (void)initCity
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *string = [@"Address/GetCityList?userId=" stringByAppendingString:[NSString stringWithFormat:@"%@",app.userInfo.UserID]];
        [[AFAppDotNetAPIClient sharedClient_token]
         GET:string
         parameters:nil
         progress:^(NSProgress * _Nonnull uploadProgress) {}
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSLog(@"success:%@",responseObject);
             
             
             NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSDictionary* dic_result=[str_result objectFromJSONString];
             
             if (dic_result.count>0) {
                 int state_value=[[dic_result objectForKey:@"Success"] intValue];
                 if (state_value==1) {
                     NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                     for (NSMutableDictionary *dic_item in currArr )
                     {
                         NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                         [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                         [d1 setObject:[dic_item objectForKey:@"Name"]  forKey:@"tagName"];

                         [SelectCity addObject:d1];
                     }
                 }
                 else
                 {
                    
                 }
             }
             else
             {
               
             }
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"error:%@",[error userInfo] );
             [CommonUseClass showAlter:@"获取市列表失败"];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }];
    
}
//区
- (void)initQu:(long)cityId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *string = [@"Address/GetAreaList?userId=" stringByAppendingString:[NSString stringWithFormat:@"%@",app.userInfo.UserID]];
    string = [string stringByAppendingString:@"&cityId="];
    string = [string stringByAppendingString:[NSString stringWithFormat:@"%ld",cityId]];
    
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:string
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1){
                 NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 for (NSMutableDictionary *dic_item in currArr ){
                     NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                         [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                         [d1 setObject:[dic_item objectForKey:@"Name"]  forKey:@"tagName"];
                         
                         [SelectQu addObject:d1];
                 }

             }
             else
             {
                 
             }
         }
         else
         {
            
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [CommonUseClass showAlter:@"获取区列表失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}
//UserDecp
- (void)initUserDecp:(long)CityId byDistrictId:(long)DistrictId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forKey:@"UserId"];
   
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%ld",CityId] forHTTPHeaderField:@"CityId"];

        [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%ld",DistrictId] forHTTPHeaderField:@"DistrictId"];
  
    NSString *string = @"Dept/GetUseDeptList";
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:string
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                 NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 for (NSMutableDictionary *dic_item in currArr )
                 {
                     NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                     [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                     [d1 setObject:[dic_item objectForKey:@"DeptName"]  forKey:@"tagName"];
                     
                     [SelectUserDecp addObject:d1];
                 }

             }
             else
             {
                 
             }
         }
         else
         {
        }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [CommonUseClass showAlter:@"获取使用单位列表失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}
//MaintDecp
- (void)initMaint:(long)CityId byDistrictId:(long)DistrictId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forKey:@"UserId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%ld",CityId] forHTTPHeaderField:@"CityId"];
    
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%ld",DistrictId] forHTTPHeaderField:@"DistrictId"];
    
    NSString *string = @"Dept/GetMaintDeptList";
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:string
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                 NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 for (NSMutableDictionary *dic_item in currArr )
                 {
                     NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                     [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                     [d1 setObject:[dic_item objectForKey:@"DeptName"]  forKey:@"tagName"];
                     
                     [SelectMaint addObject:d1];
                 }

             }
             else
             {
                
             }
         }
         else
         {
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [CommonUseClass showAlter:@"获取维保单位列表失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}
//state
- (void)initState
{
    
    NSMutableDictionary *d2 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d2 setObject:@"1" forKey:@"tagId"];
    [d2 setObject:@"是" forKey:@"tagName"];
    [SelectState addObject:d2];
    
    NSMutableDictionary *d3 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d3 setObject:@"0" forKey:@"tagId"];
    [d3 setObject:@"否" forKey:@"tagName"];
    [SelectState addObject:d3];
}
- (IBAction)btnPopClick:(id)sender {
    
    UIButton * currBtn=( UIButton *)sender;
    
    NSLog(@"%ld",currBtn.tag);
    
    float currHeight=currBtn.frame.origin.y+currBtn.frame.size.height;
    NSLog(@"====+++++%f",currHeight);
    NSMutableArray *arr2=[[NSMutableArray alloc]init];
    switch (currBtn.tag) {
        case 1:
            arr2=SelectCity;
            break;
        case 2:
            arr2=SelectQu;
            break;
        case 3:
            arr2=SelectUserDecp;
            break;
        case 4:
            arr2=SelectMaint;
            break;
        case 5:
            arr2=SelectState;
            break;        
            
        default:
            break;
    }

    
    _view_pop.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
    _view_pop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
    
    _view_Content.frame=CGRectMake(5, currHeight, bounds_width.size.width-10, _view_Content.frame.size.height);
    
    CGRect rect=_view_Content.frame;
    rect.origin.x=0;
    rect.origin.y=0;
    
    if (view_ification_02!=nil) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_ification_02.frame;
            rect.size.height=0;
            view_ification_02.frame=rect;
        } completion:^(BOOL finished) {
            [view_ification_02 removeFromSuperview];
            view_ification_02=nil;
        }];
    }
    else{
        //[self CloseAllClassIfication];
        
        view_ification_02=[[ClassIfication alloc] initWithFrame:rect ArrList:[NSMutableArray arrayWithArray:arr2]];
        view_ification_02.table_view.tag=currBtn.tag;
        
        view_ification_02.delegate=self;
        rect.size.height=0;
        
        view_ification_02.frame=rect;
        [_view_Content addSubview:view_ification_02];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=_view_Content.frame;
            rect.origin.y=0;
            view_ification_02.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    _view_pop.hidden=false;

}

- (IBAction)btnCancelClick:(id)sender {
    [self CloseSelect];
}

- (IBAction)btnDoClick:(id)sender {
    _requestWhere=[[RequestWhere alloc]init];
    if(![_txtCity.text isEqual:@"全部"])
    {
        _requestWhere.CityId=(int)_txtCity.tag;
    }
    if(![_txtQu.text isEqual:@"全部"])
    {
        _requestWhere.AddressId=(int)_txtQu.tag;
    }
    if(![_txtMaintDept.text isEqual:@"全部"])
    {
        _requestWhere.MaintDeptId=(int)_txtMaintDept.tag;
    }
    if(![_txtUserDept.text isEqual:@"全部"])
    {
        _requestWhere.UseDeptId=(int)_txtUserDept.tag;
    }
    if(![_txtState.text isEqual:@"全部"])
    {
        if(tabSelectIndex==0)
            _requestWhere.IsInstallation=(int)_txtState.tag;
        else
            _requestWhere.IsOnline=(int)_txtState.tag;
    }
    else
    {
        if(tabSelectIndex==0)
            _requestWhere.IsInstallation=-1;
        else
            _requestWhere.IsOnline=-1;
    }
    [self getSchoolCourse];
    [self getSchoolCoursePic];
    [self CloseSelect];
}

- (IBAction)btnClearClick:(id)sender {
    
    _txtCity.text= @"全部";
    _txtCity.tag=0;
    _txtQu.text=@"全部" ;
    _txtQu.tag=0;
    _txtUserDept.text=@"全部" ;
    _txtUserDept.tag=0;
    _txtMaintDept.text=@"全部" ;
    _txtMaintDept.tag=0;
    _txtState.text=@"全部" ;
    _txtState.tag=0;
    
    _requestWhere=[[RequestWhere alloc]init];
}
@end
