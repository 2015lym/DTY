//
//  wyxcDetailViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/1/17.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "appDelegate.h"
#import "ClassIfication.h"
#import "CurriculumEntity.h"
#import "UITableViewExViewController.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "XXNet.h"
@interface wyxcDetailViewController : UIViewControllerEx<UITableViewExViewDelegate,ClassIficationDelegate,CourseHearViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate>
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
@end
