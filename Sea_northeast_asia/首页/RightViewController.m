  //
//  RightViewController.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/6/29.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "RightViewController.h"
#import "LoginViewController.h"
#import "JSONKit.h"
#import "BPush.h"
#import "Util.h"
#import "MessageCenterViewController.h"
@interface RightViewController ()

@end

@implementation RightViewController
//@synthesize app;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _baiduPushChang1.transform = CGAffineTransformMakeScale(0.75, 0.75);
    //app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view from its nib.
    //添加手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeAction)];
    leftSwipe.direction = leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:leftSwipe];
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    
    [self haveTOKEN];
    
    /*缓存标签*/
    str_CachePath_baiduPushSetSelect = [NSString stringWithFormat:@"%@%@",[Util GetMyCachesPath],@"baiduPushSetSelect"];
    NSMutableArray *baiduArray=[NSMutableArray arrayWithContentsOfFile:str_CachePath_baiduPushSetSelect];
    if(baiduArray!=nil)
    {
        int iselect=[baiduArray[0] intValue];
    _baiduPushChang1.on=iselect;
    }
    
    imageRed=[[UIImageView alloc] init];
    imageRed.frame=CGRectMake(62, 15, 10, 10);
    [imageRed setBackgroundColor:[UIColor redColor]];
    imageRed.layer.masksToBounds=YES;
    imageRed.layer.cornerRadius=5;
    [view_Message addSubview:imageRed];
//    [self setImageRed:YES];
   [self showCache];
}


-(void)haveTOKEN
{
    
    //1.check
    if(super.app.str_token.length==0)
    {
        [self showPersonInfoDefault];
        return;
    }
    [self showPersonInfo];
    [self checkTOKEN:@"logding"];//登录验证

}
- (void)leftSwipeAction{
    [_delegate rightCloseView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)root_View_ClickEvent:(id)sender{
     [_delegate rightCloseView];
}

-(IBAction)btn_Login_Event:(id)sender{

    [_delegate rightCloseView];
    [_delegate rightLoginEvent];
    
}

#pragma mark TOKEN验证是否失效
-(void)checkTOKEN:(NSString *)type
{
    if (super.app.str_token.length==0) {
        [self btn_Login_Event:nil];
        return;
    }
    
    NSMutableDictionary *dic_args=[NSMutableDictionary dictionary];
    NSString *token=super.app.str_token;
    [dic_args setObject:token forKey:@"access_token"];
    [dic_args setObject:@"code" forKey:@"response_type"];
    [dic_args setObject:@"verToken" forKey:@"redirect_uri"];
    [dic_args setObject:@"{\"isToken\":true,\"param\":{}}" forKey:@"state"];
    
    [[AFAppDotNetAPIClient sharedClient_token]
     POST:@"apiDataByAccessToken.php"
     parameters:dic_args
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"success:%@",responseObject);
         NSString *str_result=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSDictionary* dic_result=[str_result objectFromJSONString];
//         NSString *status=[dic_result objectForKey:@"status"];
         NSString *message=[dic_result objectForKey:@"message"];
         
         if(message!=nil&&[message isEqualToString:@"token验证成功！"])
         {
             if ([type isEqualToString:@"logding"]) {
                 [self showPersonInfo];
             }
             else if([type isEqualToString:@"MessageCenter"])
             {
                 [_delegate rightMessageCenter];
                 [_delegate setHidden];
             }
             
         }
         else
         {
             if ([type isEqualToString:@"logding"]) {
                 super.app.str_token=@"";
                 NSUserDefaults *dic_oAuth=[NSUserDefaults standardUserDefaults];
                 [dic_oAuth removeObjectForKey:@"str_token"];
                 [dic_oAuth removeObjectForKey:@"username"];
                 [dic_oAuth removeObjectForKey:@"nikename"];
                 [dic_oAuth removeObjectForKey:@"pwd"];
                 [dic_oAuth removeObjectForKey:@"uhead"];
                 [self showPersonInfoDefault];
             }
             else if([type isEqualToString:@"MessageCenter"])
             {
                 super.app.str_token=@"";
                 [self btn_Login_Event:nil];
             }
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"error:%@",[error userInfo] );
         super.app.str_token=@"";
         
         [self showPersonInfoDefault];
     }];
   
}



-(void)showPersonInfo
{
    
    personNikename.text=super.app.userInfo.nikename;
    
    NSString *URL = super.app.userInfo.uhead;
 
    NSString *str_url=[NSString stringWithFormat:@"%@",URL];
    NSURL *imageurl=[NSURL URLWithString:str_url];
    personHead.imageURL=imageurl;
    [personHead setContentScaleFactor:[[UIScreen mainScreen] scale]];
    personHead.contentMode =  UIViewContentModeScaleAspectFill;
    personHead.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    CGRect rect_head= personHead.frame;
    rect_head.size=CGSizeMake(38, 38);
    [personHead setFrame:rect_head];
    personHead.layer.masksToBounds = YES; //没这句话它圆不起来
    personHead.layer.cornerRadius = 19;
    
}

-(void)showPersonInfoDefault
{
    personNikename.text=@"账户登陆";
    [personHead setImage:[UIImage imageNamed:@"rightmenu01.png"]];
}

-(IBAction)btn_About_OnClick:(id)sender
{
    [_delegate rightAboutEvent];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)baiduPushChangBtn:(id)sender {
   
}
-(IBAction)btn_messageCenterOnClick:(id)sender
{
    [self checkTOKEN:@"MessageCenter"];
}
-(void)setImageRed:(BOOL)hidden
{
    [imageRed setHidden:hidden];
}
- (IBAction)baiduPushChangeBtn1:(id)sender {
    UISwitch *currBtn=sender;
    BOOL currSelect=  currBtn.on;
    //int currSelect=(int)currBtn.selectedSegmentIndex;
    if( currSelect==true)
    {
        [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
            // 绑定返回值
            if (result[@"response_params"][@"channel_id"]) {
                
            }
            
            
        }];
        
    }
    else
    {
        [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
            
        }];
        
    }
    
    NSMutableArray *_select=[NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%d",currSelect],nil];
    [_select writeToFile:str_CachePath_baiduPushSetSelect atomically:YES];
}

- (IBAction)btnclearCache:(id)sender {
    [self clearFile];
}
-( void )showCache
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    float value= [ self folderSizeAtPath :cachPath];
    
    lab_Cache.text=[NSString stringWithFormat:@"[%.1fM]",value];
    if([lab_Cache.text isEqualToString:@"[0.0M]"])
        {
             lab_Cache.text=@"";
        }
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}
// 清理缓存

- (void)clearFile
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    /*
    cachPath=[cachPath stringByAppendingString:@"/com.search.northeast.asia.ksdby/EGOCache"];
    EGOCache *ego=[[EGOCache alloc]initWithCacheDirectory:cachPath];
    [ego clearCache];
    //[[EGOCache __deprecated] clearCache];
    
    return;
*/
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        BOOL isdir = NO;
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path  isDirectory:&isdir]) {
            
            //EGOCache.plist不清
            if([path rangeOfString:@"EGOCache.plist"].location !=NSNotFound)
            {
                continue;
            }
            //文件夹不清
            if(isdir )
            {
                continue;
            }
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}
-(void)clearCachSuccess
{
    NSLog ( @" 清理成功 " );
    
    //NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:0];//刷新
    //[_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    lab_Cache.text=@"";
}
@end
