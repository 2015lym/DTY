//
//  SZQuestionCheckBox_WZH.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "SZQuestionCheckBox_WZH.h"
#import "CommonUseClass.h"
#import "EventCurriculumEntity.h"
#import "HTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "OptionIDlistObject.h"
#import "OptionIDlist.h"
#import "Questionlist.h"
#import "ResultObject.h"
#import "SZQuestionCheckBox.h"
#import "SZQuestionCell_WZH.h"
#import "HTTPSessionManager.h"
#import "CommonUseClass.h"
#import "EventCurriculumEntity.h"

#import "MyControl.h"
#import "DTWBViewController.h"
#import "DTWBWebViewController_WZH.h"
#import "Util.h"
#import "CommonUseClass.h"
#import "EventCurriculumEntity.h"
#import "HTTPSessionManager.h"
#import "EWMClass.h"
#import "RequestWhere.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SZQuestionCheckBox_WZH ()
{
    UILabel *dtWeiZhi_2;
    NSString *CheckDateStr;
    NSString *StepIdNum;
    NSString *UserIdNum;
    NSString *DeptIdNum;
    UILabel *dtBianHao_2;
    UILabel *dtWeiBao_2;
    NSMutableArray *titleArray;
    RequestWhere *_requestWhere;
    
    NSMutableDictionary *dict;
    NSMutableArray *arr_Photos;
    NSString * numbers;
    NSString *curr_photo_isnfc;
    UIButton *commitButton;
    
    float Longitude;
    float Latitude;
    NSMutableArray *checkTypeArr;
    
}

@property (nonatomic, assign) CGFloat titleWidth;

@property (nonatomic, assign) CGFloat OptionWidth;

@property (nonatomic, assign) BOOL complete;

@property (nonatomic, strong) NSArray *tempArray;

@property (nonatomic, strong) NSMutableArray *arrayM;

@property (nonatomic, strong) SZConfigure *configure;

@end

@implementation SZQuestionCheckBox_WZH

@synthesize app;
- (instancetype)initWithItem:(SZQuestionItem *)questionItem andConfigure:(SZConfigure *)configure {
    
    self = [super init];
    
    if (self) {
        self.sourceArray = questionItem.ItemQuestionArray;
        if (configure != nil) self.configure = configure;
    }
    return self;
}

