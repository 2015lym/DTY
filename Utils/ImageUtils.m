//
//  ImageUtils.m
//  DJGJ_JN
//
//  Created by Lym on 2018/10/11.
//  Copyright © 2018 Lym. All rights reserved.
//

#import "ImageUtils.h"
#import "UIButton+WebCache.h"

@implementation ImageUtils

+ (UIView *)getRoundView:(UIView *)view targetSize:(CGFloat)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(size, size)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    return view;
}

+ (UILabel *)getRoundLabel:(UILabel *)view targetSize:(CGFloat)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(size, size)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    return view;
}

+ (UIButton *)getRoundButton:(UIButton *)view targetSize:(CGFloat)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(size, size)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    return view;
}

+ (UIImageView *)getRoundImageView:(UIImageView *)view targetSize:(CGFloat)size {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(size, size)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
    return view;
}

+ (void)setButtonImage:(UIButton *)btn andUrlString:(NSString *)urlString {
    [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:urlString]
                             forState:UIControlStateNormal
                     placeholderImage:[UIImage imageNamed:@"占位图-1"]];
}

+ (UIImage *)compressImageQuality:(UIImage *)sourceImage {
//    UIImage *resultImage = [UIImage imageWithData:[self zipNSDataWithImage:image]];
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280||height>1280) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        } else {
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
        //2.宽大于1280高小于1280
    }else if(width>1280||height<1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
        //3.宽小于1280高大于1280
    }else if(width<1280||height>1280){
        CGFloat scale = width/height;
        height = 1280;
        width = height*scale;
        //4.宽高都小于1280
    } else {
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return [UIImage imageWithData:data];
}

/**
 *  改变图片的大小
 *
 *  @param img     需要改变的图片
 *  @param newsize 新图片的大小
 *
 *  @return 返回修改后的新图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize {
    if (img.size.height < 70 && img.size.width < 70) {
        return img;
    } else {
        UIGraphicsBeginImageContext(newsize);
        [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
        UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
}

@end
