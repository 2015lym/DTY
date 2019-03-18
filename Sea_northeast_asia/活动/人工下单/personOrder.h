//
//  personOrder.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/10.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "appDelegate.h"
@interface personOrder : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *liftId;
@property (weak, nonatomic) IBOutlet UILabel *installationAddress;
@property (weak, nonatomic) IBOutlet UITextField *rescueNumber;
@property (weak, nonatomic) IBOutlet UITextField *rescuePhone;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;

- (IBAction)submitClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_up;
@property (weak, nonatomic) IBOutlet UIImageView *imgH;


- (IBAction)liftNumChanged:(id)sender;
@property (nonatomic,strong) AppDelegate *app;
@end