- (instancetype)initWithItem:(SZQuestionItem *)questionItem {
    
    return [self initWithItem:questionItem andConfigure:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    
    
}

-(void)getSchoolCourse
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:_liftID forKey:@"LiftID"];
     [dicHeader setValue:[NSString stringWithFormat:@"%d",_floorNumber] forKey:@"CheckType"];
    
    
    [XXNet GetURL:@"Step/GetStepList2" header:dicHeader parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
            NSString *str_json = data[@"Data"];
            NSMutableArray *dic_result = [str_json objectFromJSONString];
         NSLog(@"%@",dic_result);
         
         
         if (dic_result.count>0) {
             
            if ([data[@"Success"]intValue]) {
                
                NSMutableArray *  allTags=dic_result;
                 

               
                 commitButton.hidden=NO;
                 
                 NSMutableArray *selectArray=[[NSMutableArray alloc]init];
                 titleArray=[[NSMutableArray alloc]init];
                 checkTypeArr = [[NSMutableArray alloc]init];
                 NSMutableArray *nfcarray=[NSMutableArray new];
                 
                 
                 
                 for (NSDictionary * dic in allTags) {
                     
                     if([[dic objectForKey:@"CheckType"] intValue]==_floorNumber)
                     {
                         NSLog(@"%@",dic);
                         
                         
                         [titleArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"StepName"]]];
                         [selectArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"IsTakePhoto"]]];
                         [checkTypeArr addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"ID"]]];
                         //[nfcarray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"IsNFC"]]];
                     }
                 }
                 NSLog(@"%@",checkTypeArr);
                 
                 
                 
                
                
                
                 
                 
                 NSMutableArray *optionArray=[[NSMutableArray alloc]init];
                 NSMutableArray *numbers_Array=[[NSMutableArray alloc]init];
                 //NSMutableArray *checkArray=[[NSMutableArray alloc]init];
                 
                 
                 descArr=[[NSMutableArray alloc]init];
                 
                 NSMutableArray *dicaOP=[NSMutableArray new];
                 [dicaOP addObject:@"合格"];
                 [dicaOP addObject:@"不合格"];
                 for (int m=0; m<titleArray.count; m++) {
                     [optionArray addObject:dicaOP];
                     
                 }
                 
                 NSMutableArray *typeArray=[[NSMutableArray alloc]init];
                 
                 for (int i=0; i<titleArray.count; i++) {
                     [typeArray addObject:@(1)];
                 }
                 [typeArray addObject:@(3)];
                 
                 for (int i=0; i<titleArray.count; i++) {
                     [numbers_Array addObject:[NSString stringWithFormat:@"%d",i]];
                 }
                 
                 //                      for (int i=0; i<titleArray.count; i++) {
                 //                          [checkArray addObject:@0];
                 //                      }
                 
                 SZQuestionItem *item = [[SZQuestionItem alloc] initWithTitleArray:titleArray andOptionArray:optionArray andSelectArray:nil andQuestonType:typeArray andNumberArray:selectArray andNumberArray2:numbers_Array];
                 self.sourceArray = item.ItemQuestionArray;
                 
                 NSMutableArray *newarr=[NSMutableArray new];
                     int i =0;
                     for (NSDictionary *currDic in allTags) {
                         NSMutableDictionary *newdic=[NSMutableDictionary dictionaryWithDictionary:[self.sourceArray objectAtIndex:i]];
                         int isnfc=0;
                         if([currDic[@"IsNFC"] boolValue] && ![[CommonUseClass FormatString: currDic[@"NFCCode"]] isEqual:@""])
                             isnfc=1;
                         [newdic setObject:[NSString stringWithFormat:@"%d", isnfc] forKey:@"IsNFC"];
                         [newdic setObject:[CommonUseClass FormatString: currDic[@"TermName"]] forKey:@"TermName"];
                         [newdic setObject:[CommonUseClass FormatString: currDic[@"NFCCode"]] forKey:@"NFCCode"];
                         [newdic setObject:[CommonUseClass FormatString: currDic[@"NFCNum"]] forKey:@"NFCNum"];
                         [newarr addObject:newdic];
                         
                         i++;
                     }
                
                 self.sourceArray=newarr;
                 
                 [self.tableView reloadData];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
                
                 
             }
         }
         

            } failure:^(NSError *error) {
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"获取列表失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

- (void)dd{
    
    commitButton.hidden=YES;
    [CommonUseClass showAlter:@"暂无权限"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)selectDataErr:(NSDictionary *)dict
{
    [CommonUseClass showAlter:@"获取列表失败！"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

//-(void)getSchoolCourse2
//{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//
//    [[AFAppDotNetAPIClient sharedClient]
//     GET:[NSString stringWithFormat:@"Lift/GetLiftByLiftNum?liftNum=%@",_liftNum]
//     parameters:nil
//     progress:^(NSProgress * _Nonnull uploadProgress) {  }
//     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//         NSDictionary* dic_result2=[str_result objectFromJSONString];
//
//         if (dic_result2.count>0) {
//             int state_value=[[dic_result2 objectForKey:@"Success"] intValue];
//
//             if (state_value==1) {
//
//                 NSDictionary *  allTags=[[dic_result2 objectForKey:@"Data"] objectFromJSONString];
//
//                 StepIdNum = [NSString stringWithFormat:@"%@",[allTags objectForKey:@"AddressId"]];
//                 UserIdNum = [NSString stringWithFormat:@"%@",[allTags objectForKey:@"UpdateUserId"]];
//                 DeptIdNum = [NSString stringWithFormat:@"%@",[allTags objectForKey:@"MadeDepartmentId"]];
//
//                 dtWeiZhi_2.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",[allTags objectForKey:@"AddressPath"]],[NSString stringWithFormat:@"%@",[allTags objectForKey:@"InstallationAddress"]]];
//
//                 _liftID = [NSString stringWithFormat:@"%@",[allTags objectForKey:@"ID"]];
//
//                 dtBianHao_2.text = _liftID;
//
//                 [self performSelectorOnMainThread:@selector(cc:) withObject:allTags waitUntilDone:NO];
//             }
//         }
//
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [self performSelectorOnMainThread:@selector(selectDataErr:) withObject:nil waitUntilDone:YES];
//     }];
//
//}
-(void)cc:(NSDictionary *)dict
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dict = [NSMutableDictionary dictionaryWithCapacity:0];
    arr_Photos = [NSMutableArray arrayWithCapacity:0];
    Longitude=0;
    Latitude=0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([self.typeStr isEqualToString:@"0"]) {
        self.navigationItem.title=_Title;
    }else{
        self.navigationItem.title=@ "问卷详情";
    }
    
    [self getSchoolCourse];
    
    //[self getSchoolCourse2];
    
    //    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 200)];
    //    [self.view addSubview:headview];
    //
    //    UILabel *dtXinXi = [MyControl createLabelWithFrame:CGRectMake(10, 10, 100, 20) Font:16.0 Text:@"电梯信息"];
    //    dtXinXi.textColor = [UIColor blueColor];
    //    [headview addSubview:dtXinXi];
    //
    //    UILabel *dtBianHao = [MyControl createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(dtXinXi.frame)+20, 80, 20) Font:14 Text:@"电梯编号"];
    //    dtBianHao.textColor = [UIColor blackColor];
    //    [headview addSubview:dtBianHao];
    //
    //    dtBianHao_2 = [MyControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH-100, CGRectGetMaxY(dtXinXi.frame)+20, 80, 20) Font:14 Text:nil];
    //    dtBianHao_2.textColor = [UIColor blackColor];
    //    dtBianHao_2.textAlignment = NSTextAlignmentRight;
    //    [headview addSubview:dtBianHao_2];
    //
    //
    //    UILabel *dtWeiZhi = [MyControl createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(dtBianHao.frame)+20, 80, 20) Font:14 Text:@"电梯位置"];
    //    dtWeiZhi.textColor = [UIColor blackColor];
    //    [headview addSubview:dtWeiZhi];
    //
    //
    //    dtWeiZhi_2 = [MyControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(dtWeiZhi.frame)+10, CGRectGetMaxY(dtBianHao.frame)+10, SCREEN_WIDTH- CGRectGetMaxX(dtWeiZhi.frame)-10-20, 40) Font:14 Text:nil];
    //    dtBianHao_2.numberOfLines = 2;
    //    dtWeiZhi_2.textColor = [UIColor blackColor];
    //    [headview addSubview:dtWeiZhi_2];
    //
    //
    //
    //    UILabel *dtWeiBao = [MyControl createLabelWithFrame:CGRectMake(10, CGRectGetMaxY(dtWeiZhi.frame)+20, 80, 20) Font:14.0 Text:@"上次维保"];
    //    dtWeiBao.textColor = [UIColor blackColor];
    //    [headview addSubview:dtWeiBao];
    //
    //
    //    UILabel *dtWeiBao_2 = [MyControl createLabelWithFrame:CGRectMake(SCREEN_WIDTH-80, CGRectGetMaxY(dtWeiZhi.frame)+20, 60, 20) Font:14.0 Text:@"尚未巡检"];
    //    dtWeiBao_2.textColor = [UIColor greenColor];
    //    dtWeiBao_2.textAlignment = NSTextAlignmentRight;
    //    [headview addSubview:dtWeiBao_2];
    //
    //
    //    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(dtWeiBao.frame)+10, SCREEN_WIDTH-10, 1)];
    //    line.backgroundColor = [UIColor lightGrayColor];
    //    [headview addSubview:line];
    [self initWindow];
    self.tableView.tableHeaderView = headview;
    
    UIView * myview=[[UIView alloc]initWithFrame:CGRectMake(0, -20, bounds_width.size.width, 20)];
    myview.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [self .view addSubview: myview];
    
    
    
    UIView *footview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 200)];
    //    footview.backgroundColor=[UIColor redColor];
    UIView *answerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width-20, 120)];
    ttLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, bounds_width.size.width-20, 20)];
    
    [answerView addSubview:ttLabel];
    ttTextView=[[UITextView alloc]initWithFrame:CGRectMake(10, 40, bounds_width.size.width-20, 70)];
    if ([self.typeStr isEqualToString:@"1"]) {
        ttTextView.textColor = [UIColor blackColor];
    }else{
        ttTextView.text=@"写下您的意见";
        ttTextView.textColor = [UIColor lightGrayColor];
    }
    
    ttTextView.layer.masksToBounds=YES;
    ttTextView.layer.cornerRadius=5.0;
    ttTextView.layer.borderWidth=1;
    ttTextView.delegate=self;
    ttTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [answerView addSubview:ttTextView];
    //    [footview addSubview:answerView];
    commitButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 60, bounds_width.size.width-20, 44)];
    commitButton.hidden=YES;
    footview.frame=CGRectMake(0, 0, bounds_width.size.height, 200);
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.backgroundColor = [UIColor colorWithHexString:@"#3574fa"];
    commitButton.layer.masksToBounds = YES;
    commitButton.layer.cornerRadius = 4.0;
    [commitButton addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [footview addSubview:commitButton];
    self.tableView.tableFooterView = footview;
    
    self.canEdit = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.titleWidth = self.view.frame.size.width - (self.configure.titleSideMargin ? self.configure.titleSideMargin * 2 : HEADER_MARGIN * 2);
    self.OptionWidth = self.view.frame.size.width - (self.configure.optionSideMargin ? self.configure.optionSideMargin * 2 : OPTION_MARGIN * 2) - (self.configure.buttonSize ? self.configure.buttonSize : BUTTON_WIDTH - 5);
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    
    [_locService startUserLocationService];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_NFCSBShow:) name:@"tongzhi_NFCSBShow" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_NFCSB:) name:@"tongzhi_NFCSB" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi_NFCSBPic:) name:@"tongzhi_NFCSBPic" object:nil];
}
- (void)tongzhi_NFCSBPic:(NSNotification *)text{
    NSString *index=(NSString *)text.userInfo[@"index"];
    
    UIButton * btn=[[UIButton alloc]init];
    btn.tag=[index intValue];
    [self attentionButtonClick:btn clickedWithData:@"nfc" clickedWithPhoto:nil];
}
- (void)tongzhi_NFCSB:(NSNotification *)text{
    NSString *guid=(NSString *)text.userInfo[@"textId"];//@"04C3B10A915B80";//
    NSString *nfccode=(NSString *)text.userInfo[@"textValue"];
    NSString *index=(NSString *)text.userInfo[@"index"];
    NSString *NFCCode=(NSString *)text.userInfo[@"NFCCode"];//dianti119-000000001
    NSString *NFCNum=(NSString *)text.userInfo[@"NFCNum"];//04C3B10A915B80
    
    NSString * IsNFCOK=@"0";
    if([guid isEqual:NFCNum])//[nfccode isEqual:NFCCode]&&
    {
        IsNFCOK=@"1";
        
        if(self.app.showCount==0)
        {
            [self performSelectorOnMainThread:@selector(showMsg:) withObject:@"识别成功！" waitUntilDone:YES];
            self.app.showCount=1;
        }
    }
    else
    {
        IsNFCOK=@"0";
        if(self.app.showCount==0)
        {
         [self performSelectorOnMainThread:@selector(showMsg:) withObject:@"该标签为错误标签，请重新扫描！" waitUntilDone:YES];
            self.app.showCount=1;
        }
    }
    
    //1.
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:IsNFCOK,@"ifNfcOk",index,@"index", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_NFCSBCell" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    //2.
    [self setNfcArr:[index intValue] forNfcOk:IsNFCOK];
}

