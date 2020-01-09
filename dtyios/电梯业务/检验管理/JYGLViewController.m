//
//  JYGLViewController.m
//  Sea_northeast_asia
//
//  Created by 王永超 on 2017/3/21.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "JYGLViewController.h"
#import "warningElevatorModel.h"
#import "CommonUseClass.h"
#import "RequestWhere.h"
#import "MyControl.h"

#import "JHChartHeader.h"
#import "UMMobClick/MobClick.h"
#import "ZFChart.h"
//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define UIColorRGB(r,g,b) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])

@interface JYGLViewController ()<ZFPieChartDataSource, ZFPieChartDelegate>
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
    
    NSArray *pieArr; //饼状图数组
    
    UILabel *labweijian; //超期未检label
    UILabel *labelyijian;//已检label
    
    UILabel *labelLv;
}

@property (nonatomic, strong) ZFPieChart * pieChart;

@property (nonatomic, assign) CGFloat height;
@end

@implementation JYGLViewController
@synthesize app;
- (void)setUp{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JYGLViewController"];
    
    self.navigationItem.title=@"电梯年检";
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
    [self setUp];
    
    typeID = 0;
    //init
    tabSelectIndex=@"NULL";
    _requestWhere=[[RequestWhere alloc]init];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    IsInitselect=false;
    [self CloseSelect];
    [self CloseAllClassIfication];
    
    
    bgView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    leftBtn = [MyControl createButtonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3-1, 40) imageName:nil bgImageName:nil title:@"检验记录" SEL:@selector(btnClick:) target:self];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    leftBtn.tag=100;
    [bgView addSubview:leftBtn];
    
    
    
    btnLine = [MyControl createLabelWithFrame:CGRectMake((bounds_width.size.width/3-60)/2, CGRectGetMaxY(bgView.frame)+1, 60, 2) Font:1 Text:nil];
    btnLine.backgroundColor = [UIColor colorWithHexString:@"#3574fa"];;
    [self.view addSubview:btnLine];
    
    centertBtn =[MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 40) imageName:nil bgImageName:nil title:@"待检电梯" SEL:@selector(btnClick:) target:self];
    centertBtn.tag=101;
    centertBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:centertBtn];
    
    rightBtn = [MyControl createButtonWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, 40) imageName:nil bgImageName:nil title:@"超期未检" SEL:@selector(btnClick:) target:self];
    rightBtn.tag=102;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [bgView addSubview:rightBtn];
    
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
    chaxunBtn.tag = 103;
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
    
    
    if (typeID==0) {
        
        [self getSchoolCourse];
    }else{
        
        [self getSchoolCourse_1];
    }

    
    
    
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(chaxunLab.frame)+5, SCREEN_WIDTH, 140)];
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.piePatternType = kPieChartPatternTypeCircle;
    self.pieChart.percentType = kPercentTypeInteger;
    self.pieChart.isShadow = NO;
    self.pieChart.percentOnChartFont = [UIFont systemFontOfSize:14];
    //    self.pieChart.isAnimated = NO;
    //    self.pieChart.isShowPercent = NO;
    [self.pieChart strokePath];
    [self.view addSubview:self.pieChart];
    
    UIView *viewIns = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pieChart.frame)-10, SCREEN_WIDTH, 20)];
//    viewIns.backgroundColor = [UIColor grayColor];
    [self.view addSubview:viewIns];
    UILabel *labeper = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 20)];
