//
//  Task_RemarkTableViewCell.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/19.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemarkDelegate.h"
#import "Task_PartModel.h"

@interface Task_RemarkTableViewCell : UITableViewCell

@property (nonatomic, weak) id<RemarkDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *scrollBackView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *toolBar;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, copy) NSString *partId;


@property (nonatomic, assign) BOOL isPreview;
@property (nonatomic, strong) ElevatorAssessmentPartEntityList *model;

- (void)changeUI;

+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end
