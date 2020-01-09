//
//  Util.m
//  WageQuery
//
//  Created by Song Ques on 13-6-7.
//  Copyright (c) 2013年 掌控力. All rights reserved.
//

#import "Util.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <AVFoundation/AVFoundation.h>
#define RATE  1000
@implementation Util
#pragma mark - 判断是否整形
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 得到一个月的天数
+ (int)howManyDaysInThisMonth:(int)year month:(int)imonth;
{
    if ((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if ((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if ((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if (year%400 == 0)
        return 29;
    if (year%100 == 0)
        return 28;
    return 29;
}

#pragma mark - 格式化当前时间
+ (NSString*)nowDateToString:(NSString*)formatValue
{
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:formatValue];
    NSDate *now = [NSDate date];
    NSString *str = [dateFormatte stringFromDate:now];
    dateFormatte=nil;
    return  str;
}

#pragma mark - 把字符串转换成时间
+ (NSDate *)convertStringToDate:(NSString*)strValue formatValue:(NSString*)formatValue
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatValue];
    NSDate *date = [dateFormatter dateFromString:strValue];
    return date;
    
}

#pragma mark - 把时间转换成字符串
+ (NSString *)convertDateToString:(NSDate*)dateValue formatValue:(NSString*)formatValue
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatValue];
    NSString *str = [dateFormatter stringFromDate:dateValue];
    return  str;
}

#pragma mark - 通过日期获取星座
+ (NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d {
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m < 1||m > 12||d < 1||d > 31){
        return nil;
    }
    if (m==2 && d>29)
    {
        return nil;
    } else if (m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return nil;
        }
    }
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2- (d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue]- (-19))*2,2)]];
    
    if (result==nil) {
        result = [NSString stringWithFormat:@"%@座",@"未知"];
    }
    else
    {
        result = [NSString stringWithFormat:@"%@座",result];
    }
    return result;
}

#pragma mark -  把时间显示成文字
+ (NSString*)day_hour_string:(NSDate*)startData endDate:(NSDate*)endDate
{
    NSTimeInterval time = [endDate timeIntervalSinceDate:startData];
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minute=((int)time)%(3600*24)%3600/60;
    //NSString *dateContent = [[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    NSString *dateContent;
    if (days<=0)
    {
        if (hours==0)
        {
            if (minute==0) {
                dateContent = [[NSString alloc] initWithFormat:@"刚刚"];
            }
            else
            {
                dateContent = [[NSString alloc] initWithFormat:@"%i分钟前",minute];
            }
        }
        else
        {
            dateContent = [[NSString alloc] initWithFormat:@"%i小时前",hours];
        }
    }
    else
    {
        if (days>30&&days<60)
        {
            dateContent=@"1个月前";
        }
        else if (days>60)
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateContent = [dateFormatter stringFromDate:startData];
           
        }
        else
        {
            dateContent = [[NSString alloc] initWithFormat:@"%i天前",days];
        }
        
    }
    return dateContent;
}

#pragma mark -  把时间显示成文字
+ (NSString*)day_hour_stringNew:(NSDate*)startData endDate:(NSDate*)endDate
{
    NSTimeInterval time = [endDate timeIntervalSinceDate:startData];
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
    int minute=((int)time)%(3600*24)%3600/60;
    //NSString *dateContent = [[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    NSString *dateContent;
    if (days<=0)
    {
        if (hours==0)
        {
            if (minute==0) {
                dateContent = [[NSString alloc] initWithFormat:@"刚刚"];
            }
            else
            {
                dateContent = [[NSString alloc] initWithFormat:@"%i分钟前",minute];
            }
        }
        else
        {
            dateContent = [[NSString alloc] initWithFormat:@"%i小时前",hours];
        }
    }
    else
    {
        if (days>=1&&days<2)
        {
          dateContent=@"昨天";
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            dateContent = [dateFormatter stringFromDate:startData];
            
        }
        
    }
    return dateContent;
}


#pragma mark 比较时间

/**
 /////  和当前时间比较
 ////   1）1分钟以内 显示        :    刚刚
 ////   2）1小时以内 显示        :    X分钟前
 ///    3）今天或者昨天 显示      :    今天 09:30   昨天 09:30
 ///    4) 今年显示              :   09月12日
 ///    5) 大于本年      显示    :    2013/09/09
 **/

