//
//  PersonChangeNikenameViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/7/26.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "PersonChangeNikenameViewController.h"
#import "JSONKit.h"
#import "LoginViewController.h"
@interface PersonChangeNikenameViewController ()

@end

@implementation PersonChangeNikenameViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    isBtnOnCilck=YES;
    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
    left_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    [left_BarButoon_Item setImage:[UIImage imageNamed:@"navback.png"] forState:UIControlStateNormal];
    [left_BarButoon_Item addTarget:self action:@selector(navLeftBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
    self.navigationItem.leftBarButtonItem=leftItem;
    self.navigationItem.title=@"修改昵称";
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
    if(nikeName.text.length==0)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"快搜东北亚"
                                                      message:@"请输入昵称。"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if(nikeName.text.length>10)
    {
        [self initAlertViewEx:@"昵称不能超过10个字符！"];
        return;
    }
    
    NSString *title=nikeName.text;
    if([self stringContainsEmoji:title]==true)
    {
        [self initAlertViewEx:@"昵称不允许输入表情符号！"];
        return;
    }
    
    [self changeNikename];
}

#pragma mark 修改昵称
-(void)changeNikename
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
    [dic_args setObject:@"userName" forKey:@"redirect_uri"];
    
    /*
    NSString *tring1=@"{\"isToken\":true,\"param\":{\"nikeName\":\"";
    NSString *tring2=@"\"}}";
    NSString *nike=[tring1 stringByAppendingString:nikeName.text];
    nike=[nike stringByAppendingString:tring2];
    [dic_args setObject:nike forKey:@"state"];
     */
    NSMutableDictionary *dic_state=[NSMutableDictionary dictionary];
    [dic_state setObject:@"true" forKey:@"isToken"];
    
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    [dic_param setObject:nikeName.text forKey:@"nikeName"];
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
         
         if(message==nil||![message isEqualToString:@"修改昵称成功！"])
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
                                                           message:@"修改昵称失败！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
             [alert show];
                 }
             
             return ;
         }
         
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"修改昵称成功！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];

         app.userInfo.nikename=nikeName.text;
         [self.navigationController popToRootViewControllerAnimated:YES];
         isBtnOnCilck=YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"登录失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
         isBtnOnCilck=YES;
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        
        return NO;
        
    }
    
    return YES;
}

-(void)initAlertViewEx:(NSString *)str_message
{
    UIAlertView *alert=[[UIAlertView alloc]
                        initWithTitle:@"提示"
                        message:str_message
                        delegate:nil
                        cancelButtonTitle:@"确定"
                        otherButtonTitles:nil, nil];
    [alert show];
}

- (BOOL)stringContainsEmoji:(NSString *)string

{
    
    __block BOOL returnValue = NO;
    
    
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
     
                               options:NSStringEnumerationByComposedCharacterSequences
     
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                
                                const unichar hs = [substring characterAtIndex:0];
                                
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    
                                    if (substring.length > 1) {
                                        
                                        const unichar ls = [substring characterAtIndex:1];
                                        
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            
                                            returnValue = YES;
                                            
                                        }
                                        
                                    }
                                    
                                } else if (substring.length > 1) {
                                    
                                    const unichar ls = [substring characterAtIndex:1];
                                    
                                    if (ls == 0x20e3) {
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                } else {
                                    
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        
                                        returnValue = YES;
                                        
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        
                                        returnValue = YES;
                                        
                                    }
                                    
                                }
                                
                            }];
    
    
    
    return returnValue;
    
}

@end
