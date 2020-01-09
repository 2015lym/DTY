//
//  CurriculumEntity.h
//  AlumniChat
//
//  Created by SongQues on 16/7/1.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "UITableItem.h"

@interface EventCurriculumEntity : UITableItem


@property(nonatomic,strong)NSDictionary *enroll_list; //包含字典 字段
@property(nonatomic,strong)NSString * page; //当前页书
@property(nonatomic,strong)NSString * pagecount;//总页数
@property(nonatomic,strong)NSString * count; //总条数
@end
