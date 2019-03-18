//
//  RepairRecordDetailVC.m
//  Sea_northeast_asia
//
//  Created by wyc on 2018/1/8.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import "RepairRecordDetailVC.h"
#import "XXNet.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
@interface RepairRecordDetailVC ()<BMKMapViewDelegate,BMKLocationServiceDelegate> {
    BMKMapView* _mapView;
    float Longitude;//经度
    float Latitude; //纬度
    UIScrollView *bgScroll;
    UILabel *labName;
    UILabel *labtime;
    UILabel *labContent;
    
    EGOImageView *imgBefore;
    EGOImageView *imgAfter;
}

@end

@implementation RepairRecordDetailVC
@synthesize app;
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear]; // 当mapview即将被隐藏的时候调用，存储当前mapview的状态。
    _mapView.delegate = nil; // 不用时，置nil
    
}
- (void)startLocation {
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    _mapView.delegate =self;
    _mapView.mapType = BMKMapTypeStandard;//卫星地图
    _mapView.zoomLevel = 15;
    //添加到view上
    _mapView.gesturesEnabled = NO;
    [bgScroll addSubview:_mapView];
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"电梯的位置";
    _mapView.centerCoordinate = coor;
    [_mapView addAnnotation:annotation];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    // 生成重用标示identifier
    NSString *AnnotationViewID = @"xidanMark";
    
    // 检查是否有重用的缓存
    BMKAnnotationView* annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    // 缓存没有命中，自己构造一个，一般首次添加annotation代码会运行到此处
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        // 设置重天上掉下的效果(annotation)
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    // 设置位置
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    // 单击弹出泡泡，弹出泡泡前提annotation必须实现title属性
    annotationView.canShowCallout = YES;
    // 设置是否可以拖拽
    annotationView.draggable = NO;
    return annotationView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title=@"维修详情";
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self LoadUI];
    [self RequestNet];
}
- (void)LoadUI {
    bgScroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:bgScroll];
    [self startLocation];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_mapView.frame)+10, 95, 20)];
    [self setViewImage:@"content.png" Title:@"维修人员:" View:view1 Labelwidth:65];
    [bgScroll addSubview:view1];
    labName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view1.frame)+10, view1.frame.origin.y, SCREEN_WIDTH-labName.frame.origin.x-10, 20)];
    labName.textColor = GrayColor(181);
    labName.font = [UIFont systemFontOfSize:14];
    [bgScroll addSubview:labName];
    
    UILabel *labline1 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labName.frame)+10, SCREEN_WIDTH-10, 1)];
    labline1.backgroundColor = GrayColor(238);
    [bgScroll addSubview:labline1];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labline1.frame)+10, 95, 20)];
    [self setViewImage:@"content.png" Title:@"维修日期:" View:view2 Labelwidth:65];
    [bgScroll addSubview:view2];
    labtime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view2.frame)+10, view2.frame.origin.y, SCREEN_WIDTH-labtime.frame.origin.x-10, 20)];
    labtime.textColor = GrayColor(181);
    labtime.font = [UIFont systemFontOfSize:14];
    [bgScroll addSubview:labtime];
    UILabel *labline2 = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labtime.frame)+10, SCREEN_WIDTH-10, 1)];
    labline2.backgroundColor = GrayColor(238);
    [bgScroll addSubview:labline2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labline2.frame)+10, 95, 20)];
    [self setViewImage:@"content.png" Title:@"维修内容:" View:view3 Labelwidth:65];
    [bgScroll addSubview:view3];
    labContent = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(view3.frame)+10, view3.frame.origin.y, SCREEN_WIDTH-labContent.frame.origin.x-10, 20)];
    labContent.textColor = GrayColor(181);
    labContent.font = [UIFont systemFontOfSize:14];
    [bgScroll addSubview:labContent];
    
    UILabel *labline3=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(labContent.frame)+10,SCREEN_WIDTH,5)];
    labline3.backgroundColor = GrayColor(238);
    [bgScroll addSubview:labline3];
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labline3.frame)+10, 150, 20)];
    [self setViewImage:@"front.png" Title:@"维修前照片" View:view4 Labelwidth:100];
    [bgScroll addSubview:view4];
    imgBefore = [[EGOImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view4.frame)+10, SCREEN_WIDTH, 200)];
    imgBefore.contentMode = UIViewContentModeScaleAspectFit;
    [bgScroll addSubview:imgBefore];
    
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(imgBefore.frame)+10, 150, 20)];
    [self setViewImage:@"after.png" Title:@"维修后照片" View:view5 Labelwidth:100];
    [bgScroll addSubview:view5];
    imgAfter = [[EGOImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view5.frame)+10, SCREEN_WIDTH, 200)];
