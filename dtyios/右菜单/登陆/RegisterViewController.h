//
//  RegisterViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/13.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFAppDotNetAPIClient.h"
#import "appDelegate.h"
@import AFNetworking;
@interface RegisterViewController : UIViewController
{
    IBOutlet UITextField *text01;
    IBOutlet UITextField *text02;
    IBOutlet UITextField *text03;
    IBOutlet UIButton *btn01;
    IBOutlet UIButton *btn02;
    NSMutableArray *areaArray;
    
    NSTimer *timer2;
    BOOL is_queding;
}
@property (nonatomic,strong) AppDelegate *app;
-(void)navLeftBtn_Event:(id)sender;
-(void)navRightBtn_Event:(id)sender;
@end
