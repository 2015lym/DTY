//
//  SchoolEntity.h
//  AlumniChat
//
//  Created by xiaoanzi on 15/6/17.
//  Copyright (c) 2015年 xiaoanzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableItem.h"
@interface SchoolEntity : UITableItem
@property (nonatomic,strong)  NSString *m_nUniversity_ID;//学校id
@property (nonatomic,strong)  NSString *m_nUniversity_Name;//学校名称
@property (nonatomic,strong)  NSString *rowid;//id
@property (nonatomic,strong)  NSString *m_id;//id
@property (nonatomic,strong)  NSString *m_nUniversity_Pinyin;//拼音简称
@property (nonatomic,strong)  NSString *m_nProvince_Name;//学校所在城市
@property(nonatomic,strong) NSString *type;
@end
