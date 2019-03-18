//
//  LoginViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/13.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "LoginViewController.h"
#import "Util.h"
#import "RegisterViewController.h"
#import "ResetPasswordViewController.h"
#import "JSONKit.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize app;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //3,初始化TencentOAuth 对象 appid来自应用宝创建的应用， deletegate设置为self  一定记得实现代理方法
    
    //这里的appid填写应用宝得到的id  记得修改 “TARGETS”一栏，在“info”标签栏的“URL type”添加 的“URL scheme”，新的scheme。有问题家QQ群414319235提问
    tencentOAuth=[[TencentOAuth alloc]initWithAppId:QQ_AppID andDelegate:self];
    
    //4，设置需要的权限列表，此处尽量使用什么取什么。
    permissions= [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t",  nil];
    
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view from its nib.
    
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    [text01 setBorderStyle:UITextBorderStyleNone];
    [text02 setBorderStyle:UITextBorderStyleNone];
    text01.leftView = leftview;
    text01.leftViewMode = UITextFieldViewModeAlways;
    leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    text02.leftView = leftview ;
    text02.leftViewMode = UITextFieldViewModeAlways;
    
    UIImage *textBackgroundImage = [UIImage imageNamed:@"text01.png"];
    UIImage *textstretchedBackground = [textBackgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [text01 setBackground:textstretchedBackground ];
    [text02 setBackground:textstretchedBackground ];
    
    

    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"button01.png"];
    UIImage *buttonstretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [btn01 setBackgroundImage:buttonstretchedBackground forState:UIControlStateNormal];
    
    
    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
    left_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    [left_BarButoon_Item setImage:[UIImage imageNamed:@"navback.png"] forState:UIControlStateNormal];
    [left_BarButoon_Item addTarget:self action:@selector(navLeftBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
    self.navigationItem.leftBarButtonItem=leftItem;
    self.navigationItem.title=@"登陆";
    UIButton *right_BarButoon_Item=[[UIButton alloc] init];
    [right_BarButoon_Item.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    right_BarButoon_Item.frame=CGRectMake(0, 0,100,22);
    right_BarButoon_Item.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [right_BarButoon_Item setTitle:@"注册" forState:UIControlStateNormal];
    [right_BarButoon_Item addTarget:self action:@selector(navRightBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_BarButoon_Item];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"忘记密码" attributes:attribtDic];
    //btn02.attributedText = attribtStr;
    
    
    lab01.userInteractionEnabled=YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    
   [lab01 addGestureRecognizer:labelTapGestureRecognizer];
    //lab01 .frame=CGRectMake(0, lab01 .frame.origin.y, bounds_width.size.width, lab01 .frame.size.height);
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    ResetPasswordViewController *registerVC=[[ResetPasswordViewController alloc] initWithNibName:[Util GetResolution:@"ResetPasswordViewController"] bundle:nil];
  
    [self.navigationController pushViewController:registerVC animated:YES];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if(app.str_RegUserName!=nil &&![app.str_RegUserName isEqualToString:@""])
    {
        text01.text= app.str_RegUserName;
        text02.text=app.str_RegUserPW;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)navLeftBtn_Event:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)navRightBtn_Event:(id)sender{
    

    
    RegisterViewController *registerVC=[[RegisterViewController alloc] initWithNibName:[Util GetResolution:@"RegisterViewController"] bundle:nil];
    //RegisterViewController *registerVC=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}


#pragma mark 第三方登录
- (IBAction)LoginQQ:(id)sender {
    NSLog(@"loginAct");
    [tencentOAuth authorize:permissions inSafari:NO];
}

//登陆完成调用
- (void)tencentDidLogin
{
    //resultLable.text =@"登录完成";
    
    if (tencentOAuth.accessToken )
    {
        //  记录登录用户的OpenID、Token以及过期时间
        //tokenLable.text =tencentOAuth.accessToken;
        [tencentOAuth getUserInfo];
    }
    else
    {
        //tokenLable.text =@"登录不成功没有获取accesstoken";
    }
}
//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    NSLog(@"tencentDidNotLogin");
    if (cancelled)
    {
        //resultLable.text = @"用户取消登录";
    }else{
        //resultLable.text = @"登录失败";
    }
}
// 网络错误导致登录失败：
-(void)tencentDidNotNetWork
{
    NSLog(@"tencentDidNotNetWork");
    //resultLable.text = @"无网络连接，请设置网络";
}



-(void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"respons:%@",response.jsonResponse);
    NSDictionary *dic=response.jsonResponse;
    NSString *nikeName=[dic valueForKeyPath:@"nickname"];
    text01.text=nikeName;
}


- (IBAction)LoginWeixin:(id)sender {
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc]init];
        req.scope = @"snsapi_userinfo";
        req.openID = WX_AppID;
        req.state = @"1245";
        app.wxDelegate = self;
        
        [WXApi sendReq:req];
    }else{
        //把微信登录的按钮隐藏掉。
    }
}

