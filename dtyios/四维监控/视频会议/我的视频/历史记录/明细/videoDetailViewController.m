//
//  videoDetailViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/13.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "videoDetailViewController.h"
#import "CurriculumEntity.h"
#import "MyControl.h"
@interface videoDetailViewController ()

@end

@implementation videoDetailViewController

@synthesize app;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.navigationItem.title=@"历史记录详情";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"videoDetalCell" tableCells_Index:0];
    
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 60;
    CourseTableview.tableView.tableHeaderView=[self getTop];
    CourseTableview.tableView.tableFooterView=[self getBom];
    //tableView的frame
    CourseTableview.tableView.frame = self.view.frame;;
    // Do any additional setup after loading the view.
    CourseTableview.tableView.frame = self.view.frame;
    
    [self.view addSubview:CourseTableview.tableView];
    
    [self getSchoolCourse];
}

-(UIView *)getTop
{
    UIView *view=[MyControl createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250) backColor:[UIColor whiteColor] ];
    
    //1.
    UIImageView *img=[MyControl createImageViewWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, 20, 80, 80) imageName:@"addPeople"];
    [view addSubview:img];
    
    UILabel *labname=[MyControl createLabelWithFrame:CGRectMake(40,110, SCREEN_WIDTH-80, 20) Font:20 Text:@"个人"];
    labname.textAlignment=NSTextAlignmentCenter;
    [view addSubview:labname];
    labname.text=_dic_info[@"FromUserName"];
    
    //2
    int top=140;
    UILabel *labTime=[MyControl createLabelWithFrame:CGRectMake(40, 10+top, SCREEN_WIDTH, 20) Font:20 Text:@"个人信息"];
    [view addSubview:labTime];
    
    UILabel *labTime1=[MyControl createLabelWithFrame:CGRectMake(40, 40+top, SCREEN_WIDTH, 20) Font:15 Text:[CommonUseClass FormatString:_dic_info[@"FromPhone"]]];
    labTime1.textColor=[CommonUseClass getSysColor];
    [view addSubview:labTime1];
    
    
    UILabel *labTime2=[MyControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH-180, 40+top, 160, 20) Font:15 Text:[CommonUseClass FormatString: _dic_info[@"FromRoleName"]]];
     labTime2.textAlignment=NSTextAlignmentRight;
    labTime2.textColor=[UIColor grayColor];
    [view addSubview:labTime2];
    
    UILabel *labTimeline=[MyControl createLabelWithFrame:CGRectMake(40, 69+top, SCREEN_WIDTH-40, 1) Font:15 Text:@""];
    labTimeline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:labTimeline];
    
    //3
    top=top+70;
    UILabel *labpeople=[MyControl createLabelWithFrame:CGRectMake(40, top, SCREEN_WIDTH, 40) Font:20 Text:@"参与对象"];
    [view addSubview:labpeople];
    
    return view;
}
-(UIView *)getBom
{
    UIView *view=[MyControl createViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140) backColor:[UIColor whiteColor] ];
    
    UILabel *labTimeline0=[MyControl createLabelWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-40, 1) Font:15 Text:@""];
    labTimeline0.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:labTimeline0];
    
    //1
    NSString *createtime=[CommonUseClass FormatString:_dic_info[@"CreateTime"]];
   
    
    UILabel *labTime=[MyControl createLabelWithFrame:CGRectMake(40, 10, SCREEN_WIDTH, 20) Font:20 Text:@"通话时间"];
    [view addSubview:labTime];
    
    UILabel *labTime1=[MyControl createLabelWithFrame:CGRectMake(40, 40, SCREEN_WIDTH, 20) Font:15 Text:createtime];
    labTime1.textColor=[UIColor grayColor];
    [view addSubview:labTime1];
    
    
    //2.1time
    NSString *EndTime=[CommonUseClass FormatString:[_dic_info objectForKey:@"EndTime"]];
    NSString *ss=@"";
    if(![createtime isEqual:@""]&&![EndTime isEqual:@""])
    {
        //首先创建格式化对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        //然后创建日期对象
        NSDate *date1 = [dateFormatter dateFromString:createtime];
        NSDate *date = [dateFormatter dateFromString:EndTime];
        
        //计算时间间隔（单位是秒）
        NSTimeInterval time = [date timeIntervalSinceDate:date1];
        ss=   [CommonUseClass getMMSSFromSS:[NSString stringWithFormat:@"%f",time]];
    }
    
    UILabel *labTime2=[MyControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH-120, 40, 80, 20) Font:15 Text:ss];
    labTime2.textAlignment=NSTextAlignmentRight;
    labTime2.textColor=[UIColor grayColor];
    [view addSubview:labTime2];
    
    UILabel *labTimeline=[MyControl createLabelWithFrame:CGRectMake(40, 69, SCREEN_WIDTH-40, 1) Font:15 Text:@""];
     labTimeline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:labTimeline];
    
    //2
    int top=70;
    UILabel *labstate=[MyControl createLabelWithFrame:CGRectMake(40, 10+top, SCREEN_WIDTH, 20) Font:20 Text:@"拨打状态"];
    [view addSubview:labstate];
    
    NSString *state=[CommonUseClass FormatString:[_dic_info objectForKey:@"State"]];
    NSString *statename=@"";
    if([state isEqual:@"0"])
        statename=@"呼出视频";
    else if([state isEqual:@"1"])
        statename=@"呼入视频";
    else if([state isEqual:@"2"])
        statename=@"未接听";
    
    UILabel *labstate1=[MyControl createLabelWithFrame:CGRectMake(40, 40+top, SCREEN_WIDTH, 20) Font:15 Text:statename];
    labstate1.textColor=[UIColor grayColor];
    [view addSubview:labstate1];
    
   
    
    UILabel *labstateline=[MyControl createLabelWithFrame:CGRectMake(40, 69+top, SCREEN_WIDTH-40, 1) Font:15 Text:@""];
    labstateline.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:labstateline];
    
    return view;
    
}

