//
//  PersonController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/7/25.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "EGOImageView.h"
@interface PersonController : UIViewController
{
IBOutlet UILabel *personImg;
IBOutlet UILabel *nikeName;
 IBOutlet UILabel *password;
  IBOutlet UIButton *btnOutLine;
    
    __weak IBOutlet EGOImageView *uhead;
    
    IBOutlet UIButton *btnNikename;
    IBOutlet UIButton *btnPWD;
    
}
@property (nonatomic,strong) AppDelegate *app;
- (IBAction)btnNikename1:(id)sender;
- (IBAction)btnPWD1:(id)sender;

@end