#pragma mark 获取TOKEN
-(void)getTOKEN
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    //[dic_args setObject:@"15164241770" forKey:@"username"];
    //[dic_args setObject:@"eb668dd0f4a3b4b760107568151f0084" forKey:@"password"];
    [dic_args setObject:text01.text forKey:@"username"];
    NSString *passMd5=[self md5:text02.text];
    [dic_args setObject:passMd5 forKey:@"password"];
    [dic_args setObject:@"password" forKey:@"grant_type"];
    
    [[AFAppDotNetAPIClient sharedClient_token]
     POST:@"token.php"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *access_token=[dic_result valueForKeyPath:@"access_token"];
         app.str_token=access_token;
         
         if(app.str_token==nil||[app.str_token isEqualToString:@""])
         {
             UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"登录失败！（请确认帐号名密码是否正确）"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
             [alert show];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             return;
         }
         [self getLogin];
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         UIAlertView* alert1=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"登录失败！（获取TOKEN失败）"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert1 show];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

// -获取文件的MD5值
-(NSString*) md5:(NSString*) str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}
#pragma mark 登录函数
-(void)getLogin
{
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    NSString *token=app.str_token;
    [dic_args setObject:token forKey:@"access_token"];
    [dic_args setObject:@"code" forKey:@"response_type"];
    [dic_args setObject:@"Login" forKey:@"redirect_uri"];
    //[dic_args setObject:@"{\"isToken\":true,\"param\":{}}" forKey:@"state"];
    
    
    NSMutableDictionary *dic_state=[NSMutableDictionary dictionary];
    [dic_state setObject:@"true" forKey:@"isToken"];
    
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    [dic_param setObject:app.myChannel_id forKey:@"channelId"];
    [dic_param setObject:@"IOS" forKey:@"equipmentType"];
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
         NSString *message=[dic_result objectForKey:@"message"];
         NSString *sms_data=[dic_result objectForKey:@"result"];
         if(message==nil||![message isEqualToString:@"登录成功！！"])
         {
             UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:@"登录失败！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
             [alert show];
             app.str_token=nil;
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             return ;
         }
         
         sms_data=[sms_data valueForKeyPath:@"userInfo"];
         NSString *nikeName=[sms_data valueForKeyPath:@"nikeName"];
         NSString *headerImage=[sms_data valueForKeyPath:@"headerImage"];
         [app.userInfo setUserInfo:text01.text forNikename:nikeName forpwd:text02.text forhead:headerImage];
         NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
         [dic_oAuth setObject:app.str_token forKey:@"str_token"];
         [dic_oAuth setObject:text01.text forKey:@"username"];
         [dic_oAuth setObject:nikeName forKey:@"nikename"];
         [dic_oAuth setObject:text02.text forKey:@"pwd"];
         [dic_oAuth setObject:headerImage forKey:@"uhead"];

         //HomeViewController *homeview=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
         //_onePerson=homeview;
         //[ _onePerson HomeShowPerson];
         
         [self dismissViewControllerAnimated:YES completion:^{
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"登录失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

#pragma mark 微信登录回调。
-(void)loginSuccessByCode:(NSString *)code{
    NSLog(@"code %@",code);
    __weak typeof(*&self) weakSelf = self;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    //通过 appid  secret 认证code . 来发送获取 access_token的请求
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_AppID,URL_SECRET,code] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {  //获得access_token，然后根据access_token获取用户信息请求。
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic %@",dic);
        
        /*
         access_token   接口调用凭证
         expires_in access_token接口调用凭证超时时间，单位（秒）
         refresh_token  用户刷新access_token
         openid 授权用户唯一标识
         scope  用户授权的作用域，使用逗号（,）分隔
         unionid     当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段
         */
        NSString* accessToken=[dic valueForKey:@"access_token"];
        NSString* openID=[dic valueForKey:@"openid"];
        [weakSelf requestUserInfoByToken:accessToken andOpenid:openID];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error.localizedFailureReason);
    }];
    
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSString *nikeName=[dic valueForKeyPath:@"nickname"];
        text01.text=nikeName;
        NSLog(@"dic  ==== %@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %ld",(long)error.code);
    }];
}

#pragma mark 登录
- (IBAction)login:(id)sender {
    //1.check
    if(text01.text.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"请输入账号。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if(text02.text.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"请输入密码。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
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

    
    [self getTOKEN];
}

@end
