//
//  JYTypeViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/9/25.
//  Copyright © 2018年 SongQues. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AFAppDotNetAPIClient.h"
#import "AppDelegate.h"
#import "CommonUseClass.h"
#import "JYGLListWebViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "JYGLSave.h"
@interface JYTypeViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    NSString *UploadDate;
    NSString *InstallationAddress;
    NSString *liftID;
    UIView * view_button;
    NSMutableArray *arrayType;
    NSDictionary *currdic;
    
    UIView *view_Content_2;
    UIView *view_Content_back;
    
    BMKLocationService* _locService;
    BOOL isLoad;
    CLLocationCoordinate2D pt;
    BMKGeoCodeSearch* _geocodesearch;
    int YJBJCount;
    float Longitude;
    float Latitude;
}
@property (nonatomic,strong) AppDelegate *app;
@property (strong, nonatomic) NSString *liftNum;
@end
