//
//  UITableViewExViewController.m
//  HIChat
//
//  Created by Song Ques on 14-6-2.
//  Copyright (c) 2014年 Song Ques. All rights reserved.
//

#import "UITableViewExViewController.h"

@interface UITableViewExViewController ()

@end

@implementation UITableViewExViewController
@synthesize delegateCustom;
@synthesize dataSource;
@synthesize tableRowHeight;
@synthesize tableCellXIB;
@synthesize tableCells_Index;
@synthesize separatorStyFalg;
@synthesize PageCount;
@synthesize PageIndex;
@synthesize max_Cell_Star;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        dataSource = [[NSMutableArray alloc]init];
        tableRowHeight=45;
        separatorStyFalg=YES;
        PageIndex=1;
        PageCount=0;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style tableCellXIB:(NSString*)_tableCellXIB tableCells_Index:(int)_tableCells_Index
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        dataSource = [[NSMutableArray alloc]init];
        tableRowHeight=45;
        separatorStyFalg=YES;
        PageIndex=1;
        PageCount=0;
        tableCellXIB=_tableCellXIB;
        tableCells_Index=_tableCells_Index;
        max_Cell_Star=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.view setBackgroundColor:[UIColor clearColor]];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *egview =
        [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        
		egview.delegate = self;
		[self.tableView addSubview:egview];
		_refreshHeaderView = egview;
        egview.is_image=_is_image;
        egview=nil;
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //return 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    /*
     if (dataSource.count>0)
    {
        if (separatorStyFalg)
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        else
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
     */
     return dataSource.count;
}

- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;*/
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
	{
		NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:tableCellXIB owner:self options:nil];
		cell = [nibs objectAtIndex:tableCells_Index];
       
    }
    
    if ([dataSource count] > indexPath.row) {
        
        NSString *str_class=[NSString stringWithUTF8String:object_getClassName([dataSource objectAtIndex:indexPath.row])];
        
        UIView *view_lab=[cell viewWithTag:1000];
        if (view_lab) {
            [view_lab removeFromSuperview];
        }
        cell.contentView.hidden=NO;
        
        if ([str_class isEqualToString:@"__NSCFConstantString"]) {
            if (max_Cell_Star) {
                UILabel *dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 40)];
                dateLabel.tag=1000;
                [dateLabel setBackgroundColor:[UIColor clearColor]];
                [dateLabel setFont:[UIFont systemFontOfSize:14.0f]];
                [dateLabel setText:[dataSource objectAtIndex:indexPath.row]];
                dateLabel.textAlignment=NSTextAlignmentCenter;
                dateLabel.textColor=[UIColor colorWithRed:130.f/255 green:130.f/255 blue:130.f/255 alpha:1.0];
                cell.contentView.hidden=YES;
                [cell addSubview:dateLabel];
                if(![[dataSource objectAtIndex:indexPath.row] isEqualToString:@"无更多数据"])
                {
                    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
                }

            }
            else{
                UILabel *dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, bounds_width.size.width, 40)];
                dateLabel.tag=1000;
                [dateLabel setBackgroundColor:[UIColor clearColor]];
                [dateLabel setFont:[UIFont systemFontOfSize:14.0f]];
                [dateLabel setText:@"加载中……"];
                dateLabel.textAlignment=NSTextAlignmentCenter;
                dateLabel.textColor=[UIColor colorWithRed:130.f/255 green:130.f/255 blue:130.f/255 alpha:1.0];
                cell.contentView.hidden=YES;
                [cell addSubview:dateLabel];
            }
        }
        else
        {
            UITableViewCellEx *TableCell=(UITableViewCellEx*)cell;
            TableCell.delegateCustom=self.delegateCustom;
            
             TableCell.delegateMap=self.delegateMap;
            [TableCell configTableViewCell:[dataSource objectAtIndex:indexPath.row]
                                 index_row:(int)indexPath.row count:(int)dataSource.count];
            self.currHeight=TableCell.currHeight;
            [TableCell setNeedsUpdateConstraints];
            [TableCell updateConstraintsIfNeeded ];
        }
    }
    
    
    
    //[cell setBackgroundColor:[UIColor clearColor]];
    return cell;

}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=dataSource.count) {
        return 58;
    }
    
    NSString *str_class=[NSString stringWithUTF8String:object_getClassName([dataSource objectAtIndex:indexPath.row])];
    
    if ([str_class isEqualToString:@"__NSCFConstantString"]) {
        return 58;
    }
    
    /*
    NSMutableDictionary *dic_item=dataSource[indexPath.row];
    if([dic_item objectForKey:@"newsImageList"]) {
        NSMutableArray *newsImageList=[NSMutableArray arrayWithArray:[dic_item objectForKey:@"newsImageList"]];
        if(newsImageList.count>1)
            return 130;
    }
*/
    
    return _currHeight;//tableRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (dataSource==nil&&dataSource.count<=0) {
        return;
    }
    if(dataSource==nil|| dataSource.count<indexPath.row)
    {
        return;
    }
    NSString *str_class=[NSString stringWithUTF8String:object_getClassName([dataSource objectAtIndex:indexPath.row])];
    
    if ([str_class isEqualToString:@"__NSCFConstantString"]) {
        if(self.delegateCustom)
        {
             if (![[dataSource objectAtIndex:indexPath.row] isEqualToString:@"无更多数据"])
             {
                 if (max_Cell_Star==YES) {
                     max_Cell_Star=NO;
                     UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
                     UILabel *lab_more=(UILabel*)[cell viewWithTag:1000];
                     lab_more.font=[UIFont systemFontOfSize:15.f];
                     lab_more.textColor=[UIColor colorWithRed:130.f/255 green:130.f/255 blue:130.f/255 alpha:1.0];
                     [self.delegateCustom MoreRecord];
                 }
             }
        }
    }
    else
    {
        UITableItem *table_item = [dataSource objectAtIndex:indexPath.row];
        if (self.delegateCustom) {
            [self.delegateCustom TableRowClick:table_item];
            if([tableCellXIB isEqualToString:@"EventCourseTableViewCell1"])
                {
                    UITableViewCellEx *cell=[tableView cellForRowAtIndexPath:indexPath];
             [self.delegateCustom TableRowClickCell:table_item forcell:cell];
                }
        }
    }
}

-(void) friendBtn_OnClick:(int)rowindex
{
    UITableItem *friendEntity = [dataSource objectAtIndex:rowindex];
    if (self.delegateCustom) {
        [self.delegateCustom TableHeaderRowClick:friendEntity];
    }
    
}


-(void)dealloc
{
    [dataSource removeAllObjects];
     _refreshHeaderView.delegate=nil;
    dataSource=nil;
    _refreshHeaderView=nil;
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = NO;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	//[delegate pullUpdateData];
    if(_reloading==NO)
    {
        if(delegateCustom)
            [delegateCustom pullUpdateData];
        [self reloadTableViewDataSource];
        //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.3];
        
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

-(void) viewFrashData{
    //更新时间
    //[_refreshHeaderView refreshLastUpdatedDateNew];
    //触发下拉刷新的效果
    [self.tableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doPullRefresh) withObject:nil afterDelay:0.4];
}

//执行下拉刷新
-(void)doPullRefresh {
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

-(void)setEnableRefresh:(BOOL)value
{
    if (value)
        _refreshHeaderView.delegate=nil;
    else
        _refreshHeaderView.delegate=self;
}
-(void)setimage
{
    [_refreshHeaderView setimagehiend];
}
@end