//    labeper.text = @"检验率100%";
    labeper.font = [UIFont systemFontOfSize:14];
    [viewIns addSubview:labeper];
    labelyijian = [[UILabel alloc]init];
    labelyijian.text = @"已检";
    labelyijian.font = [UIFont systemFontOfSize:14];
    labelyijian.frame = CGRectMake(SCREEN_WIDTH-50, 0, 60, 20);
    [viewIns addSubview:labelyijian];
    
    UILabel *labYellow = [[UILabel alloc]init];
    labYellow.frame = CGRectMake(labelyijian.frame.origin.x-20, 3, 14, 14);
    [viewIns addSubview:labYellow];
    labYellow.backgroundColor = ZFColor(253, 203, 76, 1);
    labYellow.layer.masksToBounds = YES;
    labYellow.layer.cornerRadius  = 7;
    
    labweijian = [[UILabel alloc]initWithFrame:CGRectMake(labYellow.frame.origin.x-80, 0, 70, 20)];
    labweijian.text = @"超期未检";
    labweijian.font = [UIFont systemFontOfSize:14];
    [viewIns addSubview:labweijian];
    
    
    UILabel *labblue = [[UILabel alloc]init];
    labblue.frame = CGRectMake(labweijian.frame.origin.x-20, 3, 14, 14);
    [viewIns addSubview:labblue];
    labblue.backgroundColor = ZFColor(71, 204, 255, 1);
    labblue.layer.masksToBounds = YES;
    labblue.layer.cornerRadius  = 7;
    
    UIImageView *imagelv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wb1_repair"]];
    imagelv.frame = CGRectMake(10, 0, 15, 15);
    [viewIns addSubview:imagelv];
    labelLv = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imagelv.frame)+5, 0, 200, 20)];
    [viewIns addSubview:labelLv];
    labelLv.font = [UIFont systemFontOfSize:14];
    CourseTableview=[[UITableViewExViewController alloc]initWithStyle:UITableViewStylePlain tableCellXIB:@"SBAZCell2" tableCells_Index:0];
    //代理
    CourseTableview.delegateCustom=self;
    //行高
    CourseTableview.currHeight= 50;
    //tableView的frame
    if (typeID > 0) {
        CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.pieChart.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
    }
    else {
        CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(chaxunBtn.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
    }
    [self.view addSubview:CourseTableview.tableView];
    //高级查询相关
    [self initMySelect];
}
- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
//    return @[@"40", @"60"];
    return pieArr;
}

- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
    return @[ZFColor(71, 204, 255, 1), ZFColor(253, 203, 76, 1), ZFColor(214, 205, 153, 1), ZFColor(78, 250, 188, 1), ZFColor(16, 140, 39, 1), ZFColor(45, 92, 34, 1)];
}

#pragma mark - ZFPieChartDelegate

- (void)pieChart:(ZFPieChart *)pieChart didSelectPathAtIndex:(NSInteger)index{
    NSLog(@"第%ld个",(long)index);
}

- (CGFloat)allowToShowMinLimitPercent:(ZFPieChart *)pieChart{
    return 1;
}

- (CGFloat)radiusForPieChart:(ZFPieChart *)pieChart{
    return 60;
}

/** 此方法只对圆环类型(kPieChartPatternTypeForCirque)有效 */
- (CGFloat)radiusAverageNumberOfSegments:(ZFPieChart *)pieChart{
    return 2.f;
}

