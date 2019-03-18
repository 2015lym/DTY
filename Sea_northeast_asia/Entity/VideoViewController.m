//
//  VideoViewController.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/4/1.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "VideoViewController.h"
#import "XJAVPlayer.h"
#import "MyControl.h"
#import "Video.h"
#import "Video_2.h"
#import "HTTPSessionManager.h"

@interface VideoViewController () <XJAVPlayerDelegate>
{
    UIScrollView *bgScrollView;
    XJAVPlayer *myPlayer;
    
    UIImageView *imageView_1;
    UIImageView *imageView_2;
    UILabel *lab_1;
    UILabel *lab_2;
    UILabel *lab_3;
    UILabel *lab_4;
    UIButton *btn_1;
    UIButton *btn_2;
    UIView *view;
    UILabel *lab_5;
    UILabel *lab_6;
    UILabel *lab_7;
    UILabel *lab_8;
    UILabel *label_2;
    
    UILabel * lab_m;
    UILabel * lab_9;
}
@end

@implementation VideoViewController
@synthesize app;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [myPlayer pause];
    myPlayer = nil;
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    //self.view.backgroundColor=[UIColor colorWithRed:43/255.0 green:136/255.0 blue:207/255.0 alpha:1.0];
    self.navigationItem.title = @"查看详情";
    
    bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //bgScrollView.backgroundColor=[UIColor colorWithRed:43/255.0 green:136/255.0 blue:207/255.0 alpha:1.0];
    [self.view addSubview:bgScrollView];
    
    if (SCREEN_WIDTH==320) {
        bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+SCREEN_WIDTH/3);
    }else if (SCREEN_WIDTH==375){
        
    }else if (SCREEN_WIDTH==414){
        
    }else{
        bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
//    UIButton*leftButton=[[UIButton alloc] init];
//    leftButton.frame=CGRectMake(0,0,20,20);
//    [leftButton setImage:[UIImage imageNamed:@"cancelBtn"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    self.navigationItem.leftBarButtonItems = @[leftButtonItem];
    
    
    
        myPlayer = [[XJAVPlayer alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    myPlayer.delegate = self;
    myPlayer.xjPlayerUrl =_url;
    [bgScrollView addSubview:myPlayer];
    [myPlayer play];
    
    
//    // 播放本地视频
//    NSString *urlStr = @"file:///var/mobile/Containers/Data/Application/756170B2-0610-455C-ADE6-7DEB7B0E6533/Documents/video/2018-03-19-14-43-12-GMT-8.mp4";
//    NSURL *url = [NSURL fileURLWithPath:urlStr];
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
//    self.player = [AVPlayer playerWithPlayerItem:item];
//    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
//    layer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    [self.view.layer addSublayer:layer];
//    [self.player play];
    
        
    
   
    
//    //添加手势
//    UITapGestureRecognizer *Add_TapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(View_AddTap:)];
//    //将触摸事件添加到当前view
//    [self.view addGestureRecognizer:Add_TapGesture];
    
}
- (void)View_AddTap:(id)dateTap
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)leftButtonClick:(UIButton*)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
     [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - xjAVPlayer代理
- (void)nextXJPlayer
{
//    myPlayer.xjPlayerUrl = @"http://www.jxgbwlxy.gov.cn/tm/course/041629011/sco1/1.mp4";
}

- (void)xjPlayerFullOrSmall:(BOOL)flag{
    
    //如果xjPlayer的界面有导航栏或者有tabbar,在全屏代理方法里全屏时进行如下隐藏；
    if (flag) {
        
        imageView_1.hidden=YES;
        imageView_2.hidden=YES;
        lab_1.hidden=YES;
        lab_2.hidden=YES;
        lab_3.hidden=YES;
        lab_4.hidden=YES;
        btn_1.hidden=YES;
        btn_2.hidden=YES;
        view.hidden=YES;
        lab_5.hidden=YES;
        lab_6.hidden=YES;
        lab_7.hidden=YES;
        lab_8.hidden=YES;
        label_2.hidden=YES;
        lab_m.hidden=YES;
        lab_9.hidden=YES;
        
        //self.navigationController.navigationBarHidden = YES;
        //self.tabBarController.tabBar.hidden = YES;
    }else{
        
        imageView_1.hidden=NO;
        imageView_2.hidden=NO;
        lab_1.hidden=NO;
        lab_2.hidden=NO;
        lab_3.hidden=NO;
        lab_4.hidden=NO;
        btn_1.hidden=NO;
        btn_2.hidden=NO;
        view.hidden=NO;
        lab_5.hidden=NO;
        lab_6.hidden=NO;
        lab_7.hidden=NO;
        lab_8.hidden=NO;
        label_2.hidden=NO;
        lab_m.hidden=NO;
        lab_9.hidden=NO;
        
        self.navigationController.navigationBarHidden = NO;
        self.tabBarController.tabBar.hidden = YES;
    }
    
    if (flag) {
        /**
         *  全屏时隐藏顶部状态栏。由于iOS7.0后，如果你的plist文件已经设置View controller-based status bar appearance，value设为NO，就不用写下面的代码（我已经封装好）,如果没设置，就把下面的代码放开，就能在全屏时隐藏头部状态栏；
         */
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }else{
        //        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}





@end
