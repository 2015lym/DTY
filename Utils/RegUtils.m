//
//  RegUtils.m
//  DanShop
//
//  Created by Lym on 2018/12/10.
//  Copyright © 2018 Lym. All rights reserved.
//

#import "RegUtils.h"

@implementation RegUtils

+ (BOOL)customValidate:(NSString *)reg content:(NSString *)content {
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    return [test evaluateWithObject:content];
}

+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateMobile:(NSString *)mobile {
    NSString *phoneRegex = @"(^(13\\d|15[^4,\\D]|17[135678]|18\\d)\\d{8}|170[^346,\\D]\\d{7})$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (NSString *)groupValidate:(NSString *)reg content:(NSString *)content {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:content
                                      options:0
                                        range:NSMakeRange(0, content.length)];
    for (NSTextCheckingResult *match in matches) {
        NSString *group = [content substringWithRange:[match rangeAtIndex:0]];
        return group;
    }
    return @"";
}

@end
