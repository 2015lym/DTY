//
//  WorkTableViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/21.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "WorkTableViewController.h"

#import "WorkCollectionView.h"
#import "WorkCollectionViewCell.h"
#import "WorkCollectionReusableView.h"

#import "AppDelegate.h"

/* 电梯业务 */
#import "AloneWBListVC.h"
#import "DTWBWebViewController.h"

#import "WXJLListWebViewController.h"
#import "JYGLViewController.h"
#import "BJYLWViewController.h"
#import "JYGLListWebViewController.h"
#import "PhysicalUnionWebVC.h"
#import "WZHMainViewController.h"
#import "YJFXMainViewController.h"
#import "PhysicalUnionWebVC.h"
#import "PhysicalUnionWebVC.h"


/* 老旧电梯 */
#import "Task_WorkViewController.h"
#import "Env_WorkListViewController.h"
#import "Old_WorkViewController.h"
#import "Part_WorkViewController.h"
#import "Examine_HomeViewController.h"

#import <CoreLocation/CoreLocation.h>

@interface WorkTableViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate>
@property (nonatomic,strong) AppDelegate *app;

@property (nonatomic, strong) WorkCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *dataArray1;
@property (nonatomic, strong) NSMutableArray *dataArray2;

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation WorkTableViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"智慧电梯管理平台";
    
    _app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    _sectionArray = [NSMutableArray arrayWithObjects:@"电梯业务", @"电梯改造", nil];
    _dataArray1 = [NSMutableArray arrayWithObjects:@"电梯维保", @"维修记录", @"电梯年检", @"报警仪联网", @"检测服务", @"物联监控", @"无纸化维保", @"预警分析", @"通知通告", @"投诉建议", nil];
    _dataArray2 = [NSMutableArray arrayWithObjects:@"电梯评估", @"园区环境评估", @"电梯施工", @"部件管理", @"电梯检验", nil];
    [self createCollectionView];
    
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 取得定位权限，有两个方法，取决于你的定位使用情况
    // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
    // 这句话ios8以上版本使用。
    [_locationManager requestAlwaysAuthorization];
    // 开始定位
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:locations.firstObject completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获取当前城市
            NSString *city = placemark.locality;
            if (!city) {
                //注意：四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
            NSString *adderss = [NSString stringWithFormat:@"%@%@%@", city, placemark.subLocality, placemark.thoroughfare];
            [UserService setUserAddress:adderss];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else if (error == nil && [array count] == 0) {
            NSLog(@"没有结果返回.");
        }
        else if (error != nil)  {
            //NSLog(@"An error occurred = %@", error);
        }
    }];
}

#pragma mark - ---------- 创建collectionView ----------
- (void)createCollectionView {
    _collectionView = [[WorkCollectionView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight -kTabBarHeight - 10)];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _sectionArray.count;
}

#pragma mark - ---------- item数量 ----------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _dataArray1.count;
    } else {
        return _dataArray2.count;
    }
}

#pragma mark - ---------- Cell的内容 ----------
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId"
                                                                              forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.titleLabel.text = _dataArray1[indexPath.row];
        cell.itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"业务-%@", _dataArray1[indexPath.row]]];
    } else {
        cell.titleLabel.text = _dataArray2[indexPath.row];
        cell.itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"业务-%@", _dataArray2[indexPath.row]]];
    }
    [cell hyb_addCornerRadius:5];
    return cell;
}

#pragma mark - ---------- Cell的点击事件 ----------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if(indexPath.item == 0) {
            //电梯维保
            if (_app.userInfo.RoleId.intValue == 12 || _app.userInfo.RoleId.intValue == 13) {
                AloneWBListVC *awblist = [[AloneWBListVC alloc]init];
                [self.navigationController pushViewController:awblist animated:YES];
            } else {
                DTWBWebViewController *physical = [[DTWBWebViewController alloc]init];
                physical.web_url=@"/WebApp/Maintenance/Index?userid=";
                physical.web_title=@"电梯维保";
                [self.navigationController pushViewController:physical animated:YES];
            }
            
        } else if(indexPath.item == 1) {
            WXJLListWebViewController *physical = [[WXJLListWebViewController alloc]init];
            physical.web_url=@"/WebApp/Repair/index?userid=";
            physical.web_title=@"维修记录";
            [self.navigationController pushViewController:physical animated:YES];
        } else if(indexPath.item == 2) {
            JYGLViewController *ctvc=[[JYGLViewController alloc] init];
            ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
            [self.navigationController pushViewController:ctvc animated:YES];
        } else if(indexPath.item == 3) {
            BJYLWViewController *ctvc=[[BJYLWViewController alloc] init];
            ctvc.view.frame=CGRectMake(0, 64, bounds_width.size.width, bounds_width.size.height);
            [self.navigationController pushViewController:ctvc animated:YES];
        } else if(indexPath.item == 4) {
            JYGLListWebViewController *jygll = [[JYGLListWebViewController alloc]init];
            jygll.web_url=@"/WebApp/Inspect/Index?UserId=";
            jygll.web_title=@"检测服务";
            [self.navigationController pushViewController:jygll animated:YES];
        } else if(indexPath.item == 5) {
            PhysicalUnionWebVC *physical = [[PhysicalUnionWebVC alloc]init];
            physical.web_url=@"/WebApp/Monitoring/Index?userid=";
            physical.web_title=@"物联监控";
            [self.navigationController pushViewController:physical animated:YES];
            
        } else if(indexPath.item == 6) {
            WZHMainViewController *physical = [[WZHMainViewController alloc]init];
            [self.navigationController pushViewController:physical animated:YES];
        } else if(indexPath.item == 7) {
            YJFXMainViewController* physical = [[YJFXMainViewController alloc]init];
            [self.navigationController pushViewController:physical animated:YES];
        } else if(indexPath.item == 8) {
            PhysicalUnionWebVC *physical = [[PhysicalUnionWebVC alloc]init];
            physical.web_url=@"/WebApp/Notice/Index?userid=";
            physical.web_title=@"通知通告";
            [self.navigationController pushViewController:physical animated:YES];
        } else if(indexPath.item == 9) {
            PhysicalUnionWebVC *physical = [[PhysicalUnionWebVC alloc]init];
            physical.web_url=@"/WebApp/Complaint/Index?userid=";
            physical.web_title=@"投诉建议";
            [self.navigationController pushViewController:physical animated:YES];
        }
    } else {
        if (indexPath.item == 0) {
            Task_WorkViewController *vc = [Task_WorkViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.item == 1) {
            Env_WorkListViewController *vc = [Env_WorkListViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.item == 2) {
            Old_WorkViewController *vc = [Old_WorkViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.item == 3) {
            Part_WorkViewController *vc = [Part_WorkViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            Examine_HomeViewController *vc = [Examine_HomeViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - ---------- 头视图 ----------
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        WorkCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableId" forIndexPath:indexPath];
        header.titleLabel.text = _sectionArray[indexPath.section];
        reusableView = header;
    }
    //如果是头视图
    return reusableView;
}

@end
