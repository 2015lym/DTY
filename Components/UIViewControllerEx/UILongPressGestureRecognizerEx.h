//
//  UILongPressGestureRecognizerEx.h
//  HIChat
//
//  Created by 宋安安 on 14-5-20.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILongPressGestureRecognizerEx : UILongPressGestureRecognizer
@property (nonatomic ,weak) UIImageView *perentView;
@property (nonatomic ,weak) NSString *str_attuid;
@end
