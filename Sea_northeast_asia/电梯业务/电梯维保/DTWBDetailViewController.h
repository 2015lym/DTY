//
//  DTWBDetailViewController.h
//  Sea_northeast_asia
//
//  Created by wyc on 2017/5/10.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "UITableViewExViewController.h"
#import "CourseHearView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "HQDrawingView.h"
#import "warningElevatorModel.h"
@interface DTWBDetailViewController : UIViewControllerEx<UITableViewExViewDelegate,ClassIficationDelegate,CourseHearViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    ClassIfication *view_ification_02;
    UITableViewExViewController *CourseTableview;
    
    BMKLocationService* _locService;
    BOOL isLoad;
    CLLocationCoordinate2D pt;
    
    BMKMapView* _mapView;
    
    BOOL isfirstLoad;
    
    NSString *resurtdian;
}

@property (nonatomic,strong) AppDelegate *app;

@property (nonatomic,strong) NSString *lift_ID;

@property (nonatomic,strong) warningElevatorModel *dataDic;
@property (nonatomic,retain) NSString *from;


@end
