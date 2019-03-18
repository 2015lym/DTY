//
//  UIViewControllerEx.m
//  YONChat
//
//  Created by SongQues on 14/11/6.
//
//

#import "UIViewControllerEx.h"
//#import "../../AlumniChat/AppDelegate.h"

@interface UIViewControllerEx ()

@end

@implementation UIViewControllerEx
@synthesize app;
@synthesize thrift_Location;
@synthesize is_Location;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    thrift_Location=YES;
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor=VIEW_BACKGROUNDCOLOR;
    //[self.tabBarController makeTabBarHidden:YES];
    [[UINavigationBar appearance] setTitleTextAttributes: @{ NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:20], UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero]}];
    [self setNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setNav
{
    
    __IOS6_S
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background.png"]forBarMetrics:UIBarMetricsDefault];
    UIButton *btn_back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    [btn_back setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [btn_back addTarget:self action:@selector(nav_back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barcItem = [[UIBarButtonItem alloc] initWithCustomView:btn_back];
    NSArray *leftButtonItems=@[barcItem];
    self.navigationItem.leftBarButtonItems=leftButtonItems;
    __IOS6_SE

    
    __IOS7_S
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backArrow"] style:UIBarButtonItemStylePlain target:self action:@selector(nav_back:)];
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    
    __IOS7_SE
    

}

-(IBAction)nav_back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)preSetNavForSlide
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        __IOS7_S
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        __IOS7_SE
    }
}

-(void)pushViewController:(UIViewController*)pushViewController  animated:(BOOL)animated;
{
    [self preSetNavForSlide];
    [self.navigationController pushViewController:pushViewController  animated:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



- (void) setupLocationManager {
    
    NSDate *date_Now=[Util convertStringToDate:[Util nowDateToString:@"yyyy-MM-dd HH:mm:ss"] formatValue:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeInterval time=[date_Now timeIntervalSinceDate:Date_Location];
    int minute=((int)time)%(3600*24)%3600/60;
    if (minute>5||thrift_Location==NO) {
//        self.app.Date_Location=[Util convertStringToDate:[Util nowDateToString:@"yyyy-MM-dd HH:mm:ss"] formatValue:@"yyyy-MM-dd HH:mm:ss"];
        [locationManager stopUpdatingLocation];
        locationManager=nil;
        locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled]) {
            //NSLog( @"Starting CLLocationManager" );
            locationManager.delegate = self;
            locationManager.distanceFilter =10.f;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
            {
#ifdef __IPHONE_8_0
                [locationManager requestWhenInUseAuthorization];
                [locationManager requestAlwaysAuthorization];
#endif
            }
            [locationManager startUpdatingLocation];
            
        } else {
            NSLog( @"Cannot Starting CLLocationManager" );
             locationManager.delegate = self;
             locationManager.distanceFilter = 200;
             locationManager.desiredAccuracy = kCLLocationAccuracyBest;
             [locationManager startUpdatingLocation];
        }
    }
    else
    {
        [self performSelector:@selector(BroadcastingLocation) withObject:nil afterDelay:0.1];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if(kCLAuthorizationStatusNotDetermined==[CLLocationManager authorizationStatus])
        is_Location=NO;
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted)
        is_Location=NO;
    else if(kCLAuthorizationStatusDenied==[CLLocationManager authorizationStatus])
        is_Location=NO;
    else
    {
        is_Location=YES;
        thrift_Location=YES;
    }
    if (locations.count!=0) {
        locationManager=manager;
        CLLocation *newLocation=[locations objectAtIndex:locations.count-1];
        checkinLocation = newLocation;
//        self.app.checkinLocation=checkinLocation;
        // 获取经纬度
        NSLog(@"纬度:%f",newLocation.coordinate.latitude);
        NSLog(@"经度:%f",newLocation.coordinate.longitude);
        //------------------位置反编码---5.0之后使用-----------------
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation
                       completionHandler:^(NSArray *placemarks, NSError *error)
        {
            for (CLPlacemark *place in placemarks)
            {
                NSLog(@"name,%@",place.name);                       // 位置名
               NSLog(@"locality,%@",place.locality);               // 市
               NSLog(@"country,%@",place.administrativeArea);
                Provinces=[NSString stringWithFormat:@"%@",place.administrativeArea];
                City=[NSString stringWithFormat:@"%@",place.locality];;
            }
        }];
        Date_Location=[Util convertStringToDate:[Util nowDateToString:@"yyyy-MM-dd HH:mm:ss"] formatValue:@"yyyy-MM-dd HH:mm:ss"];
        if(manager)
            [manager stopUpdatingLocation];
    }
   
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if(kCLAuthorizationStatusNotDetermined==[CLLocationManager authorizationStatus])
        is_Location=NO;
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted)
        is_Location=NO;
    else if(kCLAuthorizationStatusDenied==[CLLocationManager authorizationStatus])
        is_Location=NO;
    else
    {
        is_Location=YES;
        thrift_Location=YES;
    }
    checkinLocation = newLocation;
    //self.app.checkinLocation=checkinLocation;
    // 获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);
    // 停止位置更新
    if(manager)
        [manager stopUpdatingLocation];
}
*/
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    //NSLog(@"无法获得定位信息");
    is_Location=NO;
    [manager stopUpdatingLocation];
    
}


-(void)BroadcastingLocation
{
   
    if (locationManager==nil) {
        locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled]) {
            //NSLog( @"Starting CLLocationManager" );
            locationManager.delegate = self;
            locationManager.distanceFilter =10.f;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
            {
#ifdef __IPHONE_8_0
                [locationManager requestWhenInUseAuthorization];
                [locationManager requestAlwaysAuthorization];
#endif
            }
            [locationManager startUpdatingLocation];
            
        } else {
            NSLog( @"Cannot Starting CLLocationManager" );
            locationManager.delegate = self;
            locationManager.distanceFilter = 200;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [locationManager startUpdatingLocation];
        }
    }
    else
    {
//       NSArray *arr=[[NSArray alloc]initWithObjects:checkinLocation, nil];
//       [self locationManager:locationManager didUpdateLocations:arr];
    }
    
    
 
}




@end
