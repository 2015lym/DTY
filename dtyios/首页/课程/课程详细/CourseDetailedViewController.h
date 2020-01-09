//
//  CourseDetailedViewController.h
//  AlumniChat
//
//  Created by SongQues on 16/7/2.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "UIViewControllerEx.h"
#import "DetailedEntity.h"
@interface CourseDetailedViewController : UIViewControllerEx
{
    int PageIndex;
    DetailedEntity *entity;
}
@property(nonatomic,strong)NSMutableDictionary *dic_school_info;
@end
