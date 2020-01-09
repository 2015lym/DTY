//
//  PJGLSaveViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "PJGLSaveViewController.h"

@interface PJGLSaveViewController ()<UIWebViewDelegate> {
    WKWebView *webview;
}

@end

@implementation PJGLSaveViewController

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
    [self InitPop];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_PeiJianBandOK:) name:@"tongzhi_PeiJianBandOK" object:nil];
}

- (void)tongzhi_PeiJianBandOK:(NSNotification *)text{
    NSString *PartsTypeId=(NSString *)text.userInfo[@"textOne"];
    if(![PartsTypeId isEqual:@""])
    {
        NSMutableArray *myMutableArray = [NSMutableArray new];
        for (NSDictionary *dic in _classLiftParts.listType) {
            if([[CommonUseClass FormatString: dic[@"ID"]] isEqual:[CommonUseClass FormatString:PartsTypeId]])
            {
            }
            else
            {
                [myMutableArray addObject:dic];
            }
        }
        _classLiftParts.listType=myMutableArray;
    }
    
    NSString *isOnline=(NSString *)text.userInfo[@"isOnline"];
    if([isOnline isEqual:@"1"])
    {
        [self gotoDetail];
    }
}


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
    
    // 复制按钮
//    UIButton *outLineBtn = [UIButton buttonWithType: UIButtonTypeCustom];
//    [outLineBtn setTitle:@"离线" forState:UIControlStateNormal];
//    outLineBtn.frame = CGRectMake(SCREEN_WIDTH- 70, 40, 60, 30);
////    outLineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [outLineBtn addTarget:self action:@selector(outLineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *outLineBtn = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH- 70, 40, 60, 30) imageName:nil bgImageName:nil title:@"离线" SEL:@selector(outLineBtnClick:) target:self];
    [view_head1 addSubview:stop_Btn];
    outLineBtn.backgroundColor = [UIColor orangeColor ];
    [outLineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:outLineBtn];
    
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
    
    //4
    UIView * addParts=[MyControl createViewWithFrame:CGRectMake(0,CGRectGetMaxY( headview.frame), SCREEN_WIDTH, 60) backColor:[UIColor whiteColor]];
    [self .view addSubview:addParts];
    
    UILabel *dtadd = [MyControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH-120, 15, 80, 25) Font:16 Text:@"添加配件"];
    [addParts addSubview:dtadd];
    
    UIImageView *img_add=[MyControl createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-50, 10, 35,35) imageName:@"content"];
    [addParts addSubview:img_add];
    
    // add
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCREEN_WIDTH- 120, 0, 120, 60);
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [addParts addSubview:addBtn];
    
    UILabel *dtLine4 = [MyControl createLabelWithFrame:CGRectMake(0, 55, bounds_width.size.width, 5) Font:14 Text:@""];
    dtLine4.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [addParts addSubview:dtLine4];
    
    
    //5
    int currHight=CGRectGetMaxY( addParts.frame);
    CourseTableview=[[UITableViewExForDeleteViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"PJGLSaveCell" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, currHight, SCREEN_WIDTH, SCREEN_HEIGHT-currHight);
    [self.view addSubview:CourseTableview.tableView];
    
    
    [self ShowList];

}
- (void)addBtnClick:(UIButton *)sender {
    
    [self showPop];
    
   
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
    
    PJGLSaveViewController_outline *ctvc=[[PJGLSaveViewController_outline alloc] init];
    ctvc.LiftId=_LiftId;
    ctvc.liftNum=_liftNum;
    ctvc.InstallationAddress=_InstallationAddress;
    ctvc.CertificateNum=_CertificateNum;
    ctvc.classLiftParts=_classLiftParts;
    
    [self.navigationController pushViewController:ctvc animated:YES];
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
    deleteGuid=[dic objectForKey:@"ID"];
    
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:deleteGuid forKey:@"PartsId"];
    [dicHeader setValue:self.app.userInfo.UserID forKey:@"UserId"];
    NSString *url=[NSString stringWithFormat: @"LiftParts/DeleteTL_Parts?PartsId=%@",deleteGuid];
    //url=[NSString stringWithFormat:@"%@?LiftNum=%@&CertificateNum=%@",url,_liftNum,tf.text];
    
    [XXNet GetURL:url header:nil parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(delectOK:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(dd:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        
        
        
    } failure:^(NSError *error) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:MessageResult
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}



- (void)delectOK:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [self gotoDetail ];
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
    detail.CertificateNum=_CertificateNum;
    detail.InstallationAddress=_InstallationAddress;
    detail.PartsTypeId=PartsTypeId;
    detail.PartsTypeName=PartsTypeName;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)gotoDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[CommonUseClass FormatString:_liftNum] forKey:@"LiftNum"];
    //[dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    NSString *url=[NSString stringWithFormat:@"LiftParts/GetLift"];
    [XXNet PostURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[CommonUseClass FormatString: data[@"Success"]] isEqual:@"1"]) {
            
            NSString *str_json = data [@"Data"];
            NSDictionary *dic = [str_json objectFromJSONString];
            _classLiftParts=[[classLiftParts alloc]init];
            _classLiftParts.LiftNum=[CommonUseClass FormatString:dic [@"LiftNum"]];
            _classLiftParts.CertificateNum=[CommonUseClass FormatString:dic [@"CertificateNum"]];
            NSString *path=[CommonUseClass FormatString: dic [@"AddressPath"]];
            _classLiftParts.AddressPath=path;
            _classLiftParts.InstallationAddress=[CommonUseClass FormatString: dic [@"InstallationAddress"]];
            _classLiftParts.InstallationAddress = [path stringByAppendingString:_classLiftParts.InstallationAddress];
            _classLiftParts.LiftId=[CommonUseClass FormatString:dic [@"LiftId"]];
            _classLiftParts.list=dic [@"list"];
            _classLiftParts.listType=dic [@"listType"];
            
            [self ShowList];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(dd:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        
    } failure:^(NSError *error) {
        [self performSelectorOnMainThread:@selector(dd:) withObject:MessageResult waitUntilDone:YES];
    }];
    
}

