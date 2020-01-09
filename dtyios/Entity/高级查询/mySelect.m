//
//  mySelect.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "mySelect.h"
#import "CommonUseClass.h"
#import "RequestWhere.h"

@interface mySelect ()
{
    bool IsInitselect;
    RequestWhere *_requestWhere;
    
    NSMutableArray *SelectCity;
    NSMutableArray *SelectQu;
    NSMutableArray *SelectUserDecp;
    NSMutableArray *SelectMaint;
    NSMutableArray *SelectState;
    NSMutableArray *SelectPB;
    NSMutableArray *SelectPBYY;
    
    UILabel *txtPB;
    UIImageView *imgPB;
    UIButton *btnPB;
    
    UILabel *txtPBYY;
    UIImageView *imgPBYY;
    UIButton *btnPBYY;
}
@end
@implementation mySelect
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    //self.view.alpha = 0.5;
    //self.view.backgroundColor = [UIColor grayColor];
                                 
    [self ShowSelect];
    [self initSelect];
    [self CloseAllClassIfication];
    
    
    
    //
     _scrollView.frame=CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, bounds_width.size.width, bounds_width.size.height);//_scrollView.frame.size.height
    //_scrollView.backgroundColor=[UIColor redColor];
   
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_scrollView addGestureRecognizer:tapGestureRecognizer];
    
    
    float width1=(bounds_width.size.width-30)/2;
    _txtCity.frame=CGRectMake(10, _txtCity.frame.origin.y, width1,_txtCity.frame.size.height);
    _txtCity.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _txtCity.layer.borderWidth=1.0f;
    _txtCity.layer.masksToBounds = YES;
    _txtCity.layer.cornerRadius = 4;
    _imgCity.frame=CGRectMake(CGRectGetMaxX(_txtCity.frame)-30, _txtCity.frame.origin.y, 30, 30) ;
    
    _txtQu.frame=CGRectMake(width1+20, _txtQu.frame.origin.y, width1,_txtQu.frame.size.height);
    _txtQu.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _txtQu.layer.borderWidth=1.0f;
    _txtQu.layer.masksToBounds = YES;
    _txtQu.layer.cornerRadius = 4;
    _imgQu.frame=CGRectMake(CGRectGetMaxX(_txtQu.frame)-30, _txtQu.frame.origin.y, 30, 30) ;
    
    
    float currHeight=48;
    if(_isHaveState)
    {
        _txtState.frame=CGRectMake(10, _txtState.frame.origin.y, bounds_width.size.width-20,_txtState.frame.size.height);
        _txtState.layer.borderColor= [UIColor lightGrayColor].CGColor;
        _txtState.layer.borderWidth=1.0f;
        _txtState.layer.masksToBounds = YES;
        _txtState.layer.cornerRadius = 4;
        _imgState.frame=CGRectMake(CGRectGetMaxX(_txtState.frame)-30, _txtState.frame.origin.y, 30, 30) ;
        currHeight=81;
    }
    else
    {
        _txtState.hidden=YES;
        _btnState.hidden=YES;
        _imgState.hidden=YES;
    }
    
    _txtUserDept.frame=CGRectMake(10, currHeight, bounds_width.size.width-20,_txtUserDept.frame.size.height);
    _txtUserDept.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _txtUserDept.layer.borderWidth=1.0f;
    _txtUserDept.layer.masksToBounds = YES;
    _txtUserDept.layer.cornerRadius = 4;
    _imgUserDept.frame=CGRectMake(CGRectGetMaxX(_txtUserDept.frame)-30, _txtUserDept.frame.origin.y, 30, 30) ;
    
    currHeight=currHeight+33;
    
    _txtMaintDept.frame=CGRectMake(10,currHeight, bounds_width.size.width-20,_txtMaintDept.frame.size.height);
    _txtMaintDept.layer.borderColor= [UIColor lightGrayColor].CGColor;
    _txtMaintDept.layer.borderWidth=1.0f;
    _txtMaintDept.layer.masksToBounds = YES;
    _txtMaintDept.layer.cornerRadius = 4;
    _imgMaintDept.frame=CGRectMake(CGRectGetMaxX(_txtMaintDept.frame)-30, _txtMaintDept.frame.origin.y, 30, 30) ;
    
    currHeight=currHeight+45;

    _btnCity.frame=_txtCity.frame;
    _btnQu.frame=_txtQu.frame;
    _btnUserDept.frame=_txtUserDept.frame;
    _btnMaintDept.frame=_txtMaintDept.frame;
    _btnState.frame=_txtState.frame;
    
    //2
    if(_isPB)
    {
        currHeight=currHeight-45+33;

        //2.1
        txtPB=[[UILabel alloc]init];
        txtPB.frame=CGRectMake(10, currHeight, bounds_width.size.width-20,_txtCity.frame.size.height);
        txtPB.layer.borderColor= [UIColor lightGrayColor].CGColor;
        txtPB.layer.borderWidth=1.0f;
        txtPB.layer.masksToBounds = YES;
        txtPB.layer.cornerRadius = 4;
        [_viewSelect addSubview:txtPB];
        
        imgPB=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(txtPB.frame)-30, currHeight, 30, 30) ];
        imgPB.image=[UIImage imageNamed:@"dt_choice1.png"];
        [_viewSelect addSubview:imgPB];
        
        btnPB=[[UIButton alloc]init];
        btnPB.frame=txtPB.frame;
        btnPB.tag=6;
        [btnPB addTarget:self action:@selector(btnPopClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewSelect addSubview:btnPB];
        
        currHeight=currHeight+33;
        
        //2.2
        txtPBYY=[[UILabel alloc]init];
        txtPBYY.frame=CGRectMake(10, currHeight, bounds_width.size.width-20,_txtCity.frame.size.height);
        txtPBYY.layer.borderColor= [UIColor lightGrayColor].CGColor;
        txtPBYY.layer.borderWidth=1.0f;
        txtPBYY.layer.masksToBounds = YES;
        txtPBYY.layer.cornerRadius = 4;
        [_viewSelect addSubview:txtPBYY];
        
        imgPBYY=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(txtPBYY.frame)-30, currHeight, 30, 30) ];
        imgPBYY.image=[UIImage imageNamed:@"dt_choice1.png"];
        [_viewSelect addSubview:imgPBYY];
        
        btnPBYY=[[UIButton alloc]init];
        btnPBYY.frame=txtPBYY.frame;
        btnPBYY.tag=7;
        [btnPBYY addTarget:self action:@selector(btnPopClick:) forControlEvents:UIControlEventTouchUpInside];
        [_viewSelect addSubview:btnPBYY];

        
        currHeight=currHeight+45;
    }
    
    //3
    float width2=(bounds_width.size.width-20)/2;
    _btnCancel.frame=CGRectMake(10, currHeight, width2/2, _btnCancel.frame.size.height);
     _btnClear.frame=CGRectMake(10+width2/2, currHeight, width2/2, _btnClear.frame.size.height);
     _btnDo.frame=CGRectMake(10+width1, currHeight, width2, _btnDo.frame.size.height);
    
    currHeight=currHeight+45;

    _viewSelect.frame=CGRectMake(_viewSelect.frame.origin.x, _viewSelect.frame.origin.y, bounds_width.size.width, currHeight);
}

