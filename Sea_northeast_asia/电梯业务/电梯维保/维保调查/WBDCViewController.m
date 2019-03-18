//
//  WBDCViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/12.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "WBDCViewController.h"
#import "MyControl.h"
@interface WBDCViewController ()
{
    UIView*headview;
    UILabel *dtBianHao_2;
    UILabel *dtWeiZhi_2;
    UILabel *dtWeiBao_2;
}
@end

@implementation WBDCViewController
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
    
}
- (void)btnClick_stop:(UIButton *)btn
{
    //[self.navigationController popViewControllerAnimated:YES];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[DTWBWebViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
        }
    }
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

    UILabel * lab_head1=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width, 20) Font:18 Text:@"电梯维保"];
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
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 146, bounds_width.size.width, 69)];
    [headview addSubview:view_head3];
    
    
    
    UIImageView *img_head21=[MyControl createImageViewWithFrame:CGRectMake(10, 10, 20, 20) imageName:@"wb_maintenance"];
    [view_head3 addSubview:img_head21];
    
    UILabel *dtWeiBao = [MyControl createLabelWithFrame:CGRectMake(40, 10, 80, 20) Font:14.0 Text:@"上次维保:"];
    //dtWeiBao.textColor = [UIColor blackColor];
    [view_head3 addSubview:dtWeiBao];
    
    
    dtWeiBao_2 = [MyControl createLabelWithFrame:CGRectMake(110, 10, SCREEN_WIDTH-90, 20) Font:14.0 Text:@""];
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
    [view_head3 addSubview:dtWeiZhi_2];
    
    
    UILabel *dtLine = [MyControl createLabelWithFrame:CGRectMake(0, 215, bounds_width.size.width, 5) Font:14 Text:@""];
    dtLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headview addSubview:dtLine];
    
    
    UIImageView *img_2=[MyControl createImageViewWithFrame:CGRectMake(10, 230, 20, 20) imageName:@"date_blue"];
    [headview addSubview:img_2];
    
    UILabel *tag = [MyControl createLabelWithFrame:CGRectMake(40, 230, 120, 20) Font:18 Text:@"请选择维保期限:"];
    //dtWeiZhi.textColor = [UIColor blackColor];
    [headview addSubview:tag];
    
    float width=(bounds_width.size.width-120)/2;
    float height=67;
    
    [self addButton4:40 forTop:290 forWidth:width forHeight:height forName:@"电梯维保"  forName1:@"Elevator maintenance" forTag:0 forIcon:@"wbdc1_half"];
    [self addButton4:80+width forTop:290 forWidth:width forHeight:height forName:@"电梯维保"  forName1:@"Elevator maintenance" forTag:2 forIcon:@"wbdc2_quarter"];
    [self addButton4:40 forTop:397 forWidth:width forHeight:height forName:@"电梯维保"  forName1:@"Elevator maintenance" forTag:3 forIcon:@"wbdc3_halfyear "];
    [self addButton4:80+width forTop:397 forWidth:width forHeight:height forName:@"电梯维保"  forName1:@"Elevator maintenance" forTag:4 forIcon:@"wbdc4_year"];

}

- (void)addButton4:(float)left forTop:(float)top forWidth:(float)width forHeight:(float)height forName:(NSString *)name  forName1:(NSString *)name1 forTag:(int)tag forIcon:(NSString*)imageName {
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(left, top, width, height);
    [self .view addSubview:view];
    
    UIButton *image=[[UIButton alloc]init];
    image.frame=CGRectMake((width-150)/2, 0, width, height);
    //    image.backgroundColor=[UIColor cyanColor];
    image.layer.masksToBounds = YES; //没这句话它圆不起来
    image.layer.cornerRadius = 20; //设置图片圆角的尺度
    [image setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [view addSubview:image];
    
    
    
    UIButton *button=[[UIButton alloc]init];
    button.frame=CGRectMake(0, 0, width, height);
    [button addTarget:self action:@selector(button_Event:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=tag;
    [view  addSubview:button];
}

- (IBAction)button_Event:(id)sender {
    UIButton *btn=(UIButton *)sender;
    [self goWB:btn.tag];
}
-(void)goWB:(int)tag{
    SZConfigure *configure = [[SZConfigure alloc] init];
    configure.checkedImage = @"dx_h@2x";
    configure.unCheckedImage = @"dx@2x";
    configure.optionTextColor = [UIColor lightGrayColor];
    self.questionBox = [[SZQuestionCheckBox alloc] initWithItem:self.item andConfigure:configure];
    self.questionBox.typeStr=@"0";
    self.questionBox.liftNum = _liftNum;
    self.questionBox.floorNumber=tag;
    self.questionBox.UploadDate=UploadDate;
    self.questionBox.InstallationAddress=InstallationAddress;
    self.questionBox.liftID=liftID;
    NSString * title=@"";
    if(tag==0)
    {title=@"半月保";}
    else if(tag==2)
    {title=@"季度保";}
    else if(tag==3)
    {title=@"半年保";}
    else if(tag==4)
    {title=@"年度保";}
    self.questionBox.Title=title;
    self.questionBox.CType=[NSString stringWithFormat:@"%d", tag];
    [self.navigationController pushViewController:self.questionBox animated:YES];
}
-(void)getSchoolCourse
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",_liftNum] forHTTPHeaderField:@"LiftNum"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forHTTPHeaderField:@"UserId"];
    
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:@"Check/GetLiftCheckByLiftNum"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         //                      NSLog(@"%@",[[dic_result objectForKey:@"Data"] objectFromJSONString]);
         
         NSDictionary *dict = [[dic_result objectForKey:@"Data"] objectFromJSONString];
         //NSString *floorNumber = [dict objectForKey:@"FloorNumber"];
         NSMutableArray *dict_ListCheck = [dict objectForKey:@"ListCheck"];
        
         if(dict_ListCheck.count>0)
         {
             NSDictionary *currdic=[dict_ListCheck objectAtIndex:0];
             NSString *currstr=[CommonUseClass FormatString:currdic];
             if([currstr isEqual:@""])
             {UploadDate=@"尚未巡检";}
             else
             {
             UploadDate = [currdic objectForKey:@"UploadDate"];
             }
         }
         else
         {
             UploadDate=@"尚未巡检";
         }
         
         InstallationAddress=[dict objectForKey:@"InstallationAddress"];
          NSString * LiftNum_show =[_liftNum stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         dtBianHao_2.text=LiftNum_show;
         dtWeiZhi_2.text=InstallationAddress;
         dtWeiBao_2.text=UploadDate;
         liftID=[dict objectForKey:@"ID"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         [self performSelectorOnMainThread:@selector(dd) withObject:nil waitUntilDone:YES];
         
     }];
    

}
- (void)dd{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[DTWBWebViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            }
    }
    
    
    [CommonUseClass showAlter:@"电梯不存在"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
