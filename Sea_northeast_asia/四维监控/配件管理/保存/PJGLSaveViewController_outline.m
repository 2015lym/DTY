//
//  PJGLSaveViewController_outline.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/22.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "PJGLSaveViewController_outline.h"

@implementation PJGLSaveViewController_outline
@synthesize app;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initWindow];
    //    [self initWebView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_PeiJianBandOK:) name:@"tongzhi_PeiJianBandOK" object:nil];
}

//- (void)tongzhi_PeiJianBandOK:(NSNotification *)text{
//    NSString *PartsTypeId=(NSString *)text.userInfo[@"textOne"];
//    if(![PartsTypeId isEqual:@""])
//    {
//        NSMutableArray *myMutableArray = [NSMutableArray new];
//        for (NSDictionary *dic in _classLiftParts.listType) {
//            if([[CommonUseClass FormatString: dic[@"ID"]] isEqual:[CommonUseClass FormatString:PartsTypeId]])
//            {
//            }
//            else
//            {
//                [myMutableArray addObject:dic];
//            }
//        }
//        _classLiftParts.listType=myMutableArray;
//    }

//    NSString *isOnline=(NSString *)text.userInfo[@"isOnline"];
//    if([isOnline isEqual:@"1"])
//    {
//        [self gotoDetail];
//    }
//}


//点击空白-回收键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [tf resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWindow{
    // typeID=1;
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 220)];
    [self.view addSubview:headview];
    
    //1标题60
    UIView * view_head1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 60)];
    view_head1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [headview addSubview:view_head1];
    
    
    
    UIImage *stopImage = [UIImage imageNamed:@"backArrow@2x"];
    UIImageView *stopImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 30, stopImage.size.width, stopImage.size.height) imageName:nil];
    stopImageView.userInteractionEnabled=YES;
    stopImageView.image = stopImage;
    [view_head1 addSubview:stopImageView];
    
    UIButton *stop_Btn = [MyControl createButtonWithFrame:CGRectMake(0, 30, 60, 40) imageName:nil bgImageName:nil title:nil SEL:@selector(btnClick_stop:) target:self];
    [view_head1 addSubview:stop_Btn];
    
    UILabel * lab_head1=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width, 20) Font:18 Text:@"配件管理" ];
    lab_head1.textAlignment = NSTextAlignmentCenter;
    lab_head1.textColor=[UIColor whiteColor];
    [view_head1 addSubview:lab_head1];
    