-(void)showMsg:(NSString *)msg
{
    [CommonUseClass showAlter:msg];
}

- (void)tongzhi_NFCSBShow:(NSNotification *)text{
    NSString  *name=(NSString *)text.userInfo[@"text1"];
    NSString  *desc=(NSString *)text.userInfo[@"text2"];
    NSString  *index=(NSString *)text.userInfo[@"text3"];
    NSString  *NFCCode=(NSString *)text.userInfo[@"NFCCode"];
    NSString  *NFCNum=(NSString *)text.userInfo[@"NFCNum"];
    
    NFCSBNewViewController *vc=[[NFCSBNewViewController alloc]init];
    vc.Title= name;
    vc.Memo=desc;
    vc.index=index;
    vc.NFCNum=NFCNum;
    vc.NFCCode=NFCCode;
    [self.navigationController pushViewController:vc animated:YES];
    self.app.showCount=0;
}
- (void)CallPoliceMethod:(NSDictionary*)dic {
    
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
        
        self.view=nil;
    }]];
    // 5、模态切换显示弹出框
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)initWindow{
    
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 220)];
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
    
    UILabel * lab_head1=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width, 20) Font:18 Text:_Title];
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
    
     NSString * LiftNum_show =[_liftNum stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dtBianHao_2.text=LiftNum_show;
    [view_head2 addSubview:dtBianHao_2];
    
    UILabel *dtBianHao = [MyControl createLabelWithFrame:CGRectMake(0, 50, bounds_width.size.width, 20) Font:14 Text:@"电梯编号"];
    dtBianHao.textColor = [UIColor whiteColor];
    dtBianHao.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao];
    
    //3地址等69
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 146, bounds_width.size.width, 69)];
    [headview addSubview:view_head3];
    
    
    
    UIImageView *img_head21=[MyControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"wb_maintenance"];
    [view_head3 addSubview:img_head21];
    
    UILabel *dtWeiBao = [MyControl createLabelWithFrame:CGRectMake(40, 10, 80, 20) Font:14.0 Text:@"上次维保:"];
    //dtWeiBao.textColor = [UIColor blackColor];
    [view_head3 addSubview:dtWeiBao];
    
    
    dtWeiBao_2 = [MyControl createLabelWithFrame:CGRectMake(110, 10, SCREEN_WIDTH-90, 20) Font:14.0 Text:@""];
    
    if([[CommonUseClass FormatString: _UploadDate] isEqual:@""])_UploadDate=@"尚未维保";
    else
    {
        _UploadDate = [_UploadDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        if(_UploadDate.length>=16)
             _UploadDate=[_UploadDate substringToIndex:16];
    }
    dtWeiBao_2.text=_UploadDate;
    //dtWeiBao_2.textColor = [UIColor greenColor];
    //dtWeiBao_2.textAlignment = NSTextAlignmentRight;
    [view_head3 addSubview:dtWeiBao_2];
    
    
    UIImageView *img_head22=[MyControl createImageViewWithFrame:CGRectMake(10, 40, 20, 20) imageName:@"address_blue"];
    [view_head3 addSubview:img_head22];
    
    
    UILabel *dtWeiZhi = [MyControl createLabelWithFrame:CGRectMake(40, 40, 80, 20) Font:14 Text:@"电梯位置:"];
    //dtWeiZhi.textColor = [UIColor blackColor];
    [view_head3 addSubview:dtWeiZhi];
    
    dtWeiZhi_2 = [MyControl createLabelWithFrame:CGRectMake(110, 33, SCREEN_WIDTH- 120, 34) Font:14 Text:nil];
    dtWeiZhi_2.numberOfLines = 2;
    //dtWeiZhi_2.textColor = [UIColor blackColor];
    dtWeiZhi_2.text=_InstallationAddress;
    [view_head3 addSubview:dtWeiZhi_2];
    
    
    UILabel *dtLine = [MyControl createLabelWithFrame:CGRectMake(0, 215, bounds_width.size.width, 5) Font:14 Text:@""];
    dtLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headview addSubview:dtLine];
    
}

