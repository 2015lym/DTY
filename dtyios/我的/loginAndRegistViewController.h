//
//  loginAndRegistViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/14.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "UMessage.h"
#import "videoMainViewController.h"
@interface loginAndRegistViewController : UIViewController
{
    CGRect rect_sview_Content;

}
@property (weak, nonatomic) IBOutlet UITextField *lblusername;

@property (weak, nonatomic) IBOutlet UITextField *lblpassword;
//@property (weak, nonatomic) IBOutlet UIButton *btnLoginClick;
@property (nonatomic,strong) AppDelegate *app;

- (IBAction)btnLoginClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *sview_Content;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIView *viewInput;

@property (weak, nonatomic) IBOutlet UIImageView *img_password;
- (IBAction)btnpassword:(id)sender;
@end
