//
//  MaintenanceOrderDetailViewController.m
//  dtyios
//
//  Created by Lym on 2020/6/11.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenanceOrderDetailViewController.h"
#import "MaintenanceRefuseOrderViewController.h"
#import "MapTableViewCell.h"

@interface MaintenanceOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MaintenanceOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"未进行工单";
    _titleArray = [NSMutableArray arrayWithObjects:@"注册代码", @"项目名称", @"内部编号", @"维保类别", @"维保人员", @"维保到期时间", @"联系方式", @"使用单位", @"维保单位", nil];
    _dataArray = [NSMutableArray arrayWithObjects:@"310173678463383838", @"左岸经典小区", @"8#东", @"半月维保", @"张三、李四", @"2020-06-11", @"1398748473", @"左岸经典物业服务有限公司", @"日立电梯(中国)有限公司", nil];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 163)];
    bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 30, SCREEN_WIDTH - 32, 44)];
    agreeButton.backgroundColor = [UIColor colorWithHexString:@"#007AFF"];
    agreeButton.layer.cornerRadius = 5;
    agreeButton.layer.masksToBounds = YES;
    agreeButton.titleLabel.textColor = [UIColor whiteColor];
    [agreeButton addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
    [agreeButton setTitle:@"接单" forState:UIControlStateNormal];
    [bottomView addSubview:agreeButton];
    
    UIButton *refuseButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 89, SCREEN_WIDTH - 32, 44)];
     refuseButton.backgroundColor = [UIColor systemRedColor];
     refuseButton.layer.cornerRadius = 5;
     refuseButton.layer.masksToBounds = YES;
     refuseButton.titleLabel.textColor = [UIColor whiteColor];
     [refuseButton addTarget:self action:@selector(refuse) forControlEvents:UIControlEventTouchUpInside];
     [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
     [bottomView addSubview:refuseButton];
    
    self.tableView.tableFooterView = bottomView;
}

- (void)agree {
    
}

- (void)refuse {
    MaintenanceRefuseOrderViewController *vc = [MaintenanceRefuseOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
    if (indexPath.row == _titleArray.count) {
        return 200;
    } else {
        return 44;
    }
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count + 1;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _titleArray.count) {
        MapTableViewCell *cell = [MapTableViewCell cellWithTableView:tableView];
        return cell;
    } else {
        static NSString *ideitifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
        }
        cell.textLabel.text = _titleArray[indexPath.row];
        cell.detailTextLabel.text = _dataArray[indexPath.row];
        return cell;
    }
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
