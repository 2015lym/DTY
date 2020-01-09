//
//  WZHMainViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/11.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "WZHMainViewController.h"
#import "MyControl.h"
@interface WZHMainViewController ()

@end

@implementation WZHMainViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden =  NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"无纸化维保";
    self.view.backgroundColor=[UIColor whiteColor];
    [self addControl:@"电梯维保" fortop:0 forTag:1];
    [self addControl:@"超期电梯" fortop:44 forTag:2];
    [self addControl:@"停梯申请" fortop:44*2 forTag:3];
    
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
        DTWBWebViewController_WZH *physical = [[DTWBWebViewController_WZH alloc]init];
        physical.web_url=@"/WebApp/NFCMaintenance/Index?userid=";
        physical.web_title=@"无纸化维保";
        [self.navigationController pushViewController:physical animated:YES];
    }
    else if(sender.tag==2)
    {
        PhysicalUnionWebVC *physical = [[PhysicalUnionWebVC alloc]init];
        physical.web_url=@"/WebApp/OverdueLift/index?userid=";
        physical.web_title=@"超期电梯";
        [self.navigationController pushViewController:physical animated:YES];
    }
    else if(sender.tag==3)
    {
        PhysicalUnionWebVC *physical = [[PhysicalUnionWebVC alloc]init];
        physical.web_url=@"/WebApp/StopLift/Index?UserId=";
        physical.web_title=@"停梯申请";
        [self.navigationController pushViewController:physical animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
