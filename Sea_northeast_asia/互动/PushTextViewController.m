//
//  PushTextViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/26.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "PushTextViewController.h"
#import "AppDelegate.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface PushTextViewController ()

@end

@implementation PushTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"button01.png"];
    UIImage *buttonstretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [btn_Push setBackgroundImage:buttonstretchedBackground forState:UIControlStateNormal];
    [text_view addSubview:lab_Prompt];
    self.navigationItem.title =@"发布互动";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backgroundTap:(id)sender {
    [text_view resignFirstResponder];
    [text_tilte resignFirstResponder];
}



#pragma mark textDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([text_view.text isEqualToString:@""]) {
        [lab_Prompt setHidden:NO];
    }
    else
    {
        [lab_Prompt setHidden:YES];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)_textView {
    if ([text_view.text isEqualToString:@""]) {
        [lab_Prompt setHidden:NO];
    }
    else
    {
        [lab_Prompt setHidden:YES];
    }
    
    NSRange range;
    range = NSMakeRange (text_view.text.length, 1);
    [text_view scrollRangeToVisible: range];
    NSString *str=[Util deleteEmoji:text_view.text];
    if (str.length > 1000)
    {
        NSString *toBeString = text_view.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [text_view markedTextRange];
            //获取高亮部分
            UITextPosition *position = [text_view positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 990) {
                    text_view.text = [toBeString substringToIndex:990];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    string=[Util deleteEmoji:string];
    NSString *str=[Util deleteEmoji:textField.text];
    if (1==range.length) {
        if (100>range.location) {
            return YES;
        }
    }
    if(100>range.location)
    {
        if (string.length+str.length>=100) {
            return NO;
        }
        return YES;
    }
    else
        return NO;

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        
        return YES;
        
    }
    
    
    
    text=[Util deleteEmoji:text];
    NSString *str=[Util deleteEmoji:textView.text];
    if (1==range.length) {
        if (1000>range.location) {
            return YES;
        }
    }
    if(1000>range.location)
    {
        if (text.length+str.length>=1000) {
            return NO;
        }
        return YES;
    }
    else
        return NO;
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

-(IBAction)Btn_PushOnClick:(id)sender
{
    NSString *title=text_tilte.text;
    if([self stringContainsEmoji:title]==true)
    {
         [self initAlertViewEx:@"标题不允许输入表情符号！"];
        return;
    }
    
    
    if([self stringContainsEmoji:text_view.text]==true)
    {
        [self initAlertViewEx:@"内容不允许输入表情符号！"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self checkTOKEN];
}
#pragma mark 发布动态 apiDataByAccessToken.php
-(void)pushDynamic
{
    /* */
    if (self.app.str_token==nil) {
        [self initAlertView:@"是否登入?"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    if (text_tilte.text==nil ||[text_tilte.text isEqualToString:@""] ) {
        NSString *strUrl = [text_tilte.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([strUrl isEqualToString:@""])
        {
            [self initAlertViewEx:@"请输入标题"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return;
        }
    }
    if (text_view.text==nil||[text_view.text isEqualToString:@""] ) {
        NSString *strUrl = [text_view.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([strUrl isEqualToString:@""])
        {
            [self initAlertViewEx:@"请输入内容"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return;
        }
        
    }
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:self.app.str_token forKey:@"access_token"];
    [dic_args setObject:@"code" forKey:@"response_type"];
    [dic_args setObject:@"releaseInteract" forKey:@"redirect_uri"];
    NSMutableDictionary *dic_state=[NSMutableDictionary dictionary];
    [dic_state setObject:@"true" forKey:@"isToken"];
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    [dic_param setObject:text_tilte.text forKey:@"title"];
    [dic_param setObject:text_view.text forKey:@"content"];
    [dic_param setObject:@"1" forKey:@"type"];
    
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
         NSString *str_message=[dic_result objectForKey:@"message"];
         if([str_message isEqualToString:@"发布成功！"])
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:self userInfo:nil];
             [super nav_back:nil];
         }
         else
         {
             [self initAlertViewEx:@"发布失败！"];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
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
-(void)nav_back:(id)sender
{
    UIAlertView *alert=[[UIAlertView alloc]
                        initWithTitle:@"提示"
                        message:@"是否放弃本次编辑"
                        delegate:self
                        
                        cancelButtonTitle:@"确定"
                        otherButtonTitles:@"取消", nil];
    alert.tag=1000;
    [alert show];
    
}
#pragma mark UIAlertViewDelegate
-(void)initAlertView:(NSString *)str_message
{
    UIAlertView *alert=[[UIAlertView alloc]
                        initWithTitle:@"提示"
                        message:str_message
                        delegate:self
                        cancelButtonTitle:@"确定"
                        otherButtonTitles:@"取消", nil];
    [alert show];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1000) {
        if (buttonIndex==0) {
            [super nav_back:nil];
        }
    }
    else
    {
        if (buttonIndex==0) {
            [self loginMethod];
        }
        
    }
}
#pragma mark TOKEN验证是否失效
-(void)checkTOKEN
{
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    if(super.app.str_token==nil ||[super.app.str_token isEqualToString:@""])
    {
         [self checkTOKEN_ERR];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    NSString *token=super.app.str_token;
    
    [dic_args setObject:token forKey:@"access_token"];
    [dic_args setObject:@"code" forKey:@"response_type"];
    [dic_args setObject:@"verToken" forKey:@"redirect_uri"];
    [dic_args setObject:@"{\"isToken\":true,\"param\":{}}" forKey:@"state"];
    
    [[AFAppDotNetAPIClient sharedClient_token]
     POST:@"apiDataByAccessToken.php"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         if(dic_result.count>0)
         {
         NSString *status=[dic_result objectForKey:@"status"];
         NSString *message=[dic_result objectForKey:@"message"];
         
         if(message!=nil&&[message isEqualToString:@"token验证成功！"])
         {
             [self pushDynamic];
         }
         else
         {
             [self checkTOKEN_ERR];
    
         }
         }else
         {
         [self checkTOKEN_ERR];
         }
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self checkTOKEN_ERR];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}
-(void)checkTOKEN_ERR
{
    [self initAlertViewEx:@"登录信息已过期，请重新登录！"];
    super.app.str_token=@"";
    NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
    [dic_oAuth removeObjectForKey:@"str_token"];
    [dic_oAuth removeObjectForKey:@"username"];
    [dic_oAuth removeObjectForKey:@"nikename"];
    [dic_oAuth removeObjectForKey:@"pwd"];
    [dic_oAuth removeObjectForKey:@"uhead"];
 [self loginMethod];
}

@end
