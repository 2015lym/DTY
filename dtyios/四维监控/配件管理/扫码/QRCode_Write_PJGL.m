//
//  QRCode_Write_PJGL.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "QRCode_Write_PJGL.h"

@interface QRCode_Write_PJGL ()

@end

@implementation QRCode_Write_PJGL

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self .navigationItem.title=@"输入二维码";
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    tapGesture.delegate=self;
    [self.view addGestureRecognizer:tapGesture];
    
    UILabel *lab=[MyControl createLabelWithFrame:CGRectMake(0, 50, bounds_width.size.width-20, 40) Font:24 Text:@"请输入电梯编码或注册代码"];
    lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab];
    
    _liftId=[[UITextField alloc]init];
    _liftId.frame=CGRectMake(50, CGRectGetMaxY(lab.frame)+50, bounds_width.size.width-100, 40);
    //_liftId.layer.borderColor= [UIColor lightGrayColor].CGColor;
    //_liftId.layer.borderWidth=1.0f;
    _liftId.layer.masksToBounds = YES;
    _liftId.layer.cornerRadius = 4;
    _liftId.backgroundColor=[UIColor whiteColor];
    _liftId.placeholder=@"请输入电梯编码或注册代码";
    [self.view addSubview:_liftId];
    
    UILabel *lab_line=[[UILabel alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(_liftId.frame)+5, bounds_width.size.width-100, 1)];
    lab_line.backgroundColor=[UIColor blackColor];
    [self.view addSubview:lab_line];
    
    
    
    UIButton  * _btn_up =[[UIButton alloc]init];
    _btn_up.frame=CGRectMake(50, CGRectGetMaxY(lab_line.frame)+50, bounds_width.size.width-100, 40);
    _btn_up.layer.masksToBounds = YES;
    _btn_up.layer.cornerRadius = 4;
    [_btn_up setTitle:@"确    认" forState:UIControlStateNormal ];
    [_btn_up setBackgroundColor:[UIColor colorWithHexString:@"#3574fa"]];
    [_btn_up addTarget:self action:@selector(btnclick_ok:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_up];
    
    UIButton  * _btn_create =[[UIButton alloc]init];
    _btn_create.frame=CGRectMake(50, CGRectGetMaxY(_btn_up.frame)+50, bounds_width.size.width-100, 40);
    _btn_create.layer.masksToBounds = YES;
    _btn_create.layer.cornerRadius = 4;
    [_btn_create setTitle:@"创建电梯" forState:UIControlStateNormal ];
    [_btn_create setBackgroundColor:[UIColor colorWithHexString:@"#3574fa"]];
    [_btn_create addTarget:self action:@selector(btnclick_create:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_create];
    
    self.scrollView1.frame=CGRectMake(0,0,bounds_width.size.width, bounds_width.size.height);
    self.scrollView1.contentSize=CGSizeMake(bounds_width.size.width, 700);
}




-(void)Actiondo:(UITapGestureRecognizer *)gesture
{
    [_liftId resignFirstResponder];
    [_installationAddress resignFirstResponder];
    
}
- (IBAction)btnclick_ok:(id)sender {
    
    if ([_liftId.text isEqual:@""])
    {
        [self showAlter:@"电梯编号录入不完整！"];
        return;
    }
    
    
    
    
    [self gotoDetail];
}

-(IBAction)btnclick_create:(id)sender
{
    CreateLift *ctvc=[[CreateLift alloc] init];
    [self.navigationController pushViewController:ctvc animated:YES];
}

-(void)gotoDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:[CommonUseClass FormatString:_liftId.text] forKey:@"LiftNum"];
    //[dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    NSString *url=[NSString stringWithFormat:@"LiftParts/GetLift"];
    [XXNet PostURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[CommonUseClass FormatString: data[@"Success"]] isEqual:@"1"]) {
            
            NSString *str_json = data [@"Data"];
            NSDictionary *dic = [str_json objectFromJSONString];
            LiftNum=[CommonUseClass FormatString:dic [@"LiftNum"]];
            CertificateNum=[CommonUseClass FormatString:dic [@"CertificateNum"]];
            NSString *path=[CommonUseClass FormatString: dic [@"AddressPath"]];
            InstallationAddress=[CommonUseClass FormatString: dic [@"InstallationAddress"]];
            InstallationAddress = [path stringByAppendingString:InstallationAddress];
            LiftId=[CommonUseClass FormatString:dic [@"LiftId"]];
            
            _classLiftParts=[[classLiftParts alloc]init];
            _classLiftParts.LiftId=LiftId;
            _classLiftParts.LiftNum=LiftNum;
            _classLiftParts.CertificateNum=CertificateNum;
            _classLiftParts.AddressPath=path;
            _classLiftParts.InstallationAddress=InstallationAddress;
            _classLiftParts.list=dic [@"list"];
            _classLiftParts.listType=dic [@"listType"];
            
            [self gotoDetail_go];
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

- (void)gotoDetail_go{
    PJGLSaveViewController *ctvc=[[PJGLSaveViewController alloc] init];
    ctvc.LiftId=LiftId;
    ctvc.liftNum=LiftNum;
    ctvc.InstallationAddress=InstallationAddress;
    ctvc.CertificateNum=CertificateNum;
    ctvc.classLiftParts=_classLiftParts;
    [self.navigationController pushViewController:ctvc animated:YES];
}


-(void)showAlter:(NSString *)massage{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:massage
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
    
}
@end
