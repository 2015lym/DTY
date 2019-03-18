//
//  MainViewController_dtjy.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/23.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "MainViewController_dtjy.h"

#import "Util.h"
#import "ConvenienceViewController.h"
#import "ConvenienceViewIOSController.h"
#import "EventViewController.h"
#import "EventViewIOSController.h"
#import "InteractionViewController.h"
#import "InteractionViewIOSController.h"
#import "myViewController.h"
#import "LiftPersonViewController.h"
#import "LiftBusinessViewController.h"
#import "AppDelegate.h"
#import "PersonController.h"
#import "AboutViewController.h"
#import "MessageCenterViewController.h"
#import "JYGLListViewController.h"
@interface MainViewController_dtjy ()

@end

@implementation MainViewController_dtjy

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    isloadview=YES;
    isMessage=YES;
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isloadview) {
        return;
    }
    
    JYGLListViewController *EventVC=[[JYGLListViewController alloc] init];
    
    LiftBusinessViewController *ConvenienceVC=[[LiftBusinessViewController alloc] initWithNibName:@"LiftBusinessViewController_s" bundle:nil];
    
    
    LiftPersonViewController *Homeview
    =[[LiftPersonViewController alloc]initWithNibName:@"LiftPersonViewController_s" bundle:nil];
    
    myViewController *interactionVC=[[myViewController alloc] initWithNibName:@"myViewController_s"  bundle:nil];
    
    self.viewControllers=@[EventVC,ConvenienceVC,Homeview,interactionVC];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"TabBar_dtjy" owner:self options:nil];
    view_tabBar=[nibs objectAtIndex:0];
    
    UILabel *labLine1=[MyControl createLabelWithFrame:CGRectMake(0, 0, bounds_width.size.width, 1) Font:14 Text:@""];
    labLine1.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view_tabBar addSubview:labLine1];
    
    
    CGRect rect=view_tabBar.frame;
    rect.origin.y=0;
    rect.size.width=bounds_width.size.width;
    view_tabBar.frame=rect;
    CGRect rx = [ UIScreen mainScreen ].bounds;
    self.tabBar.frame= CGRectMake(0,rx.size.height-49, bounds_width.size.width, 48);
    [self.tabBar addSubview:view_tabBar];
    
    UIImage *bgImg = [[UIImage alloc] init];
    [self.tabBar setBackgroundImage:bgImg];
    [self.tabBar setShadowImage:bgImg];
    
    view_badge_2001=[view_tabBar viewWithTag:2001];
    view_badge_2002=[view_tabBar viewWithTag:2002];
    view_badge_2003=[view_tabBar viewWithTag:2003];
    view_badge_2004=[view_tabBar viewWithTag:2004];
    
    image_badge_2001=(UIImageView*)[view_tabBar viewWithTag:3001];
    image_badge_2002=(UIImageView*)[view_tabBar viewWithTag:3002];
    image_badge_2003=(UIImageView*)[view_tabBar viewWithTag:3003];
    image_badge_2004=(UIImageView*)[view_tabBar viewWithTag:3004];
    
    float currwidth=bounds_width.size.width/2;//4;
    view_badge_2001.frame=CGRectMake(1, view_badge_2001.frame.origin. y,currwidth , 48);
    //view_badge_2002.frame=CGRectMake(currwidth, view_badge_2002.frame.origin. y,currwidth, 48);
    //view_badge_2003.frame=CGRectMake(currwidth*2, view_badge_2003.frame.origin. y,currwidth, 48);
    //view_badge_2004.frame=CGRectMake(currwidth*3, view_badge_2004.frame.origin. y,currwidth, 48);
    view_badge_2004.frame=CGRectMake(currwidth, view_badge_2004.frame.origin. y,currwidth, 48);
    lab_badge_2001=(UILabel*)[view_badge_2001 viewWithTag:4001];
    
    lab_badge_2002=(UILabel*)[view_badge_2002 viewWithTag:4002];
    lab_badge_2003=(UILabel*)[view_badge_2003 viewWithTag:4003];
    lab_badge_2004=(UILabel*)[view_badge_2004 viewWithTag:4004];
    
    
    for (UIView *btn_view1 in [view_tabBar subviews]) {
        //if(btn_view1.tag!=2001)continue;
        for(UIView *btn_view in [btn_view1 subviews]) {
            if([btn_view isMemberOfClass:[UIButton class]])
            {
                UIButton *btn=(UIButton*)btn_view;
                [btn addTarget:nil action:@selector(tabBarClickEvent:) forControlEvents:UIControlEventTouchUpInside];
                if (btn.tag==1001) {
                    [self tabBarClickEvent:btn];
                }
                
            }
            
            if([btn_view isMemberOfClass:[UIImageView class]])
            {
                UIImageView *img=(UIImageView*)btn_view;
                float width=bounds_width.size.width/2;
                
                img.frame=CGRectMake((width-30)/2, 0,30, 30);
            }
            
        }
    }
    isloadview=NO;
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(Badge_MessageCenter:) withObject:self afterDelay:0.2];
    [self performSelector:@selector(Badge_SurpriseView:) withObject:self afterDelay:0.2];
    //view_badge_2001.frame=CGRectMake(0, view_badge_2001.frame.origin. y,bounds_width.size.width/4 , 48);
    view_badge_2001.frame=CGRectMake(0, view_badge_2001.frame.origin. y,bounds_width.size.width/2 , 48);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark tabbar按钮事件
