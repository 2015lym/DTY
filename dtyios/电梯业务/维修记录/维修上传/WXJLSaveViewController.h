//
//  WXJLSaveViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/4/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MyControl.h"
#import "CommonUseClass.h"
#import "WXJLClass.h"
#import "WXJLListWebViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "myBMKPointAnnotation.h"
@interface WXJLSaveViewController : UIViewController<UIImagePickerControllerDelegate,UITextFieldDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    UIView *headview;
    UILabel *xianLabel;
    UILabel *dtWeiZhi_2;
    NSString *CheckDateStr;
    NSString *StepIdNum;
    NSString *UserIdNum;
    NSString *DeptIdNum;
    UILabel *dtBianHao_2;
    UILabel *dtWeiBao_2;
    
    UIButton *commitButton;
    EGOImageView* imgBefore;
    EGOImageView* imgAfter;
    UITextView *txtbz;
    UIScrollView *sc;
    long index;
    
    int have1;
    int have2;
    
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    CLLocationCoordinate2D pt;
    BMKGeoCodeSearch* _geocodesearch;
    BOOL isLoad;
    float Longitude;
    float Latitude;
}
@property (nonatomic,strong) AppDelegate *app;
@property (strong, nonatomic) NSString *guidStr;
@property (strong, nonatomic) NSString *typeStr;

@property (strong, nonatomic) NSString *liftNum;
@property (nonatomic,strong) NSString *liftID;
@property (nonatomic)  int floorNumber;

@property (strong, nonatomic) NSString *InstallationAddress;
@property (strong, nonatomic) NSString *UploadDate;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *CType;

@property (strong, nonatomic) NSString *Remark;
@property (strong, nonatomic) NSString *BeforePhoto;
@property (strong, nonatomic) NSString *AfterPhoto;
@property (strong, nonatomic) NSString * ID;
@end