- (void)dd:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//////////////
-(void)InitPop{
    //蒙版
    view_Content_back=[MyControl createViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height) backColor:[UIColor blackColor]];
    view_Content_back.alpha = 0.5;// 阴影透明度
    [self.view addSubview:view_Content_back];
    
    
    view_Content_2=[MyControl createViewWithFrame:CGRectMake(10, 150, self.view.frame.size.width-20, 320) backColor:[UIColor whiteColor]];
    [self.view addSubview:view_Content_2];
    
    
    
    //    UIView *viewBack=[MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 160) backColor:[UIColor whiteColor]];
    //    viewBack.alpha = 1;// 阴影透明度
    //    [view_Content_2 addSubview:viewBack];
    
    [self hiddenPop];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboard:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [view_Content_back addGestureRecognizer:tapGestureRecognizer];
}

//点击空白-回收键盘
-(void)keyboard:(UITapGestureRecognizer*)tap
{
    [self hiddenPop];
}

-(void)showPop
{
    //1.
    for(long i=view_Content_2.subviews.count-1;i>=0;i--)
    {
        id object=view_Content_2.subviews[i];
        [object removeFromSuperview ];
    }
    
    //2.
    int top=0;
    int width=view_Content_2.frame.size.width;
    
    for (NSDictionary *dic in _classLiftParts.listType) {
        
        [self addButton_dept:0 forTop:top forWidth:width forHeight:44 forName:dic[@"PartsName"] forName1:@"" forTag:[dic[@"ID"] intValue] forIcon:@""];
        top=top+44;
    }
    
    
    view_Content_2.frame=CGRectMake(view_Content_2.frame.origin.x, view_Content_2.frame.origin.y, view_Content_2.frame.size.width, top+10);
    
    
    view_Content_2.hidden=false;
    view_Content_back.hidden=false;
}

- (void)addButton_dept:(float)left forTop:(float)top forWidth:(float)width forHeight:(float)height forName:(NSString *)name  forName1:(NSString *)name1 forTag:(int)tag forIcon:(NSString*)imageName {
    UIView *view=[[UIView alloc]init];
    view.tag=10000+tag;
    view.frame=CGRectMake(left, top, width, height);
    [view_Content_2 addSubview:view];
    
    
    UILabel *selectLabel1 = [MyControl createLabelWithFrame:CGRectMake(20, 12, SCREEN_WIDTH-40, 20) Font:15 Text:name];
    selectLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel1.alpha=1.0;
    selectLabel1.text=name;
    [view addSubview:selectLabel1];
    
    UILabel *line = [MyControl createLabelWithFrame:CGRectMake(0, 43, width, 1) Font:15 Text:@""];
    line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    
    UIButton *btn_1 = [MyControl createButtonWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 44) imageName:nil bgImageName:nil title:@"" SEL:@selector(btnClick_ReplaceTheElevator:) target:self];
    //    [btn_1.layer setMasksToBounds:YES];
    //    [btn_1.layer setCornerRadius:5.0];
    //    [btn_1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    btn_1.tag=tag;
    [view addSubview:btn_1];
}


-(void)hiddenPop{
    view_Content_2.hidden=YES;
    view_Content_back.hidden=YES;
}

- (void)btnClick_ReplaceTheElevator:(UIButton *)btn
{
    //1.
    PartsTypeId=[NSString stringWithFormat:@"%ld", btn.tag];
    PartsTypeName=[self getName];
    [self hiddenPop];
    
    //2.
    if(_classLiftParts.listType.count<=0)
    {
        [CommonUseClass showAlter:@"没有要绑定的配件！"];
        return;
    }
    [self sebBQ];
}

-(NSString *)getName{
    NSString *value=@"";
    for (NSDictionary *dic in _classLiftParts.listType) {
        if([[CommonUseClass FormatString: dic[@"ID"]] isEqual:[CommonUseClass FormatString:PartsTypeId]])
        {
            return dic[@"PartsName"];
        }
    }
    return value;
}
@end
