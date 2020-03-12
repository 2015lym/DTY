//
//  RiskTaskPartDetailDelegate.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/8/20.
//  Copyright © 2019 SongQues. All rights reserved.
//

#ifndef RiskTaskPartDetailDelegate_h
#define RiskTaskPartDetailDelegate_h

typedef NS_ENUM(NSUInteger, kRiskTaskType) {
    RiskDescription,
    Solution,
    PartInfo,
};

@protocol RiskTaskPartDetailDelegate <NSObject>

- (void)selectAction:(kRiskTaskType)type andIndexPath:(NSIndexPath *)indexPath;

@end


#endif /* RiskTaskPartDetailDelegate_h */
