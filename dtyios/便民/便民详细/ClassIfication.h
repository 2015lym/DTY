//
//  ClassIfication.h
//  Sea_northeast_asia
//
//  Created by SongQues on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClassIficationDelegate <NSObject>
@required
-(void)Cell_OnClick:(id)Content typeView:(UIView *)typeView;
-(void)ColesTypeView:(UIView *)typeView;
@end
@interface ClassIfication : UIView<UITableViewDelegate,UITableViewDataSource>
{
   
    NSMutableArray *arr_DataList;
}
@property ( nonatomic,strong) IBOutlet  UITableView *table_view;
@property(nonatomic,weak)id<ClassIficationDelegate> delegate;
- (id)initWithFrame:(CGRect)frame ArrList:(NSMutableArray *) arr;
@end