//点击空白-回收键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

-(void)attentionButtonClick:(UIButton*)sender clickedWithData:(NSString *)celldata clickedWithPhoto:(NSString *)photo
{
    
    UIButton *btn = (UIButton *)sender;
    
    numbers = [NSString stringWithFormat:@"%ld",btn.tag];
    
    //如果是nfc，拍照后要把NFC标签图片设置为已扫码
    curr_photo_isnfc=@"";
    if([celldata isEqual:@"nfc"])curr_photo_isnfc=@"nfc";
    
    NSLog(@"3333====%@",numbers);
    
    if ([photo isEqualToString:@"noPhoto"]) {
        
        
    }else{
        
        [self PhotoClick];
    }
    
}

#pragma mark - 调取相机响应事件

- (void)PhotoClick{
    
    NSLog(@"调取相机");
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    //进入照相界面
    [self presentViewController:picker animated:YES completion:nil];
    
}
//点击相册中的图片或照相机照完后点击use后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        NSString * strImg= [self ImageToBase64:image];
        
        
        
        for (NSDictionary *currDic in arr_Photos) {
            
            NSArray * keys = currDic.allKeys;
            for (int i = 0; i < keys.count; i++) {
                //逐个的获取键
                NSString * key = [keys objectAtIndex:i];
                
                if([key isEqualToString:numbers])
                {
                    [arr_Photos removeObject:currDic];
                    break;
                }
            }
        }
        
        dict=[[NSMutableDictionary alloc]init];
        [dict setValue:strImg forKey:numbers];
        [arr_Photos addObject:dict];
        if([curr_photo_isnfc isEqual:@"nfc"])
        {
            //添加 字典，将label的值通过key值设置传递
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:numbers,@"textOne", nil];
            //创建通知
            NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_photo_nfc" object:nil userInfo:dict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
    }];
    
}
//点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//UIImage图片转成Base64字符串
-(NSString *)ImageToBase64:(UIImage *)originImage
{
    
    NSData *data = UIImageJPEGRepresentation(originImage, 0.2f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([self.typeStr isEqualToString:@"1"]) {
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"写下您的意见";
        textView.textColor = [UIColor lightGrayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"写下您的意见"]){
        textView.text=@"";
        textView.textColor=[UIColor lightGrayColor];
    }
}
-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

-(int)havePic:(NSString*)currNum{
    int have=0;
    for (NSDictionary *currDic in arr_Photos) {
        NSArray * keys = currDic.allKeys;
        for (int i = 0; i < keys.count; i++) {
            //逐个的获取键
            NSString * key = [keys objectAtIndex:i];
            
            if([key isEqualToString:currNum ])
            {
                
                have=1;
                return have;
            }
        }
        
    }
    
    return have;
}

-(void)commitButtonClick{
    
    NSLog(@"%ld",_sourceArray.count);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deptID = [defaults objectForKey:@"deptID"];
    
    NSString *FNCs=@"";
    int iii=0;
    for (int i=0; i< _sourceArray.count; i++) {
        
        NSDictionary *selectDict=[_sourceArray objectAtIndex:i];
        
        
        //nfc
        NSString *IsNFCOK=@"";
        NSString *strIndex=[NSString stringWithFormat:@"%d",i];
        if([[IsNFCOKArr objectForKey:strIndex] isKindOfClass:[NSString class]])
              IsNFCOK = [IsNFCOKArr objectForKey:strIndex];
        if([[selectDict objectForKey:@"IsNFC"] boolValue])
        {
            if(![IsNFCOK isEqual:@"1"])
            {
                 int havePic=[self havePic:[NSString stringWithFormat:@"%d",i]];
                if(havePic==0)
                {
                    [CommonUseClass showAlter:[NSString stringWithFormat:@"维保步骤%d请扫描NFC或拍照",i+1]];
                    return;
                }
            }
        }
        
        
        
        NSArray *selectArr=[selectDict objectForKey:@"marked"];
        int iiii=0;
        for (int m=0; m<selectArr.count; m++) {
            
            NSNumber *bdf=[selectArr objectAtIndex:m];
            if ([bdf intValue]==1) {
                iii++;
                iiii++;
            }
        }
        if (iiii==0) {
            [CommonUseClass showAlter:[NSString stringWithFormat:@"请选择维保步骤%d",i+1]];
            return;
        }
        
        //2.
        NSString *type2=[selectDict objectForKey:@"type2"];
        NSString *selectBHE=@"0";
        if(selectArr.count>1)selectBHE=[CommonUseClass FormatString: [selectArr objectAtIndex:1]];
        if([type2 isEqual:@"1"]|| [selectBHE isEqual:@"1"] )
        {
            int havePic=[self havePic:[NSString stringWithFormat:@"%d",i]];
            if(havePic==0)
            {
                [CommonUseClass showAlter:[NSString stringWithFormat:@"维保步骤%d请拍照",i+1]];
                return;
            }
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    
    EWMClass *ewm_class = [[EWMClass alloc]init];
    
    NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < _sourceArray.count; i ++) {
        ewm_class.ID=_ID;
        ewm_class.CheckDetailId = @"0";
        ewm_class.CheckId = @"0";
        ewm_class.CheckDate =[self getCurrentTimes];
        ewm_class.UploadDate = [self getCurrentTimes];
        
        
        //nfc
        NSString *IsNFCOK=@"";
        NSString *strIndex=[NSString stringWithFormat:@"%d",i];
        if([[IsNFCOKArr objectForKey:strIndex] isKindOfClass:[NSString class]])
            IsNFCOK = [IsNFCOKArr objectForKey:strIndex];
        
        if([[_sourceArray[i] objectForKey:@"IsNFC"] boolValue])
        {
            if([IsNFCOK isEqual:@"1"])
            {
                ewm_class.NFCCode=[_sourceArray[i] objectForKey:@"NFCCode"];
            }
            else
            {
                ewm_class.NFCCode=@"";
            }
        }
        
        
        NSString *str=@"";
        //NSString *strIndex=[NSString stringWithFormat:@"%d",i];
        str = [textArr objectForKey:strIndex];
        if (!str) {
            str=@"";
        }
        ewm_class.Remark = str;
        ewm_class.CType=_CType;
        
        NSString *jw = [NSString stringWithFormat:@"%f,%f",Longitude,Latitude];
        
        ewm_class.LongitudeAndLatitude = jw;
        
        
        ewm_class.StepId = [NSString stringWithFormat:@"%@",[checkTypeArr objectAtIndex:i]];
        ewm_class.UserId = app.userInfo.UserID;
        ewm_class.DeptId = deptID;
        ewm_class.LiftId = _liftID;
        
        NSDictionary *selectDict=[_sourceArray objectAtIndex:i];
        NSArray *selectArr=[selectDict objectForKey:@"marked"];
        if([selectArr[0] intValue] ==1)
        {
            ewm_class.IsPassed = true;
        }
        else
        {
            ewm_class.IsPassed = false;
        }
        
        NSString *str123=[CommonUseClass classToJson:ewm_class];
        
        NSString *str456 = [self addPic:[NSString stringWithFormat:@"%d",i] forAll:str123];
        
        [mutableArr addObject:str456];
        
        str123 = nil;
        str456 = nil;
    }
    
    NSString *mutableStr = [mutableArr componentsJoinedByString:@","];
    
    
    NSString *str_str=@"[";
    str_str=[str_str stringByAppendingString:mutableStr];
    str_str=[str_str stringByAppendingString:@"]"];
    

       [self UpdateF:str_str];
    
   
}


-(void)UpdateF:(NSString *)str_str{
    //3.是否连网
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == -1) {
            //NSLog(@"未识别网络");
            [self thisSaveData:str_str];
        }
        else if (status == 0) {
            //NSLog(@"无网络");
            [self thisSaveData:str_str];
        }else{
            //test
            //[self thisSaveData:str_str];
            //return;
            
            
            [self WBupload:str_str];
            
        }
    }];
}


