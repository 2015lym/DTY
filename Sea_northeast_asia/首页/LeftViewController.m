//
//  LeftViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/29.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "LeftViewController.h"
#define WebUrl @"http://192.168.1.111:8103/"
@interface LeftViewController ()

@end

@implementation LeftViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor blueColor];    
    //添加手势
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeAction)];
    rightSwipe.direction = rightSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:rightSwipe];
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    /*for (int i=1 ;i<8;i++) {
        UIImageView *image=[[UIImageView alloc] init];
        [image setBackgroundColor:[UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:0.8]];
        image.alpha=0.8;
        image.frame=CGRectMake(20, 45*i,view_Menu.frame.size.width-40 , 0.5);
        [view_Menu addSubview:image];
    }*/
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
- (void)rightSwipeAction{
        [_delegate leftCloseView];
}
-(void)layoutSubviews{
//    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-20, 100, 20)];
//    lab.text=@"123123123123";
//    [self.view addSubview:lab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)root_View_ClickEvent:(id)sender{
    [_delegate leftCloseView];
}

-(IBAction)Btn_OnClick:(id)sender
{
    NSString *str_weburl=@"";
    UIButton *btn=sender;
    switch (btn.tag) {
        case 1001:
        {
            str_weburl=[NSString stringWithFormat:@"%@%@",Ksdby_api,@"broadCast.html"];
        }
            break;
        case 1002:
        {
            str_weburl=[NSString stringWithFormat:@"%@%@",Ksdby_api,@"searchNews.html"];
        }
            break;
        case 1003:
        {
            str_weburl=[NSString stringWithFormat:@"%@%@",Ksdby_api,@"websiteList.html"];
        }
            break;
        case 1004:
        {
            str_weburl=[NSString stringWithFormat:@"%@%@",Ksdby_api,@"websiteList.html"];
        }
            break;
        case 1005:
        {
            str_weburl=[NSString stringWithFormat:@"%@%@?weiFlag=2",Ksdby_api,@"weixinList.html"];
        }
            break;
        case 1006:
        {
            str_weburl=[NSString stringWithFormat:@"%@%@?weiFlag=1",Ksdby_api,@"weixinList.html"];
        }
            break;
        case 1007:
        {
            str_weburl=[NSString stringWithFormat:@"%@%@",Ksdby_api,@"yellowList.html"];
        }
            break;
    }
    [_delegate leftPshuWebview:str_weburl];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end;
