//
//  EventViewIOSController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventCourseViewController.h"
#import "SchoolCourseDelegate.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "appDelegate.h"
#import "MyControl.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "CommonUseClass.h"
#import "SaveLocationClass.h"
#import <BMKLocationkit/BMKLocationComponent.h>
#import "getStateAction.h"
#import "showPicViewController.h"
@interface EventViewIOSController : UIViewController<SchoolCourseDelegate,BMKMapViewDelegate,CLLocationManagerDelegate,NIMLoginManagerDelegate,NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,BMKLocationManagerDelegate>
{
    EventCourseViewController *scvc;
    IBOutlet BMKMapView *_mapView;
    IBOutlet UIView *view_content;
    
    NSMutableArray* allTags;
    FMDatabase *fmdDB;
    UIView *viewOP;//控制流程view
    
    double  maxLatitude;
    double minLatitude;
    double maxLongitude;
    double minLongitude;
    CLLocationDistance distance ;
    
    int isAddLocation;
    
    NSMutableArray *buttonIdNameList;//按钮的名字id列表：接单时20秒，到场5分钟
    int locationTime;
    NSTimer *timer;
    int nTimeCount;
}
@property (nonatomic,strong) AppDelegate *app;

@property (nonatomic,strong) NSMutableArray * allXY;
@property (nonatomic,strong) NSMutableArray * latitudeList;
@property (nonatomic,strong) NSMutableArray * longitudeList;

+(instancetype)sharedLoadData;
@end
