//
//  SPJSaveViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/11.
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
@interface SPJSaveViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UIView *headview;
    UILabel *dtBianHao_2;
    UILabel *dtWeiBao_2;
    UILabel *dtWeiZhi_2;
    
    UIScrollView *sc;
    
    NSDictionary *currDic;
    NSString *currTag;
    
    UIView *view_Content_2;
    UIView *view_Content_back;
    UITextField *tf;
    UIButton *btnNewDianti;
    
    BMKLocationService* _locService;
    BOOL isLoad;
    CLLocationCoordinate2D pt;
    BMKGeoCodeSearch* _geocodesearch;
    int YJBJCount;
    float Longitude;
    float Latitude;
    
    UILabel *selectLabel_bhvalue;
    UILabel *selectLabel_dzvalue;
}

@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *liftNum;
@property (nonatomic,strong) NSString *liftID;
@property (strong, nonatomic) NSString *InstallationAddress;
@property (strong, nonatomic) NSString *UploadDate;
@property (strong, nonatomic) NSArray *nfcList;
@property (nonatomic,strong) AppDelegate *app;
@end