-(void)thisSaveData:(NSString *)str{
    //1
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array0 = [defaults objectForKey:@"Nfcweibao"] ;
    NSMutableArray *array = [array0 mutableCopy];
    [defaults removeObjectForKey:@"Nfcweibao"];
    [defaults synchronize];
    
    //2
    if(array==nil)
    {
        array=[NSMutableArray new];
    }
    NSDictionary *newdic=[[NSDictionary alloc]initWithObjectsAndKeys:[self getUniqueStrByUUID],@"guid",str,@"value", nil];
    
    [array addObject:newdic];
    NSArray *myArray = [array copy];
    
    //3
    [defaults setObject:myArray forKey:@"Nfcweibao"];
    [defaults synchronize];
    
    [CommonUseClass showAlter:@"离线缓存成功！"];
    [self cc];
}

- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    
    NSString    *uuidString = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString ;
    
}

-(void )WBupload:(NSString *)parm
{
    NSString *currUrl2=@"Check/SaveNFCCheckDetails";
    [HTTPSessionManager
     post:currUrl2
     parameters:parm
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         //         NSLog(@"success====%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         
         NSLog(@"dic_result：%@",dic_result);
         
         if([success integerValue]!=1)
         {
             [self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         }
         else
         {
             [self performSelectorOnMainThread:@selector(cc) withObject:data waitUntilDone:NO];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self performSelectorOnMainThread:@selector(aa) withObject:nil waitUntilDone:YES];
         
     }];
}


