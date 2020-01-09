//
//  JYGLSaveCell.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/28.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCellEx.h"
#import "CommonUseClass.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "EGOImageView.h"
#import "showImage.h"

#import "XXNet.h"
#import "AppDelegate.h"
#import "XFCameraController.h"


@interface JYGLSaveCell : UITableViewCellEx<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    //NSString *have_this_phone;
    //UIImage *this_phone;
    
   
    

}
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UITextField *labConcent;
@property (weak, nonatomic) IBOutlet UIButton *btn_look;//确认

@property (weak, nonatomic) IBOutlet UIImageView *img_serverFile;
@property (weak, nonatomic) IBOutlet UIImageView *img_thisFile;
@property (weak, nonatomic) IBOutlet UIImageView *img_photo;
@property (weak, nonatomic) IBOutlet UIImageView *img_lock;
@property (weak, nonatomic) IBOutlet UILabel *lab_lock;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UIImageView *img_outLine;
@property (weak, nonatomic) IBOutlet UIButton *btn_outLine;



@property (weak, nonatomic) IBOutlet UIButton *btn_serverFile;
@property (weak, nonatomic) IBOutlet UIButton *btn_thisFile;
@property (weak, nonatomic) IBOutlet UIButton *btn_photo;
//@property (weak, nonatomic) IBOutlet UIButton *btn_lock;

@property (nonatomic,strong) AppDelegate *app;


@end
