//
//  RescueOmitViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassIfication.h"
#import "warningElevatorModel.h"
#import "appDelegate.h"
@interface RescueOmitViewController : UIViewController
{
    ClassIfication *view_ification_02;
}
@property (weak, nonatomic) IBOutlet UIView *Viewpop;
@property (weak, nonatomic) IBOutlet UIView *ViewContent;
@property (weak, nonatomic) IBOutlet UIScrollView *view_scroll;

- (IBAction)selectYYClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtYY;
@property (weak, nonatomic) IBOutlet UIButton *selectYY;
- (IBAction)btnOK:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnUP;

@property (weak, nonatomic) IBOutlet UITextField *selYY;
@property (weak, nonatomic) IBOutlet UIImageView *imgYY;

@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) warningElevatorModel *task;
@end