+ (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
{
    
    @try {
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:formate];
        
        NSDate * nowDate = [NSDate date];
        
        /////  将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
        /////  取当前时间和转换时间两个日期对象的时间间隔
        /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //// 再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = @"";
        
        if (time<=60) {  //// 1分钟以内的
            dateStr = @"刚刚";
        } else if (time<=60*60){  ////  一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        } else if (time<=60*60*24){   //// 在两天内的
            
            [dateFormatter setDateFormat:@"YYYY/MM/dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //// 在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            } else {
                ////  昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        } else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                ////  在同一年
                [dateFormatter setDateFormat:@"MM月dd日"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            } else {
                [dateFormatter setDateFormat:@"yyyy年MM月dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

#pragma mark - 判断是否含有特殊字符
//判断是否含有特殊字符
+ (BOOL) hasSpecialCharacter:(NSString*) str
{
    
    BOOL ret = NO;
    
    if ([str rangeOfString:@"!"].length > 0 ||
        [str rangeOfString:@"@"].length > 0 ||
        [str rangeOfString:@"#"].length > 0 ||
        [str rangeOfString:@"$"].length > 0 ||
        [str rangeOfString:@"%"].length > 0 ||
        [str rangeOfString:@"^"].length > 0 ||
        [str rangeOfString:@"&"].length > 0 ||
        [str rangeOfString:@"."].length > 0 ||
        [str rangeOfString:@"'"].length > 0 ||
        [str rangeOfString:@"]"].length > 0 ||
        [str rangeOfString:@"["].length > 0 ||
        [str rangeOfString:@"-"].length > 0 ||
        [str rangeOfString:@"+"].length > 0 ||
        [str rangeOfString:@"`"].length > 0 ||
        [str rangeOfString:@"*"].length > 0 ||
        [str rangeOfString:@"("].length > 0 ||
        [str rangeOfString:@")"].length > 0 ||
        [str rangeOfString:@"<"].length > 0 ||
        [str rangeOfString:@">"].length > 0) {
        ret = YES;
    }
    
    return ret;
}

#pragma mark - 日期转换long
+ (long long) timeIntervalWithDate:(NSDate*)date
{
    long long interval = 0;
    if (date == nil)
    {
        return interval;
    }
    
    NSTimeInterval tmp = [date timeIntervalSince1970];
    interval = [[NSNumber numberWithDouble:tmp] longLongValue];
    //changge to million second
    return interval * RATE;
}

#pragma mark - 将long long型数据转化为nsdate
+ (NSDate*) dateWithTimeInterval:(NSNumber *)interval
{
    if (interval != nil) {
        if ((NSNull *)interval != [NSNull null])
        {
            long long tmpInterval = [interval longLongValue]/ RATE;
            if (tmpInterval != 0) {
                NSDate* date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)tmpInterval];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                date = [dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
                return date;
            } else {
                return 0;
            }
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

#pragma mark - 获取数据库显示的错误信息
+ (NSString *) fetchErrorMessages:(NSDictionary *)result;
{
    if ([result objectForKey:@"validate_error"]!=nil
        && [[result objectForKey:@"validate_error"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *errors = [result objectForKey:@"validate_error"];
        NSMutableString *errString = [[NSMutableString alloc] init];
        [errors enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *e = (NSString *)obj;
            [errString appendFormat:@"%@\n", e];
        }];
        return errString;
    } else {
        return nil;
    }
}

#pragma mark - APP Path
+ (NSString*) ApplicationPath
{
    __weak NSString* str_path = [NSString stringWithFormat:@"%@/", [[NSBundle mainBundle] bundlePath]];
    return str_path;
}

#pragma mark - 创建目录
+ (BOOL)createFiled:(NSString *)strPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDri=NO;
    [fileManager fileExistsAtPath:strPath isDirectory:&isDri];
    if (!isDri) {
        isDri = [fileManager createDirectoryAtPath:strPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isDri) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 删除目录
/**
	删除文件
	@param _path 文件路径
	@returns 成功返回yes
 */
+ (BOOL)deleteFileAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
}


#pragma mark - 获取用户指定的应用目录
/**
 获取缓存路径
 @returns 缓存路径
 */
+ (NSString*)getCacheDirectory:(NSString*)dir {
    NSString *str_dir = [NSString stringWithFormat:@"%@/%@/", [self getUserInfoCachesPath], dir];
    if ([Util createFiled:str_dir])
        return  str_dir;
    else
        return nil;
}

#pragma mark - 获取用户指定的应用目录Caches
+ (NSString*) GetMyCachesPath {
    NSString *str_dir = [NSString stringWithFormat:@"%@/%@/", [self getUserInfoCachesPath], @"Caches"];
    if ([Util createFiled:str_dir])
        return  str_dir;
    else
        return nil;
    
}

#pragma mark - 获取用户指定的应用目录App UserInfo Caches
+ (NSString*)getUserInfoCachesPath {
    return [NSString stringWithFormat:@"%@/%@",[self CachesPath], @"userInfo"];;
}

#pragma mark - 获取用户指定的应用目录App Caches
+ (NSString*) CachesPath {
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    return cachePath;
}

#pragma mark - 获取WAV文件长度
+ (NSNumber*)getWAVLength:(NSString*)str_filePath{
    
    NSURL *url = [NSURL fileURLWithPath:str_filePath];
    AVAudioPlayer *play = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    float times=play.duration;
    play=nil;
    NSNumber *number_length = [NSNumber numberWithInt:times];
    [play play];
    return  number_length;
}

#pragma mark -获取文件的MD5值
+ (NSString*) md5:(NSString*) path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if ( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if ( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}


#pragma mark - 图片整比例缩放
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0,image.size.width * scaleSize,image.size.height*scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)scaleToSize:(UIImage *)img
{
    NSData * imageData = UIImageJPEGRepresentation(img,1.0f);
    int length = (int)[imageData length]/1024;
    UIImage* scaledImage;
    if (length>400) {
        //960 1280
        //1280 960
        float num1=0;
        CGSize size_old= img.size;
        if (size_old.width<500||size_old.height<500) {
            
        }
        else if (size_old.width>960)
        {
            num1=size_old.width/960.f;
            size_old.width=960;
            size_old.height=size_old.height/num1;
        }
        else if (size_old.height>960)
        {
            num1=size_old.height/960.f;
            size_old.height=960;
            size_old.width=size_old.width/num1;
        }
        scaledImage = [self scaleToSize:img size:size_old];
    }
    else
    {
        scaledImage=img;
    }
    return scaledImage;
}


#pragma mark - 截取部分图像
+ (UIImage*)subToImage:(UIImage *)img rect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}
#pragma mark - 截取部分图像
+ (UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool
{
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if (centerBool)
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    else {
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            } else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2 ;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                } else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        } else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                } else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            } else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                } else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}


#pragma mark - 正则表达试验证
+ (BOOL)invalidate_strForRes:(NSString*)strtext ResStr:(NSString*)ResStr
{
    NSString *parten =ResStr;
    NSString *staString=strtext;
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray* match = [reg matchesInString:staString options:NSMatchingReportCompletion range:NSMakeRange(0, [staString length])];
    
    if (match.count != 0)
    {
        /*
         for (NSTextCheckingResult *matc in match)
         {
         NSRange range = [matc range];
         NSLog(@"%lu,%lu,%@",(unsigned long)range.location,(unsigned long)range.length,[staString substringWithRange:range]);
         }
         */
        return YES;
    }
    else
    {
        return NO;
    }
    
}


+ (NSString*)getVersionValue
{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];//获取info－plist
    NSMutableString *version = [dic objectForKey:@"CFBundleVersion"];//获取Bundle identifier
    return version;
}



#define KFacialSizeWidth_r 24
#define KFacialSizeHeight_r 24
#define MAX_WIDTH_r 280
+ (UIView *)assembleMessageAtIndex : (NSString *) message
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [Util getImageRange:message arraySource:array];
    //Class tempClass =  NSClassFromString(strClassName);
    //UIView *returnView = [[tempClass alloc] initWithFrame:CGRectZero];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:13.f];
    UIColor *fcolor = [UIColor colorWithRed:80/255.0f green:80/255.0f blue:80/255.0f alpha:1];
    __block CGFloat upX = 0;
    __block CGFloat upY = 0;
    __block CGFloat X = 0;
    __block CGFloat Y = 0;
    if (data) {
        
        BOOL isString=NO;
        
        for (int i=0;i < [data count];i++) {
            
            isString=NO;
            NSString *str = [data objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                
                if (upX+KFacialSizeHeight_r>= MAX_WIDTH_r)
                {
                    upY = upY + KFacialSizeHeight_r;
                    upX = 0;
                    X = MAX_WIDTH_r;
                    Y = upY;
                }
                
                NSDictionary *faceMap;
                faceMap = [NSDictionary dictionaryWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"0_face"
                                                           ofType:@"plist"]];
                
                NSArray *array_value=faceMap.allValues;
                BOOL isbool=YES;
                int i=0;
                for (NSString *str_faceValue in array_value) {
                    if ([str_faceValue isEqualToString:str])
                    {
                        str = [faceMap.allKeys objectAtIndex:i];
                        isbool=NO;
                        break;
                    }
                    i++;
                }
                if (isbool) {
                    
                    faceMap = [NSDictionary dictionaryWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"_expression_en"
                                                               ofType:@"plist"]];
                    NSArray *array_value=faceMap.allValues;
                    int b=0;
                    for (NSString *str_faceValue in array_value) {
                        if ([str_faceValue isEqualToString:str])
                        {
                            str = [faceMap.allKeys objectAtIndex:b];
                            break;
                        }
                        b++;
                    }
                    
                    
                }
                
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:str]];
                img.contentMode=UIViewContentModeScaleAspectFit;
                if (img.image!=nil)
                {
                    img.frame = CGRectMake(upX, upY, KFacialSizeWidth_r, KFacialSizeHeight_r);
                    [returnView addSubview:img];
                    img=nil;
                    upX=KFacialSizeHeight_r+upX;
                    if (X<MAX_WIDTH_r) X = upX;
                    
                    isString=YES;
                }
            }
            
            if (isString==NO)
            {
                str = [Util emojiImageRange:str];
                
                [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    
                    if (upX+KFacialSizeHeight_r>= MAX_WIDTH_r)
                    {
                        upY = upY + KFacialSizeHeight_r;
                        upX = 0;
                        X = MAX_WIDTH_r;
                        Y =upY;
                    }
                    if ([substring isEqualToString:@"\n"]) {
                        upY = upY + KFacialSizeHeight_r;
                        upX = 0;
                        X = MAX_WIDTH_r;
                        Y =upY;
                    }
                    //                    int j=str.length;
                    //                    BOOL Judge=YES;
                    //                    for (int i=substringRange.location;i<j;i++) {
                    //
                    //                        NSString *itme = [str substringWithRange:NSMakeRange(i,1)];
                    //                        if ([itme isEqualToString:@"\n"]) {
                    //                            Judge=NO;
                    //                        }
                    //                        else
                    //                        {
                    //                            Judge=YES;
                    //                            break;
                    //                        }
                    //                    }
                    //                    if (Judge) {
                    CGSize size = [substring sizeWithFont:fon constrainedToSize:CGSizeMake(MAX_WIDTH_r, KFacialSizeWidth_r)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,KFacialSizeHeight_r)];
                    la.textAlignment=NSTextAlignmentCenter;
                    la.font = fon;
                    la.textColor=fcolor;
                    la.text = substring;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    la=nil;
                    upX=upX+size.width;
                    if (X<MAX_WIDTH_r) {
                        X = upX;
                        //                        }
                    }
                }];
            }
        }
    }
    
    NSArray *array_views=returnView.subviews;
    UIView *view_sub;
    float view_height=KFacialSizeHeight_r;
    if (array_views.count>0) {
        view_sub= [array_views objectAtIndex:array_views.count-1];
        view_height=view_sub.frame.origin.y+view_sub.frame.size.height;
    }
    
    returnView.frame = CGRectMake(0,0, X, view_height); //@ 需要将该view的尺寸记下，方便以后使用
    return returnView;
}



