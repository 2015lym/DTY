//
//  Task_SelectTextViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/8/16.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"

@protocol Task_SelectTextViewControllerDelegate <NSObject>

- (void)selectText:(NSArray *)array;

@end

@interface Task_SelectTextViewController : YMBaseViewController
@property (nonatomic, weak) id<Task_SelectTextViewControllerDelegate> delegate;

@end

