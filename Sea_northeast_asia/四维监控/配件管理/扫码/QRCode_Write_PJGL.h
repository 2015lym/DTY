//
//  QRCode_Write_PJGL.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/10.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "MyControl.h"
#import "CreateLift.h"
#import "XXNet.h"
#import "CommonUseClass.h"
#import "PJGLSaveViewController.h"
#import "classLiftParts.h"
@interface QRCode_Write_PJGL : UIViewController
{
    NSString *InstallationAddress;
    NSString *CertificateNum;
    NSMutableArray *stet;
    NSString *LiftNum;
    NSString *LiftId;
    
    classLiftParts *_classLiftParts;
}
@property ( nonatomic) IBOutlet UITextField *liftId;
@property (weak, nonatomic) IBOutlet UILabel *installationAddress;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;

- (IBAction)submitClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_up;
@property (weak, nonatomic) IBOutlet UIImageView *imgH;


- (IBAction)liftNumChanged:(id)sender;
@property (nonatomic,strong) AppDelegate *app;

@property ( nonatomic) float Longitude;
@property ( nonatomic) float Latitude;
@end
