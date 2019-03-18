//
//  signUpViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/22.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "signUpViewController.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
@interface signUpViewController ()

@end

@implementation signUpViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    isBtnOnCilck=YES;
    // Do any additional setup after loading the view.
    
    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
    left_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    [left_BarButoon_Item setImage:[UIImage imageNamed:@"navback.png"] forState:UIControlStateNormal];
    [left_BarButoon_Item addTarget:self action:@selector(navLeftBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
    self.navigationItem.leftBarButtonItem=leftItem;
    self.navigationItem.title=@"报名";
    UIButton *right_BarButoon_Item=[[UIButton alloc] init];
   
    
    
    btnOK.layer.masksToBounds = YES; //没这句话它圆不起来
    btnOK.layer.cornerRadius = 5; //设置图片圆角的尺度
    float left=(bounds_width.size.width-view_con.frame.size.width)/2;
    view_con.frame=CGRectMake(left, 64, view_con.frame.size.width,  view_con.frame.size.height);
    
//[text_view addSubview:lab_Prompt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)navLeftBtn_Event:(id)sender{
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self nav_back:sender];
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
    if (str.length > 200)
    {
        NSString *toBeString = text_view.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [text_view markedTextRange];
            //获取高亮部分
            UITextPosition *position = [text_view positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 190) {
                    text_view.text = [toBeString substringToIndex:190];
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
        if (20>range.location) {
            return YES;
        }
    }
    if(20>range.location)
    {
        if (string.length+str.length>=20) {
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
        if (200>range.location) {
            return YES;
        }
    }
    if(200>range.location)
    {
        if (text.length+str.length>=200) {
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





- (IBAction)btnOKEvent:(id)sender {
    /*
    [_cell.btnArea setTitle:@"已报名" forState:UIControlStateNormal];
    [_cell.btnArea setBackgroundColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]] ;
    [_cell.btnArea removeTarget: nil action:nil forControlEvents:UIControlEventTouchUpInside];
    return;
    */
    
    
    if (txt_name.text==nil ||[txt_name.text isEqualToString:@""] ) {
        NSString *strUrl = [txt_name.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([strUrl isEqualToString:@""])
        {
            [self initAlertViewEx:@"请输入姓名"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return;
        }
    }
    
    if(txt_phone.text.length==0)
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

    /*
    if (text_view.text==nil||[text_view.text isEqualToString:@""] ) {
        NSString *strUrl = [text_view.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([strUrl isEqualToString:@""])
        {
            [self initAlertViewEx:@"请输入留言"];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            return;
        }
        
    }

    */
    
    
    
    
    if([self stringContainsEmoji:txt_name.text]==true)
    {
        [self initAlertViewEx:@"姓名不允许输入表情符号！"];
        return;
    }
    
    
    if([self stringContainsEmoji:text_view.text]==true)
    {
        [self initAlertViewEx:@"留言不允许输入表情符号！"];
        return;
    }
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self checkTOKEN];

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
            BOOL isMatch=[pred evaluateWithObject:txt_phone.text];
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
        if (txt_phone.text.length!=11)
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


#pragma mark TOKEN验证是否失效
-(void)checkTOKEN
{
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    if(app.str_token==nil ||[app.str_token isEqualToString:@""])
    {
        [self checkTOKEN_ERR];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
    NSString *token=app.str_token;
    
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
    app.str_token=@"";
    NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
    [dic_oAuth removeObjectForKey:@"str_token"];
    [dic_oAuth removeObjectForKey:@"username"];
    [dic_oAuth removeObjectForKey:@"nikename"];
    [dic_oAuth removeObjectForKey:@"pwd"];
    [dic_oAuth removeObjectForKey:@"uhead"];
    [self loginMethod];
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
            //[nav_back:nil];
             //[self.navigationController popToRootViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
    else
    {
        if (buttonIndex==0) {
            [self loginMethod];
        }
        
    }
}

#pragma mark 报名 apiDataByAccessToken.php
-(void)pushDynamic
{
    /* */
    if (self.app.str_token==nil) {
        [self initAlertView:@"是否登入?"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }
        NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:self.app.str_token forKey:@"access_token"];
    [dic_args setObject:@"code" forKey:@"response_type"];
    [dic_args setObject:@"activityEnroll" forKey:@"redirect_uri"];
    NSMutableDictionary *dic_state=[NSMutableDictionary dictionary];
    [dic_state setObject:@"true" forKey:@"isToken"];
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    [dic_param setObject:_actId forKey:@"actId"];
    [dic_param setObject:txt_name.text forKey:@"name"];
    [dic_param setObject:txt_phone.text forKey:@"tel"];
    [dic_param setObject:text_view.text forKey:@"leavingMsg"];
    //[dic_param setObject:@"1" forKey:@"type"];
    
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
         if([str_message isEqualToString:@"报名成功！！"])
         {
              [self initAlertViewEx:@"报名成功！！"];
             
             //NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"",@"textOne",_cell,@"textTwo", nil];
             //[[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshSignUp" object:self userInfo:dict];
             
             [_cell.btnArea setTitle:@"已报名" forState:UIControlStateNormal];
              [_cell.btnArea setBackgroundColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]] ;
             [_cell.btnArea removeTarget: nil action:nil forControlEvents:UIControlEventTouchUpInside];
             [self dismissViewControllerAnimated:YES completion:^{
             }];
         }
         else
         {
             [self initAlertViewEx:[@"报名失败！" stringByAppendingString:str_message]];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}
#pragma mark 弹出登录页面
-(void)loginMethod{
    
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


@end