- (void)aa{
    [CommonUseClass showAlter:@"提交失败"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)cc{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    //返回到指定视图控制器
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[DTWBWebViewController_WZH class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    //[CommonUseClass showAlter:@"提交成功"];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_success" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

-(void)selectDataErr_up:(NSDictionary *)dict
{
    [CommonUseClass showAlter:@"提交失败！"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (NSString *)addPic:(NSString *)currNum forAll:(NSString *)strstr
{
    if (arr_Photos.count>0) {
        NSString *currImg=@"";
        for (NSDictionary *currDic in arr_Photos) {
            NSArray * keys = currDic.allKeys;
            for (int i = 0; i < keys.count; i++) {
                //逐个的获取键
                NSString * key = [keys objectAtIndex:i];
                
                if([key isEqualToString:currNum ])
                {
                    
                    currImg=[currDic objectForKey:currNum];
                    break;
                }
            }
            
        }
        
        if(![currImg isEqualToString:@""])
        {
            NSString *str_0=@"\"Photo\" :\"";
            str_0=[str_0 stringByAppendingString:currImg];
            str_0=[str_0 stringByAppendingString:@"\","];
            
            NSString *d = strstr;
            strstr = [d stringByReplacingOccurrencesOfString:@"\"Photo\" : null," withString:str_0];
        }
        
    }
    else{
        
    }
    
    return strstr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isComplete {
    
    [self getResult];
    return self.complete;
}

- (NSArray *)resultArray {
    
    [self getResult];
    return self.tempArray;
}

- (void)getResult {
    
    BOOL complete = true;
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in self.sourceArray) {
        
        if ([dict[@"type"] integerValue] == SZQuestionOpenQuestion) {
            NSString *str = dict[@"marked"];
            complete = (str.length > 0) && complete;
            [arrayM addObject:str.length ? dict[@"marked"] : [NSNull null]];
        }
        else {
            NSArray *array = dict[@"marked"];
            complete = ([array containsObject:@"YES"] || [array containsObject:@"yes"] || [array containsObject:@(1)] || [array containsObject:@"1"]) && complete;
            [arrayM addObject:dict[@"marked"]];
        }
    }
    self.complete = complete;
    self.tempArray = arrayM.copy;
}

- (void)setCanEdit:(BOOL)canEdit {
    
    _canEdit = canEdit;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary *dict = self.sourceArray[indexPath.row];
    SZQuestionCell_WZH *cell = [[SZQuestionCell_WZH alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"questionCellIdentifier" andDict:dict andQuestionNum:indexPath.row + 1 andWidth:self.view.frame.size.width andConfigure:self.configure forIsNfc:IsNFCOKArr];
    __weak typeof(self) weakSelf = self;
    
    cell.selectOptionBack = ^(NSInteger index, NSDictionary *dict) {
        [weakSelf.arrayM replaceObjectAtIndex:index withObject:dict];
        weakSelf.sourceArray = weakSelf.arrayM.copy;
    };
    
    cell.selecttextfieldBack = ^(NSInteger index, NSString *text) {
        
        if (!textArr) {
            textArr=[[NSMutableDictionary alloc]init];
        }
        NSString *str=[NSString stringWithFormat:@"%ld",index];
        
        [textArr setObject:text forKey:str];
        
    };
    
    cell.selectNFCBack = ^(NSInteger index, NSString *text) {
        [self setNfcArr:index forNfcOk:text];
    };
    
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.userInteractionEnabled = self.canEdit;
    cell.delegate = self;
    cell.typeStr=self.typeStr;
    
    
    if ([self.typeStr isEqualToString:@"1"]) {
        
        cell.textField1.text=[descArr objectAtIndex:indexPath.row];
    }
    else{
        NSString *newStr=@"";
        
        NSString *str=[NSString stringWithFormat:@"%d",indexPath.row];
        
        NSString *strText=[textArr objectForKey:str];
        if ([strText isKindOfClass:[NSNull class]]) {
            newStr=@"";
        }
        else if (!strText) {
            newStr=@"";
        }
        else{
            newStr=strText;
        }
        cell.textField1.text=newStr;
    }
    
    return cell;
}

-(void)setNfcArr:(long)index forNfcOk:(NSString *)text{
    if (!IsNFCOKArr) {
        IsNFCOKArr=[[NSMutableDictionary alloc]init];
    }
    NSString *str=[NSString stringWithFormat:@"%ld",index];
    
    [IsNFCOKArr setObject:text forKey:str];
}
/**
 *  返回各个Cell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat topDistance = 0;
    
    if (indexPath.row == 0) {
        topDistance = self.configure.topDistance;
    }
    
    
    NSDictionary *dict = self.sourceArray[indexPath.row];
    
    if ([dict[@"type"] intValue] == SZQuestionOpenQuestion) {
        
        CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"] width:self.titleWidth fontSize:self.configure.titleFont ? self.configure.titleFont : 17 oneLineHeight:self.configure.oneLineHeight];
        return title_height + (self.configure.oneLineHeight ? self.configure.oneLineHeight : 44) + topDistance;
    }
    else {
        
        CGFloat title_height = [SZQuestionItem heightForString:dict[@"title"] width:self.titleWidth fontSize:self.configure.titleFont ? self.configure.titleFont : 17 oneLineHeight:self.configure.oneLineHeight];
        CGFloat option_height = 0;
        for (NSString *str in dict[@"option"]) {
            option_height += [SZQuestionItem heightForString:str width:self.OptionWidth fontSize:self.configure.optionFont ? self.configure.optionFont : 16 oneLineHeight:self.configure.oneLineHeight];
        }
        return title_height + option_height + topDistance + 52;//40
    }
    
    // return  60;
}

/**
 *  计算高度
 */
//-(CGFloat)heightForString:(NSString*)string isTitle:(BOOL)isTitle
//{
//    CGRect rect = [string boundingRectWithSize:CGSizeMake(isTitle ? self.titleWidth : self.OptionWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:isTitle ? self.fontSize : self.fontSize - 1]} context:nil];
//
//    return rect.size.height > 44 ? rect.size.height : 44;
//}

#pragma mark - 懒加载

- (NSMutableArray *)arrayM {
    
    if (_arrayM == nil) {
        _arrayM = [[NSMutableArray alloc] initWithArray:self.sourceArray];
    }
    return _arrayM;
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (isLoad) {
        return;
    }
    
    NSLog(@"%f",userLocation.location.coordinate.latitude);
    NSLog(@"%f",userLocation.location.coordinate.longitude);
    
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    float y = _locService.userLocation.location.coordinate.latitude;//纬度
    float x = _locService.userLocation.location.coordinate.longitude;//经度
    //发起反向地理编码检索
    CLLocationCoordinate2D pt1 = (CLLocationCoordinate2D){y, x};
    BMKReverseGeoCodeOption *reverseSearch = [[BMKReverseGeoCodeOption alloc]init];
    reverseSearch.reverseGeoPoint = pt1;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseSearch];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
        isLoad=YES;
        
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        myBMKPointAnnotation* item = [[myBMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        item.nType=1;
        
        BMKAddressComponent *class=result.addressDetail;
        
        NSString *State =class.province;
        NSString *City = class.city;
        NSString *SubLocality = class.district;
        NSString *Thoroughfare= class.streetName;
        if(Thoroughfare==nil)Thoroughfare=@"";
        NSString *SubThoroughfare=class.streetNumber;
        if(SubThoroughfare==nil)SubThoroughfare=@"";
        
        //1
        NSString *DW=[State stringByAppendingString:City];
        DW=[DW stringByAppendingString:SubLocality];
        DW=[DW stringByAppendingString:Thoroughfare];
        DW=[DW stringByAppendingString:SubThoroughfare];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        //2
        NSString *DW1=@"";
        DW1=[State stringByAppendingString:@","];
        DW1=[DW1 stringByAppendingString:City];
        DW1=[DW1 stringByAppendingString:@","];
        DW1=[DW1 stringByAppendingString:SubLocality];
        DW1=[DW1 stringByAppendingString:@","];
        DW1=[DW1 stringByAppendingString:Thoroughfare];
        DW1=[DW1 stringByAppendingString:@","];
        DW1=[DW1 stringByAppendingString:SubThoroughfare];
        //        address=DW1;
        
        Longitude=_locService.userLocation.location.coordinate.longitude;//经度
        Latitude=_locService.userLocation.location.coordinate.latitude;//纬度
        //        _address.text=DW;
        /*
         if(dic.count>0)
         {
         if(YJBJCount!=0)return ;
         YJBJCount=1;
         NSString *State = [place.addressDictionary valueForKey:@"State"] ;
         NSString *City = [place.addressDictionary valueForKey:@"City"] ;
         NSString *SubLocality = [place.addressDictionary valueForKey:@"SubLocality"] ;
         NSString *Street = [place.addressDictionary valueForKey:@"Street"] ;
         
         DW=[State stringByAppendingString:City];
         DW=[DW stringByAppendingString:SubLocality];
         DW=[DW stringByAppendingString:Street];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         // [self AddYJBJ:DW forLongitude:newLocation.coordinate.longitude forLatitude:newLocation.coordinate.latitude];
         address=DW;
         Longitude=newLocation.coordinate.longitude;
         Latitude=newLocation.coordinate.latitude;
         _address.text=DW;
         super.is_Location=NO;
         [manager stopUpdatingLocation];
         }
         */
        
        [_locService stopUserLocationService];
        
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}
/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

@end
