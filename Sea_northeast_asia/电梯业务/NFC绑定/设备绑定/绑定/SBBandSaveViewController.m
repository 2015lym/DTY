//
//  SBBandSaveViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/8/30.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "SBBandSaveViewController.h"

@interface SBBandSaveViewController ()

@end

@implementation SBBandSaveViewController

@synthesize app;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.navigationItem.title=_Title;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self initWindow];
    [self InitPop];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

//点击空白-回收键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [tf resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initWindow{
    
    headview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 260)];
    [self.view addSubview:headview];
    
    //1标题60
    UIView * view_head1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 60)];
    view_head1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [headview addSubview:view_head1];
    
    //    UIImageView *img_head1=[MyControl createImageViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, 86) imageName:@"wbdc_bg"];
    //    [view_head1 addSubview:img_head1];
    
    UIImage *stopImage = [UIImage imageNamed:@"backArrow@2x"];
    UIImageView *stopImageView = [MyControl createImageViewWithFrame:CGRectMake(20, 30, stopImage.size.width, stopImage.size.height) imageName:nil];
    stopImageView.userInteractionEnabled=YES;
    stopImageView.image = stopImage;
    [view_head1 addSubview:stopImageView];
    
    UIButton *stop_Btn = [MyControl createButtonWithFrame:CGRectMake(0, 30, 60, 40) imageName:nil bgImageName:nil title:nil SEL:@selector(btnClick_stop:) target:self];
    [view_head1 addSubview:stop_Btn];
    
    UILabel * lab_head1=[MyControl createLabelWithFrame:CGRectMake(0, 30, bounds_width.size.width, 20) Font:18 Text:_Title];
    lab_head1.textAlignment = NSTextAlignmentCenter;
    lab_head1.textColor=[UIColor whiteColor];
    [view_head1 addSubview:lab_head1];
    
    //2电梯编号86
    UIView * view_head2=[[UIView alloc]initWithFrame:CGRectMake(0, 60, bounds_width.size.width, 60)];
    [headview addSubview:view_head2];
    
    UIImageView *img_head2=[MyControl createImageViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, 175) imageName:@"NFCBack"];
    [view_head2 addSubview:img_head2];
    
    
    //2.1
    UIImageView *img_head21=[MyControl createImageViewWithFrame:CGRectMake(20, 20, 23, 20) imageName:@"nfc_liftNum"];
    [view_head2 addSubview:img_head21];
    
    UILabel *dtBianHao = [MyControl createLabelWithFrame:CGRectMake(20+5+26, 20, bounds_width.size.width, 20) Font:16 Text:@"设备编号"];
    dtBianHao.textColor = [UIColor whiteColor];
    //dtBianHao.textAlignment = NSTextAlignmentCenter;
    [view_head2 addSubview:dtBianHao];
    
    dtBianHao_2 = [MyControl createLabelWithFrame:CGRectMake(130, 20, bounds_width.size.width, 20) Font:15 Text:nil];
    dtBianHao_2.textColor = [UIColor whiteColor];
    //dtBianHao_2.textAlignment = NSTextAlignmentCenter;
    
    NSString * LiftNum_show =[_liftNum stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dtBianHao_2.text=LiftNum_show;
    [view_head2 addSubview:dtBianHao_2];
    
    UILabel *dtLine = [MyControl createLabelWithFrame:CGRectMake(20, 45, bounds_width.size.width-40, 1) Font:14 Text:@""];
    dtLine.backgroundColor = [UIColor whiteColor];
    [view_head2 addSubview:dtLine];
    
    //1.2
    int newDiantiTag=1;//@"重新绑定电梯"
    NSString *newDiantiName=@"nfc_bandLift_re";
    if([[CommonUseClass FormatString: _liftID] isEqual:@""])//@"绑定电梯"
    {
        newDiantiTag=2;
        newDiantiName=@"nfc_bandLift";
    }
    btnNewDianti= [MyControl createButtonWithFrame:CGRectMake(bounds_width.size.width-90,18, 70, 25) imageName:nil bgImageName:newDiantiName title:nil SEL:@selector(btnClick_bandLift:) target:self];
    btnNewDianti.tag=newDiantiTag;
    [view_head2 addSubview:btnNewDianti];
    
    //3地址等69
    UIView * view_head3=[[UIView alloc]initWithFrame:CGRectMake(0, 106, bounds_width.size.width, 119)];
    [headview addSubview:view_head3];
    
    
    
    
    
    UILabel *dtWeiBao = [MyControl createLabelWithFrame:CGRectMake(20, 15, 80, 20) Font:14.0 Text:@"注册号码"];
    dtWeiBao.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiBao];
    
    
    dtWeiBao_2 = [MyControl createLabelWithFrame:CGRectMake(120, 15, SCREEN_WIDTH-90, 20) Font:14.0 Text:@""];
    _UploadDate = [_UploadDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    dtWeiBao_2.text=_UploadDate;
    dtWeiBao_2.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiBao_2];
    
    
    
    
    
    UILabel *dtWeiZhi = [MyControl createLabelWithFrame:CGRectMake(20, 40, 120, 20) Font:14 Text:@"电梯安装地址"];
    dtWeiZhi.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiZhi];
    
    dtWeiZhi_2 = [MyControl createLabelWithFrame:CGRectMake(120, 33, SCREEN_WIDTH- 120, 34) Font:14 Text:nil];
    dtWeiZhi_2.numberOfLines = 2;
    dtWeiZhi_2.textColor = [UIColor whiteColor];
    dtWeiZhi_2.text=_InstallationAddress;
    [view_head3 addSubview:dtWeiZhi_2];
    
    UILabel *dtWeiZhi_ms = [MyControl createLabelWithFrame:CGRectMake(20, 70, 120, 20) Font:14 Text:@"描述"];
    dtWeiZhi_ms.textColor = [UIColor whiteColor];
    [view_head3 addSubview:dtWeiZhi_ms];
    
    UILabel *dtWeiZhi_msV = [MyControl createLabelWithFrame:CGRectMake(120, 70, SCREEN_WIDTH- 120, 20) Font:14 Text:nil];
    dtWeiZhi_msV.numberOfLines = 2;
    dtWeiZhi_msV.textColor = [UIColor whiteColor];
    dtWeiZhi_msV.text=@"请确保电梯编号与注册号码的准确性";
    [view_head3 addSubview:dtWeiZhi_msV];
    
    //2
    sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 240, bounds_width.size.width, bounds_width.size.height-240)];
    sc.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sc];
    
    
}






