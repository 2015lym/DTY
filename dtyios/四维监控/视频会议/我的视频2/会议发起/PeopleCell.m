//
//  CYZCellViewController.m
//  Sea_northeast_asia
//
//  Created by 王永超 on 2017/3/7.
//  Copyright © 2017年 SongQues. All rights reserved.
//

#import "PeopleCell.h"

@interface PeopleCell ()

@end

@implementation PeopleCell
@synthesize app;
@synthesize mSelected = _mSelected;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark -
#pragma mark UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        _mSelected = NO;
        CGRect indicatorFrame = CGRectMake(-30, abs(self.frame.size.height - 30)/ 2, 30, 30);
        _mSelectedIndicator = [[UIImageView alloc] initWithFrame:indicatorFrame];
        _mSelectedIndicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_mSelectedIndicator];
    }
    return self;
}

- (BOOL)configTableViewCell:(id)aObject_entity index_row:(int)aIndex_row count:(int)aCount_source;
{
    
    NSMutableDictionary *dic_info=[NSMutableDictionary dictionaryWithDictionary:aObject_entity];
    self.backgroundColor=[UIColor whiteColor];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, bounds_width.size.width,self.frame.size.height+50);
    
    _lbl_name.text=[NSString stringWithFormat:@"%@",[dic_info objectForKey:@"Name"]];
    _lbl_name.tag=2000;
    self.currHeight=45;
    
    UILabel *lblGuid=[[UILabel alloc]init];
    lblGuid.text=[dic_info objectForKey:@"Guid"];
    lblGuid.tag=1000;
    lblGuid.hidden=true;
    [self addSubview:lblGuid];
    
    _checkbox.frame=CGRectMake(bounds_width.size.width-40, _checkbox.frame.origin.y, _checkbox.frame.size.width,_checkbox.frame.size.height);
    _line.frame=CGRectMake(_line.frame.origin.x, _line.frame.origin.y, bounds_width.size.width,_line.frame.size.height);
    
    self.selectionStyle= UITableViewCellSelectionStyleNone;
    
    
    UIButton *checkbox = _checkbox;
    //checkbox.tag=tag;
    [checkbox setImage:[UIImage imageNamed:@"checkbox_off.png"] forState:UIControlStateNormal];
    [checkbox setImage:[UIImage imageNamed:@"checkbox_on.png"] forState:UIControlStateSelected];
    
    [checkbox addTarget:self action:@selector(checkboxClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _checkCell.frame=CGRectMake(_checkCell.frame.origin.x, _checkCell.frame.origin.y, bounds_width.size.width,_checkCell.frame.size.height);
    [_checkCell addTarget:self action:@selector(checkCellClick) forControlEvents:UIControlEventTouchUpInside];
    
    return YES;
}

-(void)checkCellClick
{
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    _checkbox.selected = !_checkbox.selected;
    
    UILabel * lbl = [self viewWithTag:1000];
    NSString *currguid=lbl.text;
    UILabel * lblname = [self viewWithTag:2000];
    NSString *currName=lblname.text;
    
    if(_checkbox.selected==true)
    {
        [self SelectList_add:currguid forList:app.array_selectList];
        [self SelectList_add:currName forList:app.array_selectNameList];
    }
    else
    {
        [self SelectList_del:currguid forList:app.array_selectList];
        [self SelectList_del:currName forList:app.array_selectNameList];
    }
}


-(void)checkboxClick:(UIButton *)btn
{
    app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    btn.selected = !btn.selected;
    
    UILabel * lbl = [self viewWithTag:1000];
    NSString *currguid=lbl.text;
    UILabel * lblname = [self viewWithTag:2000];
    NSString *currName=lblname.text;
    
    if(btn.selected==true)
    {
        [self SelectList_add:currguid forList:app.array_selectList];
        [self SelectList_add:currName forList:app.array_selectNameList];
    }
    else
    {
        [self SelectList_del:currguid forList:app.array_selectList];
        [self SelectList_del:currName forList:app.array_selectNameList];
    }
}

-(void)SelectList_add:(NSString *)currGuid forList:(NSMutableArray *)list
{
    for (NSString * str in list) {
        if([str isEqualToString :currGuid])
        {
            return;
        }
    }
    
    [list addObject:currGuid];
    
    NSLog(@"list_add==%@",list);
}
-(void)SelectList_del:(NSString *)currGuid forList:(NSMutableArray *)list
{
    for (NSString * str in list) {
        if([str isEqualToString :currGuid])
        {
            [list removeObject:currGuid];
            NSLog(@"list_remove==%@",list);
            return;
        }
    }
    
}

- (void)setFrame:(CGRect)frame
{
    float width=bounds_width.size.width;
    
    frame.size.width = width;
    [super setFrame:frame];
    
}


@end