-(IBAction)tabBarClickEvent:(id)sender
{
    //view_badge_2001.frame=CGRectMake(0, view_badge_2001.frame.origin. y,bounds_width.size.width/4 , 48);
    view_badge_2001.frame=CGRectMake(0, view_badge_2001.frame.origin. y,bounds_width.size.width/2 , 48);
    //view_badge_2001.backgroundColor=[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:0];
    //view_badge_2002.backgroundColor=[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:0];
    //view_badge_2003.backgroundColor=[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:0];
    //view_badge_2004.backgroundColor=[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:0];
    image_badge_2001.image = [UIImage imageNamed:@"tab_help.png"] ;
    image_badge_2002.image = [UIImage imageNamed:@"tab_business.png"] ;
    image_badge_2003.image = [UIImage imageNamed:@"tab_me.png"] ;
    image_badge_2004.image = [UIImage imageNamed:@"tab_btn_me_nor-@2x.png"] ;
    
    lab_badge_2001.textColor=[UIColor colorWithHexString:@"#999999"];
    lab_badge_2002.textColor=[UIColor colorWithHexString:@"#999999"];
    lab_badge_2003.textColor=[UIColor colorWithHexString:@"#999999"];
    lab_badge_2004.textColor=[UIColor colorWithHexString:@"#999999"];
    
    
    UIButton *btn=sender;
    int tag=0;
    if (btn_Current) {
        btn_Current.selected=NO;
    }
    btn_Current=btn;
    btn_Current.selected=YES;
    tag=(int)btn_Current.tag;
    switch (tag) {
        case 1001:
        {
            self.navigationItem.rightBarButtonItem=rightItem;
            [self setSelectedIndex:0];
            //view_badge_2001.backgroundColor=[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:1];
            image_badge_2001.image = [UIImage imageNamed:@"tab_help_sel.png"] ;
            lab_badge_2001.textColor=[UIColor colorWithHexString:@"#3574fa"];
        }
            break;
        case 1002:
        {
            self.navigationItem.rightBarButtonItem=rightItem;
            [self setSelectedIndex:1];
            //view_badge_2002.backgroundColor=[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:1];
            image_badge_2002.image = [UIImage imageNamed:@"tab_business_sel.png"] ;
            lab_badge_2002.textColor=[UIColor colorWithHexString:@"#3574fa"];
        }
            break;
        case 1003:
        {
            self.navigationItem.rightBarButtonItem=rightItem;
            [self setSelectedIndex:2];
            //view_badge_2003.backgroundColor=[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:1];
            image_badge_2003.image = [UIImage imageNamed:@"tab_me_sel.png"] ;
            lab_badge_2003.textColor=[UIColor colorWithHexString:@"#3574fa"];
        }
            break;
        case 1004:
        {
            self.navigationItem.rightBarButtonItem=rightItem1;
            [self setSelectedIndex:3];
            //view_badge_2004.backgroundColor=[UIColor colorWithRed:0.f/255.f green:122.f/255.f blue:255.f/255.f alpha:1];
            image_badge_2003.image = [UIImage imageNamed:@"tab_me_sel.png"] ;
            lab_badge_2004.textColor=[UIColor colorWithHexString:@"#3574fa"];
        }
            break;
    }
}