#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        self.pieChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
    }else{
        self.pieChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
    }
    
    [self.pieChart strokePath];
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
    if (typeID==0) {
        
        [self getSchoolCourse];
    }else{
        
        [self getSchoolCourse_1];
         [self getSchoolCoursePic];
    }
   
}
//高级查询相关

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
    if (btn.tag==101) {
        typeID=1;
        tabSelectIndex = @"0";
        
        [imageView removeFromSuperview];
        //imageView.hidden=NO;
        sc.hidden=YES;
        imageView = [MyControl createImageViewWithFrame:CGRectMake(SCREEN_WIDTH/2-75, 55, 150, 150) imageName:nil];//CGRectGetMaxY(chaxunBtn.frame)+
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 100/4.0;
//        imageView.backgroundColor = [UIColor yellowColor];
        [bgView2 addSubview:imageView];
        
        [self getSchoolCourse_1];
        [self getSchoolCoursePic];
        
        bgView2.frame= CGRectMake(0, 42, SCREEN_WIDTH, 55+155);
        bgView2_line2.frame= CGRectMake(0, bgView2.frame.size.height-5, SCREEN_WIDTH, 5);
        
        //chaxunBtn.frame = CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+150, 80, 40);
        CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(bgView2.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);
        
        NSLog(@"===101");
    }
    if (btn.tag==102) {
        typeID=2;
       tabSelectIndex = @"1";
        [imageView removeFromSuperview];
        //imageView.hidden=NO;
        sc.hidden=YES;
        imageView = [MyControl createImageViewWithFrame:CGRectMake(SCREEN_WIDTH/2-75, 55, 150, 150) imageName:nil];//CGRectGetMaxY(chaxunBtn.frame)+
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 100/4.0;
//        imageView.backgroundColor = [UIColor yellowColor];
        [bgView2 addSubview:imageView];
        
        [self getSchoolCourse_1];
        [self getSchoolCoursePic];
        
        bgView2.frame= CGRectMake(0, 42, SCREEN_WIDTH, 55+155);
        bgView2_line2.frame= CGRectMake(0, bgView2.frame.size.height-5, SCREEN_WIDTH, 5);
        
        //chaxunBtn.frame = CGRectMake(SCREEN_WIDTH-90, CGRectGetMaxY(btnLine.frame)+150, 80, 40);
        CourseTableview.tableView.frame = CGRectMake(0, CGRectGetMaxY(bgView2.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(chaxunBtn.frame)-10);//CGRectGetMaxY(imageView.frame)+10

        NSLog(@"===102");
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
        
        if (typeID==0) {
            
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
        if (typeID==0) {
            
            [self getSchoolCourse];
        }else{
            
            [self getSchoolCourse_1];
        }

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
    [[AFAppDotNetAPIClient sharedClient]
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
    
    [[AFAppDotNetAPIClient sharedClient]
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
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%ld",CityId] forHTTPHeaderField:@"CityId"];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%ld",DistrictId] forHTTPHeaderField:@"DistrictId"];
    
    NSString *string = @"Dept/GetUseDeptList";
    [[AFAppDotNetAPIClient sharedClient]
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
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%ld",CityId] forHTTPHeaderField:@"CityId"];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%ld",DistrictId] forHTTPHeaderField:@"DistrictId"];
    
    NSString *string = @"Dept/GetMaintDeptList";
    [[AFAppDotNetAPIClient sharedClient]
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
    if (typeID==0) {
        
        [self getSchoolCourse];
    }else{
        
        [self getSchoolCourse_1];
    }

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
    if (typeID==0) {
        
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%i",1] forHTTPHeaderField:@"PageIndex"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:@"999999" forHTTPHeaderField:@"PageSizeRate"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",tabSelectIndex] forHTTPHeaderField:@"Type"];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId]forHTTPHeaderField:@"City"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId]forHTTPHeaderField:@"Address"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId]forHTTPHeaderField:@"MaintDeptId"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId]forHTTPHeaderField:@"UseDeptId"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsInstallation]forHTTPHeaderField:@"IsInstallation"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsOnline]forHTTPHeaderField:@"IsOnline"];
    
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:@"LiftYearInspection/GetLiftYearInspectionRates"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         NSLog(@"success:%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         NSLog(@"dic_result==%@",dic_result);
         
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                 
                 NSMutableArray *  allTags=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 
                 NSString *str_1;
                 NSString *str_2;
                 
                 if ([tabSelectIndex isEqualToString:@"0"]) {
                     
                     str_1 = [NSString stringWithFormat:@"%@",[allTags valueForKey:@"已检"]];
                     str_2 = [NSString stringWithFormat:@"%@",[allTags valueForKey:@"待检"]];
                     
                 }else{
                     
                     str_1 = [NSString stringWithFormat:@"%@",[allTags valueForKey:@"超期未检"]];
                     str_2 = [NSString stringWithFormat:@"%@",[allTags valueForKey:@"已检"]];
                     
                 }
                 
                 NSArray *arr = @[str_1,str_2];
                 NSLog(@"arr==%@",arr);
                 pieArr = arr;
                 [self performSelectorOnMainThread:@selector(ResetLabelText:) withObject:pieArr waitUntilDone:NO];
                 
//                 JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
//                 pie.center = CGPointMake(75,75);
//                 pie.valueArr = arr;
//                 pie.countArr =arr;
//                 pie.backgroundColor = [UIColor clearColor];
//                 [imageView addSubview:pie];
//                 pie.positionChangeLengthWhenClick = arr.count;
//                 [pie showAnimation];
                 
                 
             }
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
- (void)ResetLabelText:(NSArray*)arr {
    [self.pieChart strokePath];
    NSLog(@"%@",arr);
    NSString *str_lv;
    int lv;
    if ([tabSelectIndex isEqualToString:@"0"]) {
        labweijian.text = [NSString stringWithFormat:@"已检:%@",arr[0]];
        labelyijian.text= [NSString stringWithFormat:@"待检:%@",arr[1]];
        
        if (labelyijian.text.intValue == 0) {
            lv = 0;
            str_lv = @"0.00%";
        }
        else {
            int lv = labelyijian.text.intValue/(labelyijian.text.intValue + labweijian.text.intValue) *100;
            str_lv = [NSString stringWithFormat:@"%d",(int)roundf(lv)];
        }
        
        labelLv.text = [NSString stringWithFormat:@"待检率%@",str_lv];
    }
    else {
        labweijian.text = [NSString stringWithFormat:@"超期未检:%@",arr[0]];
        labelyijian.text= [NSString stringWithFormat:@"已检:%@",arr[1]];
        if (labweijian.text.intValue == 0) {
            lv = 0;
            str_lv = @"0.00%";
        }
        else  {
            lv = labweijian.text.intValue/(labelyijian.text.intValue + labweijian.text.intValue) *100;
            str_lv = [NSString stringWithFormat:@"%d",(int)roundf(lv)];
            
        }
        labelLv.text = [NSString stringWithFormat:@"超期未检%@",str_lv];
    }
}