//    // 复制按钮
//    UIButton *outLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [outLineBtn setTitle:@"离线" forState:UIControlStateNormal];
//    outLineBtn.frame = CGRectMake(SCREEN_WIDTH- 70, 40, 60, 20);
//    outLineBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [outLineBtn addTarget:self action:@selector(outLineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    outLineBtn.backgroundColor = [UIColor whiteColor];
//    [outLineBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [view_head1 addSubview:outLineBtn];
    
    //2电梯编号86
    UIView * view_head2=[[UIView alloc]initWithFrame:CGRectMake(0, 60, bounds_width.size.width, 60)];
    [headview addSubview:view_head2];
    
    UIImageView *img_head2=[MyControl createImageViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, 86) imageName:@"wbdc_bg"];
    [view_head2 addSubview:img_head2];
    
    dtBianHao_2 = [MyControl createLabelWithFrame:CGRectMake(0, 20, bounds_width.size.width, 20) Font:18 Text:nil];
    dtBianHao_2.textColor = [UIColor whiteColor];
    dtBianHao_2.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao_2];
    dtBianHao_2.text=_liftNum;
    
    UILabel *dtBianHao = [MyControl createLabelWithFrame:CGRectMake(0, 50, bounds_width.size.width, 20) Font:14 Text:@"电梯编号"];
    dtBianHao.textColor = [UIColor whiteColor];
    dtBianHao.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao];
    
    
    
    
    //3地址等69
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 146, bounds_width.size.width, 69)];
    [headview addSubview:view_head3];
    
    
    
    
    
    //22
    UIImageView *img_head22=[MyControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"address_blue"];
    [view_head3 addSubview:img_head22];
    
    
    UILabel *dtWeiZhi = [MyControl createLabelWithFrame:CGRectMake(40, 10, 80, 20) Font:14 Text:@"电梯位置:"];
    [view_head3 addSubview:dtWeiZhi];
    
    dtWeiZhi_2 = [MyControl createLabelWithFrame:CGRectMake(110, 3, SCREEN_WIDTH- 120, 34) Font:14 Text:nil];
    dtWeiZhi_2.numberOfLines = 2;
    [view_head3 addSubview:dtWeiZhi_2];
    dtWeiZhi_2.text=_InstallationAddress;
    
    //33
    UIImageView *img_head33=[MyControl createImageViewWithFrame:CGRectMake(10, 40, 20, 20) imageName:@"zhuce_code"];
    [view_head3 addSubview:img_head33];
    
    
    UILabel *dtdaima = [MyControl createLabelWithFrame:CGRectMake(40, 40, 80, 20) Font:14 Text:@"注册代码:"];
    [view_head3 addSubview:dtdaima];
    
    dtdaima_2 = [MyControl createLabelWithFrame:CGRectMake(110, 40, SCREEN_WIDTH- 90, 20) Font:14 Text:nil];
    [view_head3 addSubview:dtdaima_2];
    dtdaima_2.text=_CertificateNum;
    
    // 复制按钮
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    copyBtn.frame = CGRectMake(SCREEN_WIDTH- 70, 40, 60, 20);
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [copyBtn addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    copyBtn.backgroundColor = [UIColor whiteColor];
    [copyBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    [view_head3 addSubview:copyBtn];
    
    //3
    UILabel *dtLine = [MyControl createLabelWithFrame:CGRectMake(0, 215, bounds_width.size.width, 5) Font:14 Text:@""];
    dtLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headview addSubview:dtLine];
    

    
    
    //5
    int currHight=CGRectGetMaxY( headview.frame);
    CourseTableview=[[UITableViewExForDeleteViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"PJGLSaveCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, currHight, SCREEN_WIDTH, SCREEN_HEIGHT-currHight-60);
    [self.view addSubview:CourseTableview.tableView];
    
    [self ShowList];
    
    UIButton*  Btn = [MyControl createButtonWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60) imageName:nil bgImageName:nil title:@"一键离线传输" SEL:@selector(btnClick_update:) target:self];
    Btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    Btn.backgroundColor=[CommonUseClass getSysColor];
    [self.view addSubview:Btn];
    
}

-(void)btnClick_update:(UIButton*)btn{
    if(_classLiftParts.list.count==0)
    {
        [CommonUseClass showAlter:@"没有要上传的数据!"];
        return;
    }
    
    //3.是否连网
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == -1) {
            //NSLog(@"未识别网络");
            [CommonUseClass showAlter:MessageResult_login];
            return ;
        }
        else if (status == 0) {
            //NSLog(@"无网络");
            [CommonUseClass showAlter:MessageResult_login];
            return ;
        }else{
            
            currCount=0;
            for (NSDictionary *dic in _classLiftParts.list) {
                [self SubmitData:dic];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSArray *array0 = [defaults objectForKey:@"PeiJianBand"] ;
                NSMutableArray *array = [array0 mutableCopy];
                for (NSDictionary *dic1 in array) {
                    if(dic1[@"LiftId"] ==_LiftId
                       &&dic1[@"PartsTypeId"]==dic[@"PartsTypeId"])
                    {
                        [array removeObject:dic];
                        
                        [defaults removeObjectForKey:@"PeiJianBand"];
                        [defaults synchronize];
                        NSArray *myArray = [array copy];
                        [defaults setObject:myArray forKey:@"PeiJianBand"];
                        [defaults synchronize];
                        break;
                    }
                }
            }
            
            
        }
        
        [manager stopMonitoring];
    }];
    
    

}

- (void)addBtnClick:(UIButton *)sender {
    if(_classLiftParts.listType.count<=0)
    {
        [CommonUseClass showAlter:@"没有要绑定的配件！"];
        return;
    }
    [self sebBQ];
}

/**
 * 复制链接
 */
- (void)copylinkBtnClick:(UIButton *)sender {
    
    [MBProgressHUD showSuccess:@"复制成功!" toView:self.view];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = dtdaima_2.text;
}

- (void)outLineBtnClick:(UIButton *)sender {
    
    
}

