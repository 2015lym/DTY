//
//  WorkCollectionReusableView.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/3.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "WorkCollectionReusableView.h"

@implementation WorkCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (Class)layerClass {
    return [CustomLayer class];
}

@end

#ifdef __IPHONE_11_0

@implementation CustomLayer

- (CGFloat) zPosition {
    return 0;
}

@end

#endif
