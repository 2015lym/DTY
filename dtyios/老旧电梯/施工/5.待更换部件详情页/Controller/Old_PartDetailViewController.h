//
//  Old_PartDetailViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/19.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
#import "Part_PreviewModel.h"

@interface Old_PartDetailViewController : YMBaseViewController

@property (nonatomic, strong) Part_PreviewModel *model;

@property (nonatomic, copy) NSString *taskId;

@property (nonatomic, assign) BOOL isPreview;
@end
