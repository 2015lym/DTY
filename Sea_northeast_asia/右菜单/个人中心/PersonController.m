//
//  PersonController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/7/25.
//  Copyright © 2016年 SongQues. All rights reserved.
//
#import "LoginViewController.h"
#import "PersonController.h"
#import "PersonChangePWDViewController.h"
#import "PersonChangeNikenameViewController.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
@interface PersonController ()<TZImagePickerControllerDelegate>
{
    MBProgressHUD *HUD;
}

@end

@implementation PersonController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIButton *left_BarButoon_Item=[[UIButton alloc] init];
    left_BarButoon_Item.frame=CGRectMake(0, 0,22,22);
    [left_BarButoon_Item setImage:[UIImage imageNamed:@"navback.png"] forState:UIControlStateNormal];
    [left_BarButoon_Item addTarget:self action:@selector(navLeftBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:left_BarButoon_Item];
    self.navigationItem.leftBarButtonItem=leftItem;
    self.navigationItem.title=@"个人资料";
    

    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"button01.png"];
    UIImage *buttonstretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [btnOutLine setBackgroundImage:buttonstretchedBackground forState:UIControlStateNormal];
 
}
-(void)navLeftBtn_Event:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(IBAction)Btn_Cancellation_OnClick:(id)sender{
    
    [self outLine];
}
-(void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:YES];
    
    
    /*
    app.userInfo.nikename=@"nikename";
    app.userInfo.pwd=@"pwd";
    app.userInfo.uhead=@"http://192.168.1.111:8102/serverUpload/header_default.png";
    */
    if(![app.str_token isEqualToString: @""])
    {
        
        nikeName.text=app.userInfo.nikename;
        password.text=@"******";//app.userInfo.pwd;
        
        NSString *URL = app.userInfo.uhead;
        NSString *str_url=[NSString stringWithFormat:@"%@",URL];
        NSURL *imageurl=[NSURL URLWithString:str_url];
        uhead.imageURL=imageurl;
        [uhead setContentScaleFactor:[[UIScreen mainScreen] scale]];
        uhead.contentMode =  UIViewContentModeScaleAspectFill;
        uhead.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        CGRect rect_head= uhead.frame;
        rect_head.size=CGSizeMake(46, 46);
        [uhead setFrame:rect_head];
        uhead.layer.masksToBounds = YES; //没这句话它圆不起来
        uhead.layer.cornerRadius = 23;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 注销
-(void)outLine
{
    // 1、初始化
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注销帐户"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    
   
    
    
    
    // 3、添加取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          // 此处处理点击取消按钮逻辑
                                                      }]];
    
    
    // 4、添加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"注销"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          self.app.str_token=nil;
                                                          NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
                                                          [dic_oAuth removeObjectForKey:@"str_token"];
                                                          [dic_oAuth removeObjectForKey:@"username"];
                                                          [dic_oAuth removeObjectForKey:@"nikename"];
                                                          [dic_oAuth removeObjectForKey:@"pwd"];
                                                          [dic_oAuth removeObjectForKey:@"uhead"];

                                                          
                                                          
                                                          
                                                          [app.userInfo setUserInfo:@"" forNikename:@"" forpwd:@"" forhead:@""];
                                                          [self dismissViewControllerAnimated:YES completion:^{
                                                              
                                                          }];

                                                      }]];
    
    // 5、模态切换显示弹出框
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
    
    
    
    
    
}


- (IBAction)btnNikename1:(id)sender {
    PersonChangeNikenameViewController *registerVC=[[PersonChangeNikenameViewController alloc] initWithNibName:[Util GetResolution:@"PersonChangeNikenameViewController"] bundle:nil];
    //RegisterViewController *registerVC=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (IBAction)btnPWD1:(id)sender {
    PersonChangePWDViewController *registerVC=[[PersonChangePWDViewController alloc] initWithNibName:[Util GetResolution:@"PersonChangePWDViewController"] bundle:nil];
    //RegisterViewController *registerVC=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//添加图片点击事件
-(IBAction)Btn_OnClick:(id)sender
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.selectedAssets = [NSMutableArray array]; // optional, 可选的
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    // Set the appearance
    // 在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.barTintColor = NAV_BACKGROUNDCOLOR;
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    
    // Set allow picking video & photo & originalPhoto or not
    // 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    // imagePickerVc.allowPickingImage = NO;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}
#pragma mark 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {

    UIImage *currimage=[photos objectAtIndex:0];
    //[self uploadImageWithImage:currimage];
    [self checkTOKEN:currimage];
}

