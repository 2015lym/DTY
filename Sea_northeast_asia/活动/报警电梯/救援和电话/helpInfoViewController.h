//
//  helpInfoViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/11/10.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewControllerEx.h"
#import "warningElevatorModel.h"

@interface helpInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIScrollView *viewBase;
@property (weak, nonatomic) IBOutlet UILabel *labLiftNum;
@property (weak, nonatomic) IBOutlet UILabel *labCertificateNum;
@property (weak, nonatomic) IBOutlet UILabel *labMachineNum;
@property (weak, nonatomic) IBOutlet UILabel *labCustomNum;
@property (weak, nonatomic) IBOutlet UILabel *labBrand;
@property (weak, nonatomic) IBOutlet UILabel *labModel;
@property (weak, nonatomic) IBOutlet UILabel *labInstallationAddress;
@property (weak, nonatomic) IBOutlet UILabel *labDictName;
@property (weak, nonatomic) IBOutlet UILabel *LiftType;
@property (weak, nonatomic) IBOutlet UILabel *labCheckDate;
@property (weak, nonatomic) IBOutlet UILabel *labUseDepartment;
@property (weak, nonatomic) IBOutlet UIView *viewBlue;
@property (weak, nonatomic) IBOutlet UILabel *viewIcon;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UILabel *labTatolTime;
@property (weak, nonatomic) IBOutlet UILabel *lblSatus;





@property (weak, nonatomic)  warningElevatorModel *warnModel;
@end
