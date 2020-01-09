//
//  RescueEvaluationViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "RescueEvaluationViewController.h"
#import "TL_TaskEvaluate.h"
#import "JSONKit.h"

#import "MBProgressHUD+Add.h"
#import "MyControl.h"
@interface RescueEvaluationViewController ()
{
    long pj1;
    long pj2;
    long pj3;
}
@end

@implementation RescueEvaluationViewController
@synthesize app;
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //double left=(bounds_width.size.width-320)/2;
    //_viewAll.frame=CGRectMake(left, 0, _viewAll.frame.size.width, _viewAll.frame.size.height);
    _viewAll.frame=CGRectMake(0, -20, bounds_width.size.width, bounds_width.size.height);
    
    UIView *stop_View = [[UIView alloc]initWithFrame:CGRectMake(0, 25, 60, 40)];
    stop_View.userInteractionEnabled=YES;
    [_view_head addSubview:stop_View];
    
    UIImage *stopImage = [UIImage imageNamed:@"backArrow@2x"];
    UIImageView *stopImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 5, stopImage.size.width, stopImage.size.height) imageName:nil];
    stopImageView.userInteractionEnabled=YES;
    stopImageView.image = stopImage;
    [stop_View addSubview:stopImageView];
    
    UIButton *stop_Btn = [MyControl createButtonWithFrame:CGRectMake(0, 0, 60, 40) imageName:nil bgImageName:nil title:nil SEL:@selector(btnClick_stop:) target:self];
    [stop_View addSubview:stop_Btn];
    
    _btnname_UP.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _btnname_UP.layer.borderWidth=1.0f;
    _btnname_UP.layer.masksToBounds = YES;
    _btnname_UP.layer.cornerRadius = 4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)btnClick_stop:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnClick:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [self setpj:btn.tag forView:_view1];
    pj1=btn.tag;
    }
- (void)setpj:(long)btnTag forView :(UIView*)currview{
    for(int x=1; x<=5; x++)
    {
        UIImageView *img=(UIImageView *) [currview viewWithTag:x+1000];
        if(x>btnTag)
        {
            img.image= [UIImage imageNamed:@"pj_star"];
        }
        else
        {img.image=[UIImage imageNamed:@"pj_starsel"];}
    }

}

- (IBAction)btnClick2:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [self setpj:btn.tag forView:_view2];
    pj2=btn.tag;
    
}

- (IBAction)btnClick3:(id)sender {
    UIButton *btn=(UIButton*)sender;
    [self setpj:btn.tag forView:_view3];
    pj3=btn.tag;
}

- (IBAction)btnUp:(id)sender {
    
    //生成评价分数
    NSMutableArray *scoreList = [[NSMutableArray alloc]init];
    TL_TaskEvaluate *curr=[[TL_TaskEvaluate alloc]init];
    curr.TaskId = [_task.ID intValue],
    curr.ItemId = 42,
    curr.UserId = [app.userInfo.UserID intValue];
    curr.Rank = pj1;
    [scoreList addObject:curr];
    //pj2
    curr=[[TL_TaskEvaluate alloc]init];
    curr.TaskId = [_task.ID intValue],
    curr.ItemId = 43,
    curr.UserId = [app.userInfo.UserID intValue];
    curr.Rank = pj2;
    [scoreList addObject:curr];
    //pj3
    curr=[[TL_TaskEvaluate alloc]init];
    curr.TaskId = [_task.ID intValue],
    curr.ItemId = 44,
    curr.UserId = [app.userInfo.UserID intValue];
    curr.Rank = pj3;
    [scoreList addObject:curr];
    
    [self SaveTaskStatus :_task forList:scoreList];
    /*
   
    
    //保存救援
    var result = await WebServices.Shared.SaveTaskStatus(Task);
    if (!result.Success)
    {
        Toast.MakeText(Application.Context,"救援评价失败:" + result.Message, ToastLength.Long).Show();
        return;
    }
        //保存评价分数
    var scoreResult = await WebServices.Shared.SaveEvaluationScore(scoreList);
    if (!scoreResult.Success)
    {
        Toast.MakeText(Application.Context, "评价分数失败:" + result.Message, ToastLength.Long).Show();
        return;
    }
    
    //保存成功
    if (scoreResult.Success&& result.Success)
    {
        FragmentManager.PopBackStack();
        Toast.MakeText(Application.Context, "评价成功", ToastLength.Long).Show();
    }
     */
}

-(void)SaveTaskStatus:(warningElevatorModel *) task forList:(NSMutableArray*)list
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    
    [dic_args setObject:task.StatusId forKey:@"StatusId"];
    [dic_args setObject:task.StatusName forKey:@"StatusName"];
    if(task.RemedyUserId !=nil)
        [dic_args setObject:task.RemedyUserId forKey:@"RemedyUserId"];
    if(task.ConfirmUserId!=nil)
        [dic_args setObject:task.ConfirmUserId forKey:@"ConfirmUserId"];
    [dic_args setObject:task.CreateTime forKey:@"CreateTime"];
    [dic_args setObject:task.ID forKey:@"ID"];
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"Task/SaveTaskStatus"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         //NSString *sms_data=[dic_result objectForKey:@"Data"];
         //NSDictionary* dic_data=[sms_data objectFromJSONString];
         BOOL b=[success boolValue];
         if(b!=YES)
         {
             [self showAlter:@"救援评价失败！"];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             return ;
         }
         else
         {
             //成功
             [self SaveTaskStatus_pj:list];
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"救援评价失败！"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}
//此接口保存成功，但是数据未保存进去。可能是参数类型的问题。
-(void)SaveTaskStatus_pj:(NSMutableArray *) list
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    
    [dic_args setObject:list forKey:@"taskEvaluates"];
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"Task/SaveEvaluationScore"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         //NSString *sms_data=[dic_result objectForKey:@"Data"];
         //NSDictionary* dic_data=[sms_data objectFromJSONString];
         BOOL b=[success boolValue];
         if(b!=YES)
         {
             [self showAlter:@"评价分数失败！"];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             return ;
         }
         else
         {
             //成功
             [MBProgressHUD showSuccess:@"评价成功!" toView:nil];
             
             //创建通知
             NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_RescueOK" object:nil userInfo:nil];
             //通过通知中心发送通知
             [[NSNotificationCenter defaultCenter] postNotification:notification];
             [self.navigationController popToRootViewControllerAnimated:YES];
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"评价分数失败！"];
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