#pragma mark 初始化等待
-(void)inHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
//    HUD.delegate = self;
    HUD.labelText = @"";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    [HUD show:YES];
}

#pragma mark TOKEN验证是否失效
-(void)checkTOKEN:(UIImage *)currimage
{
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
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
         if([str_result isEqualToString:@"[]"])
         {
             [self tokanError];
             return;
         }
         
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *status=[dic_result objectForKey:@"status"];
         NSString *message=[dic_result objectForKey:@"message"];
         
         if(message!=nil&&[message isEqualToString:@"token验证成功！"])
         {
             [self uploadImageWithImage:currimage];
         }
         else
         {
             [self tokanError];
             NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
             [dic_oAuth removeObjectForKey:@"str_token"];
             [dic_oAuth removeObjectForKey:@"username"];
             [dic_oAuth removeObjectForKey:@"nikename"];
             [dic_oAuth removeObjectForKey:@"pwd"];
             [dic_oAuth removeObjectForKey:@"uhead"];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
        [self tokanError];
     }];
    
}

-(void)tokanError
{
    app.str_token=@"";
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                  message:@"登录信息已过期，请重新登录！"
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
    [self loginMethod];
}

#pragma mark 弹出登录页面
-(void)loginMethod{
    
    //LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:[Util GetResolution:@"LoginViewController" ] bundle:nil];
    LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav_loginVC=[[ UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav_loginVC animated:YES completion:^{
        
    }];
}


#pragma mark 上传图片
- (void)uploadImageWithImage:(UIImage *)image {
    //截取图片
    if (image!=nil) {
        [self inHUD];
        HUD.labelText = @"正在上传图片";
    }
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    NSDictionary *parameter;
    if (self.app.str_token!=nil) {
        parameter = @{@"access_token":self.app.str_token,@"unid":[self RandomGeneration],@"flag":@"header"};
    }

    [[AFAppDotNetAPIClient sharedClient] POST:@"index.php/InteractImg/UploadImgClass" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat            = @"yyyyMMddHHmmss";
        NSString *str                         = [formatter stringFromDate:[NSDate date]];
        NSString *fileName               = [NSString stringWithFormat:@"%@.jpg", str];
        
        [formData appendPartWithFileData:imageData name:@"pics" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSProgress *progress = (NSProgress *)uploadProgress;
        NSLog(@"上传%f％",progress.fractionCompleted*100);
        HUD.labelText = [NSString stringWithFormat:@"上传头像"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary* dic_result=[str_result objectFromJSONString];
        NSString *str_status=[dic_result objectForKey:@"status"];
        if ([str_status isEqualToString:@"OK"]) {
                NSLog(@"上传结束");
                [HUD hide:YES];
            NSDictionary* dic_result_ex=[dic_result objectForKey:@"result"];
            NSString *str_head=[dic_result_ex objectForKey:@"headerImage"];
            app.userInfo.uhead=str_head;
            NSURL *imageurl=[NSURL URLWithString:str_head];
            uhead.imageURL=imageurl;

        }
        else if([str_status isEqualToString:@"NG"])
        {
            NSString *str_message=[dic_result objectForKey:@"message"];
            NSLog(@"%@",str_message);
            if ([str_message isEqualToString:@"登录信息已失效！！"]) {
                
            }
            [HUD hide:YES];
        }
        
        NSLog(@"%@",str_result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUD hide:YES];
    }];
}
-(NSString *)RandomGeneration
{
    NSArray *arr_list=[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    NSString *str_value=@"";
    for (int i=0;i<32; i++) {
        int value =arc4random() % 36;
        NSString *str_item= [arr_list objectAtIndex:value];
        str_value=[str_value stringByAppendingFormat:@"%@",str_item];
    }
    
    return str_value;
}

@end
