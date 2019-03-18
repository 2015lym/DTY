//
//  RescueEvaluationViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "warningElevatorModel.h"
@interface RescueEvaluationViewController : UIViewController
- (IBAction)btnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
- (IBAction)btnClick2:(id)sender;
- (IBAction)btnClick3:(id)sender;
- (IBAction)btnUp:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnname_UP;
@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) warningElevatorModel *task;
@property (weak, nonatomic) IBOutlet UIScrollView *viewAll;


@property (weak, nonatomic) IBOutlet UIView *view_head;

@end
