//
//  SZQuestionCheckBox_WZH.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/7/10.
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
#import "XXNet.h"
@interface SZQuestionCheckBox_WZH : UITableViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ShopsCellDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewExViewDelegate>
{
    UILabel *nameLabel;
    UILabel *ttLabel;
    NSMutableDictionary *dicret;
    
    NSDictionary* dic_result;
    UITextView *ttTextView;
    
    NSMutableDictionary *textArr;
    NSMutableDictionary *IsNFCOKArr;
    
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
- (void)CallPoliceMethod:(NSDictionary*)dic;
@property (nonatomic,strong) AppDelegate *app;
@property (weak, nonatomic) NSString *guidStr;
@property (weak, nonatomic) NSString *typeStr;

@property (weak, nonatomic) NSString *liftNum;
@property (nonatomic,strong) NSString *liftID;
@property (nonatomic,strong) NSString *ID;//维保任务ID（首次维保为0，调用SaveNFCCheckDetails接口时传入ID）
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

