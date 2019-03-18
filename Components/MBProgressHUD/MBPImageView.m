//
//  MBPImageView.m
//  HIChat
//
//  Created by Song Ques on 14-7-2.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import "MBPImageView.h"

@implementation MBPImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        index=0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)start
{
    if (!isRun) {
        isRun=YES;
        array_source=[NSMutableArray array];
        [array_source addObject:@"MBProgressHUD.bundle/run1"];
        [array_source addObject:@"MBProgressHUD.bundle/run2"];
        [array_source addObject:@"MBProgressHUD.bundle/run3"];
        [array_source addObject:@"MBProgressHUD.bundle/run4"];
        index=0;
        PV_Timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer_update) userInfo:nil repeats:YES];


    }
}

-(void)stop
{
    isRun=NO;
    [PV_Timer invalidate];
    PV_Timer=nil;
    [array_source removeAllObjects];
}

-(void)timer_update
{
    if (index==4) {
        index=0;
    }
    NSString *str_image=[array_source objectAtIndex:index];
    self.image=[UIImage imageNamed:str_image];
    index++;
}

-(void)dealloc
{
    if (PV_Timer) {
        [PV_Timer invalidate];
    }
    PV_Timer=nil;
}

@end
