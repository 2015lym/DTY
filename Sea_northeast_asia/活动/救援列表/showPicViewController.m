//
//  showPicViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/11/30.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "showPicViewController.h"

@interface showPicViewController ()
{
    EGOImageView *imageview;
}
@end

@implementation showPicViewController
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
//    [[self.tabBarController.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"图片";
    
     imageview=[[EGOImageView alloc]initWithFrame:CGRectMake(20, 20, bounds_width.size.width-40, bounds_width.size.height-180)];
    UIImage *_image=[UIImage imageNamed:@"no_photos.png"];
     imageview.image=_image;
    [self.view addSubview:imageview];
    
   
    UIButton *btn_picture=[MyControl createButtonWithFrame:CGRectMake(20, SCREEN_HEIGHT-54-64, SCREEN_WIDTH-40, 44) imageName:@"" bgImageName:@"" title:@"获取图片" SEL:@selector(btnClick_picture:) target:self];
    btn_picture.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    btn_picture.layer.masksToBounds = YES; //没这句话它圆不起来
    btn_picture.layer.cornerRadius = 8; //设置图片圆角的尺度
    [btn_picture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn_picture];
    if([[CommonUseClass FormatString: self.LiftId] isEqual:@""])
    {
        btn_picture.hidden=YES;
    }
    
    [self getPic ];
}

- (void)btnClick_picture:(UIButton *)btn
{
     [self doPic ];
}

-(void)doPic
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:@"8009" forKey:@"Command"];
    [dicHeader setValue:self.app.UM_deviceToken forKey:@"MobileSerialCode"];
    [dicHeader setValue:self.LiftId forKey:@"LiftId"];
    
    NSString *url=@"Equipments/RequestEquipmentPhotograph";
    
    [XXNet PostURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        
        if ([data[@"Success"]intValue]) {
            [self performSelectorOnMainThread:@selector(doOK:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(doErr:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        
        
        
    } failure:^(NSError *error) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:MessageResult
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)doErr:(NSString *)msg{
    [CommonUseClass showAlter:msg];
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)doOK:(NSString *)msg{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [self getPic ];
}

-(void)getPic
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:self.TaskId forKey:@"TaskId"];
    
    NSString *url=@"Equipments/GetEquipmentFile";
    
    [XXNet PostURL:url header:nil parameters:dicHeader succeed:^(NSDictionary *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if ([data[@"Success"]intValue]) {
            
            NSString *str_json = data [@"Data"];
            NSDictionary *dic = [str_json objectFromJSONString];
            
            [self performSelectorOnMainThread:@selector(getOK:) withObject:dic waitUntilDone:YES];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(doErr:) withObject:data[@"Message"] waitUntilDone:YES];
        }
        
        
        
    } failure:^(NSError *error) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:MessageResult
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)getOK:(NSDictionary *)dic{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *  _url=[CommonUseClass FormatString: dic[@"FileNmae"]];
    if(![_url isEqual:@""])
    {
        _url=[NSString stringWithFormat:@"%@%@", Ksdby_api_Img,_url];
        NSURL *url = [NSURL URLWithString:_url];
        imageview.imageURL=url;
        if(imageview.image==nil)
        {
            imageview.image=[UIImage imageNamed:@"no_photos.png"];
        }    
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
