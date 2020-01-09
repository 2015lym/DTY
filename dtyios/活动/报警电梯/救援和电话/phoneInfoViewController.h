//
//  phoneInfoViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/14.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "warningElevatorModel.h"
#import "AppDelegate.h"
#import "XXNet.h"

#import "NTESBundleSetting.h"
#import "NTESMeetingViewController.h"
#import "NTESMeetingManager.h"
#import "NTESMeetingRolesManager.h"
@interface phoneInfoViewController : UIViewController{
     NSString *WYID;
    
}
@property (weak, nonatomic)  warningElevatorModel *warnModel;

@property (weak, nonatomic) IBOutlet UIView *viewHeader;

@property (weak, nonatomic) IBOutlet UIScrollView *viewBase;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UILabel *labTatolTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSatus;
@property (weak, nonatomic) IBOutlet UILabel *viewIcon;
@property (weak, nonatomic) IBOutlet UIView *_viewBlue;

@property (nonatomic,strong) AppDelegate *app;
@property (nonatomic,strong) NSString *roomid;
@end
