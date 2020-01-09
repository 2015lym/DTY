//
//  RescueCompleteViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/21.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassIfication.h"
#import "warningElevatorModel.h"
#import "appDelegate.h"
@interface RescueCompleteViewController : UIViewController<ClassIficationDelegate>
{
    ClassIfication *view_ification_02;
}
@property (weak, nonatomic) IBOutlet UITextField *txtPeopleCount;
@property (weak, nonatomic) IBOutlet UITextField *txtPeoplePhone;
@property (weak, nonatomic) IBOutlet UITextView *txtConter;
@property (weak, nonatomic) IBOutlet UIButton *selectYY;
@property (weak, nonatomic) IBOutlet UITextField *selYY;
@property (weak, nonatomic) IBOutlet UITextField *txtYY;
@property (weak, nonatomic) IBOutlet UIImageView *imgYY;
@property (weak, nonatomic) IBOutlet UIButton *selectJJ;
@property (weak, nonatomic) IBOutlet UITextField *txtJJ;
@property (weak, nonatomic) IBOutlet UITextField *selJJ;
@property (weak, nonatomic) IBOutlet UIImageView *imgJJ;
@property (weak, nonatomic) IBOutlet UIButton *btnUP;
- (IBAction)selectYYClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *view_Content;
@property (weak, nonatomic) IBOutlet UIScrollView *view_scroll;
@property (weak, nonatomic) IBOutlet UIView *view_pop;
- (IBAction)selectJJClick:(id)sender;
- (IBAction)btnOK:(id)sender;
@property (nonatomic,strong) warningElevatorModel *task;
@property (nonatomic,strong) AppDelegate *app;
@end
