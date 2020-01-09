//
//  CreateLift.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/27.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "MyControl.h"
#import "XXNet.h"
#import "CommonUseClass.h"
@interface CreateLift : UIViewController
@property ( nonatomic) IBOutlet UITextField *liftId;
@property ( nonatomic) IBOutlet UITextField *installationAddress;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;

- (IBAction)submitClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_up;
@property (weak, nonatomic) IBOutlet UIImageView *imgH;


- (IBAction)liftNumChanged:(id)sender;
@property (nonatomic,strong) AppDelegate *app;
@end