+ (UIView *)assembleMessageAtIndexEX : (NSString *) message
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [Util getImageRange:message arraySource:array];
    //Class tempClass =  NSClassFromString(strClassName);
    //UIView *returnView = [[tempClass alloc] initWithFrame:CGRectZero];
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    NSArray *data = array;
    UIFont *fon = [UIFont systemFontOfSize:14.f];
    UIColor *fcolor = [UIColor colorWithRed:130/255.0f green:130/255.0f blue:130/255.0f alpha:1];
    __block CGFloat upX = 0;
    __block CGFloat upY = 0;
    __block CGFloat X = 0;
    __block CGFloat Y = 0;

    if (data) {
        
        BOOL isString=NO;
        
        for (int i=0;i < [data count];i++) {
            
            isString=NO;
            NSString *str = [data objectAtIndex:i];
            if ([str hasPrefix: BEGIN_FLAG] && [str hasSuffix: END_FLAG])
            {
                
                if (upX+KFacialSizeHeight_r>= 180)
                {
                    upY = upY + KFacialSizeHeight_r;
                    upX = 0;
                    X = 180;
                    Y = upY;
                }
                
                NSDictionary *faceMap;
                faceMap = [NSDictionary dictionaryWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:@"0_face"
                                                           ofType:@"plist"]];
                
                NSArray *array_value=faceMap.allValues;
                BOOL isbool=YES;
                int i=0;
                for (NSString *str_faceValue in array_value) {
                    if ([str_faceValue isEqualToString:str])
                    {
                        str = [faceMap.allKeys objectAtIndex:i];
                        isbool=NO;
                        break;
                    }
                    i++;
                }
                if (isbool) {
                    
                    faceMap = [NSDictionary dictionaryWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"_expression_en"
                                                               ofType:@"plist"]];
                    NSArray *array_value=faceMap.allValues;
                    int b=0;
                    for (NSString *str_faceValue in array_value) {
                        if ([str_faceValue isEqualToString:str])
                        {
                            str = [faceMap.allKeys objectAtIndex:b];
                            break;
                        }
                        b++;
                    }
                    
                    
                }
                
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:str]];
                img.contentMode=UIViewContentModeScaleAspectFit;
                if (img.image!=nil)
                {
                    img.frame = CGRectMake(upX, upY, KFacialSizeWidth_r, KFacialSizeHeight_r);
                    [returnView addSubview:img];
                    img=nil;
                    upX=KFacialSizeHeight_r+upX;
                    if (X<180) X = upX;
                    
                    isString=YES;
                }
            }
            
            if (isString==NO)
            {
                str = [Util emojiImageRange:str];
                
                [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                    
                    if (upX+KFacialSizeHeight_r>= 180)
                    {
                        upY = upY + KFacialSizeHeight_r;
                        upX = 0;
                        X = 180;
                        Y =upY;
                    }
                    if ([substring isEqualToString:@"\n"]) {
                        upY = upY + KFacialSizeHeight_r;
                        
                        upX = 0;
                        X = 180;
                        Y =upY;
                    }
                    CGSize size = [substring sizeWithFont:fon constrainedToSize:CGSizeMake(180, KFacialSizeWidth_r)];
                    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(upX,upY,size.width,KFacialSizeHeight_r)];
                    la.textAlignment=NSTextAlignmentCenter;
                    la.font = fon;
                    la.textColor=fcolor;
                    la.text = substring;
                    la.backgroundColor = [UIColor clearColor];
                    [returnView addSubview:la];
                    la=nil;
                    upX=upX+size.width;
                    if (X<180) {
                        X = upX;
                        //                        }
                    }
                }];
            }
        }
    }
    
    NSArray *array_views=returnView.subviews;
    UIView *view_sub;
    float view_height=KFacialSizeHeight_r;
    if (array_views.count>0) {
        view_sub= [array_views objectAtIndex:array_views.count-1];
        view_height=view_sub.frame.origin.y+view_sub.frame.size.height;
    }
    
    returnView.frame = CGRectMake(0,0, X, view_height); //@ 需要将该view的尺寸记下，方便以后使用
    return returnView;
}



