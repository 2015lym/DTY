//
//  Examine_ContentViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
#import "ExamineProjectListModel.h"

@interface Examine_ContentViewController : YMBaseViewController

@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *saveArray;

@property (nonatomic, strong) ExamineProjectListModel *model;

@property (nonatomic, copy) NSString *taskId;

@property (nonatomic, assign) BOOL isPreview;

@end
