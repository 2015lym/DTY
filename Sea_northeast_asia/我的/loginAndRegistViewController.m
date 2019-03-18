//
//  loginAndRegistViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/14.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "loginAndRegistViewController.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
#import "AFAppDotNetAPIClient.h"
@interface loginAndRegistViewController ()
{
    NSString * str_password;
}
@end

@implementation loginAndRegistViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //_btnLogin.frame=CGRectMake(_btnLogin.frame.origin.x, _btnLogin.frame.origin.y, _viewInput.frame.size.width, _btnLogin.frame.size.height);
    _btnLogin.layer.masksToBounds = YES; //没这句话它圆不起来
    _btnLogin.layer.cornerRadius = 4; //设置图片圆角的尺度
    
    
    _viewInput.layer.masksToBounds = YES; //没这句话它圆不起来
    _viewInput.layer.cornerRadius = 4; //设置图片圆角的尺度
    _viewInput.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _viewInput.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _viewInput.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    _viewInput.layer.shadowRadius = 10;//阴影半径，默认3
    
    _viewInput.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    _viewInput.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _viewInput.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    _viewInput.layer.shadowRadius = 4;//阴影半径，默认3
    
   str_password=@"close";
    _viewInput.frame=CGRectMake( _viewInput.frame.origin.x,  _viewInput.frame.origin.y, _viewInput.frame.size.width, bounds_width.size.height-_viewInput.frame.origin.y-10);
    _sview_Content.frame=CGRectMake( _sview_Content.frame.origin.x,  _sview_Content.frame.origin.y, _sview_Content.frame.size.width, bounds_width.size.height);
}

