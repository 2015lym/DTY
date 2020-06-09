//
//  MaintenanceCalendarViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/4.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceCalendarViewController.h"

@interface MaintenanceCalendarViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MaintenanceCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"维保日历";
    _dataArray = [NSMutableArray arrayWithObjects:@"5月8日", @"5月9日", @"5月10日", @"5月11日", @"5月12日", @"5月13日", @"5月14日",  nil];
    _tableView.tableFooterView = [UIView new];
}

#pragma mark - ---------- 每个Section的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ideitifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.detailTextLabel.text = @"计划保养7台";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
