//
//  TaskPartDetailDelegate.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/18.
//  Copyright © 2019 SongQues. All rights reserved.
//

#ifndef TaskPartDetailDelegate_h
#define TaskPartDetailDelegate_h

typedef NS_ENUM(NSUInteger, kTaskType) {
    SeverityLevel,
    ProbabilityLevel,
    IdentificationStatus,
};

@protocol TaskPartDetailDelegate <NSObject>

- (void)selectAction:(kTaskType)type andIndexPath:(NSIndexPath *)indexPath;

@end

#endif /* TaskPartDetailDelegate_h */