-(void) Badge_PeopleNearby:(int)badgeValue
{
    
}
-(void) Badge_MessageCenter:(int)badgeValue
{
    
}
-(void) Badge_SurpriseView:(int)badgeValue
{
    
}
-(void) Badge_MeView:(int)badgeValue
{
    
}

- (void)nav_LeftClick:(id)sender
{
    [self rightCloseView];
    [self refRefshView];
    if (lableVC!=nil) {
        CGRect rect=lableVC.view.frame;
        rect.origin.x=0;
        lableVC.view.frame=rect;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=lableVC.view.frame;
            rect.origin.x=0-rect.size.width;
            lableVC.view.frame=rect;
        } completion:^(BOOL finished) {
            [lableVC.view removeFromSuperview];
            lableVC=nil;
        }];
    }
    else
    {
        
        lableVC=[[LeftViewController alloc] initWithNibName:[Util GetResolution:@"LeftViewController"] bundle:nil];
        lableVC.delegate=self;
        CGRect rect=self.navigationController.view.frame;
        rect.origin.x=0-rect.size.width;
        rect.origin.y=bounds_width.size.height-self.view.frame.size.height;
        //        rect.size.height=self.view.frame.size.height-rect.origin.y+20;
        lableVC.view.frame=rect;
        [self.navigationController.view addSubview:lableVC.view];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=lableVC.view.frame;
            rect.origin.x=0;
            lableVC.view.frame=rect;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
}
#pragma mark LeftViewDelegate
-(void)rightCloseView
{
    CGRect rect=rightVC.view.frame;
    rect.origin.x=0;
    rightVC.view.frame=rect;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect=rightVC.view.frame;
        rect.origin.x=rect.size.width;
        rightVC.view.frame=rect;
    } completion:^(BOOL finished) {
        [rightVC.view removeFromSuperview];
        rightVC=nil;
    }];
    
}

