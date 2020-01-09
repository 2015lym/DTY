//
//  SWJKViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "SWJKViewController.h"
#import "MyControl.h"
#import "NFCMainViewController.h"
#import "AddPeopleViewController.h"
#import "SBTSViewController.h"
#import "NFCSBNewViewController.h"
#import "PJGLListViewController.h"
@interface SWJKViewController ()

@end

@implementation SWJKViewController
@synthesize app;
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;// NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    UIView *V1=[[UIView alloc]init];
    V1.frame=CGRectMake(0, 0, bounds_width.size.width, 66);
    V1.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    [self.view addSubview:V1];
    
    UILabel *lab=[MyControl createLabelWithFrame:CGRectMake(0, 10, bounds_width.size.width, 56) Font:18 Text:@"智慧电梯管理平台"];
    lab.backgroundColor=[UIColor colorWithHexString:@"#3574fa"];
    lab.textColor=[UIColor whiteColor];
    lab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview: lab];
    
    int oldHeight=66;
    int defaltHeight=66;
    
    
    float height=(bounds_width.size.height-48-66)/5;
    float width=(bounds_width.size.width)/2;
    [self addButton4:0 forTop:defaltHeight+0 forWidth:width forHeight:height forName:@"四维监控"  forName1:@"Four-Dimensional Monitoring" forTag:1 forIcon:@"swjk_swjk.png"];
   [self addButton4:width forTop:defaltHeight+0 forWidth:width forHeight:height forName:@"设备调试"  forName1:@"Debugging Of Equipment" forTag:2 forIcon:@"swjk_sbts.png"];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(0,defaltHeight+ height, bounds_width.size.width, 1) ];
    line1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line1];
    
    defaltHeight=defaltHeight+height;
    [self addButton4:0 forTop:defaltHeight+0 forWidth:width forHeight:height forName:@"视频通话"  forName1:@"Video Call" forTag:3 forIcon:@"swjk_spth.png"];
    [self addButton4:width forTop:defaltHeight+0 forWidth:width forHeight:height forName:@"设备绑定"  forName1:@"Equipment Binding" forTag:0 forIcon:@"swjk_sbbd.png"];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(0, defaltHeight+ height, bounds_width.size.width, 1) ];
    line2.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line2];
    
    //3
    defaltHeight=defaltHeight+height;
    [self addButton4:0 forTop:defaltHeight+0 forWidth:width forHeight:height forName:@"配件管理"  forName1:@"Parts Management" forTag:5 forIcon:@"swjk_pjgl.png"];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(0, defaltHeight+ height, bounds_width.size.width, 1) ];
    line3.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line3];
    
//    defaltHeight=defaltHeight+height;
//    [self addButton4:0 forTop:defaltHeight+0 forWidth:width forHeight:height forName:@"video"  forName1:@"video" forTag:999 forIcon:@"nfcBand.png"];
//
//
//    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(0, defaltHeight+ height, bounds_width.size.width, 1) ];
//    line3.backgroundColor=[UIColor groupTableViewBackgroundColor];
//    [self.view addSubview:line3];

    
    UILabel *line_su=[[UILabel alloc]initWithFrame:CGRectMake(width, oldHeight, 1, height*3) ];
    line_su.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line_su];
    
}
- (void)addButton4:(float)left forTop:(float)top forWidth:(float)width forHeight:(float)height forName:(NSString *)name  forName1:(NSString *)name1 forTag:(int)tag forIcon:(NSString*)imageName {
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(left, top, width, height);
    [self .view addSubview:view];
    
    UIButton *image=[[UIButton alloc]init];
    image.frame=CGRectMake((width-40)/2, 10, 40, 40);
    //    image.backgroundColor=[UIColor cyanColor];
//    image.layer.masksToBounds = YES; //没这句话它圆不起来
//    image.layer.cornerRadius = 20; //设置图片圆角的尺度
    [image setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [view addSubview:image];
    
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(0, 55, width, 20);
    label.text=name;
    label.font=[UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithHexString:@"#3574fa"];
    [view addSubview:label];
    
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=CGRectMake(0, 75, width, 20);
    label1.text=name1;
    label1.font=[UIFont systemFontOfSize:11];
    label1.textColor=[UIColor grayColor];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    
    UIButton *button=[[UIButton alloc]init];
    button.frame=CGRectMake(0, 0, width, height);
    [button addTarget:self action:@selector(button_Event:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=tag;
    [view  addSubview:button];
}

- (IBAction)button_Event:(id)sender {
    UIButton *btn=(UIButton *)sender;
    if(btn.tag==0) {       
        //标牌绑定
        NFCMainViewController *ctvc=[[NFCMainViewController alloc] init];
        [self.navigationController pushViewController:ctvc animated:YES];
    }
    else if(btn.tag==1)
    {
        PhysicalUnionWebVC *physical = [[PhysicalUnionWebVC alloc]init];
        physical.web_url=@"/WebApp/FourMonitoring/Index?userid=";
        physical.web_title=@"四维监控";
        [self.navigationController pushViewController:physical animated:YES];
    }
    
    else if(btn.tag==2) {
//        设备调试
        SBTSViewController *physical = [[SBTSViewController alloc]init];
        [self.navigationController pushViewController:physical animated:YES];
    }
    

    else if(btn.tag==3) {
//                //test
//                videoMainViewController *ctvc=[[videoMainViewController alloc] init];
//                [self.navigationController pushViewController:ctvc animated:YES];
        AddPeopleViewController *vc = [[AddPeopleViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if(btn.tag==5)
    {
        PJGLListViewController *physical = [[PJGLListViewController alloc]init];
        physical.web_url=@"/WebApp/CheckParts/LiftParts?userid=";
        physical.web_title=@"配件管理";
        [self.navigationController pushViewController:physical animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
