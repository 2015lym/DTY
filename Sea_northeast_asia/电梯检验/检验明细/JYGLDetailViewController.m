//
//  JYGLDetailViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/24.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "JYGLDetailViewController.h"
#import "MyControl.h"
@interface JYGLDetailViewController ()
{
    UIView*headview;
    UILabel *dtBianHao_2;
    UILabel *dtWeiZhi_2;
    UILabel *dtWeiBao_2;
    UILabel *dtdaima_2;
}
@end

@implementation JYGLDetailViewController

@synthesize app;

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    [self initWindow];
    [self getSchoolCourse];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_image:) name:@"showImage" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_Video:) name:@"showVideo" object:nil];
}
- (void)tongzhi_image:(NSNotification *)text{
    NSString *model=(NSString *)text.userInfo[@"textOne"];
    showImage *ctvc=[[showImage alloc] init];
    ctvc.url=model;
    [self.navigationController pushViewController:ctvc animated:YES];
}

- (void)tongzhi_Video:(NSNotification *)text{
    NSString *model=(NSString *)text.userInfo[@"textOne"];
    VideoViewController *ctvc=[[VideoViewController alloc] init];
    ctvc.url=model;
    [self.navigationController pushViewController:ctvc animated:YES];
}

- (void)btnClick_stop:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initWindow{
    typeID=1;
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 280)];
    [self.view addSubview:headview];
    
    //1标题60
    UIView * view_head1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 60)];
    view_head1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [headview addSubview:view_head1];
    
    //    UIImageView *img_head1=[MyControl createImageViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, 86) imageName:@"wbdc_bg"];
    //    [view_head1 addSubview:img_head1];
    
    UIImage *stopImage = [UIImage imageNamed:@"backArrow@2x"];
    UIImageView *stopImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 30, stopImage.size.width, stopImage.size.height) imageName:nil];
    stopImageView.userInteractionEnabled=YES;
    stopImageView.image = stopImage;
    [view_head1 addSubview:stopImageView];
    
    UIButton *stop_Btn = [MyControl createButtonWithFrame:CGRectMake(0, 30, 60, 40) imageName:nil bgImageName:nil title:nil SEL:@selector(btnClick_stop:) target:self];
    [view_head1 addSubview:stop_Btn];
    
    UILabel * lab_head1=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width, 20) Font:18 Text:@"检测服务"];
    lab_head1.textAlignment = NSTextAlignmentCenter;
    lab_head1.textColor=[UIColor whiteColor];
    [view_head1 addSubview:lab_head1];
    
    //2电梯编号86
    UIView * view_head2=[[UIView alloc]initWithFrame:CGRectMake(0, 60, bounds_width.size.width, 60)];
    [headview addSubview:view_head2];
    
    UIImageView *img_head2=[MyControl createImageViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, 86) imageName:@"wbdc_bg"];
    [view_head2 addSubview:img_head2];
    
    dtBianHao_2 = [MyControl createLabelWithFrame:CGRectMake(0, 20, bounds_width.size.width, 20) Font:18 Text:nil];
    dtBianHao_2.textColor = [UIColor whiteColor];
    dtBianHao_2.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao_2];
    
    UILabel *dtBianHao = [MyControl createLabelWithFrame:CGRectMake(0, 50, bounds_width.size.width, 20) Font:14 Text:@"电梯编号"];
    dtBianHao.textColor = [UIColor whiteColor];
    dtBianHao.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao];
    
    //3地址等69
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 146, bounds_width.size.width, 119)];
    [headview addSubview:view_head3];
    
    
    
    UIImageView *img_head21=[MyControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"wb_maintenance"];
    [view_head3 addSubview:img_head21];
    
    UILabel *dtWeiBao = [MyControl createLabelWithFrame:CGRectMake(40, 10, 80, 20) Font:14.0 Text:@"上次检验:"];
    //dtWeiBao.textColor = [UIColor blackColor];
    [view_head3 addSubview:dtWeiBao];
    
    
    dtWeiBao_2 = [MyControl createLabelWithFrame:CGRectMake(110, 10, SCREEN_WIDTH-90, 20) Font:14.0 Text:@""];
    //dtWeiBao_2.textColor = [UIColor greenColor];
    //dtWeiBao_2.textAlignment = NSTextAlignmentRight;
    [view_head3 addSubview:dtWeiBao_2];
    
    //22
    UIImageView *img_head22=[MyControl createImageViewWithFrame:CGRectMake(10, 40, 20, 20) imageName:@"address_blue"];
    [view_head3 addSubview:img_head22];
    
    
    UILabel *dtWeiZhi = [MyControl createLabelWithFrame:CGRectMake(40, 40, 80, 20) Font:14 Text:@"电梯位置:"];
    [view_head3 addSubview:dtWeiZhi];
    
    dtWeiZhi_2 = [MyControl createLabelWithFrame:CGRectMake(110, 33, SCREEN_WIDTH- 120, 34) Font:14 Text:nil];
    dtWeiZhi_2.numberOfLines = 2;
    [view_head3 addSubview:dtWeiZhi_2];
    
    //33
    UIImageView *img_head33=[MyControl createImageViewWithFrame:CGRectMake(10, 70, 20, 20) imageName:@"zhuce_code"];
    [view_head3 addSubview:img_head33];
    
    
    UILabel *dtdaima = [MyControl createLabelWithFrame:CGRectMake(40, 70, 80, 20) Font:14 Text:@"注册代码:"];
    [view_head3 addSubview:dtdaima];
    
    dtdaima_2 = [MyControl createLabelWithFrame:CGRectMake(110, 70, SCREEN_WIDTH- 90, 20) Font:14 Text:nil];
    [view_head3 addSubview:dtdaima_2];
    
    // 复制按钮
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    copyBtn.frame = CGRectMake(SCREEN_WIDTH- 70, 70, 60, 20);
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [copyBtn addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

    [view_head3 addSubview:copyBtn];
    
    
    
    
    //3
    UILabel *dtLine = [MyControl createLabelWithFrame:CGRectMake(0, 245, bounds_width.size.width, 5) Font:14 Text:@""];
    dtLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headview addSubview:dtLine];
    
    dtBianHao_2.text=_liftNum;
    dtWeiZhi_2.text=_model.Lift.InstallationAddress;
    dtWeiBao_2.text=[CommonUseClass getDateString:_model.CreateTime];
    dtdaima_2.text=_model.StatusName;
    
    
    //tab
    bgView= [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dtLine.frame), SCREEN_WIDTH, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    leftBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3-1, 40) imageName:nil bgImageName:nil title:@"制动器试验" SEL:@selector(btnClick:) target:self];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    leftBtn.tag=100;
    [bgView addSubview:leftBtn];
    
    
    
    
    
    centertBtn =[MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 40) imageName:nil bgImageName:nil title:@"限速器校验" SEL:@selector(btnClick:) target:self];
    centertBtn.tag=101;
    centertBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:centertBtn];
    
    rightBtn = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 40) imageName:nil bgImageName:nil title:@"平衡系数校验" SEL:@selector(btnClick:) target:self];
    rightBtn.tag=102;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:rightBtn];
    
  
    
    UILabel *dtLine1 = [MyControl createLabelWithFrame:CGRectMake(0, 39, bounds_width.size.width, 1) Font:14 Text:@""];
    dtLine1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView addSubview:dtLine1];
    
    btnLine = [MyControl createLabelWithFrame:CGRectMake((bounds_width.size.width/3-60)/2, 38, 60, 2) Font:1 Text:nil];
    btnLine.backgroundColor = [UIColor colorWithHexString:@"#3574fa"];;
    [bgView addSubview:btnLine];
    
    //5
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"JYGLDetailCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(bgView.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(bgView.frame));
    [self.view addSubview:CourseTableview.tableView];
}
-(void)btnClick:(UIButton*)btn{
    
    
    [UIView animateWithDuration:0.3 animations:^{
        btnLine.frame =CGRectMake( ((btn.tag-100)*SCREEN_WIDTH/3)+(SCREEN_WIDTH/3-60)/2, 38, 60, 2);
    }];
    
    
    if (btn.tag==100) {
        
        typeID=1;
    }
    if (btn.tag==101) {
        typeID=2;
    }
    if (btn.tag==102) {
        typeID=3;
    }
    [self showData];
}