-(void)getSchoolCourse
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    AFAppDotNetAPIClient *_sharedClient2=[AFAppDotNetAPIClient sharedClient_new];
    [_sharedClient2.requestSerializer setValue:[NSString stringWithFormat:@"%i",CourseTableview.PageIndex] forHTTPHeaderField:@"PageIndex"];
    [_sharedClient2.requestSerializer setValue:@"20" forHTTPHeaderField:@"PageSize"];
    [_sharedClient2.requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    
//    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",tabSelectIndex] forHTTPHeaderField:@"Type"];

    [_sharedClient2.requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId]forHTTPHeaderField:@"City"];
    [_sharedClient2.requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId]forHTTPHeaderField:@"Address"];
    [_sharedClient2.requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId]forHTTPHeaderField:@"MaintDeptId"];
    [_sharedClient2.requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId]forHTTPHeaderField:@"UseDeptId"];
    [_sharedClient2.requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsInstallation]forHTTPHeaderField:@"IsInstallation"];
    [_sharedClient2.requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsOnline]forHTTPHeaderField:@"IsOnline"];
    
    
    
    [_sharedClient2
     GET:@"LiftYearInspection/GetLiftYearInspectionList"
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
                     
//                     model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UpdateDatetime"]];
                     model.YearInspectionDate = [NSString stringWithFormat:@"%@",[dic_item objectForKey:@"YearInspectionDate"]];
                     model.YearInspectionNextDate = [NSString stringWithFormat:@"%@",[dic_item objectForKey:@"YearInspectionNextDate"]];
                     model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                     
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintenancePeriod"]];
                     
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

         }
        
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

-(void)getSchoolCourse_1
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImageView *image=[CourseTableview.view  viewWithTag:3000];
    if (image!=nil) {
        [image removeFromSuperview];
    }
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%i",CourseTableview.PageIndex] forHTTPHeaderField:@"PageIndex"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:@"20" forHTTPHeaderField:@"PageSize"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",tabSelectIndex] forHTTPHeaderField:@"Type"];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.CityId]forHTTPHeaderField:@"City"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.AddressId]forHTTPHeaderField:@"AddressId"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.MaintDeptId]forHTTPHeaderField:@"MaintDeptId"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.UseDeptId]forHTTPHeaderField:@"UseDeptId"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsInstallation]forHTTPHeaderField:@"IsInstallation"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%d",_requestWhere.IsOnline]forHTTPHeaderField:@"IsOnline"];
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:@"LiftYearInspection/GetLiftYearInspectionList"
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
                     
                     //                     model.CreateTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"UpdateDatetime"]];
                     model.YearInspectionDate = [NSString stringWithFormat:@"%@",[dic_item objectForKey:@"YearInspectionDate"]];
                     model.YearInspectionNextDate = [NSString stringWithFormat:@"%@",[dic_item objectForKey:@"YearInspectionNextDate"]];
                     model.ID=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] ;
                     
                     model.TotalLossTime=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"MaintenancePeriod"]];
                     
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
             
         }
         
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
