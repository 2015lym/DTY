//
//  EWMDetailViewController.m
//  Sea_northeast_asia
//
//  Created by 王永超 on 2017/3/23.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "EWMDetailViewController.h"
#import "MyControl.h"
#import "DTWBViewController.h"
#import "Util.h"
#import "CommonUseClass.h"
#import "EventCurriculumEntity.h"
#import "HTTPSessionManager.h"
#import "EWMClass.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface EWMDetailViewController ()
{
    UIScrollView *sc;
    UILabel *dtWeiZhi_2;
    UIView *line;
    
    UILabel *oneSelece;
    UILabel *TwoSelece;
    UILabel *ThreeSelece;
    UILabel *FourSelece;
    UILabel *FiveSelece;
    UILabel *SixSelece;
    
    UITextField *tf_1;
    UITextField *tf_2;
    UITextField *tf_3;
    UITextField *tf_4;
    UITextField *tf_5;
    UITextField *tf_6;
    NSMutableArray *tf_Arr;
    
    NSData *imageData;
    UIImageView *foodPhoto;
    NSMutableArray *arr_Photos;
    NSMutableArray *dataArray;
    
    int CheckDetailIdNum ;
    int CheckIdNum;
    NSString *CheckDateStr;
    NSString *StepIdNum;
    NSString *UserIdNum;
    NSString *DeptIdNum;
    
    NSMutableArray *base_Arr;
    NSString * numbers;
    NSMutableDictionary *dict;
    
    NSString *drag_1;
    NSString *drag_2;
    NSString *drag_3;
    NSString *drag_4;
    NSString *drag_5;
    NSString *drag_6;
    
    NSString *photo_1;
    NSString *photo_2;
    NSString *photo_3;
    NSString *photo_4;
    NSString *photo_5;
    NSString *photo_6;
}
@end

@implementation EWMDetailViewController
@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dict = [NSMutableDictionary dictionaryWithCapacity:0];
    CheckDetailIdNum=0;
    CheckIdNum = 0;
    arr_Photos = [NSMutableArray arrayWithCapacity:0];
    dataArray = [NSMutableArray arrayWithCapacity:0];
    tf_Arr = [NSMutableArray arrayWithCapacity:0];
    base_Arr = [NSMutableArray arrayWithCapacity:0];
    
    
    for (int i = 0; i < 6; i ++) {
        
        [arr_Photos addObject:@"0"];
    }
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    arr_Photos=[NSMutableArray array];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"";
    
    UIButton *right_BarButoon_Item=[[UIButton alloc] init];
    right_BarButoon_Item.frame=CGRectMake(0, 0,40,22);
    [right_BarButoon_Item setTitle:@"提交" forState:UIControlStateNormal];
    [right_BarButoon_Item addTarget:self action:@selector(navRightBtn_Event:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right_BarButoon_Item];
    self.navigationItem.rightBarButtonItems=@[rightItem];

    
    NSLog(@"liftNum==%@",_liftNum);
    
   
    [self getSchoolCourse];
    
    [self getSchoolCourse2];
    
    
    
}

-(void)navRightBtn_Event:(id)sender
{
    NSLog(@"二维码");
    
//    [self AddData];
}

//点击空白-回收键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [tf_1 resignFirstResponder];
    [tf_2 resignFirstResponder];
    [tf_3 resignFirstResponder];
    [tf_4 resignFirstResponder];
    [tf_5 resignFirstResponder];
    [tf_6 resignFirstResponder];
}
//开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==tf_2) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            sc.frame = CGRectMake(0, -100, SCREEN_WIDTH, SCREEN_HEIGHT-100);
        }];
    }
    if (textField==tf_3) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            sc.frame = CGRectMake(0, -100-75, SCREEN_WIDTH, SCREEN_HEIGHT-100-75);
        }];
    }
    if (textField==tf_4) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            sc.frame = CGRectMake(0, -100, SCREEN_WIDTH, SCREEN_HEIGHT-100);
        }];
    }
    if (textField==tf_5) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            sc.frame = CGRectMake(0, -100-75, SCREEN_WIDTH, SCREEN_HEIGHT-100-75);
        }];
    }
    if (textField==tf_6) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            sc.frame = CGRectMake(0, -100-75, SCREEN_WIDTH, SCREEN_HEIGHT-100-75);
        }];
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        
        sc.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
}
//完成编辑-回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [tf_1 resignFirstResponder];
    [tf_2 resignFirstResponder];
    [tf_3 resignFirstResponder];
    [tf_4 resignFirstResponder];
    [tf_5 resignFirstResponder];
    [tf_6 resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        sc.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }];
    
    return YES;
}



