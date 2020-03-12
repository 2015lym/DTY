//
//  LiftBusinessViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/18.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "LiftBusinessViewController.h"
#import "BJYLWViewController.h"
#import "DTWBViewController.h"
#import "JYGLViewController.h"
#import "RepairRecordVC.h"
#import "ShieldingManagerVC.h"
#import "PhysicalUnionVC.h"
#import "AloneWBListVC.h"
#import "JYGLListWebViewController.h"
#import "PhysicalUnionWebVC.h"
@interface LiftBusinessViewController ()

@end

@implementation


LiftBusinessViewController
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
    
    int defaltHeight=66;
    
    float height=(bounds_width.size.height-48-66)/5;
    float width=(bounds_width.size.width)/2;
    [self addButton4:0 forTop:defaltHeight+0 forWidth:width forHeight:height forName:@"电梯维保"  forName1:@"Elevator maintenance" forTag:0 forIcon:@"dtwb_48dp.png"];
    [self addButton4:width forTop:defaltHeight+0 forWidth:width forHeight:height forName:@"维修记录"  forName1:@"Maintenance record" forTag:1 forIcon:@"records.png"];
    [self addButton4:0 forTop:defaltHeight+height forWidth:width forHeight:height forName:@"电梯年检"  forName1:@"Inspection management" forTag:2 forIcon:@"jygl_48dp.png"];
    [self addButton4:width forTop:defaltHeight+height forWidth:width forHeight:height forName:@"报警仪联网"  forName1:@"Alarm network" forTag:3 forIcon:@"bjylw_48dp.png"];
    [self addButton4:0 forTop:defaltHeight+height*2 forWidth:width forHeight:height forName:@"检测服务"  forName1:@"Shielding service" forTag:4 forIcon:@"pbgl_48dp.png"];
    [self addButton4:width forTop:defaltHeight+height*2 forWidth:width forHeight:height forName:@"物联监控"  forName1:@"Monitor" forTag:5 forIcon:@"wljk_48dp.png"];
    [self addButton4:0 forTop:defaltHeight+height*3 forWidth:width forHeight:height forName:@"无纸化维保"  forName1:@"Paperless maintenance" forTag:6 forIcon:@"dtwb_wzh.png"];
    [self addButton4:width forTop:defaltHeight+height*3 forWidth:width forHeight:height forName:@"预警分析"  forName1:@"Warning analysis" forTag:7 forIcon:@"analysis.png"];
    [self addButton4:0 forTop:defaltHeight+height*4 forWidth:width forHeight:height forName:@"通知通告"  forName1:@"Notice" forTag:8 forIcon:@"tzgg_48dp.png"];
    [self addButton4:width forTop:defaltHeight+height*4 forWidth:width forHeight:height forName:@"投诉建议"  forName1:@"Complaint proposal" forTag:9 forIcon:@"tsjy_48dp.png"];
    
    UILabel *line1=[[UILabel alloc]initWithFrame:CGRectMake(0,defaltHeight+ height, bounds_width.size.width, 1) ];
    line1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line1];
    
    UILabel *line2=[[UILabel alloc]initWithFrame:CGRectMake(0, defaltHeight+ height*2, bounds_width.size.width, 1) ];
    line2.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line2];
    
    UILabel *line3=[[UILabel alloc]initWithFrame:CGRectMake(0, defaltHeight+ height*3, bounds_width.size.width, 1) ];
    line3.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line3];
    
    UILabel *line4=[[UILabel alloc]initWithFrame:CGRectMake(0, defaltHeight+ height*4, bounds_width.size.width, 1) ];
    line4.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line4];
    
    UILabel *line_su=[[UILabel alloc]initWithFrame:CGRectMake(width, defaltHeight+ 0, 1, bounds_width.size.height) ];
    line_su.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:line_su];

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
- (void)addButton4:(float)left forTop:(float)top forWidth:(float)width forHeight:(float)height forName:(NSString *)name  forName1:(NSString *)name1 forTag:(int)tag forIcon:(NSString*)imageName {
    UIView *view=[[UIView alloc]init];
    view.frame=CGRectMake(left, top, width, height);
    [self .view addSubview:view];
    
    UIButton *image=[[UIButton alloc]init];
    image.frame=CGRectMake((width-40)/2, 10, 40, 40);
    //    image.backgroundColor=[UIColor cyanColor];
    image.layer.masksToBounds = YES; //没这句话它圆不起来
    image.layer.cornerRadius = 20; //设置图片圆角的尺度
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
    label1.font=[UIFont systemFontOfSize:12];
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
        //电梯维保
        if (app.userInfo.RoleId.intValue == 12 || app.userInfo.RoleId.intValue == 13) {
            AloneWBListVC *awblist = [[AloneWBListVC alloc]init];
            [self.navigationController pushViewController:awblist animated:YES];
        }
        else {
//            DTWBViewController *ctvc=[[DTWBViewController alloc] init];
//            ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
//            [self.navigationController pushViewController:ctvc animated:YES];
            DTWBWebViewController *physical = [[DTWBWebViewController alloc]init];
            physical.web_url=@"/WebApp/Maintenance/Index?userid=";
            physical.web_title=@"电梯维保";
            [self.navigationController pushViewController:physical animated:YES];
        }
        
    }
    else if(btn.tag==1) {
//        RepairRecordVC *repair = [[RepairRecordVC alloc]init];
//        [self.navigationController pushViewController:repair animated:YES];
        
        WXJLListWebViewController *physical = [[WXJLListWebViewController alloc]init];
        physical.web_url=@"/WebApp/Repair/index?userid=";
        physical.web_title=@"维修记录";
        [self.navigationController pushViewController:physical animated:YES];
    }
    else if(btn.tag==2)
    {JYGLViewController *ctvc=[[JYGLViewController alloc] init];
        ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
        [self.navigationController pushViewController:ctvc animated:YES];
    }
    else if(btn.tag==3)
    {
        BJYLWViewController *ctvc=[[BJYLWViewController alloc] init];
        ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
        [self.navigationController pushViewController:ctvc animated:YES];
    }
    else if(btn.tag==4)
    {
//        ShieldingManagerVC *shielding = [[ShieldingManagerVC alloc]init];
//        [self.navigationController pushViewController:shielding animated:YES];
        JYGLListWebViewController *jygll = [[JYGLListWebViewController alloc]init];
        jygll.web_url=@"/WebApp/Inspect/Index?UserId=";
        jygll.web_title=@"检测服务";
        [self.navigationController pushViewController:jygll animated:YES];
    }
    else if(btn.tag==5)
    {
        PhysicalUnionWebVC *physical = [[PhysicalUnionWebVC alloc]init];
        physical.web_url=@"/WebApp/Monitoring/Index?userid=";
        physical.web_title=@"物联监控";
        [self.navigationController pushViewController:physical animated:YES];
//        PhysicalUnionVC *physical = [[PhysicalUnionVC alloc]init];
//        [self.navigationController pushViewController:physical animated:YES];

    }
    else if(btn.tag==6)
    {

//        DTWBWebViewController_WZH *physical = [[DTWBWebViewController_WZH alloc]init];
//        physical.web_url=@"/WebApp/NFCMaintenance/Index?userid=";
//        physical.web_title=@"无纸化维保";
//        [self.navigationController pushViewController:physical animated:YES];
        WZHMainViewController *physical = [[WZHMainViewController alloc]init];
        [self.navigationController pushViewController:physical animated:YES];
    }
    else if(btn.tag==7)
    {
        YJFXMainViewController* physical = [[YJFXMainViewController alloc]init];
        [self.navigationController pushViewController:physical animated:YES];
    }
    else if(btn.tag==8)
    {
//        TZTGViewController * physical = [[TZTGViewController alloc]init];
//        [self.navigationController pushViewController:physical animated:YES];
        PhysicalUnionWebVC *physical = [[PhysicalUnionWebVC alloc]init];
        physical.web_url=@"/WebApp/Notice/Index?userid=";
        physical.web_title=@"通知通告";
        [self.navigationController pushViewController:physical animated:YES];
    }
    else if(btn.tag==9)
    {
        
//        complainAdvice *ctvc=[[complainAdvice alloc] init];
//        ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
//        ctvc.str_type=@"zc";
//        [self.navigationController pushViewController:ctvc animated:YES];
        PhysicalUnionWebVC *physical = [[PhysicalUnionWebVC alloc]init];
        physical.web_url=@"/WebApp/Complaint/Index?userid=";
        physical.web_title=@"投诉建议";
        [self.navigationController pushViewController:physical animated:YES];
    }
}

- (IBAction)BJYLWClick:(id)sender {
    
}

- (IBAction)DTWBClick:(id)sender {
    
}
- (IBAction)JYGLClick:(id)sender {
    
    

}


@end
