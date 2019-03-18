//
//  JSONString.m
//  CRM
//
//  Created by Lion User on 02/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+JsonMethods.h"


@implementation NSString (JsonMethods)

-(NSDictionary *) dictionaryFromJson{
    NSError *errorJson;
    NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&errorJson];
    return ret;
}

@end
