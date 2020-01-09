//
//  WXShareViewController.m
//  AlumniChat
//
//  Created by SongQues on 16/6/6.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "WXShareViewController.h"
#import "WXApi.h"
@interface WXShareViewController ()

@end

@implementation WXShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
    [self viewLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewLoad{
    UIImageView *bgiamge=[[UIImageView alloc]initWithFrame:bounds_width];
    bgiamge.backgroundColor=[UIColor colorWithRed:80/255 green:80/255 blue:80/255 alpha:0.7];
    [self.view addSubview:bgiamge];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-240, self.view.frame.size.width, 240)];
    view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:view];
    

    
    btn_friends=[[UIButton alloc] initWithFrame:CGRectMake(80, 30, 40, 40)];
    [btn_friends addTarget:self action:@selector(btn_FriendsOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_friends setBackgroundImage:[UIImage imageNamed:@"share_friends.png"] forState:UIControlStateNormal];
    [view addSubview:btn_friends];
    
    UILabel *lab_friends=[[UILabel alloc] initWithFrame:CGRectMake(btn_friends.frame.origin.x-20, CGRectGetMaxY(btn_friends.frame)+5, 80, 24)];
    lab_friends.text=@"分享到好友";
    lab_friends.font=[UIFont systemFontOfSize:14];
    [lab_friends setTextColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]];
    lab_friends.textAlignment=NSTextAlignmentCenter;
    [view addSubview:lab_friends];
    
    
    btn_Circle=[[UIButton alloc] initWithFrame:CGRectMake(bounds_width.size.width-120, 30, 40, 40)];
    [btn_Circle addTarget:self action:@selector(btn_CircleOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn_Circle setBackgroundImage:[UIImage imageNamed:@"share_moments.png"] forState:UIControlStateNormal];
    [view addSubview:btn_Circle];
    
    UILabel *lab_circle=[[UILabel alloc] initWithFrame:CGRectMake(btn_Circle.frame.origin.x-30, CGRectGetMaxY(btn_Circle.frame)+5, 100, 24)];
    lab_circle.text=@"分享到朋友圈";
    lab_circle.font=[UIFont systemFontOfSize:14];
    [lab_circle setTextColor:[UIColor colorWithRed:168.f/255.f green:168.f/255.f blue:168.f/255.f alpha:1]];
    lab_circle.textAlignment=NSTextAlignmentCenter;
    [view addSubview:lab_circle];
    
    
    UILabel *lab_line=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn_Circle.frame)+60, bounds_width.size.width, 1)];
    [lab_line setBackgroundColor:[UIColor colorWithRed:238.f/255.f green:238.f/255.f blue:238.f/255.f alpha:1]];
    [view addSubview:lab_line];
    
    btn_Cancel=[[UIButton alloc] init];
    btn_Cancel.frame=CGRectMake(0, CGRectGetMaxY(lab_circle.frame)+40, bounds_width.size.width, 30);
    [btn_Cancel setTitle:@"取消" forState:UIControlStateNormal];
    [btn_Cancel setTitleColor:[UIColor colorWithRed:255.f/255.0f green:128.0f/255.0f blue:0.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    //    btn_Cancel.backgroundColor=[UIColor redColor];
    [btn_Cancel addTarget:self action:@selector(btn_CancelOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn_Cancel];
}

-(IBAction)btn_CancelOnClick:(id)sender
{
    [_wxshareDelegate btn_Cancel];
}
-(IBAction)btn_CircleOnClick:(id)sender
{
    //    视频分享：http://school.wenxueyou.com/video_detail_share.html?vcId=视频ID
    //    课程分享：http://school.wenxueyou.com/enroll_detail_share.html?enrollId=课程ID&type=学校类型
    if ([WXApi isWXAppInstalled]) {
        /*
        if ([_type isEqualToString:@"问答"])
        {
            _wxtitle=@"我在问学友里分享了一个问题";
             [self send_wxMseeage_Circlefriends: _shareurl];
        }
        else if ([_type isEqualToString:@"学友圈"])
        {
            _wxtitle=@"我在问学友里分享了一个动态";
            [self send_wxMseeage_Circlefriends: _shareurl];
        }
        */
        [self send_wxMseeage_Circlefriends: _shareurl];
    }
    else
    {
        NSLog(@"未安装微信");
    }
}
-(IBAction)btn_FriendsOnClick:(id)sender
{
    //if ([WXApi isWXAppInstalled]) {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
        /*
        if([_type isEqualToString:@"问答"])
        {
            _wxtitle=@"我在问学友里分享了一个问题";
            [self send_wxMseeage_Friends: _shareurl];
        }
        else if ([_type isEqualToString:@"学友圈"])
        {
            _wxtitle=@"我在问学友里分享了一个动态";
            [self send_wxMseeage_Friends: _shareurl];
        }
         */
        [self send_wxMseeage_Friends: _shareurl];
    }
    else
    {
        NSLog(@"未安装微信");
    }
    
    
}

-(UIImage *)getimage:(NSString *)url
{
    UIImage *image=[UIImage imageNamed:@"share_logo_108.png"];
    if(![url isEqualToString:@""])
    {
        image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        image=[self imageCompressForWidth:image targetWidth:120];
    }
    return image;
}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
CGSize imageSize = sourceImage.size;
CGFloat width = imageSize.width;
CGFloat height = imageSize.height;
CGFloat targetWidth = defineWidth;
    CGFloat targetHeight =defineWidth;// (targetWidth / width) * height;
UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
[sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
return newImage;
}

-(void)send_wxMseeage_Circlefriends:(NSString *)url
{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _wxtitle;
    message.description=_wxMemo;

    [message setThumbImage:[self getimage:_wxImage]];
    [message setMediaTagName:@"快搜东北亚"];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req=[[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}
-(void)send_wxMseeage_Friends:(NSString *)url
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =_wxtitle;
    message.description=_wxMemo;
    /*
    if([_type isEqualToString:@"问答"])
    {
        message.description=[NSString stringWithFormat:@"我在问学友提问了一个问题，快来帮我解答吧！"];
    }
    else if([_type isEqualToString:@"学友圈"])
    {
        message.description=[NSString stringWithFormat:@"我在问学友里发表了一个动态快来问学友看看吧！"];
    }
     */
   [message setThumbImage:[self getimage:_wxImage]];
    [message setMediaTagName:@"快搜东北亚"];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl =url;
    message.mediaObject = ext;
    SendMessageToWXReq* req=[[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}



@end
