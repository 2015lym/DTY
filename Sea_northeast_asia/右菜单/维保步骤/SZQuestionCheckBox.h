//
//  SZQuestionCheckBox.h
//  SZQuestionCheckBox_demo
//
//  Created by 吴三忠 on 16/4/27.
//  Copyright © 2016年 吴三忠. All rights reserved.
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

@interface SZQuestionCheckBox : UITableViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ShopsCellDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
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
    
}
@property (nonatomic,strong) AppDelegate *app;
@property (weak, nonatomic) NSString *guidStr;
@property (weak, nonatomic) NSString *typeStr;

@property (weak, nonatomic) NSString *liftNum;
@property (nonatomic,strong) NSString *liftID;
@property (nonatomic)  int floorNumber;

@property (weak, nonatomic) NSString *InstallationAddress;
@property (weak, nonatomic) NSString *UploadDate;
@property (weak, nonatomic) NSString *Title;
@property (weak, nonatomic) NSString *CType;
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
