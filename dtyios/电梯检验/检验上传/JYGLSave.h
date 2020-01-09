//
//  JYGLSave.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/2/26.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFAppDotNetAPIClient.h"
#import "AppDelegate.h"
#import "CommonUseClass.h"
#import "SZConfigure.h"
#import "SZQuestionCheckBox.h"
#import "warningElevatorModel.h"
#import "XXNet.h"
#import "CurriculumEntity.h"
#import "showImage.h"
#import "VideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "writeNameViewController.h"
#import "XFDaterView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
typedef void(^CallBackBlcok) (NSURL *text);//1

@interface JYGLSave : UIViewController<UITableViewExViewDelegate,XFDaterViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    NSString *UploadDate;
    NSString *InstallationAddress;
    NSString *liftID;
    
    UIView *bgView;
    UIButton *leftBtn;
    UIButton *centertBtn;
    UIButton *rightBtn;
    UILabel *btnLine;
    UIButton *DectBtn;
    
    UIView *view_Content_2;
    UIView *view_Content_back;
    
    UITableViewExViewController *CourseTableview;
//    int typeID;
    
    
    NSString * InspectId;
    NSString *cellGuid;
    
    UIImageView *item;
    
    NSString *Daterid;
    NSString *Daterid_listid;
    
    int updata_allCount;
    int updata_currCount;
    NSString *updata_OK;
    NSString *updata_no;
    
    BMKLocationService* _locService;
    BOOL isLoad;
    CLLocationCoordinate2D pt;
    BMKGeoCodeSearch* _geocodesearch;
    int YJBJCount;

    NSString *selectDect;
    
    UIButton *_btn_WriteName;
}
@property (nonatomic,strong) AppDelegate *app;
@property (strong, nonatomic) XFDaterView *dater;

@property (weak, nonatomic) NSString *liftNum;
@property (weak, nonatomic) NSString *TypeCode;
@property (weak, nonatomic) NSString *InspectDeptId;
//
@property (nonatomic, copy) NSString *workFormId;

@property (weak, nonatomic) NSString *TypeId;

@property (weak, nonatomic) warningElevatorModel  *model;

@property (nonatomic, strong) SZQuestionCheckBox *questionBox;
@property (nonatomic, strong) SZQuestionItem *item;
- (void)ViewMethod:(NSDictionary*)dic;

@property (nonatomic,strong) MPMoviePlayerController *mpcontrol;

@property ( nonatomic) float Longitude;
@property ( nonatomic) float Latitude;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSArray *DectList;
@property (nonatomic, strong) NSArray *WorkFormList;
@end
