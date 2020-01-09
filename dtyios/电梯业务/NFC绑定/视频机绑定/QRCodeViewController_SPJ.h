//
//  QRCodeViewController_SPJ.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/11.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPJSaveViewController.h"
#import "UITableViewExViewController.h"
#import "UITableViewExForDeleteViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "myBMKPointAnnotation.h"
#import "EventCurriculumEntity.h"
#import "XXNet.h"
#import "JYGLSave.h"
#import "QRCode_Write.h"
@interface QRCodeViewController_SPJ : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UIView *viewLast;
    
    BMKLocationService* _locService;
    BOOL isLoad;
    CLLocationCoordinate2D pt;
    BMKGeoCodeSearch* _geocodesearch;
    EventCurriculumEntity *entity;
    
    NSString *LiftNum;
    NSArray * arrData;
    
    NSString *InstallationAddress;
    NSString *UploadDate;
    NSMutableArray *stet;
    NSString *liftID;
    NSArray * nfcList;
}
@property (nonatomic,strong) NSString *Type_ID;
@property (nonatomic, strong) SZQuestionItem *item;

@property (nonatomic,strong) AppDelegate *app;
@property ( nonatomic)  NSString * companyType;


@end