//    imgAfter.backgroundColor = [UIColor lightGrayColor];
    imgAfter.contentMode = UIViewContentModeScaleAspectFit;
    [bgScroll addSubview:imgAfter];
    bgScroll.contentSize = CGSizeMake(0, CGRectGetMaxY(imgAfter.frame)+64);
}
- (void)setViewImage:(NSString*)imgName Title:(NSString*)title View:(UIView*)view Labelwidth:(float)width {
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    img.image = [UIImage imageNamed:imgName];
    [view addSubview:img];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame)+10, 0, width, 20)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = RGBACOLOR(131, 145, 177, 1);
    [view addSubview:label];
}
- (void)RequestNet {
    NSMutableDictionary *dicHeader = [[NSMutableDictionary alloc]init];
    [dicHeader setValue:app.userInfo.UserID forKey:@"UserId"];
    NSMutableDictionary *dicparams = [NSMutableDictionary dictionary];
    [dicparams setValue:[NSString stringWithFormat:@"%@",self.dicData[@"ID"]] forKey:@"Id"];
    [XXNet GetURL:RepairRecordDetailURL header:dicHeader parameters:dicparams succeed:^(NSDictionary *data) {
        if ([data[@"Success"]intValue]) {
            NSDictionary *dicJson = [data[@"Data"] objectFromJSONString];
            [self performSelectorOnMainThread:@selector(GetDetailSuccess:) withObject:dicJson waitUntilDone:NO];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)GetDetailSuccess:(NSDictionary*)data {
    labName.text = [NSString stringWithFormat:@"%@",data[@"User"][@"UserName"]];
    labtime.text = [NSString stringWithFormat:@"%@",data[@"CreateTime"]];
    labContent.text = [NSString stringWithFormat:@"%@",data[@"Remark"]];
    NSString *jingweidu = [NSString stringWithFormat:@"%@",data[@"RepairPosition"]];
    NSArray *arrjingweidu = [jingweidu componentsSeparatedByString:@","];
    NSString *longit = [arrjingweidu firstObject];
    Longitude = longit.floatValue;
    NSString *Lati = [arrjingweidu lastObject];
    Latitude = Lati.floatValue;
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = Latitude;
    coor.longitude = Longitude;
    annotation.coordinate = coor;
    annotation.title = @"电梯的位置";
    [_mapView setCenterCoordinate:coor];
    [_mapView addAnnotation:annotation];
    NSString *str_before = [NSString stringWithFormat:@"%@",data[@"BeforePhoto"]];
    str_before = [NSString stringWithFormat:@"%@%@",Ksdby_api_Img,[str_before stringByReplacingOccurrencesOfString:@"~" withString:@""]];
    NSString *str_after  = [NSString stringWithFormat:@"%@",data[@"AfterPhoto"]];
    str_after = [NSString stringWithFormat:@"%@%@",Ksdby_api_Img,[str_after stringByReplacingOccurrencesOfString:@"~" withString:@""]];
    imgBefore.imageURL = [NSURL URLWithString:str_before];
    imgAfter.imageURL = [NSURL URLWithString:str_after];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
