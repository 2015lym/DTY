//
//  DTWBViewController.m
//  Sea_northeast_asia
//
//  Created by 王永超 on 2017/3/23.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "DTWBViewController.h"
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
@interface DTWBViewController ()
{
    NSString *tabSelectIndex;
    bool IsInitselect;
    RequestWhere *_requestWhere;
    
    UIView * bgView;
    UIButton * leftBtn;
    UIButton * centertBtn;
    UIButton * rightBtn;
    UIButton *rightBtn2;
    UILabel * btnLine;
    
    UIScrollView *sc;
    UIView *_view_pop;
    UIView *_view_Content;
    UILabel *yearLabel;
    
    
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
    UIButton *chaxunBtn3;
    
    UIImageView *chaxunImg;
    UILabel *chaxunLab;
    UIView * bgView2;
    UILabel * bgView2_line2;

    
    UIView *imageView;
    
    int typeID;
    JHPieChart *pie;
    
    
}

@end

@implementation DTWBViewController

@synthesize app;
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=@"电梯维保";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_warn:) name:@"tongzhi_success" object:nil];
    
    UIButton *right_BarButoon_Item=[[UIButton alloc] init];
    right_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    //[right_BarButoon_Item setTitle:@"扫码" forState:UIControlStateNormal];
    [right_BarButoon_Item setImage:[UIImage imageNamed:@"dt_scan.png"] forState:UIControlStateNormal];
    [right_BarButoon_Item addTarget:self action:@selector(navRightBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_BarButoon_Item];
    self.navigationItem.rightBarButtonItems=@[rightItem];
    
    
    typeID = 0;
    //init
    tabSelectIndex=@"";
    _requestWhere=[[RequestWhere alloc]init];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    IsInitselect=false;
    [self CloseSelect];
    [self CloseAllClassIfication];
    float width = SCREEN_WIDTH/5;
    
    bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    leftBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, width, 40) imageName:nil bgImageName:nil title:@"维保记录" SEL:@selector(btnClick:) target:self];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    leftBtn.tag=100;
    [bgView addSubview:leftBtn];
    
    
    btnLine = [MyControl createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame)+1, width, 2) Font:1 Text:nil];
    btnLine.backgroundColor = [UIColor colorWithHexString:@"#3574fa"];;
    [self.view addSubview:btnLine];
    
    centertBtn =[MyControl createButtonWithFrame:CGRectMake(width, 0, width, 40) imageName:nil bgImageName:nil title:@"待查记录" SEL:@selector(btnClick:) target:self];
    centertBtn.tag=101;
    centertBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:centertBtn];
    
    rightBtn = [MyControl createButtonWithFrame:CGRectMake(width*2, 0, width, 40) imageName:nil bgImageName:nil title:@"漏查记录" SEL:@selector(btnClick:) target:self];
    rightBtn.tag=102;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:rightBtn];
    
    rightBtn2 = [MyControl createButtonWithFrame:CGRectMake(width*3, 0, width, 40) imageName:nil bgImageName:nil title:@"维保历史" SEL:@selector(btnClick:) target:self];
    rightBtn2.tag=103;
    rightBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:rightBtn2];
    chaxunBtn3 = [MyControl createButtonWithFrame:CGRectMake(width*4, 0, width, 40) imageName:nil bgImageName:nil title:@"维保确认" SEL:@selector(btnClick:) target:self];
    chaxunBtn3.tag=104;
    chaxunBtn3.titleLabel.font = [UIFont systemFontOfSize:13];
    [bgView addSubview:chaxunBtn3];
