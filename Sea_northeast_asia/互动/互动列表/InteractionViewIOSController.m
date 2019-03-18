//
//  InteractionViewIOSController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "InteractionViewIOSController.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kRestOfHeight (kHeight - 64 - 49 )
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PushImageViewController.h"
#import "PushTextViewController.h"
@interface InteractionViewIOSController ()<TZImagePickerControllerDelegate>
{
    NSMutableArray * _selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
}
@end

@implementation InteractionViewIOSController

- (void)viewDidLoad {
    [super viewDidLoad];
    return;
    // Do any additional setup after loading the view.
    [self addscvc];
    //添加消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"Refresh" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[self.tabBarController.navigationController.navigationBar viewWithTag:10000] removeFromSuperview];
    self.tabBarController.navigationItem.title=@"互动";
    
}


-(void)addscvc
{
    scvc=[[InteractionCourseViewController alloc] init];
    scvc.tag=@"-1";
    scvc.view.tag=-1;
    //scvc.dic_school_info=dic_school_info;
    scvc.delegate=self;
    CGRect rect= scvc.view.frame;
    //rect=CGRectMake(kWidth*2, 0, kWidth, kRestOfHeight);
    rect=CGRectMake(0, 0, kWidth, kRestOfHeight);
    [scvc.view setFrame:rect];
    //[firstCollection addSubview:scvc.view];
    [view_Conout addSubview:scvc.view];
}

#pragma 弹出名细页面
-(void)SchoolCoursePush:(UIViewControllerEx *)vc
{
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)navRightBtn_Event
{
    [self checkTOKEN];
}
#pragma mark TOKEN验证是否失效
-(void)checkTOKEN
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
             NSString *message=[dic_result objectForKey:@"message"];
             
             if(message!=nil&&[message isEqualToString:@"token验证成功！"])
             {
                 UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil  otherButtonTitles:@"照片",@"纯文本",nil];
                 actionSheet.tag=1001;
                 [actionSheet showInView:self.view];
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

#pragma mark 弹出登录页面
-(void)loginMethod{
    
    //LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:[Util GetResolution:@"LoginViewController" ] bundle:nil];
    LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav_loginVC=[[ UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav_loginVC animated:YES completion:^{
        
    }];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1001) {
        switch (buttonIndex) {
            case 0:
            {
                [self pickPhotoButtonClick];
            }
                break;
            case 1:
            {
                PushTextViewController *ptvc=[[PushTextViewController alloc] initWithNibName:[Util GetResolution:@"PushTextViewController"] bundle:nil];
                [self.tabBarController.navigationController pushViewController:ptvc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark 获取照片列表

- (void)pickPhotoButtonClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:8 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
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
#pragma mark TZImagePickerControllerDelegate
#pragma mark 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}
#pragma mark 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    PushImageViewController *ptvc=[[PushImageViewController alloc] initWithNibName:[Util GetResolution:@"PushImageViewController"] bundle:nil];
    ptvc.Arr_image=[NSMutableArray arrayWithArray:photos];
    ptvc.Arr_Assets=[NSMutableArray arrayWithArray:assets];
    [self.tabBarController.navigationController pushViewController:ptvc animated:YES];
}
#pragma mark 用户选择好了视频
/*
 - (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
 _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
 _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
 _layout.itemCount = _selectedPhotos.count;
 // open this code to send video / 打开这段代码发送视频
 // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
 // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
 // Export completed, send video here, send by outputPath or NSData
 // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
 
 // }];
 [_collectionView reloadData];
 _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
 }
 */
#pragma mark NotificationCenter method
-(void)notificationAction:(NSNotification *)notification{
    [scvc getSchoolCourse];
}
@end
