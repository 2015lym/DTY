//
//  HJViewController.h
//  Sea_northeast_asia
//
//  Created by SinodomMac02 on 17/3/10.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface myBMKPointAnnotation : BMKPointAnnotation

@property(nonatomic,assign)int nType;  // 1 自己 2 其他
@end