- (NSString *)addPic:(NSString *)currNum forAll:(NSString *)strstr
{
     if (arr_Photos.count>0) {
         NSString *currImg=@"";
         for (NSDictionary *currDic in arr_Photos) {
             NSArray * keys = currDic.allKeys;
             for (int i = 0; i < keys.count; i++) {
                 //逐个的获取键
                 NSString * key = [keys objectAtIndex:i];
                 
                 if([key isEqualToString:currNum ])
                 {
                     
                     currImg=[currDic objectForKey:currNum];
                     break;
                 }
             }

         }
         
         if(![currImg isEqualToString:@""])
         {
             NSString *str_0=@"\"Photo\" :\"";
             str_0=[str_0 stringByAppendingString:currImg];
             str_0=[str_0 stringByAppendingString:@"\","];
             
             NSString *d = strstr;
             strstr = [d stringByReplacingOccurrencesOfString:@"\"Photo\" : null," withString:str_0];
         }
        
     }
    else{
        
    }
    
    return strstr;
}
/*
- (void)AddData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *currUrl=@"Check/SaveCheckDetails";
    
    [tf_Arr addObject:tf_1.text];
    [tf_Arr addObject:tf_2.text];
    [tf_Arr addObject:tf_3.text];
    [tf_Arr addObject:tf_4.text];
    [tf_Arr addObject:tf_5.text];
    [tf_Arr addObject:tf_6.text];
    
    NSLog(@"tf_Arr==%@",tf_Arr);
    
    
    EWMClass *ewm_class = [[EWMClass alloc]init];
    ewm_class.CheckDetailId = @"0";
    ewm_class.CheckId = @"0";
    ewm_class.CheckDate = @"2017-03-24 09:38";
    ewm_class.UploadDate = @"2017-03-24 09:38";
    ewm_class.Remark = tf_1.text;
    ewm_class.LongitudeAndLatitude = @"123.414704,41.756505";
    ewm_class.StepId = StepIdNum;
    ewm_class.UserId = UserIdNum;
    ewm_class.DeptId = DeptIdNum;
    ewm_class.LiftId = _liftID;
    ewm_class.IsPassed = true;
    
    NSString *strstr=[CommonUseClass classToJson:ewm_class];
    drag_1= [self addPic:@"0" forAll:strstr];
    
    EWMClass *ewm_class1 = [[EWMClass alloc]init];
    ewm_class1.CheckDetailId = @"0";
    ewm_class1.CheckId = @"0";
    ewm_class1.CheckDate = @"2017-03-24 09:38";
    ewm_class1.UploadDate = @"2017-03-24 09:38";
    ewm_class1.Remark = tf_2.text;
    ewm_class1.LongitudeAndLatitude = @"123.414704,41.756505";
    ewm_class1.StepId = StepIdNum;
    ewm_class1.UserId = UserIdNum;
    ewm_class1.DeptId = DeptIdNum;
    ewm_class1.LiftId = _liftID;
    ewm_class1.IsPassed = true;
    
    NSString *strstr1=[CommonUseClass classToJson:ewm_class1];
    drag_2=[self addPic:@"1" forAll:strstr1];
    
    EWMClass *ewm_class2 = [[EWMClass alloc]init];
    ewm_class2.CheckDetailId = @"0";
    ewm_class2.CheckId = @"0";
    ewm_class2.CheckDate = @"2017-03-24 09:38";
    ewm_class2.UploadDate = @"2017-03-24 09:38";
    ewm_class2.Remark = tf_3.text;
    ewm_class2.LongitudeAndLatitude = @"123.414704,41.756505";
    ewm_class2.StepId = StepIdNum;
    ewm_class2.UserId = UserIdNum;
    ewm_class2.DeptId = DeptIdNum;
    ewm_class2.LiftId = _liftID;
    ewm_class2.IsPassed = true;
    
    
    NSString *strstr2=[CommonUseClass classToJson:ewm_class2];
    drag_3=[self addPic:@"2" forAll:strstr2];

    EWMClass *ewm_class3 = [[EWMClass alloc]init];
    ewm_class3.CheckDetailId = @"0";
    ewm_class3.CheckId = @"0";
    ewm_class3.CheckDate = @"2017-03-24 09:38";
    ewm_class3.UploadDate = @"2017-03-24 09:38";
    ewm_class3.Remark = tf_4.text;
    ewm_class3.LongitudeAndLatitude = @"123.414704,41.756505";
    ewm_class3.StepId = StepIdNum;
    ewm_class3.UserId = UserIdNum;
    ewm_class3.DeptId = DeptIdNum;
    ewm_class3.LiftId = _liftID;
    ewm_class3.IsPassed = true;
    
    
    NSString *strstr3=[CommonUseClass classToJson:ewm_class3];
    drag_4=[self addPic:@"3" forAll:strstr3];

    EWMClass *ewm_class4 = [[EWMClass alloc]init];
    ewm_class4.CheckDetailId = @"0";
    ewm_class4.CheckId = @"0";
    ewm_class4.CheckDate = @"2017-03-24 09:38";
    ewm_class4.UploadDate = @"2017-03-24 09:38";
    ewm_class4.Remark = tf_5.text;
    ewm_class4.LongitudeAndLatitude = @"123.414704,41.756505";
    ewm_class4.StepId = StepIdNum;
    ewm_class4.UserId = UserIdNum;
    ewm_class4.DeptId = DeptIdNum;
    ewm_class4.LiftId = _liftID;
    ewm_class4.IsPassed = true;
    
    
    NSString *strstr4=[CommonUseClass classToJson:ewm_class4];
    drag_5=[self addPic:@"4" forAll:strstr4];

    
    
    EWMClass *ewm_class5 = [[EWMClass alloc]init];
    ewm_class5.CheckDetailId = @"0";
    ewm_class5.CheckId = @"0";
    ewm_class5.CheckDate = @"2017-03-24 09:38";
    ewm_class5.UploadDate = @"2017-03-24 09:38";
    ewm_class5.Remark = tf_6.text;
    ewm_class5.LongitudeAndLatitude = @"123.414704,41.756505";
    ewm_class5.StepId = StepIdNum;
    ewm_class5.UserId = UserIdNum;
    ewm_class5.DeptId = DeptIdNum;
    ewm_class5.LiftId = _liftID;
    ewm_class5.IsPassed = true;
    
    NSString *strstr5=[CommonUseClass classToJson:ewm_class5];
    drag_6=[self addPic:@"5" forAll:strstr5];


    NSString *str11 = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",drag_1,drag_2,drag_3,drag_4,drag_5,drag_6];
    NSString *str_str=@"[";
    str_str=[str_str stringByAppendingString:str11];
    str_str=[str_str stringByAppendingString:@"]"];
    
    
    [HTTPSessionManager
     post:currUrl
     parameters:str_str
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, id  _Nullable data) {
         
         //         NSLog(@"success====%@",responseObject);
         
         NSString *str_result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSString *success=[dic_result objectForKey:@"Success"];
         
         NSLog(@"dic_result==%@",dic_result);
         
         if([success integerValue]!=1)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
         }
         else
         {

             
             [self performSelectorOnMainThread:@selector(cc) withObject:data waitUntilDone:NO];
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",[error userInfo] );
        [MBProgressHUD showMessag:@"提交失败" toView:self.view];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}
*/
- (void)cc{

    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    //返回到指定视图控制器
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[DTWBWebViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
    
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi_success" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

//UIImage图片转成Base64字符串
-(NSString *)ImageToBase64:(UIImage *)originImage
{
    
    //UIImage *originImage = [UIImage imageNamed:@"Cover.png"];
    
    NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);
    
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedImageStr;
    
}

-(void)getSchoolCourse2
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[AFAppDotNetAPIClient sharedClient]
     GET:[NSString stringWithFormat:@"Lift/GetLiftByLiftNum?liftNum=%@",_liftNum]
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {  }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         
         if (CourseTableview.PageIndex==1) {
             [CourseTableview.dataSource removeAllObjects];
         }
         else
         {
             [CourseTableview.dataSource removeLastObject];
         }
         
         if (dic_result.count>0) {
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             
             if (state_value==1) {
                 
                 NSDictionary *  allTags=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 
//                 NSLog(@"allTags_2==%@",allTags);
                 
                 
                 StepIdNum = [NSString stringWithFormat:@"%@",[allTags objectForKey:@"AddressId"]];
                 UserIdNum = [NSString stringWithFormat:@"%@",[allTags objectForKey:@"UpdateUserId"]];
                 DeptIdNum = [NSString stringWithFormat:@"%@",[allTags objectForKey:@"MadeDepartmentId"]];
                 
                 
                 
                 dtWeiZhi_2.text = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%@",[allTags objectForKey:@"AddressPath"]],[NSString stringWithFormat:@"%@",[allTags objectForKey:@"InstallationAddress"]]];
                 
//                 NSLog(@"dtWeiZhi_2==%@",dtWeiZhi_2);
                 
                 
                 _liftID = [NSString stringWithFormat:@"%@",[allTags objectForKey:@"ID"]];
                 
                 [self performSelectorOnMainThread:@selector(cc:) withObject:allTags waitUntilDone:NO];
             }
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"获取列表失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
         [alert show];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
    
}

-(void)getSchoolCourse
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AFAppDotNetAPIClient sharedClient]
     GET:@"Step/GetStepList"
     parameters:nil
     progress:^(NSProgress * _Nonnull uploadProgress) {
     }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
         NSLog(@"%@",dic_result);
         
         
         if (CourseTableview.PageIndex==1) {
             [CourseTableview.dataSource removeAllObjects];
         }
         else
         {
             [CourseTableview.dataSource removeLastObject];
         }
         
         if (dic_result.count>0) {
             
             int state_value=[[dic_result objectForKey:@"Success"] intValue];
             if (state_value==1) {
                 
                 NSMutableArray *  allTags=[[dic_result objectForKey:@"Data"] objectFromJSONString];
                 
//                 NSLog(@"allTags==%@",allTags);
                 
                 NSArray *StepNameArr = [allTags valueForKey:@"StepName"];
                 
                 NSArray *IsTakePhotos = [allTags valueForKey:@"IsTakePhoto"];
                 

                 
                 
                 //[[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:app.userInfo.UserID forHTTPHeaderField:@"UserId"];
                 //[[AFAppDotNetAPIClient sharedClient].requestSerializer setValue:_liftNum forHTTPHeaderField:@"LiftNum"];
                 NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
                 [dic_args setObject:[NSString stringWithFormat:@"%@",app.userInfo.UserID] forKey:@"UserId"];
                 [dic_args setObject:_liftNum forKey:@"LiftNum"];
                 [[AFAppDotNetAPIClient sharedClient]
                  GET:@"GetLiftCheckByLiftNum"
                  parameters:dic_args
                  progress:^(NSProgress * _Nonnull uploadProgress) {  }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                      
                      NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                      NSDictionary* dic_result=[str_result objectFromJSONString];
                      NSLog(@"%@",dic_result);
                      
                      
                      
                      NSMutableArray *arr1=[[NSMutableArray alloc]init];
                      NSArray *checkTypeArr = [allTags valueForKey:@"CheckType"];
                      for (NSDictionary * dic in allTags) {
                          if([[dic objectForKey:@"CheckType"] intValue]==3)
                          {
                              NSDictionary *dic1=[NSDictionary new];
                              [dic1 setValue:[dic objectForKey:@"StepName"] forKey:@"StepName"];
                              [dic1 setValue:[dic objectForKey:@"Sort"] forKey:@"Sort"];
                              [arr1 addObject:dic1];
                          }
                      }
                      
                      NSMutableArray * arrnew=[NSMutableArray new];
                      for (int  i =0; i<[arr1 count]-1; i++) {
                          
                          for (int j = i+1; j<[arr1 count]; j++) {
                              
                              if ([arr1[i] intValue]>[arr1[j] intValue]) {
                                  
                                  //交换
                                  
                                  [arr1 exchangeObjectAtIndex:i withObjectAtIndex:j];
                                  
                              }
                              
                          }
                          
                      }
                      int i=0;
                      
                      
                      
                      
                      
                      
                      [self performSelectorOnMainThread:@selector(cc:) withObject:allTags waitUntilDone:NO];
                      
                      
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
                  
                      
                  }];
                 
                 
                 
             }
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"获取列表失败！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil, nil];
         [alert show];
         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     }];
}

-(void)cc:(NSDictionary *)dict
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - 调取相机响应事件

- (void)PhotoClick{
    
    NSLog(@"调取相机");
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    //进入照相界面
    [self presentViewController:picker animated:YES completion:nil];
    
}
//点击相册中的图片或照相机照完后点击use后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        NSString * strImg= [self ImageToBase64:image];
        
        
        
        for (NSDictionary *currDic in arr_Photos) {
            
            NSArray * keys = currDic.allKeys;
            for (int i = 0; i < keys.count; i++) {
                //逐个的获取键
                NSString * key = [keys objectAtIndex:i];
                
                if([key isEqualToString:numbers])
                {
                    [arr_Photos removeObject:currDic];
                    break;
                }
            }
        }
        
        dict=[[NSMutableDictionary alloc]init];
        [dict setValue:strImg forKey:numbers];
        [arr_Photos addObject:dict];
        
    }];
    
}
//点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