+ (NSString *)GetResolution:(NSString *)xib_name
{
    /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        xib_name = [NSString stringWithFormat:@"%@_n",xib_name];
    }
    else
    {
     */
        CGRect rect_screen = [[UIScreen mainScreen]bounds];
        CGSize size_screen = rect_screen.size;
        CGFloat scale_screen = [UIScreen mainScreen].scale;
        CGFloat width = size_screen.width*scale_screen;
//        CGFloat width = size_screen.width*scale_screen;
//        NSLog(@"width:%f",width);
        if (size_screen.width==375.0f) {
            xib_name = [NSString stringWithFormat:@"%@_s",xib_name];
        }
        else if (size_screen.width==414.0f)
        {
            xib_name = [NSString stringWithFormat:@"%@_p",xib_name];
        }
        else
        {
            return xib_name;
        }
    /*
    }
     */
    return xib_name;
}
+ (float)GetUIFontSize:(float)Fontsize
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7) {
        return Fontsize;
    }
    else
    {
        CGRect rect_screen = [[UIScreen mainScreen]bounds];
        CGSize size_screen = rect_screen.size;
        CGFloat scale_screen = [UIScreen mainScreen].scale;
        CGFloat width = size_screen.width*scale_screen;
//        NSLog(@"width:%f",width);
        if (size_screen.width==375.0f) {
            Fontsize=Fontsize+2;
        }
        else if (size_screen.width==414.0f)
        {
            Fontsize=Fontsize+4;
        }
        else
        {
            Fontsize=Fontsize;
        }
    }
    return Fontsize;
}

