//
//  elevatorRescueTooBar.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/8.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface elevatorRescueTooBar : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnArea;
@property (weak, nonatomic) IBOutlet UIButton *btnHelper;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
- (IBAction)btnHelperClick:(id)sender;
- (IBAction)btnPhoneClick:(id)sender;

@end
