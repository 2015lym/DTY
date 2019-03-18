//
//  NTESMeetingView.m
//  Sea_northeast_asia
//
//  Created by wyc on 2017/6/12.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "NTESMeetingView.h"
#import "NTESMeetingRolesManager.h"
#import "UIView+NTES.h"
#import "NTESGLView.h"
#import <NIMAVChat/NIMAVChat.h>
#import "NTESVideoFSViewController.h"
#import "AppDelegate.h"
#define NTESMeetingMaxActors 4

@interface NTESMeetingView()<NIMNetCallManagerDelegate>
{
    NSMutableArray *_actorViews;
    NSMutableArray *_actors;
    NSMutableArray *_backgroundViews;
}

@property (nonatomic, weak) UIView *localVideoLayer;
@property (nonatomic, strong) NTESVideoFSViewController *videoVc;
@property (nonatomic, strong) UIButton *fullScreenBtn;

@end

@implementation NTESMeetingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _actorViews = [NSMutableArray array];
        _backgroundViews = [NSMutableArray array];
        _videoVc = [[NTESVideoFSViewController alloc]init];
        
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImage = [UIImage imageNamed:@"meeting_background2"];
        _fullScreenBtn.hidden = YES;
        for (int i = 0; i < NTESMeetingMaxActors; i++) {
            UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
            [self addSubview:background];
            [_backgroundViews addObject:background];
            
            NTESGLView *view = [[NTESGLView alloc] initWithFrame:self.bounds];
            
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.backgroundColor = [UIColor clearColor];
            [view render:nil width:0 height:0];
            [self addSubview:view];
            [_actorViews addObject:view];
            
        }
        [self updateActors];
        [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    }
    return self;
}


- (void)dealloc
{
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}

- (void)onLocalDisplayviewReady:(CALayer *)layer
{
    if ([NTESMeetingRolesManager sharedInstance].myRole.isActor) {
        [self startLocalPreview:layer];
    }
    else {
        _localVideoLayer = layer;
    }
}

- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    
    
    //NSLog(@"%ld===%@",_actors.count,yuvData);
    
    
    if (_actors.count == 0) {
        return;
    }
    NSUInteger viewIndex = [_actors indexOfObject:user];
    
    //判断是否全屏
    if(_isFullScreen)
    {
        if(viewIndex == 0)
        {
            [_videoVc onRemoteYUVReady:yuvData width:width height:height from:user];
        }
    }
    else
    {
        if (viewIndex != NSNotFound && viewIndex < NTESMeetingMaxActors) {
            NTESGLView *view = _actorViews[viewIndex];
            [view render:yuvData width:width height:height];
            
            //2.
            UIView *myview = (UIButton *)[view viewWithTag:(10000)];
            if(myview ==nil)
            {
                [self showUserInfo:view forID:user];
            }
            
            if(viewIndex == 0)
            {
                if(_showFullScreenBtn)
                {
                    _fullScreenBtn.hidden = NO;
                    
                }
                else
                {
                    _fullScreenBtn.hidden = YES;
                }
            }
        }
    }
}

-(void)setShowFullScreenBtn:(BOOL)showFullScreenBtn
{
    _showFullScreenBtn = showFullScreenBtn;
    if(!showFullScreenBtn)
    {
        _fullScreenBtn.hidden = !showFullScreenBtn;
    }
    //退出全屏
    if (self.isFullScreen&&!showFullScreenBtn ) {
        [_videoVc onExitFullScreen];
    }
}

-(void)goFullScreen
{
    [self.viewController presentViewController:_videoVc animated:NO completion:^{
        self.isFullScreen = YES;
    }];
}

- (void)startLocalPreview:(UIView *)layer
{
    [self stopLocalPreview];
    
    DDLogInfo(@"Start local preview");
    
    _localVideoLayer = layer;
    
    //NSLog(@"+++++%ld",[self localViewIndex]);
    
    
    
    NTESGLView *localView = _actorViews[[self localViewIndex]];
    
    [localView render:nil width:0 height:0];
    [localView  addSubview:layer];
    layer.tag=20000;
//    [localView.layer addSublayer:_localVideoLayer];
    
    [self layoutLocalPreviewLayer];
}


-(void)stopLocalPreview
{
    DDLogInfo(@"Stop local preview");
    if (_localVideoLayer) {
        [_localVideoLayer removeFromSuperview];
    }
}

- (void)layoutLocalPreviewLayer
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat rotateDegree;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateDegree = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateDegree = M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateDegree = M_PI_2 * 3.0;
            break;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationUnknown:
            rotateDegree = 0;
            break;
    }
    
