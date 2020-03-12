//
//  Task_TextViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/4/9.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"

@protocol Task_TextViewControllerDelegate <NSObject>

- (void)saveText:(NSString *)text andTitle:(NSString *)title andIndexPath:(NSIndexPath *)indexPath;

@end

@interface Task_TextViewController : YMBaseViewController

@property (nonatomic, copy) NSString *previewString;

@property (nonatomic, assign) BOOL isPreview;

@property (nonatomic, weak) id<Task_TextViewControllerDelegate> delegate;
@property (nonatomic, assign) NSIndexPath *indexPath;

@end