//    leftBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4-1, 40) imageName:nil bgImageName:nil title:@"维保记录" SEL:@selector(btnClick:) target:self];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    leftBtn.tag=100;
//    [bgView addSubview:leftBtn];
//
//
//    btnLine = [MyControl createLabelWithFrame:CGRectMake((bounds_width.size.width/4-60)/2, CGRectGetMaxY(bgView.frame)+1, 60, 2) Font:1 Text:nil];
//    btnLine.backgroundColor = [UIColor colorWithHexString:@"#3574fa"];;
//    [self.view addSubview:btnLine];
//
//    centertBtn =[MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 40) imageName:nil bgImageName:nil title:@"待查记录" SEL:@selector(btnClick:) target:self];
//    centertBtn.tag=101;
//    centertBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [bgView addSubview:centertBtn];
//
//    rightBtn = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH/4*2, 0, SCREEN_WIDTH/4, 40) imageName:nil bgImageName:nil title:@"漏查记录" SEL:@selector(btnClick:) target:self];
//    rightBtn.tag=102;
//    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [bgView addSubview:rightBtn];
//
//    rightBtn2 = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH/4*3, 0, SCREEN_WIDTH/4, 40) imageName:nil bgImageName:nil title:@"维保历史" SEL:@selector(btnClick:) target:self];
//    rightBtn2.tag=103;
//    rightBtn2.titleLabel.font = [UIFont systemFontOfSize:16];
//    [bgView addSubview:rightBtn2];
    
    
    yearLabel = [MyControl createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(btnLine.frame)+10, 2*SCREEN_WIDTH/3, 30) Font:30 Text:@"2017年维保"];
    yearLabel.hidden = YES;
    yearLabel.textColor = [UIColor blueColor];
    yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:yearLabel];
    
    //2
    bgView2= [[UIView alloc]initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 55)];
    bgView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView2];
    bgView2_line2= [[UILabel alloc]initWithFrame:CGRectMake(0, bgView2.frame.size.height-5, SCREEN_WIDTH, 5)];
    bgView2_line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [bgView2 addSubview:bgView2_line2];
    
    
    
    chaxunImg = [MyControl createImageViewWithFrame:CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+5, 72, 42) imageName:@"dt_search.png"];
    [self.view addSubview:chaxunImg];
    
    chaxunLab=[[UILabel alloc]initWithFrame:CGRectMake(bounds_width.size.width-92-70, CGRectGetMaxY(btnLine.frame)+12, 70, 30)];
    chaxunLab.textColor=[UIColor grayColor];
    chaxunLab.text=@"高级查询";
    [self.view addSubview:chaxunLab];

    
    
    chaxunBtn = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+5, 80, 40) imageName:nil bgImageName:nil title:@"" SEL:@selector(chaXunBtnClick:) target:self];
    [chaxunBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //chaxunBtn.backgroundColor = [UIColor colorWithRed:0 green:119/255.0 blue:250/255.0 alpha:1.0];
    [self.view addSubview:chaxunBtn];
    
    chaxunBtn.frame = CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+5, 80, 40);
    chaxunImg.frame = CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+5, 72, 42);
    chaxunLab.frame = CGRectMake(chaxunLab.frame.origin.x, CGRectGetMaxY(btnLine.frame)+12,chaxunLab.frame.size.width, chaxunLab.frame.size.height);
    UILabel *curr_line2= [[UILabel alloc]initWithFrame:CGRectMake(0, 42+50, SCREEN_WIDTH, 1)];
    curr_line2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:curr_line2];
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame)+2, bounds_width.size.width, 1)];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line];
    
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"SBAZCell3" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(chaxunBtn.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
    [self.view addSubview:CourseTableview.tableView];
    
    
    sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btnLine.frame), SCREEN_WIDTH, 200)];
    sc.backgroundColor = [UIColor whiteColor];
    sc.hidden = YES;
    sc.userInteractionEnabled=YES;
    [self.view addSubview:sc];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    view.backgroundColor = [UIColor clearColor];
    [sc addSubview:view];
    
    NSArray *arrSelect = @[@"取消",@"重置",@"确定"];
    for (int i = 0; i < 3; i++) {
        
        UIButton *selectBtn = [MyControl createButtonWithFrame:CGRectMake((SCREEN_WIDTH/3)*i+20, 150, 80, 40) imageName:nil bgImageName:nil title:arrSelect[i] SEL:@selector(selectBtnClick:) target:self];
        [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        selectBtn.backgroundColor = [UIColor colorWithRed:0 green:119/255.0 blue:250/255.0 alpha:1.0];
        selectBtn.tag = 104+i;
        [view addSubview:selectBtn];
        
    }
    
    shi_lab = [MyControl createLabelWithFrame:CGRectMake(10, 20, 20, 20) Font:14 Text:@"市"];
    shi_lab.textColor = [UIColor blackColor];
    [view addSubview:shi_lab];
    shi_labDetail = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(shi_lab.frame)+5, 20, 80, 20) Font:14 Text:@"全部"];
    shi_labDetail.userInteractionEnabled=YES;
    shi_labDetail.textColor = [UIColor blackColor];
    shi_labDetail.backgroundColor = [UIColor lightGrayColor];
    shi_labBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 80, 20) imageName:nil bgImageName:nil title:nil SEL:@selector(labBtnClick:) target:self];
    shi_labBtn.tag = 200;
    [shi_labDetail addSubview:shi_labBtn];
    [sc addSubview:shi_labDetail];
    
    UILabel *qu_lab = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(shi_labDetail.frame)+80, 20, 20, 20) Font:14 Text:@"区"];
    qu_lab.textColor = [UIColor blackColor];
    [view addSubview:qu_lab];
    qu_labDetail = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(qu_lab.frame)+5, 20, 80, 20) Font:14 Text:@"全部"];
    qu_labDetail.userInteractionEnabled=YES;
    qu_labDetail.textColor = [UIColor blackColor];
    qu_labDetail.backgroundColor = [UIColor lightGrayColor];
    [sc addSubview:qu_labDetail];
    qu_labBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 80, 20) imageName:nil bgImageName:nil title:nil SEL:@selector(labBtnClick:) target:self];
    qu_labBtn.tag = 201;
    [qu_labDetail addSubview:qu_labBtn];
    
    UILabel *sydw_lab = [MyControl createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(shi_lab.frame)+20, 60, 20) Font:14 Text:@"使用单位"];
    sydw_lab.textColor = [UIColor blackColor];
    [view addSubview:sydw_lab];
    sydw_labDetail = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(sydw_lab.frame)+5, CGRectGetMaxY(shi_lab.frame)+20, 200, 20) Font:14 Text:@"全部"];
    sydw_labDetail.userInteractionEnabled=YES;
    sydw_labDetail.textColor = [UIColor blackColor];
    sydw_labDetail.backgroundColor = [UIColor lightGrayColor];
    [sc addSubview:sydw_labDetail];
    sydw_labBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 200, 20) imageName:nil bgImageName:nil title:nil SEL:@selector(labBtnClick:) target:self];
    sydw_labBtn.tag = 202;
    [sydw_labDetail addSubview:sydw_labBtn];
    
    UILabel *wbdw_lab = [MyControl createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(sydw_lab.frame)+20, 60, 20) Font:14 Text:@"维保单位"];
    wbdw_lab.textColor = [UIColor blackColor];
    [view addSubview:wbdw_lab];
    wbdw_labDetail = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(wbdw_lab.frame)+5, CGRectGetMaxY(sydw_lab.frame)+20, 200, 20) Font:14 Text:@"全部"];
    wbdw_labDetail.userInteractionEnabled=YES;
    wbdw_labDetail.textColor = [UIColor blackColor];
    wbdw_labDetail.backgroundColor = [UIColor lightGrayColor];
    [sc addSubview:wbdw_labDetail];
    wbdw_labBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 200, 20) imageName:nil bgImageName:nil title:nil SEL:@selector(labBtnClick:) target:self];
    wbdw_labBtn.tag = 203;
    [wbdw_labDetail addSubview:wbdw_labBtn];
    
    
    _view_pop = [[UIView alloc]init];
    _view_pop.userInteractionEnabled=YES;
    _view_pop.frame=CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    _view_pop.backgroundColor = [UIColor greenColor];
    _view_pop.hidden = YES;
    //    _view_pop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
    [self.view addSubview:_view_pop];
    
    //    UITapGestureRecognizer
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    tapGesture.delegate=self;
    [_view_pop addGestureRecognizer:tapGesture];
    
    _view_Content = [[UIView alloc]init];
    _view_Content.frame=CGRectMake(10, 20, SCREEN_WIDTH-20,SCREEN_HEIGHT/3);
    _view_Content.hidden = YES;
    [_view_pop addSubview:_view_Content];
    
    
    [self getSchoolCourse];
    
    //高级查询相关
    [self initMySelect];
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
    if (typeID==0||typeID==3) {
        
        [self getSchoolCourse];
    }else {
        
        [self getSchoolCourse_1];
        
        if (typeID==1||typeID==2)
        [self getSchoolCoursePic];
    }
    
}
//高级查询相关


