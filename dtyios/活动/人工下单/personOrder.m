//
//  personOrder.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/10.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "personOrder.h"


@implementation personOrder
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    _rescueNumber.text=@"1";
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    
    tapGesture.delegate=self;
    [self.view addGestureRecognizer:tapGesture];
    
    _imgH.frame=CGRectMake(_imgH.frame.origin.x, _imgH.frame.origin.y, bounds_width.size.width, _imgH.frame.size.height);
    _liftId.frame=CGRectMake(_liftId.frame.origin.x, _liftId.frame.origin.y, bounds_width.size.width-20, _liftId.frame.size.height);
    _liftId.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _liftId.layer.borderWidth=1.0f;
    _liftId.layer.masksToBounds = YES;
    _liftId.layer.cornerRadius = 4;
    
    _installationAddress.frame=CGRectMake(_installationAddress.frame.origin.x, _installationAddress.frame.origin.y, bounds_width.size.width-20, _installationAddress.frame.size.height);
    _installationAddress.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _installationAddress.layer.borderWidth=1.0f;
    _installationAddress.layer.masksToBounds = YES;
    _installationAddress.layer.cornerRadius = 4;
    
    _rescueNumber.frame=CGRectMake(_rescueNumber.frame.origin.x, _rescueNumber.frame.origin.y, bounds_width.size.width-20, _rescueNumber.frame.size.height);
    _rescueNumber.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _rescueNumber.layer.borderWidth=1.0f;
    _rescueNumber.layer.masksToBounds = YES;
    _rescueNumber.layer.cornerRadius = 4;
    
    _rescuePhone.frame=CGRectMake(_rescuePhone.frame.origin.x, _rescuePhone.frame.origin.y, bounds_width.size.width-20, _rescuePhone.frame.size.height);
    _rescuePhone.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _rescuePhone.layer.borderWidth=1.0f;
    _rescuePhone.layer.masksToBounds = YES;
    _rescuePhone.layer.cornerRadius = 4;
    
    //_content=[[UITextView alloc]init];
    _content.frame=CGRectMake(_content.frame.origin.x, _content.frame.origin.y, bounds_width.size.width-20, 78);
    _content.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _content.layer.borderWidth=1.0f;
    _content.layer.masksToBounds = YES;
    _content.layer.cornerRadius = 4;
    
    _btn_up.frame=CGRectMake(_btn_up.frame.origin.x, _btn_up.frame.origin.y, bounds_width.size.width-20, _btn_up.frame.size.height);
    _btn_up.layer.masksToBounds = YES;
    _btn_up.layer.cornerRadius = 4;
    
    self.scrollView1.frame=CGRectMake(0,0,bounds_width.size.width, bounds_width.size.height);
    self.scrollView1.contentSize=CGSizeMake(bounds_width.size.width, 700);
}

-(void)Actiondo:(UITapGestureRecognizer *)gesture
{
    [_liftId resignFirstResponder];
    [_content resignFirstResponder];
    [_rescueNumber resignFirstResponder];
    [_rescuePhone resignFirstResponder];
}
- (IBAction)submitClick:(id)sender {
    
    if ([_liftId.text isEqual:@""])
    {
        [self showAlter:@"电梯编号录入不完整！"];
        return;
    }

    
    if (![_rescueNumber.text isEqual:@""])
    {
        if(![Util isPureInt :_rescueNumber.text])
        {
            [self showAlter:@"被困人数录入错误！"];
            return;
        }
        if([_rescueNumber.text intValue]<=0)
        {
            [self showAlter:@"被困人数需大于0！"];
            return;
        }
    }
    else
    {
        [self showAlter:@"被困人数不能为空！"];
        return;
    }
    
    [self AddOrder];
}

- (void)AddOrder
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    
    [dic_args setObject:[NSString stringWithFormat:@"%ld",_liftId.tag] forKey:@"LiftId"];
    [dic_args setObject:_rescueNumber.text forKey:@"RescueNumber"];
    
    [dic_args setObject:_rescuePhone.text forKey:@"RescuePhone"];
    [dic_args setObject:@"" forKey:@"Content"];
    //[dic_args setObject:_content.text forKey:@"Content"];
    [dic_args setObject:app.userInfo.UserID forKey:@"ConfirmUserId"];
    
    
    
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"Task/ArtificialOrder"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
              NSString *state_Message=[dic_result objectForKey:@"Message"];
             
             if (state_value==1) {
                 _liftId.text=@"";
                 _liftId.tag=0;
                 _installationAddress.text=@"";
                 _rescueNumber.text=@"1";
                 _rescuePhone.text=@"";
                 _content.text=@"";
                [self showAlter:@"下单成功！" ];
             }
             else
             {
                 [self showAlter:[@"下单失败！" stringByAppendingString:state_Message]];
             }
             
         }
         else
         {
             [self showAlter:@"下单失败！"];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"下单失败！"];
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}

- (IBAction)liftNumChanged:(id)sender {
    if(![_liftId.text isEqual:@""])
    {
        [ self GetLiftByLiftNum:_liftId.text];
    }
}


- (void)GetLiftByLiftNum: (NSString *) liftNum
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *string = [@"Lift/GetLiftByLiftNum?liftNum=" stringByAppendingString:liftNum];
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {       }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             
             
             if (state_value==1) {
               NSDictionary* dic_item=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 

                _installationAddress.text=[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"InstallationAddress"]];
                 _liftId.tag=[[NSString stringWithFormat:@"%@",[dic_item objectForKey:@"ID"]] longLongValue];
             }
             else
             {
                 [self showAlter:@"获取电梯地址失败！"];
                 
             }
            
         }
         else
         {
             [self showAlter:@"获取电梯地址失败！"];
            
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"获取电梯地址失败！"];
         
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