//点击空白-回收键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self CloseAllClassIfication];
}

#pragma mark ClassIficationDelegate
-(void)CloseAllClassIfication
{
    [view_ification_02 removeFromSuperview];
    view_ification_02=nil;
    _view_pop.hidden=true;
}

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
            _txtCity.text=[Content objectForKey:@"tagName"];
            _txtCity.tag=[[Content objectForKey:@"tagId"] intValue];
            
            //qu
            SelectQu=[[NSMutableArray alloc]init];
            NSMutableDictionary *d4 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d4 setObject:@"0" forKey:@"tagId"];
            [d4 setObject:@"区(全部)" forKey:@"tagName"];
            [SelectQu addObject:d4];
            
            _txtQu.text=@"区(全部)" ;
            _txtQu.tag=0;
            
            [self initQu:_txtCity.tag];
            
            //decp
            SelectUserDecp=[[NSMutableArray alloc]init];
            NSMutableDictionary *d5 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d5 setObject:@"0" forKey:@"tagId"];
            [d5 setObject:@"使用单位(全部)" forKey:@"tagName"];
            [SelectUserDecp addObject:d5];
            
            _txtUserDept.text=@"使用单位(全部)" ;
            _txtUserDept.tag=0;
            
            [self initUserDecp:_txtCity.tag byDistrictId: 0];
            
            //decp
            SelectMaint=[[NSMutableArray alloc]init];
            NSMutableDictionary *d6 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d6 setObject:@"0" forKey:@"tagId"];
            [d6 setObject:@"维保单位(全部)" forKey:@"tagName"];
            [SelectMaint addObject:d6];
            
            _txtMaintDept.text=@"维保单位(全部)" ;
            _txtMaintDept.tag=0;
            
            [self initMaint:_txtCity.tag byDistrictId: 0];
        }
        else if(currClass.table_view.tag==2)
        {
            _txtQu.text=[Content objectForKey:@"tagName"];
            _txtQu.tag=[[Content objectForKey:@"tagId"] intValue];
            
            //decp
            SelectUserDecp=[[NSMutableArray alloc]init];
            NSMutableDictionary *d5 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d5 setObject:@"0" forKey:@"tagId"];
            [d5 setObject:@"使用单位(全部)" forKey:@"tagName"];
            [SelectUserDecp addObject:d5];
            
            _txtUserDept.text=@"使用单位(全部)" ;
            _txtUserDept.tag=0;
            
            [self initUserDecp:_txtCity.tag byDistrictId: _txtQu.tag];
            
            //decp
            SelectMaint=[[NSMutableArray alloc]init];
            NSMutableDictionary *d6 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d6 setObject:@"0" forKey:@"tagId"];
            [d6 setObject:@"维保单位(全部)" forKey:@"tagName"];
            [SelectMaint addObject:d6];
            
            _txtMaintDept.text=@"维保单位(全部)" ;
            _txtMaintDept.tag=0;
            
            [self initMaint:_txtCity.tag byDistrictId: _txtQu.tag];
        }
        else if(currClass.table_view.tag==3)
        {
            _txtUserDept.text=[Content objectForKey:@"tagName"];
            _txtUserDept.tag=[[Content objectForKey:@"tagId"] intValue];
            
        }
        else if(currClass.table_view.tag== 4)
        {
            _txtMaintDept.text=[Content objectForKey:@"tagName"];
            _txtMaintDept.tag=[[Content objectForKey:@"tagId"] intValue];
            
        }
        else if(currClass.table_view.tag== 5)
        {
            _txtState.text=[Content objectForKey:@"tagName"];
            _txtState.tag=[[Content objectForKey:@"tagId"] intValue];
            
        }
        else if(currClass.table_view.tag== 6)
        {
            txtPB.text=[Content objectForKey:@"tagName"];
            txtPB.tag=[[Content objectForKey:@"tagId"] intValue];
            
            //qu
            SelectPBYY=[[NSMutableArray alloc]init];
            NSMutableDictionary *d4 = [NSMutableDictionary dictionaryWithCapacity:2];
            [d4 setObject:@"0" forKey:@"tagId"];
            [d4 setObject:@"屏蔽原因(全部)" forKey:@"tagName"];
            [SelectPBYY addObject:d4];
            
            txtPBYY.text=@"屏蔽原因(全部)" ;
            txtPBYY.tag=0;
            
            [self initShieldReason:txtPB.tag];
        }
        
        if(currClass.table_view.tag==7)
        {
            txtPBYY.text=[Content objectForKey:@"tagName"];
            txtPBYY.tag=[[Content objectForKey:@"tagId"] intValue];
            
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
    _view_pop.hidden=true;
    
}


