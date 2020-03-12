//
//  Task_PartDetailViewController.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/17.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
#import "Task_PartModel.h"

@interface Task_PartDetailViewController : YMBaseViewController

@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, strong) ElevatorAssessmentPartEntityList *model;
@property (nonatomic, strong) ElevatorAssessmentClassEntityList *classModel;

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *certificateNum;
@property (nonatomic, copy) NSString *InternalNumAndBuildingNum;

@end
