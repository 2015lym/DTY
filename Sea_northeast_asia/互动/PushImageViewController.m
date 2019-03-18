//
//  PushImageViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/26.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "PushImageViewController.h"
#import "JSONKit.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"

#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "AppDelegate.h"
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kTileWidth  64.f
#define kTileHeight 64.f
@interface PushImageViewController ()<TZImagePickerControllerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSString *str_unid;
}
@end

@implementation PushImageViewController
@synthesize Arr_image,isSelectOriginalPhotoEx,Arr_Assets;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView_imageList];
    UIImage *buttonBackgroundImage = [UIImage imageNamed:@"button01.png"];
    UIImage *buttonstretchedBackground = [buttonBackgroundImage stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [btn_Push setBackgroundImage:buttonstretchedBackground forState:UIControlStateNormal];
    [text_view addSubview:lab_Prompt];
    self.navigationItem.title=@"发布互动";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backgroundTap:(id)sender {
    [text_view resignFirstResponder];    
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
    
    //    text_view.frame=CGRectMake(0, view_text.frame.size.height+4, view_image.frame.size.width, view_image.frame.size.height);
    
    NSRange range;
    range = NSMakeRange (text_view.text.length, 1);
    [text_view scrollRangeToVisible: range];
    NSString *str=[Util deleteEmoji:text_view.text];
    if (str.length > 100)
    {
        NSString *toBeString = text_view.text;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [text_view markedTextRange];
            //获取高亮部分
            UITextPosition *position = [text_view positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 90) {
                    text_view.text = [toBeString substringToIndex:90];
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        
        return NO;
        
    }

    
    text=[Util deleteEmoji:text];
    NSString *str=[Util deleteEmoji:textView.text];
    if (1==range.length) {
        if (100>range.location) {
            return YES;
        }
    }
    if(100>range.location)
    {
        if (text.length+str.length>=100) {
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


#pragma mark 初始化图片视图
-(void)initView_imageList
{
    if (btn_Addimage==nil) {
        [self initBtn_AddImage];
    }
    for (UIView *item in [view_imageList subviews]) {
        [item removeFromSuperview];
    }
    for (int i=0;i<Arr_image.count;i++)
    {
        UIImage *image =[Arr_image objectAtIndex:i];
        UIImageView *imageV=[[UIImageView alloc] init];
        imageV.image=image;
        imageV.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.frame=[self createFrameLayoutTile:i];
        imageV.clipsToBounds = YES;
        
        UIButton *btn=[[UIButton alloc]init];
        btn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [btn addTarget:self action:@selector(Btn_PicturePreview_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=i;
        btn.frame=[self createFrameLayoutTile:i];
        btn.backgroundColor=[UIColor redColor];
        [view_imageList addSubview:btn];
        [view_imageList addSubview:imageV];
    }
    if (Arr_image.count<8) {
        btn_Addimage.frame=[self createFrameLayoutTile:Arr_image.count];
        [view_imageList addSubview:btn_Addimage];
        [btn_Addimage setHidden:NO];
    }
    else
    {
        [btn_Addimage setHidden:YES];
        btn_Addimage.frame=[self createFrameLayoutTile:7];
        [view_imageList addSubview:btn_Addimage];
    }
    CGRect rect1= view_imageList.frame;
    rect1.size.height=CGRectGetMaxY(btn_Addimage.frame)+10;
    view_imageList.frame=rect1;
    CGRect rect=btn_Push.frame;
    rect.origin.y=CGRectGetMaxY(view_imageList.frame)+20;
    btn_Push.frame=rect;
}
#pragma mark 计算图片出现的位置
- (CGRect)createFrameLayoutTile :(int)counter
{
    CGRect rect;
    int startY= 0;
    int startX=20;
    int row=(counter/4);
    int marginTop = startY+(row *(kTileHeight+8)) ;
    
    float interval=((bounds_width.size.width-startX*2)-kTileWidth*4)/3;
    if (counter % 4==0) {
        rect= CGRectMake(startX, marginTop,kTileWidth,kTileHeight);
    }
    else if (counter % 4==1)
    {
        rect= CGRectMake(startX+kTileWidth+interval, marginTop,kTileWidth,kTileHeight);
    }
    else if (counter % 4==2)
    {
        rect= CGRectMake(startX+(kTileWidth+interval)*2, marginTop,kTileWidth, kTileHeight);
    }
    else
    {
        rect= CGRectMake(startX+(kTileWidth+interval)*3, marginTop,kTileWidth, kTileHeight);
    }
    return rect;
}

#pragma mark 初始化添加图片按钮
-(void)initBtn_AddImage
{
    UIButton *btn=[[UIButton alloc]init];
    btn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
    [btn addTarget:self action:@selector(Btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"push_Addimage.png"] forState:UIControlStateNormal];
    btn_Addimage=btn;
}
//添加图片点击事件
-(IBAction)Btn_OnClick:(id)sender
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:8 delegate:self];
    imagePickerVc.isSelectOriginalPhoto = isSelectOriginalPhotoEx;
    imagePickerVc.selectedAssets = Arr_Assets; // optional, 可选的
    
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
-(IBAction)Btn_PicturePreview_OnClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:Arr_Assets selectedPhotos:Arr_image index:btn.tag];
    imagePickerVc.isSelectOriginalPhoto = isSelectOriginalPhotoEx;
    // imagePickerVc.allowPickingOriginalPhoto = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        Arr_image = [NSMutableArray arrayWithArray:photos];
        Arr_Assets = [NSMutableArray arrayWithArray:assets];
        isSelectOriginalPhotoEx = isSelectOriginalPhoto;
        [self initView_imageList];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate
#pragma mark 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}
#pragma mark 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    Arr_image = [NSMutableArray arrayWithArray:photos];
    Arr_Assets = [NSMutableArray arrayWithArray:assets];
    isSelectOriginalPhotoEx = isSelectOriginalPhoto;
    [self initView_imageList];
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
-(IBAction)btn_asdasd:(id)sender
{
    if([self stringContainsEmoji:text_view.text]==true)
    {
        [self initAlertViewEx:@"标题不允许输入表情符号！"];
        return;
    }
    if (text_view.text.length==0) {
        [self initAlertViewEx:@"请输入标题"];
        return;
    }
    [self uploadImageWithImage:0];
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

#pragma mark 上传图片
- (void)uploadImageWithImage:(int)Index {
    //截取图片
    if (Index==0) {
        [self inHUD];
        HUD.labelText = @"正在上传图片";
        str_unid = [self RandomGeneration];
    }
    UIImage * image=[Arr_image objectAtIndex:Index];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.001);
    NSDictionary *parameter;
    if (self.app.str_token!=nil) {
        parameter = @{@"access_token":self.app.str_token,@"unid":str_unid,@"flag":@"interact"};
    }
    else
    {
        [self initAlertView:@"是否登录？"];
        [HUD hide:YES];
        return;
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
        NSLog(@"第%i张图片 上传%f％",Index+1,progress.fractionCompleted*100);
        HUD.labelText = [NSString stringWithFormat:@"第%i张图片 上传%.2f％",Index+1,progress.fractionCompleted*100];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary* dic_result=[str_result objectFromJSONString];
        NSString *str_status=[dic_result objectForKey:@"status"];
        if ([str_status isEqualToString:@"OK"]) {
            if (Index+1<Arr_image.count) {
                [self uploadImageWithImage:Index+1];
            }
            else
            {
                NSLog(@"上传结束");
                [self pushDynamic];
                HUD.labelText =@"正在发布";
                
            }
        }
        else if([str_status isEqualToString:@"NG"])
        {
            NSString *str_message=[dic_result objectForKey:@"message"];
            NSLog(@"%@",str_message);
            if ([str_message isEqualToString:@"登录信息已失效！！"]) {
                 [self initAlertView:str_message];
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
#pragma mark 发布动态 apiDataByAccessToken.php
-(void)pushDynamic
{
    /* */
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    [dic_args setObject:self.app.str_token forKey:@"access_token"];
    [dic_args setObject:@"code" forKey:@"response_type"];
    [dic_args setObject:@"InteractImgType" forKey:@"redirect_uri"];
    NSMutableDictionary *dic_state=[NSMutableDictionary dictionary];
    [dic_state setObject:@"true" forKey:@"isToken"];
    NSMutableDictionary *dic_param=[NSMutableDictionary dictionary];
    [dic_param setObject:text_view.text forKey:@"title"];
    [dic_param setObject:str_unid forKey:@"unid"];
    [dic_param setObject:@"2" forKey:@"type"];
   
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
         NSString *str_status=[dic_result objectForKey:@"status"];
         if([str_status isEqualToString:@"OK"])
         {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh" object:self userInfo:nil];
             [super nav_back:nil];
             [HUD hide:YES];
         }
         [HUD hide:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         [HUD hide:YES];
    }];

}
#pragma mark 初始化等待
-(void)inHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    [HUD show:YES];
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

#pragma mark TOKEN验证是否失效
-(void)checkTOKEN
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if(super.app.str_token==nil ||[super.app.str_token isEqualToString:@""])
    {
        [self checkTOKEN_ERR];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        return;
    }

    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
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
            [self uploadImageWithImage:0];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
         else
         {
             [self checkTOKEN_ERR];
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
         }
         else
         {
             [self checkTOKEN_ERR];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         super.app.str_token=@"";
         NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
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
