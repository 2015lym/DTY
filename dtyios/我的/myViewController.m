//
//  myViewController.m
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/16.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "myViewController.h"
#import "loginAndRegistViewController.h"
#import "RepairRecordVC.h"
#import "ChangePasswordVC.h"
#import "ContactUSVC.h"
@interface myViewController () {
    NSArray *titleArr;
    NSArray *imageArr;
}

@end

@implementation myViewController
@synthesize app;
-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _viewUserInfo.layer.masksToBounds = YES; //没这句话它圆不起来
//    _viewUserInfo.layer.cornerRadius = 10; //设置图片圆角的尺度
    _viewOP.layer.masksToBounds = YES; //没这句话它圆不起来
    _viewOP.layer.cornerRadius = 10; //设置图片圆角的尺度
//    _imageHead.layer.masksToBounds = YES; //没这句话它圆不起来
//    _imageHead.layer.cornerRadius = 30; //设置图片圆角的尺度
    self.view.frame=CGRectMake(0, -20, bounds_width.size.width, bounds_width.size.height+20);
    
    _lblLoginName.layer.masksToBounds = YES; //没这句话它圆不起来
    _lblLoginName.layer.cornerRadius = 10; //设置图片圆角的尺度
    
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    titleArr = @[@"修改密码",@"联系我们"];//,@"关于电梯云"
    imageArr = @[@"my_password",@"my_contact"];//,@"my_about"
    long l=[app.userInfo.UserID longLongValue];
    _lblLoginName.text=[NSString stringWithFormat: @"登录名：%@", app.userInfo.username];
    _lblUserID.text=[NSString stringWithFormat:@"·用户ID：%ld",l];
    _lblUserName.text=[NSString stringWithFormat: @"·用户名：%@",app.userInfo.nikename];
    _listTable.delegate = self;
    _listTable.dataSource = self;
    _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _lblUserID.frame=CGRectMake(_lblLoginName.frame.origin.x, _lblUserID.frame.origin.y,  _lblUserID.frame.size.width, _lblUserID.frame.size.height);
//    _lblUserName.frame=CGRectMake(_lblLoginName.frame.origin.x, _lblUserName.frame.origin.y,  _lblUserName.frame.size.width, _lblUserName.frame.size.height);
    UITapGestureRecognizer *tapUseinfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(UserInfoMethod:)];
    tapUseinfo.numberOfTapsRequired = 1;
    tapUseinfo.numberOfTouchesRequired = 1;
    [_viewUserInfo addGestureRecognizer:tapUseinfo];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = _imageHead.frame;
    [button addTarget:self action:@selector(btnmyInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    [_viewUserInfo addSubview:button];
}

//跳转到个人中心页面
- (void)UserInfoMethod:(UIGestureRecognizer*)recognizer {
    
}

- (IBAction)btnmyInfoClick:(id)sender
{
    userInfoViewController *detal=[[userInfoViewController alloc]init];
    [self.navigationController pushViewController:detal animated:YES];
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


- (IBAction)btnUserInfoClick:(id)sender {
}

- (IBAction)btnOutClick:(id)sender {
     [self outLine];
}

- (IBAction)btnChangePassClick:(id)sender {
}

-(void)outLine
{
    // 1、初始化
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否退出？"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    
    
    
    
    // 3、添加取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          // 此处处理点击取消按钮逻辑
                                                      }]];
    
    
    // 4、添加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"退出"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          /*
                                                          self.app.str_token=nil;
                                                          NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
                                                          [dic_oAuth removeObjectForKey:@"str_token"];
                                                          [dic_oAuth removeObjectForKey:@"username"];
                                                          [dic_oAuth removeObjectForKey:@"nikename"];
                                                          [dic_oAuth removeObjectForKey:@"pwd"];
                                                          [dic_oAuth removeObjectForKey:@"uhead"];
                                                          */
                                                          
                                                          videoMainViewController *video=[[videoMainViewController alloc]init];
                                                          [video videologout];
                                                          
                                                          NSString   *str_CachePath_Login = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"Login"];
                                                          if ([[ NSFileManager defaultManager ] fileExistsAtPath :str_CachePath_Login]) {
                                                              
                                                              [[ NSFileManager defaultManager ] removeItemAtPath :str_CachePath_Login error :nil];
                                                          }
                                                          
                                                          NSString *userid=[NSString stringWithFormat:@"%@" ,app.userInfo.UserID];
                                                          [UMessage removeAlias:userid type:@"ELEVATOR" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                                                              
                                                              NSLog(@"responseObject=%@",responseObject);
                                                              
                                                          }];

                                                          
                                                          [app.userInfo setUserInfo:@"" forpwd:@"" forUserID:@"" forDeptRoleCode:@"" forRoleId:@"" forNikename:@""];
                                                          
                                                          
                                                          //[self dismissViewControllerAnimated:YES completion:^{
                                                              
                                                         // }];
                                                          
  
                                                          
                                                   
                                                          [app loginShow];
                                                          [[self class] cancelPreviousPerformRequestsWithTarget:self];
                                                      }]];
    
    // 5、模态切换显示弹出框
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
    
    
    
    
    
}
- (IBAction)PushtoRecordMethod:(id)sender {
    RepairRecordVC *repair = [[RepairRecordVC alloc]init];
    [self.navigationController pushViewController:repair animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    UIImage *icon = [UIImage imageNamed:imageArr[indexPath.row]];
    CGSize itemSize = CGSizeMake(20, 20);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.textLabel.text = titleArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 43, cell.contentView.frame.size.width-10, 1)];
    label.backgroundColor = GrayColor(239);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = GrayColor(91);
    [cell.contentView addSubview:label];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ChangePasswordVC *cpvc = [[ChangePasswordVC alloc]init];
        [self.navigationController pushViewController:cpvc animated:YES];
    }
    else if (indexPath.row == 1) {
        ContactUSVC *contact = [[ContactUSVC alloc]init];
        [self.navigationController pushViewController:contact animated:YES];
    }
    
}

@end
