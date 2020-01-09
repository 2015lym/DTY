//
//  CourseDetailedViewController.m
//  AlumniChat
//
//  Created by SongQues on 16/7/2.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "CourseDetailedViewController.h"
#import "AppDelegate.h"
@interface CourseDetailedViewController ()

@end

@implementation CourseDetailedViewController
@synthesize dic_school_info;
- (void)viewDidLoad {
    [super viewDidLoad];
    PageIndex=1;
    [self getSchoolCourseDetails];
    // Do any additional setup after loading the view from its nib.
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
-(void)getSchoolCourseDetails
{
    /*

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dic_body=[NSMutableDictionary dictionary];
    [dic_body setObject:@"" forKey:@"tokenReqs"];
    [dic_body setObject:[NSNumber numberWithFloat:checkinLocation.coordinate.longitude] forKey:@"longitude"];
    [dic_body setObject:[NSNumber numberWithFloat:checkinLocation.coordinate.latitude] forKey:@"lat"];
    [dic_body setObject:[dic_school_info objectForKey:@"enrollId"] forKey:@"enrollId"];
     [dic_body setObject:self.app.userInfoEntity.rid forKey:@"userID"];
    [dic_body setObject:[NSString stringWithFormat:@"%i",PageIndex ] forKey:@"page"];
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    //    [dic_args setObject:@"666666" forKey:@"access_token"];
    //    [dic_args setObject:@"code" forKey:@"response_type"];
    [dic_args setObject:@"getSchoolCourseDetails" forKey:@"reqsUrl"];
    [dic_args setObject:[dic_body JSONString] forKey:@"body"];
    [[AFAppDotNetAPIClient sharedClientS]
     postPath:@"oauth/apiDataByAccessToken.php"
     parameters:dic_args
     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"state"] intValue];
             if (state_value==200) {
                 NSMutableDictionary *dic_enroll=[dic_result objectForKey:@"enroll_list"];
                 entity=[[DetailedEntity alloc] init];
                 entity.actualCount=[dic_enroll objectForKey:@"actualCount"];
                 entity.apply=[dic_enroll objectForKey:@"apply"];
                 entity.catalog=[dic_enroll objectForKey:@"catalog"];
                 entity.deadline=[dic_enroll objectForKey:@"deadline"];
                 entity.enrollId=[dic_enroll objectForKey:@"enrollId"];
                 entity.glod=[dic_enroll objectForKey:@"glod"];
                 entity.image=[dic_enroll objectForKey:@"image"];
                 entity.isEnroll=[dic_enroll objectForKey:@"isEnroll"];
                 entity.phone=[dic_enroll objectForKey:@"phone"];
                 entity.promise=[dic_enroll objectForKey:@"promise"];
                 entity.schoolAdd=[dic_enroll objectForKey:@"schoolAdd"];
                 entity.title=[dic_enroll objectForKey:@"title"];
                 entity.videoAdd=[dic_enroll objectForKey:@"videoAdd"];
                 [self initView];
             }
         }
         NSLog(@"");
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
    */
}
-(void)initView
{
    
}
@end
