//
//  RegisterViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/13.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "RegisterViewController.h"
#import "JSONKit.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize app;
static int count = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    app.str_RegUserName=@"";
    app.str_RegUserPW=@"";
    
    // Do any additional setup after loading the view from its nib.
    is_queding=NO;
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    [text01 setBorderStyle:UITextBorderStyleNone];
    [text02 setBorderStyle:UITextBorderStyleNone];
    [text03 setBorderStyle:UITextBorderStyleNone];
    text01.leftView = leftview;
    text01.leftViewMode = UITextFieldViewModeAlways;
    leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    text02.leftView = leftview ;
    text02.leftViewMode = UITextFieldViewModeAlways;
    leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    text03.leftView = leftview ;
    text03.leftViewMode = UITextFieldViewModeAlways;
    
    UIImage *textBackgroundImage = [UIImage imageNamed:@"text01.png"];
    UIImage *textstretchedBackground = [textBackgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [text01 setBackground:textstretchedBackground ];
    [text02 setBackground:textstretchedBackground ];
    [text03 setBackground:textstretchedBackground ];
    
    
    
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"button02.png"];
    UIImage *buttonstretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:8 topCapHeight:4];
    [btn01 setBackgroundImage:buttonstretchedBackground forState:UIControlStateNormal];
    
    buttonBackgroundImage = [UIImage imageNamed:@"button01.png"];
    buttonstretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [btn02 setBackgroundImage:buttonstretchedBackground forState:UIControlStateNormal];

    self.navigationItem.title=@"注册";}
#pragma mark 注册
-(IBAction)btn_OnClick:(id)sender
{
    //app.str_RegUserName=@"1";
    //app.str_RegUserPW=@"2";
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //return;
    /*
     if (!is_queding) {
     UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
     message:@"请获取验证码。"
     delegate:nil
     cancelButtonTitle:@"确定"
     otherButtonTitles:nil, nil];
     [alert show];
     return;
     }
     */
    
    [self submit];
}

-(void)submit
{
    //1.check
    if(text01.text.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"请输入手机号。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(![self checkPhone])
    {
        return;
    }
    
    if(text02.text.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"请输入验证码。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(text02.text.length!=6)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"验证码格式不正确，应为6位数字"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    
    
    if(text03.text.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"请输入密码。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(text03.text.length<6||text03.text.length>15)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"请输入6-15位数字或字母。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(![self isPassword:text03.text])
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"密码格式不正确（6-15位数字或字母）。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    
    //2.
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:text01.text forKey:@"username"];
    [dic_args setObject:text03.text forKey:@"password"];
    [dic_args setObject:text02.text forKey:@"verCode"];
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/User/register"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSMutableDictionary *dic_result=[str_result objectFromJSONString];
         
         NSString *str_message=[dic_result valueForKeyPath:@"message"];
         NSDictionary *attributes = [dic_result valueForKeyPath:@"sms_data"];
         NSString *str_status=[dic_result valueForKeyPath:@"status"];
         NSLog(@"%@",str_status);
         if([str_status isEqualToString:@"OK"])
         {
             app.str_RegUserName=text01.text;
             app.str_RegUserPW=text03.text;
             
             UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"注册成功！"
                                                          delegate:self
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
             [alert show];
         }
         else
         {
             UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:str_message
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
             [alert show];
             return ;
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",error);
     }];
    
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
//点击确定后关闭当前窗口。
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 获取验证码
-(IBAction)btn_OnClick_get:(id)sender
{
    
    if(text01.text.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"请输入手机号。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
if([self checkPhone])
{
     [self getCode];
}
}

//验证手机号是否正确
-(BOOL)checkPhone
{
    int compareResult = 0;
    for (int i=0; i<areaArray.count; i++)
    {
        NSDictionary* dict1=[areaArray objectAtIndex:i];
        NSString* code1=[dict1 valueForKey:@"zone"];
        NSString *str=@"86";
        if ([code1 isEqualToString:str])
        {
            compareResult=1;
            NSString* rule1=[dict1 valueForKey:@"rule"];
            NSPredicate* pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule1];
            BOOL isMatch=[pred evaluateWithObject:text01.text];
            if (!isMatch)
            {
                //手机号码不正确
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                              message:@"手机号格式不正确"
                                                             delegate:nil
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
                [alert show];
                //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                return false;
            }
            break;
        }
    }
    
    if (!compareResult)
    {
        if (text01.text.length!=11)
        {
            //手机号码不正确
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:@"手机号格式不正确"
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
            [alert show];
           
            return false;
        }
    }
    return true;
}

//得到验证码
-(void)getCode
{
    //1.timer
    NSTimer* timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(updateTime)
                                                  userInfo:nil
                                                   repeats:YES];
    timer2=timer;
    count=0;
    
    //2.得到验证码
    is_queding=NO;
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:text01.text forKey:@"mobile"];
    [dic_args setObject:@"register" forKey:@"flag"];
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"index.php/User/getCode"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSMutableDictionary *dic_result=[str_result objectFromJSONString];
         NSString *str_message=[dic_result objectForKey:@"message"];
         NSDictionary *attributes = [dic_result objectForKey:@"sms_data"];
         NSString *str_status=[dic_result valueForKeyPath:@"status"];
         NSLog(@"%@",str_status);
         if([str_status isEqualToString:@"OK"])
         {}
         else
         {
             UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:str_message
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
             [alert show];
             [self reCode];
             return ;
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",error);
     }];
    
}

-(void)updateTime
{
    btn01.enabled=NO;
    count++;
    if (count>=60)
    {
        [self reCode];
        
        return;
    }
    //NSLog(@"更新时间");
    btn01.titleLabel.text=[NSString stringWithFormat:@"%i秒重发",60-count];
}

-(void)reCode
{
    [timer2 invalidate];
    btn01.titleLabel.text=@"重新发送";
    //is_Verification=NO;
    btn01.enabled=YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
