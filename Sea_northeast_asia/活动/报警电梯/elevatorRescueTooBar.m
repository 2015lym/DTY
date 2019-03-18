//
//  elevatorRescueTooBar.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/8.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "elevatorRescueTooBar.h"

@interface elevatorRescueTooBar ()

@end

@implementation elevatorRescueTooBar

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    double newWidth=[UIScreen mainScreen].bounds.size.width/2;
    dispatch_async(dispatch_get_main_queue(), ^{
       
        _btnHelper.frame=CGRectMake(0, _btnHelper.frame.origin.y, newWidth, _btnHelper.frame.size.height) ;
        _btnPhone.frame=CGRectMake(newWidth+1, _btnPhone.frame.origin.y, newWidth, _btnPhone.frame.size.height) ;
    });

  
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

- (IBAction)btnHelperClick:(id)sender {
   //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"Helper",@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_HelperOrPhone" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)btnPhoneClick:(id)sender {
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"Phone",@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_HelperOrPhone" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
@end
