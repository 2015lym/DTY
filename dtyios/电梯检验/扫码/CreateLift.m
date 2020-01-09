//
//  CreateLift.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/27.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "CreateLift.h"

@interface CreateLift ()

@end

@implementation CreateLift

@synthesize app;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self .navigationItem.title=@"创建电梯 ";
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    tapGesture.delegate=self;
    [self.view addGestureRecognizer:tapGesture];
    
    //1
    UILabel *lab=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width-20, 40) Font:24 Text:@"注册代码"];
    lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab];
    
    _liftId=[[UITextField alloc]init];
    _liftId.frame=CGRectMake(20, CGRectGetMaxY(lab.frame)+30, bounds_width.size.width-40, 40);
    _liftId.layer.masksToBounds = YES;
    _liftId.layer.cornerRadius = 4;
    _liftId.backgroundColor=[UIColor whiteColor];
    _liftId.placeholder=@"请输入注册代码";
    [self.view addSubview:_liftId];
    
    UILabel *lab_line=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_liftId.frame)+5, bounds_width.size.width-40, 1)];
    lab_line.backgroundColor=[UIColor blackColor];
    [self.view addSubview:lab_line];
    
    //2
    UILabel *lab1=[MyControl createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(_liftId.frame)+30, bounds_width.size.width-20, 40) Font:24 Text:@"电梯地址"];
    lab1.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab1];
    
    _installationAddress=[[UITextField alloc]init];
    _installationAddress.frame=CGRectMake(20, CGRectGetMaxY(lab1.frame)+30, bounds_width.size.width-40, 40);
    _installationAddress.layer.masksToBounds = YES;
    _installationAddress.layer.cornerRadius = 4;
    _installationAddress.backgroundColor=[UIColor whiteColor];
    _installationAddress.placeholder=@"请输入电梯地址";
    [self.view addSubview:_installationAddress];
    
    UILabel *lab_line1=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_installationAddress.frame)+5, bounds_width.size.width-40, 1)];
    lab_line1.backgroundColor=[UIColor blackColor];
    [self.view addSubview:lab_line1];
    
    
    
    UIButton  * _btn_up =[[UIButton alloc]init];
    _btn_up.frame=CGRectMake(20, CGRectGetMaxY(_installationAddress.frame)+30, bounds_width.size.width-40, 40);
    _btn_up.layer.masksToBounds = YES;
    _btn_up.layer.cornerRadius = 4;
    [_btn_up setTitle:@"确    认" forState:UIControlStateNormal ];
    [_btn_up setBackgroundColor:[UIColor colorWithHexString:@"#3574fa"]];
     [_btn_up addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn_up];
    

    
    self.scrollView1.frame=CGRectMake(0,0,bounds_width.size.width, bounds_width.size.height);
    self.scrollView1.contentSize=CGSizeMake(bounds_width.size.width, 700);
}

-(void)Actiondo:(UITapGestureRecognizer *)gesture
{
    [_liftId resignFirstResponder];
    [_installationAddress resignFirstResponder];
    
}
- (IBAction)submitClick:(id)sender {
    
    if ([_liftId.text isEqual:@""])
    {
        [self showAlter:@"注册代码录入不完整！"];
        return;
    }
    
    NSString *str=[CommonUseClass FormatString: _installationAddress.text];
    if ([str isEqual:@""])
    {
        
        [self showAlter:@"电梯地址录入不完整！"];
        return;
        
    }
    
    [self AddOrder];
}

- (void)AddOrder
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    
    [dicHeader setValue:_liftId.text forKey:@"CertificateNum"];
    [dicHeader setValue:_installationAddress.text forKey:@"InstallationAddress"];
    [XXNet PostURL:AddLift header:nil  parameters:dicHeader succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[CommonUseClass FormatString: data[@"Success"]] isEqual:@"1"]) {
            [CommonUseClass showAlter:@"操作成功"];
            
             [self .navigationController popViewControllerAnimated:YES];
            
        }
        else
        {
             [CommonUseClass showAlter:[CommonUseClass FormatString: data[@"Message"]]];
        }
        
    } failure:^(NSError *error) {
        
        [self performSelectorOnMainThread:@selector(dd) withObject:nil waitUntilDone:YES];
        
    }];
    
}


- (void)dd{
    
    [CommonUseClass showAlter:@"操作失败"];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

