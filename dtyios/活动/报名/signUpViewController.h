//
//  signUpViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/22.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFAppDotNetAPIClient.h"
#import "appDelegate.h"
#import "EventCourseTableViewCell.h"
@import AFNetworking;
@interface signUpViewController : UIViewControllerEx
{
     BOOL isBtnOnCilck;
    __weak IBOutlet UITextField *txt_name;
    __weak IBOutlet UITextField *txt_phone;
    
    __weak IBOutlet UIButton *btnOK;
    
    __weak IBOutlet UIView *view_con;
    
    __weak IBOutlet UILabel *lab_Prompt;
    
    __weak IBOutlet UITextView *text_view;
    NSMutableArray *areaArray;
   
   
}
@property (nonatomic,strong) AppDelegate *app;
- (IBAction)btnOKEvent:(id)sender;
@property (nonatomic,strong)  NSString *actId;
@property (nonatomic,strong)   EventCourseTableViewCell *cell;
@end
