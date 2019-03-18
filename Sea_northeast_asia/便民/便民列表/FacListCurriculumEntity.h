//
//  CurriculumEntity.h
//  AlumniChat
//
//  Created by SongQues on 16/7/1.
//  Copyright © 2016年 xiaoanzi. All rights reserved.
//

#import "UITableItem.h"

@interface FacListCurriculumEntity : UITableItem
/*
 state	String
 desc	String
 body
 adver_list	JsonArray
 adveriImg	String
 adverId	Integer
 link	String
 enroll_list	JsonArray
 enrollId	Integer
 image	String
 title	String
 deadline	String
 showCount	String
 schoolName	String
 isEnroll	String
 page	Integer
 pagecount	Integer
 count	Integer
 
 "enroll_list": [
 {
 "enrollId": "10001",
 "image": "upload/1455438899.8768.png",
 "title": "演讲口才技巧",
 "deadline": "2016-04-01",
 "showCount": "0",
 "schoolName": "清华大学",
 "isEnroll": "0"
 }
 ],
 */
@property(nonatomic,strong)NSMutableArray *adver_list;//包含字典 字段
@property(nonatomic,strong)NSMutableArray *enroll_list; //包含字典 字段
@property(nonatomic,strong)NSString * page; //当前页书
@property(nonatomic,strong)NSString * pagecount;//总页数
@property(nonatomic,strong)NSString * count; //总条数
@end
