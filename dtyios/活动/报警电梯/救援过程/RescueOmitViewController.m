//
//  RescueOmitViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "RescueOmitViewController.h"
#import "FMDatabase.h"
#import "JSONKit.h"

#import "MBProgressHUD+Add.h"

@interface RescueOmitViewController ()
{
    FMDatabase *fmdDB;
    long YYTag;
}
@end

@implementation RescueOmitViewController
@synthesize app;
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _view_scroll.frame=CGRectMake((bounds_width.size.width-320)/2, 0, 320, _view_scroll.frame.size.height);
    
    _Viewpop.hidden=true;
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    
    tapGesture.delegate=self;
    [_view_scroll addGestureRecognizer:tapGesture];
    
    
    _ViewContent.layer.shadowOpacity = 0.5;// 阴影透明度
    _ViewContent.layer.shadowColor = [UIColor grayColor].CGColor;// 阴影的颜色
    _ViewContent.layer.shadowRadius = 3;// 阴影扩散的范围控制
    _ViewContent.layer.shadowOffset= CGSizeMake(1, 1);// 阴影的范围
    
    [self myinit];
}
- (void)myinit{
   
    self.navigationItem.title=@"误报";
    _selectYY.frame=CGRectMake(_selectYY.frame.origin.x, _selectYY.frame.origin.y, bounds_width.size.width-40, _selectYY.frame.size.height);
    _imgYY.frame=CGRectMake(bounds_width.size.width-50, _imgYY.frame.origin.y, 30, _imgYY.frame.size.height);
    
    _selYY.frame=CGRectMake(_selYY.frame.origin.x, _selYY.frame.origin.y, bounds_width.size.width-40, _selYY.frame.size.height);
    _selYY.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _selYY.layer.borderWidth=1.0f;
    _selYY.layer.masksToBounds = YES;
    _selYY.layer.cornerRadius = 4;
    
    _txtYY.frame=CGRectMake(_txtYY.frame.origin.x, _txtYY.frame.origin.y, bounds_width.size.width-40, _txtYY.frame.size.height);
    _txtYY.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _txtYY.layer.borderWidth=1.0f;
    _txtYY.layer.masksToBounds = YES;
    _txtYY.layer.cornerRadius = 4;
    
    
    _btnUP.frame=CGRectMake(_btnUP.frame.origin.x, _btnUP.frame.origin.y, bounds_width.size.width-40, _btnUP.frame.size.height);
    _btnUP.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _btnUP.layer.borderWidth=1.0f;
    _btnUP.layer.masksToBounds = YES;
    _btnUP.layer.cornerRadius = 4;
    
    _view_scroll.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
    _view_scroll.contentSize=CGSizeMake(bounds_width.size.width, CGRectGetMaxY(_btnUP.frame)+80);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Actiondo:(UITapGestureRecognizer *)gesture
{
    [self CloseAllClassIfication];
    [_txtYY resignFirstResponder];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    if(touch.view.tag==1000)
    {
        return NO;
    }
    
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (IBAction)selectYYClick:(id)sender {
    //_Viewpop.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
    _Viewpop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
    
    //_ViewContent.frame=CGRectMake(5, 50, bounds_width.size.width-10, _ViewContent.frame.size.height);
    
    CGRect rect=_ViewContent.frame;
    rect.origin.x=0;
    rect.origin.y=0;
    if (view_ification_02!=nil) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=view_ification_02.frame;
            rect.size.height=0;
            view_ification_02.frame=rect;
        } completion:^(BOOL finished) {
            [view_ification_02 removeFromSuperview];
            view_ification_02=nil;
        }];
    }
    else{
        //[self CloseAllClassIfication];
        
        NSMutableArray *arr2=[self Link_Database_status:@"17"];
        
        
        
        view_ification_02=[[ClassIfication alloc] initWithFrame:rect ArrList:[NSMutableArray arrayWithArray:arr2]];
        view_ification_02.table_view.tag=1;
        
        view_ification_02.delegate=self;
        rect.size.height=0;
        
        view_ification_02.frame=rect;
        [_ViewContent addSubview:view_ification_02];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=_ViewContent.frame;
            rect.origin.y=0;
            view_ification_02.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    _Viewpop.hidden=false;

}

