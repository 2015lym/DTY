//
//  MaintenanceCalendarViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/4.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceCalendarViewController.h"
#import "MaintenanceOrderDetailViewController.h"

@interface MaintenanceCalendarViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *dayArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MaintenanceCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"维保日历";
    [self getDate];
    [self netRequest];
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
    return _dateArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ideitifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
    }
    cell.textLabel.text = _dateArray[indexPath.row];
    for (NSDictionary *dic in self.dataArray) {
        NSString *day = [dic[@"startDate"] componentsSeparatedByString:@"-"][2];
        if ([_dayArray[indexPath.row] isEqualToString:day]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"计划保养%@台", dic[@"name"]];
        } else {
            cell.detailTextLabel.text = @"无计划";
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MaintenanceOrderDetailViewController *vc = [MaintenanceOrderDetailViewController new];
//    vc.orderType = todo;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getDate {
    _dateArray = [NSMutableArray array];
    _dayArray = [NSMutableArray array];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval oneDay = 24 * 60 * 60;
    for (int i=0; i<7; i++) {
        NSDate *tempDate = [currentDate initWithTimeIntervalSinceNow: oneDay * i];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        NSString *strDate = [dateFormatter stringFromDate:tempDate];
        [_dateArray addObject:strDate];
        
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"dd"];
        NSString *day = [dayFormatter stringFromDate:tempDate];
        [_dayArray addObject:day];
    }
    _startDateLabel.text = _dateArray.firstObject;
    _endDateLabel.text = _dateArray.lastObject;
    NSLog(@"%@", _dateArray);
}

- (void)netRequest {
    [self showProgress];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [UserService getUserInfo].userId;
    [NetRequest GET:@"NPMaintenanceApp/GetMaintenanceCalendarApp" params:dic callback:^(BaseModel *baseModel) {
        if (baseModel.success) {
            self.dataArray = [NSMutableArray arrayWithArray:[StringFunction stringToJson:baseModel.data]];
            [self.tableView reloadData];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
        [self showInfo:@"服务器错误"];
    }];
}
@end
