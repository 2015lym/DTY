//
//  ExamineProjectListModel.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamineProjectListModel : NSObject

@property (nonatomic, copy) NSString *SortCode;
@property (nonatomic, copy) NSString *CategoryNameFour;
@property (nonatomic, copy) NSString *CategoryNameOne;
@property (nonatomic, assign) NSInteger CategoryLevel;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *CategoryNameThree;
@property (nonatomic, copy) NSString *Type;
@property (nonatomic, copy) NSString *CategoryNameTwo;
@property (nonatomic, copy) NSString *Id;

@property (nonatomic, assign) BOOL hasFour;
@property (nonatomic, assign) BOOL hasValue;
@property (nonatomic, assign) BOOL isPreview;

@end