-(NSMutableArray *)Link_Database_status :(NSString *)type
{
    fmdDB=[FMDatabase databaseWithPath: [[NSBundle mainBundle] pathForResource:@"SinodomSQLite" ofType:@"sqlite"]];
    [fmdDB open];
    NSMutableArray *arr2=[[NSMutableArray alloc]init];
    NSString *str_sql=@"select * from TS_Dict where ParentId in(";
    str_sql=[str_sql stringByAppendingString:type];
    str_sql=[str_sql stringByAppendingString:@")"];
    
    FMResultSet *result_set=[fmdDB executeQuery:str_sql];
    while ([result_set next]) {
        NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d1 setObject:[result_set stringForColumn:@"ID"] forKey:@"tagId"];
        [d1 setObject:[result_set stringForColumn:@"FullPath"] forKey:@"tagName"];
        [arr2 addObject:d1];
    }
    
    [fmdDB close];
    return arr2;
}
#pragma mark 关闭所有ClassIfication视图
-(void)CloseAllClassIfication
{
    [view_ification_02 removeFromSuperview];
    view_ification_02=nil;
    _Viewpop.hidden=true;
}

#pragma mark ClassIficationDelegate
-(void)ColesTypeView:(UIView *)typeView
{
    if(typeView ==view_ification_02)
    {
        if (view_ification_02!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_02.frame;
                rect.size.height=0;
                view_ification_02.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_02 removeFromSuperview];
                view_ification_02=nil;
            }];
        }
    }
    
}
-(void)Cell_OnClick:(id)Content typeView:(UIView *)typeView
{
    ClassIfication *currClass=(ClassIfication *)typeView;
    if(typeView ==view_ification_02)
    {
        if(currClass.table_view.tag==1)
        {
            [_selectYY setTitle:[Content objectForKey:@"tagName"] forState:UIControlStateNormal];
            _selectYY.tag=[[Content objectForKey:@"tagId"] intValue];
        }
         if (view_ification_02!=nil) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect rect=view_ification_02.frame;
                rect.size.height=0;
                view_ification_02.frame=rect;
            } completion:^(BOOL finished) {
                [view_ification_02 removeFromSuperview];
                view_ification_02=nil;
            }];
        }
        
        
    }
    _Viewpop.hidden=true;
    
}

- (IBAction)btnOK:(id)sender {
    
    
    _task.ReasonId = [NSString stringWithFormat:@"%ld",_selectYY.tag];
    if(_selectYY.tag ==0)
    {
        [self showAlter:@"请选择原因！"];
        return;
    }
    _task.ReasonDesc = _txtYY.text;
    
   
    //保存救援
    [self SaveTaskStatus:_task];
    

}

-(void)SaveTaskStatus:(warningElevatorModel *) task
{
    YYTag=_selectYY.tag;
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
    
    
    
    
    
    [dic_args setObject:task.ReasonId forKey:@"ReasonId"];
    [dic_args setObject:task.ReasonDesc forKey:@"ReasonDesc"];
   
    
    
    
    
    [[AFAppDotNetAPIClient sharedClient]
     POST:@"Task/SaveTaskStatus"
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
             [self showAlter:@"操作失败！"];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             return ;
         }
         else
         {
             
                 //成功
                 [MBProgressHUD showSuccess:@"操作成功!" toView:nil];
                 
                 //创建通知
                 NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_RescueOK" object:nil userInfo:nil];
                 //通过通知中心发送通知
                 [[NSNotificationCenter defaultCenter] postNotification:notification];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [self showAlter:@"操作失败！"];
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
