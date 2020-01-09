//
//  FileFunction.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/4/26.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileFunction : NSObject

+ (NSString *)getTmpPath;
+ (NSString *)getSandBoxPath;
+ (NSString *)getVideoPath;
+ (NSString *)saveImage:(UIImage *)image;
+ (BOOL)deleteFileAtPath:(NSString *)path;
+ (UIImage *)ymimageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
@end
