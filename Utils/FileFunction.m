//
//  FileFunction.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/4/26.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "FileFunction.h"

@implementation FileFunction

+ (NSString *)getTmpPath {
    return NSTemporaryDirectory();
}

+ (NSString *)getSandBoxPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
}

+ (NSString *)getVideoPath {
    NSString *sandbox = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *video = [NSString stringWithFormat:@"file://%@/video", sandbox];
    return video;
}

+ (NSString *)saveImage:(UIImage *)image {
    
    /* ---如果图片长度或宽度大于1000，则压缩图片宽度为200，高度保持原比例---*/
    if (image.size.width>1000 || image.size.height>1000) {
        image = [self ymimageCompressForWidth:image targetWidth:700];
    }
    
    //获取沙盒
    NSString *path = [self getSandBoxPath];
    NSString *imageName = [NSString stringWithFormat:@"%@.png", [BaseFunction getTimestamp]];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", path, imageName];
    NSLog(@"图片路径：%@", imagePath);
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    return imageName;
}


/* ---图片大小压缩LYM---*/
+ (UIImage *)ymimageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


// 删除文件
+ (BOOL)deleteFileAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