- (void)showData{
    [CourseTableview.dataSource removeAllObjects];
    
    
    CurriculumEntity *entity=[[CurriculumEntity alloc] init];
    entity.enroll_list=arrData;
    [self init_tableview_hear:entity];
    
    [self performSelector:@selector(doneLoadingTableViewData) withObject:arrData afterDelay:0.1];
}
/**
 * 复制链接
 */
- (void)copylinkBtnClick:(UIButton *)sender {
    
    [MBProgressHUD showSuccess:@"复制成功!" toView:self.view];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = dtdaima_2.text;
}




-(void)getSchoolCourse
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
//    [dicHeader setValue:[NSString stringWithFormat:@"%d", CourseTableview.PageIndex] forKey:@"PageIndex"];
//    [dicHeader setValue:@"20" forKey:@"PageSize"];
//    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [XXNet GetURL:GetInspectStepList header:nil parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            
         
            NSString *str_json = data[@"Data"];
            arrData = [str_json objectFromJSONString];
            
            [self getSchoolCourse1];
        }
         
     } failure:^(NSError *error) {
         
         [self performSelectorOnMainThread:@selector(dd) withObject:nil waitUntilDone:YES];
         
     }];
    
    
}

-(void)getSchoolCourse1
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
        [dicHeader setValue:_liftNum forKey:@"LiftNum"];
        [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    [XXNet GetURL:GetInspectByLiftNum header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            NSString *str_json = data [@"Data"];//InspectDetails"];
            NSDictionary *  dic = [str_json objectFromJSONString];
            NSArray *currArr=[dic objectForKey:@"InspectDetails"];
            NSMutableArray *newArr=[[NSMutableArray alloc]init];
            
            for (NSMutableDictionary *currdic in arrData) {
                 NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:currdic];
                for (NSMutableDictionary *currdic_value in currArr) {
                    
                    
                    if([[currdic_value objectForKey:@"StepId"] isEqual: [currdic objectForKey:@"ID"] ])
                    {
                       
                        [newdic setObject:[currdic_value objectForKey:@"Remark"] forKey:@"Remark"];
                        [newdic setObject:[currdic_value objectForKey:@"CreateTime"] forKey:@"CreateTime1"];
                        
                        NSDictionary *dicuser=currdic_value[@"User"];
                        NSString *struser=@"";
                        if( dicuser!=nil&&![[CommonUseClass FormatString: dicuser] isEqual:@""])struser=[dicuser objectForKey:@"UserName"];
                        [newdic setObject: struser forKey:@"UserName"];
                        
                         [newdic setObject:[currdic_value objectForKey:@"PhotoUrl"] forKey:@"PhotoUrl"];
                         [newdic setObject:[currdic_value objectForKey:@"VideoPath"] forKey:@"VideoPath"];
                        break;
                    }
                    
                }
                [newArr addObject:newdic];
            }
            
            arrData=newArr;
            [self showData];
        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(dd) withObject:nil waitUntilDone:YES];
        
    }];
    
    
}
- (void)dd{
    
    [CommonUseClass showAlter:@"暂无权限"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)init_tableview_hear:(CurriculumEntity *)entity
{
    if (entity.enroll_list.count) {
        
        for (NSMutableDictionary *dic_item in entity.enroll_list ) {
            if([[dic_item objectForKey:@"TypeID"]intValue] !=typeID)continue;
            [CourseTableview.dataSource addObject:dic_item];
            
        }
        if (entity.enroll_list.count>19) {
            //[CourseTableview.dataSource addObject:@"加载中……"];
        }
        else
        {
            [CourseTableview.dataSource addObject:@"无更多数据"];
        }
    }
}
#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
//    CourseTableview.PageIndex+=1;
//
//
//        [self getSchoolCourse];
    
    
}
-(void)TableRowClick:(UITableItem*)value
{
    
    
    
    
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

@end