#pragma mark 下拉列表相关
- (void)ShowSelect
{
    _viewSelect.hidden=false;
}
- (void)CloseSelect
{
    _viewSelect.hidden=true;
}

-(void)InitSelect
{
    _txtCity.text= @"市(全部)";
    _txtCity.tag=0;
    _txtQu.text=@"区(全部)" ;
    _txtQu.tag=0;
    _txtUserDept.text=@"使用单位(全部)" ;
    _txtUserDept.tag=0;
    _txtMaintDept.text=@"维保单位(全部)" ;
    _txtMaintDept.tag=0;
    _txtState.text=_stateAll;//@"安装状态(全部)" ;
    _txtState.tag=0;
    
    txtPB.text= @"屏蔽状态(全部)";
    txtPB.tag=0;
    txtPBYY.text= @"屏蔽原因(全部)";
    txtPBYY.tag=0;
    
    _requestWhere=[[RequestWhere alloc]init];
}

- (void)initSelectFrame
{
    _viewSelect.frame=CGRectMake(_viewSelect.frame.origin.x, _viewSelect.frame.origin.y, bounds_width.size.width, _viewSelect.frame.size.height);
    float width=bounds_width.size.width/2;
    
    _txtCity.frame=CGRectMake(_txtCity.frame.origin.x, _txtCity.frame.origin.y, width-20-34-20, _txtCity.frame.size.height);
    _btnCity.frame=CGRectMake(_txtCity.frame.origin.x, _txtCity.frame.origin.y, width-20-34-20, _txtCity.frame.size.height);
    
    _lblQu.frame=CGRectMake(width, _lblQu.frame.origin.y, _lblQu.frame.size.width, _lblQu.frame.size.height);
    _txtQu.frame=CGRectMake(width+34, _txtQu.frame.origin.y, width-20-34-20, _txtQu.frame.size.height);
    _btnQu.frame=CGRectMake(width+34, _txtQu.frame.origin.y, width-20-34-20, _txtQu.frame.size.height);
    
    _txtUserDept.frame=CGRectMake(_txtUserDept.frame.origin.x, _txtUserDept.frame.origin.y, bounds_width.size.width-91-10, _txtUserDept.frame.size.height);
    _btnUserDept.frame=CGRectMake(_txtUserDept.frame.origin.x, _txtUserDept.frame.origin.y, bounds_width.size.width-91-10, _txtUserDept.frame.size.height);
    
    _txtMaintDept.frame=CGRectMake(_txtMaintDept.frame.origin.x, _txtMaintDept.frame.origin.y, bounds_width.size.width-91-10, _txtMaintDept.frame.size.height);
    _btnMaintDept.frame=CGRectMake(_btnMaintDept.frame.origin.x, _btnMaintDept.frame.origin.y, bounds_width.size.width-91-10, _btnMaintDept.frame.size.height);
    
    _txtState.frame=CGRectMake(_txtState.frame.origin.x, _txtState.frame.origin.y, bounds_width.size.width-91-10, _txtState.frame.size.height);
    _btnState.frame=CGRectMake(_btnState.frame.origin.x, _btnState.frame.origin.y, bounds_width.size.width-91-10, _btnState.frame.size.height);
    
    
    _btnClear.frame=CGRectMake(width- _btnClear.frame.size.width/2, _btnClear.frame.origin.y, _btnClear.frame.size.width, _btnClear.frame.size.height);
    _btnDo.frame=CGRectMake(bounds_width.size.width-8-_btnDo.frame.size.width, _btnDo.frame.origin.y, _btnDo.frame.size.width, _btnDo.frame.size.height);
    
}
- (void)initSelect
{
    if(!IsInitselect)
    {
        [self initSelectFrame];
        
        SelectUserDecp=[[NSMutableArray alloc]init];
        NSMutableDictionary *d2 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d2 setObject:@"0" forKey:@"tagId"];
        [d2 setObject:@"使用单位(全部)" forKey:@"tagName"];
        [SelectUserDecp addObject:d2];
        
        SelectMaint=[[NSMutableArray alloc]init];
        NSMutableDictionary *d3 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d3 setObject:@"0" forKey:@"tagId"];
        [d3 setObject:@"维保单位(全部)" forKey:@"tagName"];
        [SelectMaint addObject:d3];
        
        
        
        
        //[self initUserDecp:0 byDistrictId: 0];
        //[self initMaint:0 byDistrictId: 0];
    }
    IsInitselect=true;
    
    //1.
    if(_isHaveState)
    {
    SelectState=[[NSMutableArray alloc]init];
    NSMutableDictionary *d4 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d4 setObject:@"0" forKey:@"tagId"];
    [d4 setObject:_stateAll forKey:@"tagName"];//@"安装状态(全部)"
    [SelectState addObject:d4];
    [self initState];
    }
    //2.
    SelectCity=[[NSMutableArray alloc]init];
    NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d1 setObject:@"0" forKey:@"tagId"];
    [d1 setObject:@"市(全部)" forKey:@"tagName"];
    [SelectCity addObject:d1];
    if(app.SelectCity!=nil)
        SelectCity=app.SelectCity;
    else
        [self initCity];
    
    if(_isPB)
    {
        SelectPB=[[NSMutableArray alloc]init];
        NSMutableDictionary *d4 = [NSMutableDictionary dictionaryWithCapacity:2];
        [d4 setObject:@"0" forKey:@"tagId"];
        [d4 setObject:@"屏蔽状态(全部)" forKey:@"tagName"];
        [SelectPB addObject:d4];
        [self initPB];
    }
    //2.
    _txtCity.text= @"市(全部)";
    _txtCity.tag=0;
    _txtQu.text=@"区(全部)" ;
    _txtQu.tag=0;
    _txtUserDept.text=@"使用单位(全部)" ;
    _txtUserDept.tag=0;
    _txtMaintDept.text=@"维保单位(全部)" ;
    _txtMaintDept.tag=0;
    _txtState.text=_stateAll ;//@"安装状态(全部)"
    _txtState.tag=0;
    
    txtPB.text= @"屏蔽状态(全部)";
    txtPB.tag=0;
    txtPBYY.text= @"屏蔽原因(全部)";
    txtPBYY.tag=0;

    _requestWhere=[[RequestWhere alloc]init];
}
//city
- (void)initCity
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *string = [@"Address/GetCityList?userId=" stringByAppendingString:[NSString stringWithFormat:@"%@",app.userInfo.UserID]];
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                 NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 for (NSMutableDictionary *dic_item in currArr )
                 {
                     NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                     [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                     [d1 setObject:[dic_item objectForKey:@"Name"]  forKey:@"tagName"];
                     
                     [SelectCity addObject:d1];
                 }
             }
             else
             {
                 
             }
         }
         else
         {
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [CommonUseClass showAlter:@"获取市列表失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}
//区
- (void)initQu:(long)cityId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *string = [@"Address/GetAreaList?userId=" stringByAppendingString:[NSString stringWithFormat:@"%@",app.userInfo.UserID]];
    string = [string stringByAppendingString:@"&cityId="];
    string = [string stringByAppendingString:[NSString stringWithFormat:@"%ld",cityId]];
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1){
                 NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 for (NSMutableDictionary *dic_item in currArr ){
                     NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                     [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                     [d1 setObject:[dic_item objectForKey:@"Name"]  forKey:@"tagName"];
                     
                     [SelectQu addObject:d1];
                 }
                 
             }
             else
             {
                 
             }
         }
         else
         {
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [CommonUseClass showAlter:@"获取区列表失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}
//UserDecp
- (void)initUserDecp:(long)CityId byDistrictId:(long)DistrictId
{
    return;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forKey:@"UserId"];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%ld",CityId] forHTTPHeaderField:@"CityId"];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%ld",DistrictId] forHTTPHeaderField:@"DistrictId"];
    
    NSString *string = @"Dept/GetUseDeptList";
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                 NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 for (NSMutableDictionary *dic_item in currArr )
                 {
                     NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                     [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                     [d1 setObject:[dic_item objectForKey:@"DeptName"]  forKey:@"tagName"];
                     
                     [SelectUserDecp addObject:d1];
                 }
                 
             }
             else
             {
                 
             }
         }
         else
         {
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [CommonUseClass showAlter:@"获取使用单位列表失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}
//MaintDecp
- (void)initMaint:(long)CityId byDistrictId:(long)DistrictId
{
    return;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forKey:@"UserId"];
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%ld",CityId] forHTTPHeaderField:@"CityId"];
    
    [[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:[NSString stringWithFormat:@"%ld",DistrictId] forHTTPHeaderField:@"DistrictId"];
    
    NSString *string = @"Dept/GetMaintDeptList";
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                 NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 for (NSMutableDictionary *dic_item in currArr )
                 {
                     NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                     [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                     [d1 setObject:[dic_item objectForKey:@"DeptName"]  forKey:@"tagName"];
                     
                     [SelectMaint addObject:d1];
                 }
                 
             }
             else
             {
                 
             }
         }
         else
         {
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [CommonUseClass showAlter:@"获取维保单位列表失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

//屏蔽原因
- (void)initShieldReason:(long)IsShield
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *string = @"Dict/GetDictListByRoot?Code=";
    string = [string stringByAppendingString:[NSString stringWithFormat:@"%@",@"ShieldingCause"]];
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:string
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1){
                 NSMutableArray *currArr=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 for (NSMutableDictionary *dic_item in currArr ){
                     NSMutableDictionary *d1 = [NSMutableDictionary dictionaryWithCapacity:2];
                     [d1 setObject:[dic_item objectForKey:@"ID"] forKey:@"tagId"];
                     [d1 setObject:[dic_item objectForKey:@"DictName"]  forKey:@"tagName"];
                     
                     [SelectPBYY addObject:d1];
                 }
                 
             }
             else
             {
                 
             }
         }
         else
         {
             
         }
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [CommonUseClass showAlter:@"获取区列表失败"];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}


//state
- (void)initState
{
    
    NSMutableDictionary *d2 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d2 setObject:@"1" forKey:@"tagId"];
    [d2 setObject:@"是" forKey:@"tagName"];
    [SelectState addObject:d2];
    
    NSMutableDictionary *d3 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d3 setObject:@"0" forKey:@"tagId"];
    [d3 setObject:@"否" forKey:@"tagName"];
    [SelectState addObject:d3];
}

