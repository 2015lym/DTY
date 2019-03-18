//
//  ClassIfication.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "ClassIfication.h"

@implementation ClassIfication
@synthesize table_view;

- (id)initWithFrame:(CGRect)frame ArrList:(NSMutableArray *) arr {
    if (self = [super initWithFrame:frame]) {
        CGRect rect=frame;
        rect.size.height=240;
        table_view=[[UITableView alloc]initWithFrame:rect];
        table_view.delegate=self;
        table_view.dataSource=self;
        [self addSubview:table_view];
        arr_DataList=[NSMutableArray arrayWithArray:arr];
        
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 240, bounds_width.size.width, bounds_width.size.height-240)];
//        UITapGestureRecognizer* singleRecognizer;
//        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
//        singleRecognizer.numberOfTapsRequired = 1; // 单击
//        [view addGestureRecognizer:singleRecognizer];
//        [self addSubview:view];

        self.backgroundColor=[UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:0.7];
        self.layer.masksToBounds=YES;
    }
    return self;
}
//-(void)handleSingleTapFrom
//{
//    [_delegate ColesTypeView:self];
//}
#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //分组数 也就是section数
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return arr_DataList.count;
}

//设置每个分组下tableview的行数
/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1) {
        return dataSource.count;
    }else{
        return 1;
    }
}
 */
/*
//每个分组上边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 20;
}
//每个分组下边预留的空白高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 40;
    }
    return 20;
}
 */
//每一个分组下对应的tableview 高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

//设置每行对应的cell（展示的内容）
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    
    //cell.textLabel.text=[arr_DataList objectAtIndex:indexPath.row];
    NSMutableDictionary *dic=[arr_DataList objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"tagName"];
    cell.tag=1000;
    cell.contentView.tag=1000;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[arr_DataList objectAtIndex:indexPath.row]);
    if (_delegate) {
        [_delegate Cell_OnClick:[arr_DataList objectAtIndex:indexPath.row] typeView:self];
    }
}
@end