//    [_localVideoLayer setAffineTransform:CGAffineTransformMakeRotation(rotateDegree)];
    
    UIView *localView = _actorViews[[self localViewIndex]];
    _localVideoLayer.transform = CGAffineTransformMakeRotation(rotateDegree);
    _localVideoLayer.frame = localView.bounds;
    
    //show userinfo
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    UIView *myviewshow = (UIView *)[localView viewWithTag:(20000)];
    if(myviewshow !=nil)
    {
        //1.
        UIView *myview = (UIButton *)[myviewshow viewWithTag:(10000)];
        if(myview ==nil)
        {
            [self showUserInfo:myviewshow forID:myUid];
        }
        
        
    }
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < NTESMeetingMaxActors; i ++) {
        UIView *view = _actorViews[i];
        view.width = self.width/2;
        
        //每个视频视图的高度
        view.height = self.height/2;
        view.top = i < 2 ? 0 : self.height / 2;
        view.left = (i + 1) % 2 ? 0 : self.width / 2;
        //        if(i==0)
        //        {
        //            _fullScreenBtn.frame = CGRectMake(view.frame.size.width-7-30, view.frame.size.height-7-30, 30, 30);
        //            [_fullScreenBtn setImage: [UIImage imageNamed:@"chatroom_video_fullscreen"] forState:UIControlStateNormal];
        //            [_fullScreenBtn addTarget:self action:@selector(goFullScreen) forControlEvents:UIControlEventTouchUpInside];
        //            [view addSubview:_fullScreenBtn];
        //        }
        
        UIImageView *backgound = _backgroundViews[i];
        backgound.frame = view.frame;
    }
    
}

- (void)updateActors
{
    NSMutableArray *actors = [NSMutableArray arrayWithArray:[[NTESMeetingRolesManager sharedInstance] allActors]];
    
    //NSLog(@"actors==%@",actors);
    
    
    [actors sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *actor1  = obj1;
        NSString *actor2  = obj2;
        NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
        NTESMeetingRole *role1 = [[NTESMeetingRolesManager sharedInstance] role:actor1];
        NTESMeetingRole *role2 = [[NTESMeetingRolesManager sharedInstance] role:actor2];
        NSLog(@"actor1==%d",role1.isActor);
        NSLog(@"actor2==%d",role2.isActor);
        //Manager排第一
        if (role1.isManager) {
            return NSOrderedAscending;
        }
        else if (role2.isManager) {
            return NSOrderedDescending;
        }
        
        //自己排第二（如果自己不是Manager）
        if ([actor1 isEqualToString:myUid]) {
            return NSOrderedAscending;
        }
        else if ([actor2 isEqualToString:myUid]) {
            return NSOrderedDescending;
        }
        
        return NSOrderedAscending;
        
    }];
    
    if (actors.count != _actors.count) {
        for (NTESGLView *view in _actorViews) {
            [view render:nil width:0 height:0];
            
            //3.
            for (UIView *con in view.subviews) {
                
                if(con.tag==10000)
                {
                    [con removeFromSuperview];
                }
                if([con isKindOfClass:[UIButton class]])
                {
                    con.hidden=YES;
                }
            }
        }
    }
    
    _actors = actors;
    
    if (_localVideoLayer) {
        
        [self onLocalDisplayviewReady:_localVideoLayer];
    }
}

-(NSUInteger)localViewIndex
{
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    if (_actors.count) {
        return [_actors indexOfObject:myUid];
    }
    else {
        return NSNotFound;
    }
}
-(void)showUserInfo:(NTESGLView *)view forID:(NSString *)uid
{
    
    
    UIView * myview=[[UIView alloc]init];
    myview.frame=CGRectMake(0, view.frame.size.height-32, view.frame.size.width, 32);
    [view addSubview:myview];
    myview.tag=10000;
    myview.backgroundColor=[UIColor blackColor];
    myview.alpha=0.5;//实现透明效果
    
    
    NSString *name;
    NSString *ucode;
    AppDelegate *app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if(app.meetingUsers.count>0)
    {
        for (NSDictionary *dic in app.meetingUsers) {
            if([dic[@"WYID"] rangeOfString:uid].location !=NSNotFound)
            {
                name=[CommonUseClass FormatString:  dic[@"name"]];
                ucode=[CommonUseClass FormatString: dic[@"ucode"]];
                break;
            }
        }
    }
    NSString *str=[NSString stringWithFormat:@"  %@(%@)",name,ucode];
    if([ucode isEqual:@""])
    {
        str=[NSString stringWithFormat:@"%@",name];
    }
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(0, 0, myview.frame.size.width, myview.frame.size.height);
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    label.numberOfLines=2;
    label.text=str;
    [myview addSubview:label];
}
@end
