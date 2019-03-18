//
//  userInfoViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "userInfoViewController.h"
#import "EventCurriculumEntity.h"
#import "XXNet.h"
#import "RequestWhere.h"
#import "CurriculumEntity.h"
@interface userInfoViewController ()
{
    UILabel *lbl_LoginName;
    UILabel *lbl_UserName;
    UILabel *lbl_sfz;
    UILabel *lbl_Email;
    UILabel *lbl_Phone;
    UILabel *lbl_Mobile;
    
    UILabel *lbl_DeptName;
    UILabel *lbl_RoleName;
    UILabel *lbl_zw;
    
    UILabel *lbl_Remark;
}
@end

@implementation userInfoViewController

@synthesize app;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title=@"我的信息";
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    
    [self CreateUI];
    [self RequestNetData];
}
- (void)CreateUI {
    float currHeight=0;
    
    lbl_LoginName=[[UILabel alloc]init];
    lbl_UserName=[[UILabel alloc]init];
    lbl_sfz=[[UILabel alloc]init];
    lbl_Email=[[UILabel alloc]init];
    lbl_Phone=[[UILabel alloc]init];
    lbl_Mobile=[[UILabel alloc]init];
    
    lbl_DeptName=[[UILabel alloc]init];
    lbl_RoleName=[[UILabel alloc]init];
    lbl_zw=[[UILabel alloc]init];
    
    //1.
    UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(10, 10, bounds_width.size.width-20, 280)];
    view1.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view1];
    
    UIImageView *img11=[[UIImageView alloc]init];
    img11.frame=CGRectMake(0, 10, 100, 25);
    img11.image=[UIImage imageNamed:@"myinfo_label"];
    [view1 addSubview:img11];
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(10, 10, 100, 25);
    label.text=@"基本信息";
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor groupTableViewBackgroundColor];
    [view1 addSubview:label];
    
    currHeight=currHeight+40;
    [self addButton4:0 forTop:currHeight forWidth:view1.frame.size.width forHeight:40 forName:@"登陆名：" forName1:@"" forView:view1 forText:lbl_LoginName];
    currHeight=currHeight+40;
    [self addButton4:0 forTop:currHeight forWidth:view1.frame.size.width forHeight:40 forName:@"用户名：" forName1:@"" forView:view1 forText:lbl_UserName];
    currHeight=currHeight+40;
    [self addButton4:0 forTop:currHeight forWidth:view1.frame.size.width forHeight:40 forName:@"身份证：" forName1:@"" forView:view1 forText:lbl_sfz];
    currHeight=currHeight+40;
    [self addButton4:0 forTop:currHeight forWidth:view1.frame.size.width forHeight:40 forName:@"邮箱：" forName1:@"" forView:view1 forText:lbl_Email];
    currHeight=currHeight+40;
    [self addButton4:0 forTop:currHeight forWidth:view1.frame.size.width forHeight:40 forName:@"电话：" forName1:@"" forView:view1 forText:lbl_Phone];
    currHeight=currHeight+40;
    [self addButton4:0 forTop:currHeight forWidth:view1.frame.size.width forHeight:40 forName:@"手机：" forName1:@"" forView:view1 forText:lbl_Mobile];
    
    
    //2.
    UIView *view2=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view1.frame)+10, bounds_width.size.width-20, 160)];
    view2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view2];
    
    UIImageView *img22=[[UIImageView alloc]init];
    img22.frame=CGRectMake(0, 10, 100, 25);
    img22.image=[UIImage imageNamed:@"myinfo_label"];
    [view2 addSubview:img22];
    
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=CGRectMake(10, 10, 100, 25);
    label2.text=@"职位信息";
    label2.font=[UIFont systemFontOfSize:15];
    label2.textColor=[UIColor groupTableViewBackgroundColor];
    [view2 addSubview:label2];
    
    currHeight=40;
    [self addButton4:0 forTop:currHeight forWidth:view1.frame.size.width forHeight:40 forName:@"所属部门：" forName1:@"" forView:view2 forText:lbl_DeptName];
    currHeight=currHeight+40;
    [self addButton4:0 forTop:currHeight forWidth:view1.frame.size.width forHeight:40 forName:@"权限：" forName1:@"" forView:view2 forText:lbl_RoleName];
    currHeight=currHeight+40;
    [self addButton4:0 forTop:currHeight forWidth:view1.frame.size.width forHeight:40 forName:@"职位：" forName1:@"" forView:view2 forText:lbl_zw];
   
    
    //3.
    UIView *view3=[[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(view2.frame)+10, bounds_width.size.width-20, 80)];
    view3.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view3];
    
    UIImageView *img33=[[UIImageView alloc]init];
    img33.frame=CGRectMake(0, 10, 100, 25);
    img33.image=[UIImage imageNamed:@"myinfo_label"];
    [view3 addSubview:img33];
    
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=CGRectMake(10, 10, 100, 25);
    label3.text=@"负责区域";
    label3.font=[UIFont systemFontOfSize:15];
    label3.textColor=[UIColor groupTableViewBackgroundColor];
    [view3 addSubview:label3];
    
    lbl_Remark=[[UILabel alloc]init];
    lbl_Remark.frame=CGRectMake(10, 50, 100, 20);
    lbl_Remark.text=@"";
    lbl_Remark.font=[UIFont systemFontOfSize:15];
    lbl_Remark.textColor=[UIColor lightGrayColor];
    [view3 addSubview:lbl_Remark];
}

