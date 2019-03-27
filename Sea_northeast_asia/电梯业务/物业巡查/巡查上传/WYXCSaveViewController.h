//
//  WYXCSaveViewController.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/4/25.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZConfigure.h"
#import "SZQuestionItem.h"
#import "AppDelegate.h"
#import "SZQuestionCell.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "myBMKPointAnnotation.h"
#import "WYXCClass.h"
#import "WYXCListWebViewController.h"

@interface WYXCSaveViewController : UITableViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

{
    UILabel *nameLabel;
    UILabel *ttLabel;
    NSMutableDictionary *dicret;
    
    NSDictionary* dic_result;
    UITextView *ttTextView;
    
    NSMutableDictionary *textArr;
    
    NSString * currUrl;
    
    NSMutableArray *descArr;
    
    UILabel *tLabel;
    NSDictionary *dict1;
    
    UIView *headview;
    UILabel *xianLabel;
    
    BMKMapView* _mapView;
    BMKLocationService* _locService;
    CLLocationCoordinate2D pt;
    BMKGeoCodeSearch* _geocodesearch;
    BOOL isLoad;
    
    //NSString * str_update;
    
}
@property (nonatomic,strong) AppDelegate *app;
@property (weak, nonatomic) NSString *guidStr;
@property (weak, nonatomic) NSString *typeStr;

@property (strong, nonatomic) NSString *liftNum;
@property (nonatomic,strong) NSString *liftID;
@property (nonatomic)  int floorNumber;

@property (strong, nonatomic) NSString *InstallationAddress;
@property (strong, nonatomic) NSString *UploadDate;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *CType;
@property (strong, nonatomic) NSMutableArray *  allTags;
@property (strong, nonatomic) NSString *PropertyCheckId;

/*
 * 能否编辑选择, 默认为YES
 */
@property (nonatomic, assign) BOOL canEdit;

/*
 * 资源数组
 */
@property (nonatomic, strong) NSArray *sourceArray;

/*
 * 是否完成
 */
@property (nonatomic, assign, readonly) BOOL isComplete;

/*
 * 结果返回数组
 */
@property (nonatomic, strong, readonly) NSArray *resultArray;

/**
 *  构造方法
 *
 *  @param questionItem 资源模型
 *
 *  @return
 */
- (instancetype)initWithItem:(SZQuestionItem *)questionItem;

/**
 *  构造方法
 *
 *  @param questionItem 资源模型
 *  @param configure    配置信息
 *
 *  @return
 */
- (instancetype)initWithItem:(SZQuestionItem *)questionItem andConfigure:(SZConfigure *)configure;

@end