- (void)tongzhi_warn:(NSNotification *)text
{
    [MBProgressHUD show:@"提交成功" icon:nil view:self.view];
}

-(void)Actiondo:(UITapGestureRecognizer *)gesture
{
    NSLog(@"+++++++++++");
    
    //    [self CloseAllClassIfication];
    /*
     [_txtPeopleCount resignFirstResponder];
     [_txtPeoplePhone resignFirstResponder];
     [_txtConter resignFirstResponder];
     [_txtYY resignFirstResponder];
     [_txtJJ resignFirstResponder];
     */
    
    _view_Content.hidden=YES;
    _view_pop.hidden=YES;
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


-(void)btnClick:(UIButton*)btn{
    
    [UIView animateWithDuration:0.3 animations:^{
        btnLine.frame =CGRectMake(((btn.tag-100)*SCREEN_WIDTH/5), CGRectGetMaxY(bgView.frame)+1, SCREEN_WIDTH/5, 2);
    }];
//    [UIView animateWithDuration:0.3 animations:^{
//        btnLine.frame =CGRectMake(5+((btn.tag-100)*SCREEN_WIDTH/4), CGRectGetMaxY(bgView.frame)+1, SCREEN_WIDTH/4-10, 2);
//    }];
    
    if (btn.tag==100) {
        
        yearLabel.hidden = YES;
        [self InitSelect];
        typeID=0;
        [imageView removeFromSuperview];
        sc.hidden = YES;
        [self getSchoolCourse];
        //chaxunBtn.frame = CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+5, 80, 40);
        bgView2.frame= CGRectMake(0, 42, SCREEN_WIDTH, 55);
        bgView2_line2.frame= CGRectMake(0, bgView2.frame.size.height-5, SCREEN_WIDTH, 5);
        
        CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(chaxunBtn.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
        
        NSLog(@"===100");
    }
    if (btn.tag==101) {
        yearLabel.hidden = YES;
        [self InitSelect];
        typeID=1;
        tabSelectIndex = @"0";
        [imageView removeFromSuperview];
        sc.hidden = YES;
        
        
        imageView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-75, 55, 150, 150)];
        pie = [[JHPieChart alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        [imageView addSubview:pie];
        [bgView2 addSubview:imageView];
        
        [self getSchoolCourse_1];
        [self getSchoolCoursePic];
        
        //chaxunBtn.frame = CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+150, 80, 40);
        bgView2.frame= CGRectMake(0, 42, SCREEN_WIDTH, 55+155);
        bgView2_line2.frame= CGRectMake(0, bgView2.frame.size.height-5, SCREEN_WIDTH, 5);
        
        CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(bgView2.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
        
        NSLog(@"===101");
    }
    if (btn.tag==102) {
        yearLabel.hidden = YES;
        [self InitSelect];
         typeID=2;
        tabSelectIndex = @"1";
        [imageView removeFromSuperview];
        
        sc.hidden = YES;
        
        imageView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-75, 55, 150, 150)];
        pie = [[JHPieChart alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        [imageView addSubview:pie];
        [bgView2 addSubview:imageView];
        
        [self getSchoolCourse_1];
        [self getSchoolCoursePic];
        
        //chaxunBtn.frame = CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+150, 80, 40);
        bgView2.frame= CGRectMake(0, 42, SCREEN_WIDTH, 55+155);
        bgView2_line2.frame= CGRectMake(0, bgView2.frame.size.height-5, SCREEN_WIDTH, 5);
        
        CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(bgView2.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
        
        NSLog(@"===102");
    }
    if (btn.tag==103) {
        yearLabel.hidden = NO;
        [self InitSelect];
         typeID=3;
        tabSelectIndex = @"2";
        [imageView removeFromSuperview];
        sc.hidden = YES;
        [self getSchoolCourse];
        //chaxunBtn.frame = CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+5, 80, 40);
        bgView2.frame= CGRectMake(0, 42, SCREEN_WIDTH, 55);
        bgView2_line2.frame= CGRectMake(0, bgView2.frame.size.height-5, SCREEN_WIDTH, 5);
        
        CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(chaxunBtn.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
        
        NSLog(@"===103");
    }
    
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

- (void)selectBtnClick:(UIButton *)btn
{
    
    if (btn.tag==104) {
        
        NSLog(@"===104");
        sc.hidden = YES;
        imageView.hidden = NO;
    }
    if (btn.tag==105) {
        
        [self InitSelect];
        NSLog(@"===105");
    }
    if (btn.tag==106) {
        imageView.hidden = NO;
        
        NSLog(@"===106");
        _requestWhere=[[RequestWhere alloc]init];
        if(![shi_labDetail.text isEqual:@"全部"])
        {
            _requestWhere.CityId=(int)shi_labDetail.tag;
        }
        if(![qu_labDetail.text isEqual:@"全部"])
        {
            _requestWhere.AddressId=(int)qu_labDetail.tag;
        }
        if(![sydw_labDetail.text isEqual:@"全部"])
        {
            _requestWhere.MaintDeptId=(int)sydw_labDetail.tag;
        }
        if(![wbdw_labDetail.text isEqual:@"全部"])
        {
            _requestWhere.UseDeptId=(int)wbdw_labDetail.tag;
        }
        
        else
        {
            if(tabSelectIndex==0)
                _requestWhere.IsInstallation=-1;
            else
                _requestWhere.IsOnline=-1;
        }
        
        if (typeID==0||typeID==3) {
            
            [self getSchoolCourse];
        }else{
            
            [self getSchoolCourse_1];
        }
        
        
        [self getSchoolCoursePic];
        [self CloseSelect];
        
    }
    
}

- (void)selectBtnClick2:(UIButton *)btn
{
    if (btn.tag==300) {
        
        NSLog(@"===300");
        sc.hidden = YES;
        
    }
    if (btn.tag==301) {
        
        [self InitSelect];
        
    }
    if (btn.tag==302) {
        
        _requestWhere=[[RequestWhere alloc]init];
        if(![shi_labDetail.text isEqual:@"全部"])
        {
            _requestWhere.CityId=(int)shi_labDetail.tag;
        }
        if(![qu_labDetail.text isEqual:@"全部"])
        {
            _requestWhere.AddressId=(int)qu_labDetail.tag;
        }
        if(![sydw_labDetail.text isEqual:@"全部"])
        {
            _requestWhere.MaintDeptId=(int)sydw_labDetail.tag;
        }
        if(![wbdw_labDetail.text isEqual:@"全部"])
        {
            _requestWhere.UseDeptId=(int)wbdw_labDetail.tag;
        }
        
        else
        {
            if(tabSelectIndex==0)
                _requestWhere.IsInstallation=-1;
            else
                _requestWhere.IsOnline=-1;
        }
        
        if (typeID==0||typeID==3) {
            
            [self getSchoolCourse];
        }else{
            
            [self getSchoolCourse_1];
        }
        
//        [self getSchoolCourse];
        //        [self getSchoolCoursePic];
        [self CloseSelect];
        
    }
    
    
}

#pragma mark ClassIficationDelegate
-(void)CloseAllClassIfication
{
    [view_ification_02 removeFromSuperview];
    //    view_ification_02=nil;
    //    _view_pop.hidden=YES;
    _view_Content.hidden = YES;
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
        if(currClass.table_view.tag==200)
        {
            shi_labDetail.text=[Content objectForKey:@"tagName"];
            shi_labDetail.tag=[[Content objectForKey:@"tagId"] intValue];
            
            //qu
            SelectQu=[[NSMutableArray alloc]init];
            NSMutableDictionary *d4 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d4 setObject:@"0" forKey:@"tagId"];
            [d4 setObject:@"全部" forKey:@"tagName"];
            [SelectQu addObject:d4];
            
            qu_labDetail.text=@"全部" ;
            qu_labDetail.tag=0;
            
            [self initQu:shi_labDetail.tag];
            
            //decp
            SelectUserDecp=[[NSMutableArray alloc]init];
            NSMutableDictionary *d5 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d5 setObject:@"0" forKey:@"tagId"];
            [d5 setObject:@"全部" forKey:@"tagName"];
            [SelectUserDecp addObject:d5];
            
            sydw_labDetail.text=@"全部" ;
            sydw_labDetail.tag=0;
            
            [self initUserDecp:shi_labDetail.tag byDistrictId: 0];
            
            //decp
            SelectMaint=[[NSMutableArray alloc]init];
            NSMutableDictionary *d6 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d6 setObject:@"0" forKey:@"tagId"];
            [d6 setObject:@"全部" forKey:@"tagName"];
            [SelectMaint addObject:d6];
            
            wbdw_labDetail.text=@"全部" ;
            wbdw_labDetail.tag=0;
            
            [self initMaint:shi_labDetail.tag byDistrictId: 0];
        }
        else if(currClass.table_view.tag==201)
        {
            qu_labDetail.text=[Content objectForKey:@"tagName"];
            qu_labDetail.tag=[[Content objectForKey:@"tagId"] intValue];
            
            //decp
            SelectUserDecp=[[NSMutableArray alloc]init];
            NSMutableDictionary *d5 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d5 setObject:@"0" forKey:@"tagId"];
            [d5 setObject:@"全部" forKey:@"tagName"];
            [SelectUserDecp addObject:d5];
            
            sydw_labDetail.text=@"全部" ;
            sydw_labDetail.tag=0;
            
            [self initUserDecp:shi_labDetail.tag byDistrictId: qu_labDetail.tag];
            
            //decp
            SelectMaint=[[NSMutableArray alloc]init];
            NSMutableDictionary *d6 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d6 setObject:@"0" forKey:@"tagId"];
            [d6 setObject:@"全部" forKey:@"tagName"];
            [SelectMaint addObject:d6];
            
            wbdw_labDetail.text=@"全部" ;
            wbdw_labDetail.tag=0;
            
            [self initMaint:shi_labDetail.tag byDistrictId: qu_labDetail.tag];
        }
        else if(currClass.table_view.tag==202)
        {
            sydw_labDetail.text=[Content objectForKey:@"tagName"];
            sydw_labDetail.tag=[[Content objectForKey:@"tagId"] intValue];
            
        }
        else if(currClass.table_view.tag== 203)
        {
            wbdw_labDetail.text=[Content objectForKey:@"tagName"];
            wbdw_labDetail.tag=[[Content objectForKey:@"tagId"] intValue];
            
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
    sc.hidden=false;
}
- (void)CloseSelect
{
    sc.hidden=true;
}

-(void)InitSelect
{
    shi_labDetail.text= @"全部";
    shi_labDetail.tag=0;
    qu_labDetail.text=@"全部" ;
    qu_labDetail.tag=0;
    sydw_labDetail.text=@"全部" ;
    sydw_labDetail.tag=0;
    wbdw_labDetail.text=@"全部" ;
    wbdw_labDetail.tag=0;
    
    _requestWhere=[[RequestWhere alloc]init];
}
/*
 - (void)initSelectFrame
 {
 sc.frame=CGRectMake(sc.frame.origin.x, sc.frame.origin.y, bounds_width.size.width, sc.frame.size.height);
 float width=bounds_width.size.width/2;
 
 shi_labDetail.frame=CGRectMake(shi_labDetail.frame.origin.x, shi_labDetail.frame.origin.y, width-20-34-20, shi_labDetail.frame.size.height);
 shi_labBtn.frame=CGRectMake(_txtCity.frame.origin.x, _txtCity.frame.origin.y, width-20-34-20, _txtCity.frame.size.height);
 
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
 */

- (void)initSelect
{
    if(!IsInitselect)
    {
        //        [self initSelectFrame];
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
                 
                 NSLog(@"SelectCity==%@",SelectCity);
                 
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
- (void)labBtnClick:(id)btn
{
    UIButton * currBtn=(UIButton *)btn;
    //    float currHeight=currBtn.frame.origin.y+currBtn.frame.size.height;
    //    NSLog(@"====+++++%f",currHeight);
    
    NSMutableArray *arr2=[[NSMutableArray alloc]init];
    switch (currBtn.tag) {
        case 200:
            arr2=SelectCity;
            NSLog(@"市");
            NSLog(@"arr2===%@",arr2);
            _view_pop.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
            _view_pop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
            _view_Content.frame=CGRectMake(5, 90, bounds_width.size.width-20, _view_Content.frame.size.height);
            break;
        case 201:
            arr2=SelectQu;
            NSLog(@"arr2===%@",arr2);
            _view_pop.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
            _view_pop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
            _view_Content.frame=CGRectMake(5, 90, bounds_width.size.width-20, _view_Content.frame.size.height);
            
            break;
        case 202:
            arr2=SelectUserDecp;
            NSLog(@"arr2===%@",arr2);
            _view_pop.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
            _view_pop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
            _view_Content.frame=CGRectMake(5, 130, bounds_width.size.width-20, _view_Content.frame.size.height);
            
            break;
        case 203:
            arr2=SelectMaint;
            NSLog(@"arr2===%@",arr2);
            _view_pop.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
            _view_pop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
            _view_Content.frame=CGRectMake(5, 170, bounds_width.size.width-20, _view_Content.frame.size.height);
            
            break;
        default:
            break;
    }
    
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
    
    _view_pop.hidden = NO;
    _view_Content.hidden = NO;
}

#pragma mark TablviewDelegateEX
-(void)MoreRecord
{
    CourseTableview.PageIndex+=1;
    
    if (typeID==0||typeID==3) {
        [self getSchoolCourse];
    }else{
        
        [self getSchoolCourse_1];
    }
    
}
-(void)TableRowClick:(UITableItem*)value
{
    warningElevatorModel *warnmodel=(warningElevatorModel *)value;
    
    if (typeID==0) {
        
        DTWBDetailViewController *vc = [[DTWBDetailViewController alloc] init];
        vc.lift_ID = warnmodel.ID;
        vc.dataDic = warnmodel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (typeID==3) {
        
        WBDetailViewController *vc = [[WBDetailViewController alloc] init];
        vc.liftNum = warnmodel.Lift. LiftNum;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

    
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
    
    if (typeID==0||typeID==3) {
        
        [self getSchoolCourse];
    }else{
    
        [self getSchoolCourse_1];
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
-(void)getSchoolCoursePic
{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%i",1] forHTTPHeaderField:@"PageIndex"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:@"999999" forHTTPHeaderField:@"PageSizeRate"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%@",tabSelectIndex] forHTTPHeaderField:@"Type"];

    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId]forHTTPHeaderField:@"CityId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId]forHTTPHeaderField:@"AddressId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId]forHTTPHeaderField:@"MaintDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId]forHTTPHeaderField:@"UseDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsInstallation]forHTTPHeaderField:@"IsInstallation"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsOnline]forHTTPHeaderField:@"IsOnline"];
    
    
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:@"Check/GetCheckRates"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         NSLog(@"success:%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         NSLog(@"dic_result==%@",dic_result);
         
         [self performSelectorOnMainThread:@selector(cc:) withObject:dic_result waitUntilDone:NO];
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"获取图表失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
//         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}

- (void)cc:(NSDictionary*)dic_result
{
    
    int state_value=[[dic_result objectForKey:@"Success"] intValue];
    
    if (state_value==1) {
        NSMutableArray *allTags=[[dic_result objectForKey:@"Data"] objectFromJSONString];
        
        NSLog(@"allTags==%@",allTags);
        
        NSString *str_1;
        NSString *str_2;
        
        if ([tabSelectIndex isEqualToString:@"0"]) {
            
            str_1 = [NSString stringWithFormat:@"%@",[allTags valueForKey:@"其它"]];
            str_2 = [NSString stringWithFormat:@"%@",[allTags valueForKey:@"待检"]];
            
        }else{
            
            str_1 = [NSString stringWithFormat:@"%@",[allTags valueForKey:@"其它"]];
            str_2 = [NSString stringWithFormat:@"%@",[allTags valueForKey:@"漏检"]];
        }
        
        NSArray *arr = @[str_1,str_2];
        NSLog(@"arr==%@",arr);
        
        //JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
        pie.center = CGPointMake(75,75);
        pie.valueArr = arr;
        pie.countArr =arr;
        pie.backgroundColor = [UIColor clearColor];
        
        pie.positionChangeLengthWhenClick = arr.count;
        [pie showAnimation];

    }
    
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

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
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId]forHTTPHeaderField:@"CityId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId]forHTTPHeaderField:@"AddressId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId]forHTTPHeaderField:@"MaintDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId]forHTTPHeaderField:@"UseDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsInstallation]forHTTPHeaderField:@"IsInstallation"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsOnline]forHTTPHeaderField:@"IsOnline"];
    
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:@"Check/GetCheckList"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
         
     }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         NSLog(@"success:%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
//         NSLog(@"dic_result==%@",dic_result);
         
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
                 
//                 NSLog(@"allTags==%@",allTags);
                 
                 for (NSMutableDictionary *dic_item in allTags ){
                     warningElevatorModel *model=[[warningElevatorModel alloc] init];
                     model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UpdateDatetime"]];
                     model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                     
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintenancePeriod"]];
                     
                     warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                     
                     NSLog(@"dic_item==%@",dic_item);
                     
                     lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftNum"]];
                     
                     lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"InstallationAddress"]];
                     
                     
                     model.RescueType=@"维保状态：";
                     
                     
                     
                     model.Lift=lift;
                     [arr addObject:model];
                 }
                 
                 [MBProgressHUD showSuccess:[NSString stringWithFormat:@"读取：%lu%@",(unsigned long)allTags.count,@"条数据!"] toView:nil];
                 
                 
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
-(void)getSchoolCourse_1
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%i",CourseTableview.PageIndex] forHTTPHeaderField:@"PageIndex"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:@"20" forHTTPHeaderField:@"PageSize"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%@",tabSelectIndex] forHTTPHeaderField:@"Type"];
    
    
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId]forHTTPHeaderField:@"CityId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId]forHTTPHeaderField:@"AddressId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId]forHTTPHeaderField:@"MaintDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId]forHTTPHeaderField:@"UseDeptId"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsInstallation]forHTTPHeaderField:@"IsInstallation"];
    [[AFAppDotNetAPIClient sharedClient_token].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsOnline]forHTTPHeaderField:@"IsOnline"];
    
    [[AFAppDotNetAPIClient sharedClient_token]
     GET:@"Check/GetCheckList"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         //         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
//         NSLog(@"dic_result==%@",dic_result);
         
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
                 
                 //                 NSLog(@"allTags==%@",allTags);
                 
                 for (NSMutableDictionary *dic_item in allTags ){
                     warningElevatorModel *model=[[warningElevatorModel alloc] init];
                     model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UpdateDatetime"]];
                     model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                     
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintenancePeriod"]];
                     
                     warningElevatorLift *lift=[[warningElevatorLift alloc]init];
                     
                     lift.LiftNum=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"LiftNum"]];
                     lift.InstallationAddress=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"InstallationAddress"]];
                     
                     if(typeID==1)
                         model.RescueType=@"待查状态：";
                     else if(typeID==2)
                         model.RescueType=@"漏查状态：";
                     else if(typeID==3)
                         model.RescueType=@"维保状态：";
                     
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
             }
             else
             {
                 
             }
         }
         else
         {
             
         }
         
         [CourseTableview.tableView reloadData];
         [CourseTableview doneLoadingTableViewData];
         CourseTableview.max_Cell_Star=YES;
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





@end