- (void)addButton4:(float)left forTop:(float)top forWidth:(float)width forHeight:(float)height forName:(NSString *)name  forName1:(NSString *)name1 forView:(UIView *)pView forText:(UILabel*)label1 {
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(left, top, width, height);
    [pView addSubview:view];
    
   
    
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(10, 10, 100, 20);
    label.text=name;
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor lightGrayColor];
    [view addSubview:label];
    
    //label1=[[UILabel alloc]init];
    label1.frame=CGRectMake(width-310, 10, 300, 20);
    label1.text=name1;
    label1.font=[UIFont systemFontOfSize:15];
    label1.textColor=[UIColor blackColor];// grayColor];
    label1.textAlignment = NSTextAlignmentRight;
    [view addSubview:label1];
    
    UILabel *label11=[[UILabel alloc]init];
    label11.frame=CGRectMake(10, 39, width-20, 1);
    label11.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:label11];
    
}
- (void)RequestNetData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:app.userInfo.UserID forKey:@"id"];
    [XXNet GetURL:GetUserInfoCheckURL header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"Success"]intValue]) {
            
            NSString *str_json = data[@"Data"];
            NSDictionary *arrData = [str_json objectFromJSONString];
            
            [self performSelectorOnMainThread:@selector(bandinfo:) withObject:arrData waitUntilDone:NO];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

-(void)bandinfo:(NSDictionary *)dic
{
    lbl_LoginName.text= [CommonUseClass FormatString: [dic objectForKey:@"LoginName"]];
    lbl_UserName.text= [CommonUseClass FormatString: [dic objectForKey:@"UserName"]];
    lbl_sfz.text= @"";
    lbl_Email.text= [CommonUseClass FormatString: [dic objectForKey:@"Email"]];
    lbl_Phone.text= [CommonUseClass FormatString: [dic objectForKey:@"Phone"]];
    lbl_Mobile.text= [CommonUseClass FormatString: [dic objectForKey:@"Mobile"]];
    
    NSDictionary *dic_Dept=[dic objectForKey:@"Dept"];
    lbl_DeptName.text= [CommonUseClass FormatString: [dic_Dept objectForKey:@"DeptName"]];
    lbl_RoleName.text= [CommonUseClass FormatString: [dic objectForKey:@"RoleName"]];
    lbl_zw.text=@"";
    
    lbl_Remark.text= [CommonUseClass FormatString: [dic objectForKey:@"Remark"]];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