- (void)btnClick_stop:(UIButton *)btn
{
    NSString *msg=MsgBack;
    // 1、初始化
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:msg message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    // 3、添加取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
    // 4、添加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    // 5、模态切换显示弹出框
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//////////////
-(void)InitPop{
    //蒙版
    view_Content_back=[MyControl createViewWithFrame:CGRectMake(0, 0, bounds_width.size.width, bounds_width.size.height) backColor:[UIColor blackColor]];
    view_Content_back.alpha = 0.5;// 阴影透明度
    [self.view addSubview:view_Content_back];
    
    
    view_Content_2=[MyControl createViewWithFrame:CGRectMake(10, 150, self.view.frame.size.width-20, 240) backColor:[UIColor whiteColor]];
    [self.view addSubview:view_Content_2];
    
    
    
    UIView *viewBack=[MyControl createViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 240) backColor:[UIColor whiteColor]];
    viewBack.alpha = 1;// 阴影透明度
    [view_Content_2 addSubview:viewBack];
    
    UILabel *selectLabel = [MyControl createLabelWithFrame:CGRectMake(0, 10, viewBack.frame.size.width, 20) Font:18 Text:@"输入电梯注册号码"];
    selectLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel.alpha=1.0;
    selectLabel.textAlignment = NSTextAlignmentCenter;
    [viewBack addSubview:selectLabel];
    
    tf=[MyControl createTextFildWithFrame:CGRectMake(20, CGRectGetMaxY(selectLabel.frame)+20, viewBack.frame.size.width-130-20, 40) Font:15 Text:@""];
    [tf.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    [tf.layer setBorderWidth:1];
    [viewBack addSubview:tf];
    
    //1.2
    UIButton *btn_select = [MyControl createButtonWithFrame:CGRectMake(viewBack.frame.size.width-120, CGRectGetMaxY(selectLabel.frame)+20, 50, 40) imageName:nil bgImageName:nil title:@"查询" SEL:@selector(btnClick_getLift:) target:self];
    [btn_select.layer setMasksToBounds:YES];
    [btn_select.layer setCornerRadius:5.0];
    [btn_select setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    btn_select.tag=200;
    [viewBack addSubview:btn_select];
    
    UIButton *btn_1 = [MyControl createButtonWithFrame:CGRectMake(viewBack.frame.size.width-60, CGRectGetMaxY(selectLabel.frame)+20, 60, 40) imageName:nil bgImageName:nil title:@"确定" SEL:@selector(btnClick_ReplaceTheElevator:) target:self];
    [btn_1.layer setMasksToBounds:YES];
    [btn_1.layer setCornerRadius:5.0];
    [btn_1 setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    btn_1.tag=200;
    [viewBack addSubview:btn_1];
    
    UILabel *selectLabel1 = [MyControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(btn_1.frame)+20, SCREEN_WIDTH-40, 20) Font:14 Text:@"提示:请输入当前电梯的准确注册号码"];
    selectLabel1.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel1.alpha=1.0;
    [viewBack addSubview:selectLabel1];
    
    //2.1
    UILabel *selectLabel_bh = [MyControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(selectLabel1.frame)+20,80, 20) Font:14 Text:@"电梯编号:"];
    selectLabel_bh.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel_bh.alpha=1.0;
    [viewBack addSubview:selectLabel_bh];
    
    selectLabel_bhvalue = [MyControl createLabelWithFrame:CGRectMake(90, CGRectGetMaxY(selectLabel1.frame)+20, SCREEN_WIDTH-100, 20) Font:14 Text:@""];
    selectLabel_bhvalue.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel_bhvalue.alpha=1.0;
    [viewBack addSubview:selectLabel_bhvalue];
    
    //2.2
    UILabel *selectLabel_dz = [MyControl createLabelWithFrame:CGRectMake(20, CGRectGetMaxY(selectLabel_bhvalue.frame)+20, 60, 20) Font:14 Text:@"地址:"];
    selectLabel_dz.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel_dz.alpha=1.0;
    [viewBack addSubview:selectLabel_dz];
    
    selectLabel_dzvalue = [MyControl createLabelWithFrame:CGRectMake(70, CGRectGetMaxY(selectLabel_bhvalue.frame)+10, SCREEN_WIDTH-80, 40) Font:14 Text:@""];
    selectLabel_dzvalue.textColor = [UIColor colorWithHexString:@"#333333"];
    selectLabel_dzvalue.alpha=1.0;
    [viewBack addSubview:selectLabel_dzvalue];
    
    [self hiddenPop];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboard:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [view_Content_back addGestureRecognizer:tapGestureRecognizer];
}
- (void)btnClick_bandLift:(UIButton *)btn
{
    view_Content_2.hidden=false;
    view_Content_back.hidden=false;
}
//点击空白-回收键盘
-(void)keyboard:(UITapGestureRecognizer*)tap
{
    [tf resignFirstResponder];
    [self hiddenPop];
}

-(void)hiddenPop{
    view_Content_2.hidden=YES;
    view_Content_back.hidden=YES;
}

- (void)btnClick_ReplaceTheElevator:(UIButton *)btn
{
    if(tf.text.length<=0)
    {
        [CommonUseClass showAlter:@"请输入注册号码!"];
        return;
    }
    if(tf.text.length!=20)
    {
        [CommonUseClass showAlter:@"请输入准确的注册号码!"];
        return;
    }
    [self getSchoolCourse_bandLift];
    
}

-(void)getSchoolCourse_bandLift
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    //    [dicHeader setValue:_liftNum forKey:@"LiftNum"];
    //    [dicHeader setValue:tf.text forKey:@"CertificateNum"];
    NSString *url=@"Equipments/ReplacEequipment";
    url=[NSString stringWithFormat:@"%@?deviceNum=%@&CertificateNum=%@",url,_liftNum,tf.text];
    
    [XXNet GetURL:url header:nil parameters:nil succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(bandLiftOK:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(dd:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        
        
        
    } failure:^(NSError *error) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"绑定失败！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)dd:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)bandLiftOK:(NSString *)msg{
    [CommonUseClass showAlter:msg];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [self gotoDetail ];
}


-(void)gotoDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:_liftNum forKey:@"deviceNum"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    NSString *url=[NSString stringWithFormat:@"Equipments/GetLiftEequipment?deviceNum=%@",_liftNum];
    [XXNet GetURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[CommonUseClass FormatString: data[@"Message"]] isEqual:@"操作成功"]) {
            
            NSString *str_json = data [@"Data"];
            NSArray *arrData = [str_json objectFromJSONString];
            if(arrData.count>0)
            {
                NSMutableDictionary *dic=(NSMutableDictionary *)arrData;
                _UploadDate=[CommonUseClass FormatString:dic [@"CertificateNum"]];
                
                NSString *path=[CommonUseClass FormatString: dic [@"AddressPath"]];
                _InstallationAddress=[CommonUseClass FormatString: dic [@"InstallationAddress"]];
                _InstallationAddress = [path stringByAppendingString:_InstallationAddress];
                
                _liftID=[dic objectForKey:@"LiftID"];
                
                
                [self performSelectorOnMainThread:@selector(reBand:) withObject:data[@"Message"] waitUntilDone:YES];
                
            }
            else
            {
                [self performSelectorOnMainThread:@selector(dd:) withObject:SysDataError waitUntilDone:YES];
            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(dd:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"查询失败！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

- (void)reBand:(NSString *)msg{
    [self hiddenPop];
    tf.text=@"";
    
    [btnNewDianti setBackgroundImage:[UIImage imageNamed:@"nfc_bandLift_re"] forState:UIControlStateNormal];
    dtWeiBao_2.text=_UploadDate;
    dtWeiZhi_2.text=_InstallationAddress;
    
    [tf resignFirstResponder];
    [sc.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
}
//getlift
- (void)btnClick_getLift:(UIButton *)btn
{
    if(tf.text.length<=0)
    {
        [CommonUseClass showAlter:@"请输入注册号码!"];
        return;
    }
    if(tf.text.length!=20)
    {
        [CommonUseClass showAlter:@"请输入准确的注册号码!"];
        return;
    }
    
    [self GetLift];
}
-(void)GetLift
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:tf.text forKey:@"CertificateNum"];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    NSString *url=[NSString stringWithFormat:@"Lift/GetLiftByCertificateNum?CertificateNum=%@",tf.text];
    [XXNet GetURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[CommonUseClass FormatString: data[@"Message"]] isEqual:@"操作成功"]) {
            
            NSString *str_json = data [@"Data"];
            NSDictionary *dic = [str_json objectFromJSONString];
            [self performSelectorOnMainThread:@selector(showLift:) withObject:dic waitUntilDone:YES];
            
        }
        else
        {
            [CommonUseClass showAlter:data[@"Message"]];
        }
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    } failure:^(NSError *error) {
        
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"查询失败！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}

- (void)showLift:(NSDictionary *)dic{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    selectLabel_bhvalue.text=[CommonUseClass FormatString:dic [@"LiftNum"]];
    
    NSString *path=[CommonUseClass FormatString: dic [@"AddressPath"]];
    NSString *dz=[CommonUseClass FormatString: dic [@"InstallationAddress"]];
    dz = [path stringByAppendingString:dz];
    selectLabel_dzvalue.text=dz;
}
@end
