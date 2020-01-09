//
//  ImageUtils.h
//  DJGJ_JN
//
//  Created by Lym on 2018/10/11.
//  Copyright © 2018 Lym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

// 获取原型UIView
+ (UIView *)getRoundView:(UIView *)view targetSize:(CGFloat)size;

// 获取圆形Label
+ (UILabel *)getRoundLabel:(UILabel *)view targetSize:(CGFloat)size;

// 获取圆形按钮
+ (UIButton *)getRoundButton:(UIButton *)view targetSize:(CGFloat)size;

// 获取原型图片
+ (UIImageView *)getRoundImageView:(UIImageView *)view targetSize:(CGFloat)size;

// 设置按钮图片
+ (void)setButtonImage:(UIButton *)btn andUrlString:(NSString *)urlString;

// 压缩图片
+ (UIImage *)compressImageQuality:(UIImage *)sourceImage;

/**
 *  改变图片的大小
 *
 *  @param img     需要改变的图片
 *  @param newsize 新图片的大小
 *
 *  @return 返回修改后的新图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;

@end
