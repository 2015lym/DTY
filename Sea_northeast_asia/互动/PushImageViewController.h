//
//  PushImageViewController.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/7/26.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "UIViewControllerEx.h"

@interface PushImageViewController : UIViewControllerEx
{
    IBOutlet UIButton *btn_Push;
    IBOutlet UITextView *text_view;
    IBOutlet UIView *view_center;
    IBOutlet UIView *view_textContent;
    IBOutlet UILabel *lab_Prompt;
    
    IBOutlet UIView *view_imageList;
    NSMutableArray *Arr_image;
    UIButton *btn_Addimage;
    
}
@property(nonatomic,strong)NSMutableArray *Arr_image;
@property(nonatomic,strong)NSMutableArray *Arr_Assets;
@property(nonatomic)BOOL isSelectOriginalPhotoEx;
-(IBAction)backgroundTap:(id)sender;
@end