- (void)btnClick_stop:(UIButton *)btn
{
    NSString *msg=MsgBack;
    // 1、初始化
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    // 3、添加取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
    // 4、添加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    // 5、模态切换显示弹出框
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


#pragma mark 返回编辑模式，默认为删除模式
-(void)tableForDelete:(UITableItem*)value{
    
    NSDictionary *dic=(NSDictionary *)value;
    deleteGuid=[dic objectForKey:@"PartsTypeId"];
    
    UIAlertView* a=[[UIAlertView alloc]init];
    a=[[UIAlertView alloc] initWithTitle:@"提示"message:@"是否要删除?"delegate:self cancelButtonTitle:@"确定"otherButtonTitles: @"取消",nil];
    [a show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0)
    {
        [self DeleteData];
    }
}

-(void)DeleteData
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"PeiJianBand"] ;
    NSMutableArray *array = [array0 mutableCopy];
    for (NSDictionary *dic1 in array) {
        if(dic1[@"LiftId"] ==_LiftId
           &&dic1[@"PartsTypeId"]==deleteGuid)
        {
            [array removeObject:dic1];
            
            [defaults removeObjectForKey:@"PeiJianBand"];
            [defaults synchronize];
            NSArray *myArray = [array copy];
            [defaults setObject:myArray forKey:@"PeiJianBand"];
            [defaults synchronize];
            break;
        }
    }
    [self ShowList];
}
#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
}
-(void)TableRowClick:(UITableItem*)value
{
    //    NSMutableDictionary *dic_value=(NSMutableDictionary *)value;
    //
    //    TZTGDetailViewController *detal=[[TZTGDetailViewController alloc]init];
    //    detal.ID=[dic_value objectForKey:@"ID"];
    //    [self.navigationController pushViewController:detal animated:YES];
}

-(void)pullUpdateData
{
    //    CourseTableview.PageIndex=1;
    //    [self RequestNetData];
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

-(void)ShowList
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"PeiJianBand"] ;
    NSMutableArray *newarray=[NSMutableArray new];
    for (NSDictionary *dic in array0) {
        if([[CommonUseClass FormatString: dic[@"LiftId"]] isEqual:[CommonUseClass FormatString: _LiftId]])
        {
            [newarray addObject:dic];
        }
    }
    _classLiftParts.list=newarray;
    
    [CourseTableview.dataSource removeAllObjects];
    CurriculumEntity *entity=[[CurriculumEntity alloc] init];
    entity.enroll_list=_classLiftParts.list;
    [self init_tableview_hear:entity];
    [CourseTableview.tableView reloadData];
    [CourseTableview doneLoadingTableViewData];
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




-(void)sebBQ
{
    PJGLSaveDetailViewController*detail = [[PJGLSaveDetailViewController alloc]init];
    detail.classLiftParts= _classLiftParts;
    detail.liftNum=_liftNum;
    detail.LiftId=_LiftId;
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)dd:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)SubmitData:(NSDictionary *)dic
{
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    UIImageView *imgview=(UIImageView *)arr_Photos[0];
//    NSData *data =UIImageJPEGRepresentation(imgview.image, 0.4f);
    NSData *data=dic[@"MultipartFile"];

    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[CommonUseClass FormatString: dic[@"Manufacturer"]] forKey:@"Manufacturer"];
    [dicHeader setValue:dic[@"Brand"] forKey:@"Model"];
    [dicHeader setValue:dic[@"Model"] forKey:@"Brand"];
    [dicHeader setValue:dic[@"InstallationTime"] forKey:@"InstallationTime"];
    [dicHeader setValue:dic[@"PartsTypeId"] forKey:@"PartsTypeId"];
    [dicHeader setValue:dic[@"ProductName"] forKey:@"ProductName"];
    [dicHeader setValue:dic[@"LiftId"] forKey:@"LiftId"];
//    [dicHeader setValue:self.app.userInfo.UserID forKey:@"UserId"];

    [XXNet requestAFURL:@"LiftParts/AddLiftParts" parameters:dicHeader imageData:data succeed:^(NSDictionary *data) {
        if ([data[@"Success"]intValue]) {
           
        }
        else
        {
            [self performSelectorOnMainThread:@selector(dd:) withObject:[NSString stringWithFormat:@"%@%@", dic[@"ProductName"],data[@"Message"]] waitUntilDone:YES];
        }
        [self updateOver];
    } failure:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(dd:) withObject:[NSString stringWithFormat:@"%@%@", dic[@"ProductName"],MessageResult] waitUntilDone:YES];
        [self updateOver];
    }];
}

-(void)updateOver
{
    currCount++;
    if(currCount==_classLiftParts.list.count)
    {
        //1.
        //添加 字典，将label的值通过key值设置传递
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"",@"textOne",@"1",@"isOnline", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_PeiJianBandOK" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
