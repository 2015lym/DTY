//
//  NFCMainViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/8/30.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "NFCMainViewController.h"
#import "MyControl.h"
@interface NFCMainViewController ()

@end

@implementation NFCMainViewController
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden =  NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"设备绑定";
    self.view.backgroundColor=[UIColor whiteColor];
    [self addControl:@"标牌绑定" fortop:0 forTag:1];
    [self addControl:@"一键通绑定" fortop:44 forTag:2];
     [self addControl:@"视频机绑定" fortop:44*2 forTag:3];
     [self addControl:@"四维监控绑定" fortop:44*3 forTag:4];
     [self addControl:@"标签初始化" fortop:44*4 forTag:5];
     [self addControl:@"读取标签" fortop:44*5 forTag:6];
}
- (void)addControl:(NSString *)name fortop :(int)top forTag:(int)tag{
    UIView *view=[MyControl createViewWithFrame:CGRectMake(0, top, bounds_width.size.width, 44) backColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    
    UILabel *labName=[MyControl createLabelWithFrame:CGRectMake(10, 10, 200, 23) Font:15 Text:@""];
    labName.textColor=[UIColor lightGrayColor];
    [view addSubview:labName];
    labName.text=name;
    
    UIImageView *img=[MyControl createImageViewWithFrame:CGRectMake(bounds_width.size.width-30, 12, 20, 20) imageName:@"ic_arrow_right"];
    [view addSubview:img];
    
    UILabel *line=[MyControl createLabelWithFrame:CGRectMake(0, 43, bounds_width.size.width, 1) Font:18 Text:@""];
    line.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:line];
    
    UIButton * btncall = [MyControl createButtonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) imageName:nil bgImageName:nil title:@"" SEL:@selector(btncallClick:) target:self];
    [view addSubview:btncall];
    btncall.tag=tag;
}
//主叫
- (void)btncallClick:(UIButton*)sender {
    if(sender.tag==1)
    {
        //标牌绑定
        NFCListViewController *ctvc=[[NFCListViewController alloc] init];
        ctvc.web_url=@"/WebApp/NFC/Index?userid=";
        ctvc.web_title=@"标牌绑定";
        [self.navigationController pushViewController:ctvc animated:YES];
    }
    else if(sender.tag==2)
    {
        QRCodeViewController_sbband *cdvc=[[QRCodeViewController_sbband alloc] init];// initWithNibName:@"QRCodeViewController_JX" bundle:nil];
        cdvc.Type_ID = @"2";
        cdvc.companyType=@"Ios_ESL_XJLXQYXC";
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:cdvc animated:YES];
    }
    else if(sender.tag==3)
    {
        //视频机绑定
        QRCodeViewController_SPJ * cdvc=[[QRCodeViewController_SPJ alloc] initWithNibName:@"QRCodeViewController_JX" bundle:nil];
        cdvc.Type_ID = @"2";
        cdvc.companyType=@"Ios_ESL_XJLXQYXC";
        self.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:cdvc animated:YES];
    }
    else if(sender.tag==4)
    {
        SWJKBandSaveViewController *ctvc=[[SWJKBandSaveViewController alloc] init];
        ctvc.Title=@"四维监控绑定";
        [self.navigationController pushViewController:ctvc animated:YES];
    }
    else if(sender.tag==5)
    {
        NFCSBNewViewController *vc=[[NFCSBNewViewController alloc]init];
        vc.Title= @"标签初始化";
        vc.type=@"write";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(sender.tag==6)
    {
        readBQViewController *vc=[[readBQViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