//pb
- (void)initPB
{
    
    NSMutableDictionary *d2 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d2 setObject:@"1" forKey:@"tagId"];
    [d2 setObject:@"是" forKey:@"tagName"];
    [SelectPB addObject:d2];
    
    NSMutableDictionary *d3 = [NSMutableDictionary dictionaryWithCapacity:2];
    [d3 setObject:@"0" forKey:@"tagId"];
    [d3 setObject:@"否" forKey:@"tagName"];
    [SelectPB addObject:d3];
}
- (IBAction)btnPopClick:(id)sender {
    
    UIButton * currBtn=( UIButton *)sender;
    
    NSLog(@"%ld",currBtn.tag);
    
    float currHeight=currBtn.frame.origin.y+currBtn.frame.size.height;
    NSLog(@"====+++++%f",currHeight);
    NSMutableArray *arr2=[[NSMutableArray alloc]init];
    switch (currBtn.tag) {
        case 1:
            arr2=SelectCity;
            break;
        case 2:
            arr2=SelectQu;
            break;
        case 3:
            arr2=SelectUserDecp;
            return;
        case 4:
            arr2=SelectMaint;
            return;
        case 5:
            if(_isHaveState)
            {
                //1.
                _txtState.text=_stateAll ;
                _txtState.tag=0;
                
                //2.
                SelectState=[[NSMutableArray alloc]init];
                NSMutableDictionary *d4 = [NSMutableDictionary dictionaryWithCapacity:2];
                [d4 setObject:@"0" forKey:@"tagId"];
                [d4 setObject:_stateAll forKey:@"tagName"];
                [SelectState addObject:d4];
                [self initState];
            }
            
            arr2=SelectState;
            break;
        case 6:
            arr2=SelectPB;
            break;
        case 7:
            if(txtPB.tag!=1)
            {
                [CommonUseClass showAlter:@"请先选择屏蔽状态！"];
                return;
            }
            arr2=SelectPBYY;
            break;
        default:
            break;
    }
    
    
    _view_pop.frame=CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height);
    _view_pop .backgroundColor=[UIColor colorWithRed:235.f/255.f green:235.f/255.f blue:235.f/255.f alpha:0];
    
    _view_Content.frame=CGRectMake(5, currHeight, bounds_width.size.width-10, _view_Content.frame.size.height);
    
    CGRect rect=_view_Content.frame;
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
        
        view_ification_02=[[ClassIfication alloc] initWithFrame:rect ArrList:[NSMutableArray arrayWithArray:arr2]];
        view_ification_02.table_view.tag=currBtn.tag;
        
        view_ification_02.delegate=self;
        rect.size.height=0;
        
        view_ification_02.frame=rect;
        [_view_Content addSubview:view_ification_02];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=_view_Content.frame;
            rect.origin.y=0;
            view_ification_02.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    _view_pop.hidden=false;
    
}