+ (NSString*)deleteEmoji:(NSString*)stringContent
{
    NSString *str_msg = [NSString stringWithFormat:@"%@",stringContent];
    __block BOOL returnValue = NO;
    NSMutableArray *array_strSource = [NSMutableArray array];
    
    [str_msg enumerateSubstringsInRange:NSMakeRange(0, [str_msg length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        //NSData *emojiData = [substring dataUsingEncoding:NSUnicodeStringEncoding];
        //NSString *str = [[NSString alloc]initWithData:emojiData encoding:NSUTF8StringEncoding];
        
        //char *unicodeStr = [substring cStringUsingEncoding:NSUnicodeStringEncoding];
        
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    [array_strSource addObject:[NSString stringWithFormat:@"%@%@%@",BEGIN_EMOJI,[GTMBase64 encodeBase64String:substring],END_EMOJI]];
                    //[array_strSource addObject:@" "];
                    returnValue = YES;
                }
                else
                {
                    [array_strSource addObject:substring];
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                //[array_strSource addObject:@" "];
                [array_strSource addObject:[NSString stringWithFormat:@"%@%@%@",BEGIN_EMOJI,[GTMBase64 encodeBase64String:substring],END_EMOJI]];
                returnValue = YES;
                
            }
            else
            {
                [array_strSource addObject:substring];
            }
            
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                [array_strSource addObject:[NSString stringWithFormat:@"%@%@%@",BEGIN_EMOJI,[GTMBase64 encodeBase64String:substring],END_EMOJI]];
                //[array_strSource addObject:@" "];
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                [array_strSource addObject:[NSString stringWithFormat:@"%@%@%@",BEGIN_EMOJI,[GTMBase64 encodeBase64String:substring],END_EMOJI]];
                //[array_strSource addObject:@" "];
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                [array_strSource addObject:[NSString stringWithFormat:@"%@%@%@",BEGIN_EMOJI,[GTMBase64 encodeBase64String:substring],END_EMOJI]];
                //[array_strSource addObject:@" "];
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                [array_strSource addObject:[NSString stringWithFormat:@"%@%@%@",BEGIN_EMOJI,[GTMBase64 encodeBase64String:substring],END_EMOJI]];
                //[array_strSource addObject:@" "];
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                [array_strSource addObject:[NSString stringWithFormat:@"%@%@%@",BEGIN_EMOJI,[GTMBase64 encodeBase64String:substring],END_EMOJI]];
                //[array_strSource addObject:@" "];
                returnValue = YES;
            }
            else
            {
                [array_strSource addObject:substring];
            }
        }
    }];
    
    NSMutableString *str_sub = [NSMutableString string];
    for (NSString *str_item in array_strSource) {
        [str_sub appendString:str_item];
    }
    NSString *str_content = [NSString stringWithFormat:@"%@",str_sub];
    return  str_content;
}
@end