-(void)refRefshView{
    HomeViewController  *view_CampusLife=[self.viewControllers objectAtIndex:0];
    [view_CampusLife refRefshView];
}
-(void)rightLoginEvent{
    if(self.app.str_token.length==0)
    {
        [self loginMethod] ;
    }
    else
    {
        [self showPerson] ;
    }
    
}
-(void)loginMethod{
    
    //LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:[Util GetResolution:@"LoginViewController" ] bundle:nil];
    LoginViewController *loginVC=[[LoginViewController alloc]initWithNibName:[Util GetResolution:@"LoginViewController"] bundle:nil];
    UINavigationController *nav_loginVC=[[ UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav_loginVC animated:YES completion:^{
        
    }];
}
// 弹出个人中心窗口
-(void)showPerson
{
    PersonController *loginVC1=[[PersonController alloc]initWithNibName:[Util GetResolution:@"PersonController"] bundle:nil];
    UINavigationController *nav_loginVC1=[[ UINavigationController alloc]initWithRootViewController:loginVC1];
    [self presentViewController:nav_loginVC1 animated:YES completion:^{
        
    }];
}
-(void)rightAboutEvent
{
    AboutViewController *About=[[AboutViewController alloc]initWithNibName:[Util GetResolution:@"AboutViewController"] bundle:nil];
    UINavigationController *nav_About=[[ UINavigationController alloc]initWithRootViewController:About];
    [self presentViewController:nav_About animated:YES completion:^{
        
    }];
}
-(void)setHidden
{
    [self setIsMessage:YES];
}
-(void)rightMessageCenter
{
    MessageCenterViewController *About=[[MessageCenterViewController alloc]initWithNibName:[Util GetResolution:@"MessageCenterViewController"] bundle:nil];
    UINavigationController *nav_About=[[ UINavigationController alloc]initWithRootViewController:About];
    [self presentViewController:nav_About animated:YES completion:^{
        
    }];
}
- (void)nav_RightClick:(id)sender
{
    [self leftCloseView];
    [self refRefshView];
    if (rightVC!=nil) {
        CGRect rect=rightVC.view.frame;
        rect.origin.x=0;
        rightVC.view.frame=rect;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=rightVC.view.frame;
            rect.origin.x=rect.size.width;
            rightVC.view.frame=rect;
        } completion:^(BOOL finished) {
            [rightVC.view removeFromSuperview];
            rightVC=nil;
        }];
    }
    else
    {
        rightVC=[[RightViewController alloc] initWithNibName:[Util GetResolution:@"RightViewController"] bundle:nil];
        
        rightVC.delegate=self;
        CGRect rect=self.view.frame;
        rect.origin.x=rect.size.width;
        rect.origin.y=bounds_width.size.height-self.view.frame.size.height;
        //        rect.size.height=self.view.frame.size.height-rect.origin.y+20;
        rightVC.view.frame=rect;
        [self.navigationController.view addSubview:rightVC.view];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect=rightVC.view.frame;
            rect.origin.x=0;
            rightVC.view.frame=rect;
            [rightVC setImageRed:isMessage];
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
#pragma mark LeftViewDelegate
-(void)leftCloseView
{
    CGRect rect=lableVC.view.frame;
    rect.origin.x=0;
    lableVC.view.frame=rect;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect=lableVC.view.frame;
        rect.origin.x=0-rect.size.width;
        lableVC.view.frame=rect;
    } completion:^(BOOL finished) {
        [lableVC.view removeFromSuperview];
        lableVC=nil;
    }];
    
}
-(void)leftPshuWebview:(NSString *)url
{
    LeftWebViewController *leftWebVC=[[LeftWebViewController alloc]initWithNibName:[Util GetResolution:@"LeftWebViewController"] bundle:nil];
    //    CGRect rect=bounds_width;
    //    leftWebVC.view.frame=bounds_width;
    [leftWebVC setUrl:url];
    UINavigationController *nav_leftWebVC=[[ UINavigationController alloc]initWithRootViewController:leftWebVC];
    [self presentViewController:nav_leftWebVC animated:YES completion:^{
        
    }];
}
-(void)navRightBtn_Event:(id)sender{
    [self leftCloseView];
    InteractionViewIOSController  *view_CampusLife=[self.viewControllers objectAtIndex:3];
    [view_CampusLife navRightBtn_Event];
}

-(void)pushWebview:(NSString *)url info:(NSDictionary *)info;
{
    NSLog(@"%@",info);
    if ([[info objectForKey:@"type"] isEqualToString:@"1"]) {
        NSString *str_id=[info objectForKey:@"id"];
        if (str_id!=nil) {
            url=[NSString stringWithFormat:@"%@newsDetail.html?newsId=%@",Ksdby_api,str_id];
        }
        
    }
    else if([[info objectForKey:@"type"] isEqualToString:@"2"])
    {
        NSString *str_id=[info objectForKey:@"id"];
        if (str_id!=nil) {
            url=[NSString stringWithFormat:@"%@activityDetails.html?actId=%@",Ksdby_api,str_id];
        }
        
    }
    else if([[info objectForKey:@"type"] isEqualToString:@"3"])
    {
        NSString *str_id=[info objectForKey:@"id"];
        if ([[info objectForKey:@"flag"]isEqualToString:@"text"]) {
            if (str_id!=nil) {
                url=[NSString stringWithFormat:@"%@interactDetails_text.html?entranceId=1&interactionId=%@",Ksdby_api,str_id];
            }
        }
        else
        {
            if (str_id!=nil) {
                url=[NSString stringWithFormat:@"%@interactDetails_image.html?entranceId=1&interactionId=%@",Ksdby_api,str_id];
            }
        }
    }
    LeftWebViewController *leftWebVC=[[LeftWebViewController alloc]initWithNibName:[Util GetResolution:@"LeftWebViewController"] bundle:nil];
    [leftWebVC setUrl:url];
    UINavigationController *nav_leftWebVC=[[ UINavigationController alloc]initWithRootViewController:leftWebVC];
    [self presentViewController:nav_leftWebVC animated:NO completion:^{
        
    }];
}
-(void)setIsMessage:(BOOL)message
{
    isMessage=message;
    if (rightVC!=nil) {
        [rightVC setImageRed:isMessage];
    }
}

@end
