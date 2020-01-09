//
//  PushTextViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/26.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UIViewControllerEx.h"

@interface PushTextViewController : UIViewControllerEx
{
    IBOutlet UIButton *btn_Push;
    IBOutlet UITextView *text_view;
    IBOutlet UIView *view_center;
    IBOutlet UIView *view_textContent;
    IBOutlet UILabel *lab_Prompt;
    IBOutlet UITextField *text_tilte;
}
-(IBAction)backgroundTap:(id)sender;
@end
