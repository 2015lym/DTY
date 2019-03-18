//
//  UITableViewCellEx.m
//  YONChat
//
//  Created by SongQues on 14/11/26.
//
//

#import "UITableViewCellEx.h"

@implementation UITableViewCellEx
@synthesize delegateCustom;
@synthesize index_row;
@synthesize entity;
- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source{return NO;}
-(void)reloadData{}
@end