- (IBAction)btnCancelClick:(id)sender {
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_MySelect_Cancel" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
   
    
}

- (IBAction)btnDoClick:(id)sender {
    _requestWhere=[[RequestWhere alloc]init];
    if(![_txtCity.text isEqual:@"市(全部)"])
    {
        _requestWhere.CityId=(int)_txtCity.tag;
    }
    if(![_txtQu.text isEqual:@"区(全部)"])
    {
        _requestWhere.AddressId=(int)_txtQu.tag;
    }
    if(![_txtMaintDept.text isEqual:@"维保单位(全部)"])
    {
        _requestWhere.MaintDeptId=(int)_txtMaintDept.tag;
    }
    if(![_txtUserDept.text isEqual:@"使用单位(全部)"])
    {
        _requestWhere.UseDeptId=(int)_txtUserDept.tag;
    }
    
    if(![txtPB.text isEqual:@"屏蔽状态(全部)"])
    {
        _requestWhere.IsShield=(int)txtPB.tag;
    }
    if(![txtPBYY.text isEqual:@"屏蔽原因(全部)"])
    {
        _requestWhere.ShieldReasonId=(int)txtPBYY.tag;
    }
    if(![_txtState.text isEqual:_stateAll ])//@"安装状态(全部)"
    {
        if(_tabSelectIndex==0)
            _requestWhere.IsInstallation=(int)_txtState.tag;
        else
            _requestWhere.IsOnline=(int)_txtState.tag;
    }
    else
    {
        if(_tabSelectIndex==0)
            _requestWhere.IsInstallation=-1;
        else
            _requestWhere.IsOnline=-1;
    }
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_requestWhere,@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_MySelect_Do" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    /*
    [self getSchoolCourse];
    [self getSchoolCoursePic];
    [self CloseSelect];
     */
}

- (IBAction)btnClearClick:(id)sender {
    
    _txtCity.text= @"市(全部)";
    _txtCity.tag=0;
    _txtQu.text=@"区(全部)" ;
    _txtQu.tag=0;
    _txtUserDept.text=@"使用单位(全部)" ;
    _txtUserDept.tag=0;
    _txtMaintDept.text=@"维保单位(全部)" ;
    _txtMaintDept.tag=0;
    _txtState.text=_stateAll ;//@"安装状态(全部)" ;
    _txtState.tag=0;
    
    txtPB.text= @"屏蔽状态(全部)";
    txtPB.tag=0;
    txtPBYY.text= @"屏蔽原因(全部)";
    txtPBYY.tag=0;
    _requestWhere=[[RequestWhere alloc]init];
}

@end
