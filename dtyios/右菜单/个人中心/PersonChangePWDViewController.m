//
//  PersonChangePWDViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/7/26.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "PersonChangePWDViewController.h"
#import "JSONKit.h"

#import "LoginViewController.h"
@interface PersonChangePWDViewController ()

@end

@implementation PersonChangePWDViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    isBtnOnCilck=YES;
    // Do any additional setup after loading the view.
    
    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
    left_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    [left_BarButoon_Item setImage:[UIImage imageNamed:@"navback.png"] forState:UIControlStateNormal];
    [left_BarButoon_Item addTarget:self action:@selector(navLeftBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
    self.navigationItem.leftBarButtonItem=leftItem;
    self.navigationItem.title=@"修改密码";
    UIButton *right_BarButoon_Item=[[UIButton alloc] init];
    [right_BarButoon_Item.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    right_BarButoon_Item.frame=CGRectMake(0, 0,100,22);
    right_BarButoon_Item.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [right_BarButoon_Item setTitle:@"保存" forState:UIControlStateNormal];
    [right_BarButoon_Item addTarget:self action:@selector(navRightBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_BarButoon_Item];
    self.navigationItem.rightBarButtonItem=rightItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navLeftBtn_Event:(id)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)navRightBtn_Event:(id)sender{
    //1.check
    if(pwdOld.text.length==0)
    {
        [self showAlter:@"请输入旧密码。"];
        return;
    }
    if(pwdOld.text.length<6||pwdOld.text.length>15)
    {
        [self showAlter:@"旧密码请输入6-15位数字或字母。"];
        return;
    }
    if(pwdNew.text.length==0)
    {
        [self showAlter:@"请输入新密码。"];
        return;
    }
    if(pwdNew.text.length<6||pwdNew.text.length>15)
    {
        [self showAlter:@"新密码请输入6-15位数字或字母。"];
        return;
    }
    
    if(![self isPassword:pwdNew.text])
    {
  
        [self showAlter:@"密码格式不正确（6-15位数字或字母）。"];
        return;
    }
    if(pwdReNew.text.length==0)
    {
        [self showAlter:@"请输入确认密码。"];
        return;
    }
    if(pwdReNew.text.length<6||pwdReNew.text.length>15)
    {
        [self showAlter:@"确认密码请输入6-15位数字或字母。"];
        return;
    }
    if(![pwdReNew.text isEqualToString:pwdNew.text])
    {
        [self showAlter:@"新密码与确认密码不相同。"];
        return;
    }
    

    
    

    [self changePwd];
}

- (BOOL)isPassword:(NSString *)str

{
    bool isNumber=false;
    BOOL isZM=false;
    for(int i =0;i<str.length;i++)
    {
        if ([str characterAtIndex:i] >= 'a' && [str characterAtIndex:i] <= 'z') {
            
            isZM= YES;
        }
        
        if ([str characterAtIndex:i] >= 'A' && [str characterAtIndex:i] <= 'Z') {
            
            isZM= YES;
        }
        
        if ([str characterAtIndex:i] >= '0' && [str characterAtIndex:i] <= '9') {
            
            isNumber= YES;
        }
        
    }
    return isZM&&isNumber;
    
}


-(void)showAlter:(NSString *)message
{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark 修改密码
-(void)changePwd
{
    if (!isBtnOnCilck) {
        return;
    }
    isBtnOnCilck=NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    NSString *token=app.str_token;
    [dic_args setObject:token forKey:@"access_token"];
    [dic_args setObject:@"code" forKey:@"response_type"];
    [dic_args setObject:@"userPassword" forKey:@"redirect_uri"];
    
    /*
    NSString *tring1=@"{\"isToken\":true,\"param\":{\"old\":\"";
    NSString *tring2=@"\",\"password\":\"";
    NSString *tring3=@"\"}}";
    NSString *nike=[tring1 stringByAppendingString:pwdOld.text];
    nike=[nike stringByAppendingString:tring2];
    nike=[nike stringByAppendingString:pwdNew.text];
    nike=[nike stringByAppendingString:tring3];
    [dic_args setObject:nike forKey:@"state"];
    */
    
    NSMutableDictionary *dic_state=[NSMutableDictionary dictionary];
    [dic_state setObject:@"true" forKey:@"isToken"];
    
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    [dic_param setObject:pwdOld.text forKey:@"old"];
    [dic_param setObject:pwdNew.text forKey:@"password"];
    [dic_state setObject:dic_param forKey:@"param"];
    
    NSString *json_state=[dic_state JSONString];
    [dic_args setObject:json_state forKey:@"state"];
    
    
    
    
    [[AFAppDotNetAPIClient sharedClient_token]
     POST:@"apiDataByAccessToken.php"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *message=[NSString stringWithFormat:@"%@",[dic_result objectForKey:@"message"]];
         
         if(message==nil||![message isEqualToString:@"密码修改成功！"])
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             isBtnOnCilck=true;
             NSString *currError=[dic_result objectForKey:@"error"];
             if([currError isEqualToString:@"invalid_token"])
             {
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                               message:@"登录信息已过期，请重新登录！"
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
                 [alert show];
                 [self loginMethod];
             }
             else
             {

             UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:message
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
             [alert show];
             }
             return ;
         }
         
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"修改密码成功！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
         
         app.userInfo.pwd=pwdNew.text;
         [self.navigationController popToRootViewControllerAnimated:YES];
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         isBtnOnCilck=YES;
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"登录失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
          [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         isBtnOnCilck=YES;
     }];
    
}

#pragma mark 弹出登录页面
-(void)loginMethod{
    
    //LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:[Util GetResolution:@"LoginViewController" ] bundle:nil];
    LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav_loginVC=[[ UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav_loginVC animated:YES completion:^{
        
    }];
}
@end
