//
//  QRCodeViewController_PJGL.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJGLSaveViewController.h"
#import "XXNet.h"
#import "JYGLSave.h"
#import "QRCode_Write_PJGL.h"
#import "classLiftParts.h"
@interface QRCodeViewController_PJGL : UIViewController
{
    UIView *viewLast;
    NSString *LiftNum;
    
    NSString *LiftId;
    NSString *InstallationAddress;
    NSString *CertificateNum;
    NSMutableArray *stet;
    
  classLiftParts *_classLiftParts;
    int okCount;
}
@property (nonatomic,strong) NSString *Type_ID;
@property (nonatomic, strong) SZQuestionItem *item;

@property (nonatomic,strong) AppDelegate *app;
@property ( nonatomic)  NSString * companyType;
@end