- (IBAction)btnpassword:(id)sender {
    if([str_password isEqualToString:@"close"])
    {
        _img_password.image=[UIImage imageNamed:@"login_display"];
        _lblpassword.secureTextEntry=false;
        str_password=@"open";
    }
    else
    {
        _img_password.image=[UIImage imageNamed:@"login_hide"];
        _lblpassword.secureTextEntry=true;
        str_password=@"close";
    }
    
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_lblusername resignFirstResponder];
    [_lblpassword resignFirstResponder];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(rect_sview_Content.size.height==0||rect_sview_Content.size.width==0)
    {
        rect_sview_Content=_sview_Content.frame;
        rect_sview_Content.size.height=rect_sview_Content.size.height+64;
    }
    
    //增加监听，键盘出现
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，键盘消失
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _btnLogin.frame=CGRectMake(_btnLogin.frame.origin.x, _btnLogin.frame.origin.y, _btnLogin.frame.size.width, _btnLogin.frame.size.height);
    
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect rect=self.view.frame;
    _sview_Content.frame=CGRectMake(rect.origin.x,rect.origin.y,rect.size.width, rect.size.height-keyboardRect.size.height);
    [_sview_Content setContentSize:rect.size];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    //NSDictionary *userInfo = [notification userInfo];
    //NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //CGRect keyboardRectb  = [aValue CGRectValue];
    _sview_Content.frame=self.view.frame;
    [_sview_Content setContentSize:CGSizeMake(0, 0)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLoginClick:(id)sender {
    //1.check
    if(_lblusername.text.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"电梯云"
                                                      message:@"请输入用户名。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(_lblpassword.text.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"电梯云"
                                                      message:@"请输入密码。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    /*
    if(text02.text.length<6||text02.text.length>15)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"请输入6-15位数字或字母。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
     */
    
    
    [self getLogin];

}

#pragma mark 登录函数
-(void)getLogin
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    
    [dic_args setObject:_lblusername.text forKey:@"UserName"];
    [dic_args setObject:_lblpassword.text forKey:@"PassWord"];
    
    
    /*
    NSMutableDictionary *dic_state=[NSMutableDictionary dictionary];
    [dic_state setObject:@"UserName" forKey:_lblusername.text];
    [dic_state setObject:@"PassWord" forKey:_lblpassword.text];
    NSString *json_state=[dic_state JSONString];
    [dic_args setObject:json_state forKey:@"LoginInfo"];
    
     NSString *string = [@"LoginInfo/Login?UserName=" stringByAppendingString:_lblusername.text];
    string = [string stringByAppendingString:@"&PassWord="];
    string = [string stringByAppendingString:_lblpassword.text];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:_lblusername.text forHTTPHeaderField:@"LoginName"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:_lblpassword.text forHTTPHeaderField:@"Password"];
    */
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"LoginInfo/Login"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         NSString *sms_data=[dic_result objectForKey:@"Data"];
         NSDictionary* dic_data=[sms_data objectFromJSONString];
         BOOL b=[success boolValue];
         if(b!=YES)
         {
             [self showAlter:@"登录失败！"];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             return ;
         }
         else
         {
             long LoginErrorType=[[dic_data valueForKeyPath:@"LoginErrorType"] longValue];
             if(LoginErrorType==1)
             {
                 [self showAlter:@"登录名不存在！"];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 return ;

             }
             else if(LoginErrorType==2)
             {
                 [self showAlter:@"登录密码错误！"];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 return ;
             }
             else if(LoginErrorType==3)
             {
                 [self showAlter:@"此用户未激活！"];
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 return ;
             }
//             else if (LoginErrorType==4)//未知流程，安卓代码好像是成功
//             {
//             }
             else
             {
         
         //////////////////////UpdateLogin调用接口
        
                 NSString *UserID=[dic_data valueForKeyPath:@"UserID"];
                 NSDictionary *User=[dic_data valueForKeyPath:@"User"];
                 NSDictionary *Dept=[User valueForKeyPath:@"Dept"];
                 NSString *deptID = [NSString stringWithFormat:@"%@",[Dept objectForKey:@"ID"]];
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:deptID forKey:@"deptID"];
                 [defaults synchronize];
                 NSDictionary *RoleGroup=[Dept valueForKeyPath:@"RoleGroup"];
                 NSString *DeptRoleCode=[RoleGroup valueForKeyPath:@"RoleCode"];
                 NSString *role_id = [NSString stringWithFormat:@"%@",[User objectForKey:@"RoleId"]];
                 NSString *nikename = [NSString stringWithFormat:@"%@",[User objectForKey:@"UserName"]];
                 app.userInfo  =[[UserInfoEntity alloc]init];
                 [app.userInfo setUserInfo:_lblusername.text forpwd:_lblpassword.text forUserID:UserID forDeptRoleCode:DeptRoleCode forRoleId:role_id forNikename:nikename];
         
                 //写缓存
                 NSString   *str_CachePath_Login = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"Login"];
                 if ([[ NSFileManager defaultManager ] fileExistsAtPath :str_CachePath_Login]) {
                     
                     [[ NSFileManager defaultManager ] removeItemAtPath :str_CachePath_Login error :nil];
                 }
                 NSMutableArray *userinfo=[[NSMutableArray alloc]init];
                 [userinfo addObject:app.userInfo.username];
                 [userinfo addObject:UserID];
                 [userinfo addObject:DeptRoleCode];
                 [userinfo addObject:role_id];
                 [userinfo addObject:nikename];
                 [userinfo writeToFile:str_CachePath_Login atomically:YES];
                 
                 NSString *userid=[NSString stringWithFormat:@"%@" ,app.userInfo.UserID];
                 [UMessage setAlias:userid type:@"ELEVATOR" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                     NSLog(@"---responseObject---%@", responseObject);
                     NSLog(@"---error----%@", error);
                 }];
                 
                 //video_login
                 videoMainViewController *videoMain=[[videoMainViewController alloc]init];
                 [videoMain videologin:app.userInfo.username];
                 NSString *WYID =app.userInfo.username;
                 [defaults setObject:WYID forKey:@"WYID"];
            
                 
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [app loginSucceed];
             [[self class] cancelPreviousPerformRequestsWithTarget:self];

             }
                 
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:MessageResult_login];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
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
