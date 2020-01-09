//
//  SWJKBandSaveViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/12.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyControl.h"
#import "AppDelegate.h"
#import "NFCBandClass.h"
#import "CommonUseClass.h"
#import "XXNet.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface SWJKBandSaveViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UIView *headview;
    UILabel *dtBianHao_2;
    UILabel *dtWeiBao_2;
    UILabel *dtWeiZhi_2;
    UITextField *tf_zcCode;
    UITextField *tf_sbCode;
    
    UIScrollView *sc;
    NSDictionary *currDic;
    NSString *currTag;
    

    
    BMKLocationService* _locService;
    BOOL isLoad;
    CLLocationCoordinate2D pt;
    BMKGeoCodeSearch* _geocodesearch;
    int YJBJCount;
    float Longitude;
    float Latitude;
}

@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *liftNum;
@property (nonatomic,strong) NSString *liftID;
@property (strong, nonatomic) NSString *InstallationAddress;
@property (strong, nonatomic) NSString *UploadDate;
@property (strong, nonatomic) NSArray *nfcList;
@property (nonatomic,strong) AppDelegate *app;

@end
