//
//  Env_SelectViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/12.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
#import "Env_FormModel.h"

@interface Env_SelectViewController : YMBaseViewController

@property (nonatomic, assign) BOOL isMultiple;
@property (nonatomic, strong) EnvironmentAssessmentCategoryEntityList *model;

@end
