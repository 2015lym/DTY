//
//  MyControl.h
//  hepai
//
//  Created by apple  on 14-9-24.
//  Copyright (c) 2014年 ___QUICKPHONEGRAPH___. All rights reserved.
//

#import<Foundation/Foundation.h>
#import<UIKit/UIKit.h>
#import "CommonUseClass.h"
#import "EGOImageView.h"
@interface MyControl : NSObject
+(float)isIOS7;
+(UIView*)createViewWithFrame:(CGRect)frame backColor:(UIColor*)backcolor;
+(UIButton*)createButtonWithFrame:(CGRect)frame imageName:(NSString*)imageName bgImageName:(NSString*)bgImageName title:(NSString*)title SEL:(SEL)sel target:(id)target;

//创建ImageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame imageName:(NSString*)imageName;

//创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(float)font
Text:(NSString*)text;

+(UITextField*)createTextFildWithFrame:(CGRect)frame Font:(float)font
                           Text:(NSString*)text;

+(UIImageView*)createImageViewWithFrame_Url:(CGRect)frame imageName:(NSString*)imageName;
+(EGOImageView*)createEGOImageViewWithFrame_Url:(EGOImageView*)imageView imageName:(NSString*)imageName;

@end
