//
//  PJGLSaveDetailViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUseClass.h"
#import "XXNet.h"
#import "AppDelegate.h"

#import "MyControl.h"

#import "UILongPressGestureRecognizerEx.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "Indication.h"
#import "classLiftParts.h"
#import "XFDaterView.h"
#import "NFCSBNewViewController.h"
@import CoreNFC;
@interface PJGLSaveDetailViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,NFCNDEFReaderSessionDelegate>
{
    UIView *headview;
    UILabel *dtBianHao_2;
    UITextField *lab_time;
    UITextField *lab_name;
    
    UITextField *lab_Model;
    UITextField *lab_Brand;
    
    
    UILabel * bq_value;
    UILabel * bq_code;
    
    UIView *view_image;
    UIImageView *imageview;
    NSMutableArray *arr_Photos;
    NSMutableArray *arr_Failure;// 记录上传失败得图片
    UIButton *btn_addimage;
    UIImageView *image_delete;
    BOOL islog;
    NSMutableDictionary *dic_attid;
    int count;
    
    NSString *picUrl;
    
    NSString *_partsid;
    
    
}
@property (nonatomic,strong) AppDelegate *app;
@property (strong, nonatomic) XFDaterView *dater;

@property (strong, nonatomic) NSString *liftNum;
@property (strong, nonatomic) NSString *LiftId;
@property (strong, nonatomic) NSString *InstallationAddress;
@property (strong, nonatomic) NSString *CertificateNum;
@property (strong, nonatomic) classLiftParts *classLiftParts;//NSString *partsid;
@property (strong, nonatomic) NSString *PartsTypeId;
@property (strong, nonatomic) NSString *PartsTypeName;
@end
