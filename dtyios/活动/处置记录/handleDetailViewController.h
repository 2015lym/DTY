//
//  handleDetailViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/12/18.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "warningElevatorModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "MyControl.h"
#import "CommonUseClass.h"
@interface handleDetailViewController : UIViewController
@property (weak, nonatomic)  warningElevatorModel *warnModel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIScrollView *viewInfo1;
@property (weak, nonatomic) IBOutlet UIScrollView *viewInfo2;
@property (weak, nonatomic) IBOutlet UILabel *lbl_state;
@property (weak, nonatomic) IBOutlet UILabel *RescueType;
@property (weak, nonatomic) IBOutlet UILabel *RemedyUser;
@property (weak, nonatomic) IBOutlet UILabel *compary;
@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UILabel *time3;
@property (weak, nonatomic) IBOutlet UILabel *time4;
@property (weak, nonatomic) IBOutlet UILabel *time5;


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
@end
