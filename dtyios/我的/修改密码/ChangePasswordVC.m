//
//  ChangePasswordVC.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "CommonUseClass.h"
#import "XXNet.h"
@interface ChangePasswordVC ()<UITextFieldDelegate> {
    NSArray *viewArr;
}

@end

@implementation ChangePasswordVC
@synthesize app;
@synthesize tf1,tf2,tf3;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title=@"修改密码";
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideKeyboard)];
    tapKeyboard.numberOfTouchesRequired = 1;
    tapKeyboard.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapKeyboard];
    tf1.delegate = self;
    tf2.delegate = self;
    tf3.delegate = self;
    
    viewArr = @[_view1,_view2,_view3];
    _btnSubmit.layer.masksToBounds = YES;
    _btnSubmit.layer.cornerRadius  = 7;
    for (UIView *view in viewArr) {
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view.layer.borderColor = GrayColor(226).CGColor;
        view.layer.borderWidth = 0.7;
    }
}
- (void)HideKeyboard {
    [tf1 resignFirstResponder];
    [tf2 resignFirstResponder];
    [tf3 resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SubmitMethod:(UIButton *)sender {
    if (tf1.text.length == 0) {
        [CommonUseClass showAlter:@"请输入原密码！"];
        return;
    }
    if (tf2.text.length == 0) {
        [CommonUseClass showAlter:@"请输入新密码!"];
        return;
    }
    if (tf3.text.length == 0) {
        [CommonUseClass showAlter:@"请再次输入密码!"];
        return;
    }
    if (![tf2.text isEqualToString:tf3.text]) {
        [CommonUseClass showAlter:@"两次输入的密码不一样！"];
        return;
    }
    [self RequestNet];
}
- (void)RequestNet {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:app.userInfo.username forKey:@"LoginName"];
    [dic setValue:tf1.text forKey:@"Password"];
    [dic setValue:tf3.text forKey:@"NewPassword"];
    [XXNet PostURL:GetModifyPwd header:nil parameters:dic succeed:^(NSDictionary *data) {
        NSLog(@"%@",data);
    } failure:^(NSError *error) {
        
    }];
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
