//
//  MBPImageView.h
//  HIChat
//
//  Created by Song Ques on 14-7-2.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBPImageView : UIImageView
{
    NSTimer *PV_Timer;
    NSMutableArray *array_source;
    BOOL isRun;
    int index;
}

-(void)start;
-(void)stop;

@end