#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
    [self getSchoolCourse];
}
-(void)TableRowClick:(UITableItem*)value
{
    warningElevatorModel *warnModel=(warningElevatorModel *)value;
    
    //    handleDetailViewController *ctvc=[[handleDetailViewController alloc] init];
    //    ctvc.warnModel=warnModel;
    //    ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
    //
    //
    //    [_delegate SchoolCoursePush:ctvc];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)getSchoolCourse
{
    NSString *currUrl=[NSString stringWithFormat:@"NeteaseMi/GetAppAlarmRoomRecordUser?roomID=%@",_dic_info[@"RoomID"]];
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [XXNet GetURL:currUrl header:nil parameters:nil succeed:^(NSDictionary *data) {
        
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(selectDataOk:) withObject:@"" waitUntilDone:YES];
            if (CourseTableview.PageIndex==1) {
                [CourseTableview.dataSource removeAllObjects];
            }
            else
            {
                [CourseTableview.dataSource removeLastObject];
            }
            
            NSString *str_json = data [@"Data"];
            NSArray *myArray = [str_json objectFromJSONString];
            NSMutableArray *array_newJS= [myArray mutableCopy];
            
            for (long i=array_newJS.count-1; i>=0;i--) {
                
                NSDictionary * dic=array_newJS[i];
                if([dic[@"LoginName"] isEqual:_dic_info[ @"FromLoginName"]])
                   [array_newJS removeObjectAtIndex:i];
            }
            
            CurriculumEntity *entity=[[CurriculumEntity alloc] init];
            entity.enroll_list=array_newJS;
            NSLog(@"++++++%@",entity.enroll_list);
            [self init_tableview_hear:entity];
            [self performSelector:@ selector(doneLoadingTableViewData) withObject:nil afterDelay:0.1];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:@"查询失败" waitUntilDone:YES];
        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:MessageResult waitUntilDone:YES];
        
    }];
}
-(void)selectDataOk:(NSString *)msg
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)selectDataErr:(NSString *)msg
{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)deleteNoDataImage
{
    UIView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
}

-(void)NoDataShowImage
{
    UIView *view=[[UIView alloc ]initWithFrame:CGRectMake(0, 60, 320, 130)];
    //UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake((bounds_width.size.width-218)/2, 0, 218, 100)];
    //image.image=[UIImage imageNamed:@"NoData.png"];
    //[view addSubview:image];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake((bounds_width.size.width-80)/2, 100, 80, 30)];
    label.text=@"暂无数据";
    label.textAlignment=NSTextAlignmentCenter;
    [label setTextColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]];
    [view addSubview:label];
    
    [CourseTableview.view addSubview:view];
    view.tag=3000;
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
//        else
//        {
//            [CourseTableview.dataSource addObject:@"无更多数据"];
//        }
    }
}
-(void)CourseHearOnClick:(UIViewController *)vc
{
    [_delegate SchoolCoursePush:vc];
}

@end
