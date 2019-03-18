//
//  ClassIficationEx.m
//  Sea_northeast_asia
//
//  Created by SongQues on 16/8/12.
//  Copyright © 2016年 SongQues. All rights reserved.
//

#import "ClassIficationEx.h"

@implementation ClassIficationEx

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame ArrList:(NSMutableArray *) arr {
    if (self = [super initWithFrame:frame]) {
        arr_City=[NSMutableArray arrayWithArray:arr];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 240, bounds_width.size.width, bounds_width.size.height-240)];
        UITapGestureRecognizer* singleRecognizer;
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [view addGestureRecognizer:singleRecognizer];
        [self addSubview:view];
        CGRect rect=frame;
        rect.size.height=240;
        rect.origin.x=bounds_width.size.width/2;
        rect.size.width=bounds_width.size.width/2;
        table_view=[[UITableView alloc]initWithFrame:rect];
        table_view.delegate=self;
        table_view.dataSource=self;
        [self addSubview:table_view];
        rect.origin.x=0;
        rect.size.width=bounds_width.size.width/2+5;
        scrollview=[[UIScrollView alloc] initWithFrame:rect];
        scrollview.backgroundColor=[UIColor whiteColor];
        [self addSubview:scrollview];
        [self addUIButton:arr];
        
        self.backgroundColor=[UIColor colorWithRed:225.f/255.f green:225.f/255.f blue:225.f/255.f alpha:0.7];
        self.layer.masksToBounds=YES;
    }
    return self;
}
-(void)handleSingleTapFrom
{
    [_delegate ColesTypeView:self];
}
-(void)addUIButton:(NSMutableArray *)arr_info
{
    for (int i=0;i<arr_info.count;i++) {
        NSMutableDictionary *dic_info =[arr_info objectAtIndex:i];
        UIButton *btn=[[UIButton alloc] init];
        btn.tag=i;
        [btn setTitle:[dic_info objectForKey:@"tagName"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(Btn_OnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(0,-1+i*40, bounds_width.size.width/2-2, 40);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_background_d"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_background_s"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [scrollview addSubview:btn];
        scrollview.contentSize=CGSizeMake(0, CGRectGetMaxY(btn.frame));
        if (i==0) {
            [self Btn_OnClick:btn];
        }
    }
}
-(IBAction)Btn_OnClick:(id)sender
{
//    arr_DataList=[NSMutableArray arrayWithArray:arr];
    if (btn_tag!=nil) {
        btn_tag.selected=NO;
    }
    UIButton *btn=(UIButton *)sender;
    btn.selected=YES;
    btn_tag=btn;
    NSMutableDictionary *dic_info=[arr_City objectAtIndex:btn.tag];
    arr_DataList=[NSMutableArray arrayWithArray:[dic_info objectForKey:@"cityList"]];
    [table_view reloadData];
}

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
    
    NSMutableDictionary *dic=[arr_DataList objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"tagName"];
    
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
