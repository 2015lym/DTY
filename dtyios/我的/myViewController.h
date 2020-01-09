//
//  myViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/16.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "userInfoViewController.h"
#import "AppDelegate.h"
@interface myViewController : UIViewControllerEx<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) AppDelegate *app;

@property (strong, nonatomic) IBOutlet UILabel *lblUserID;
@property (strong, nonatomic) IBOutlet UILabel *lblLoginName;
@property (strong, nonatomic) IBOutlet UILabel *lblUserName;
@property (strong, nonatomic) IBOutlet UIView *viewUserInfo;

@property (strong, nonatomic) IBOutlet UIView *viewOP;

@property (strong, nonatomic) IBOutlet UIImageView *imageHead;
@property (strong, nonatomic) IBOutlet UITableView *listTable;


- (IBAction)btnUserInfoClick:(id)sender;

- (IBAction)btnOutClick:(id)sender;
- (IBAction)btnChangePassClick:(id)sender;
- (IBAction)btnmyInfoClick:(id)sender;
@end
