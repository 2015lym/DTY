//
//  Env_SelectViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/12.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Env_SelectViewController.h"

@interface Env_SelectViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<EnvironmentAssessmentItmeEntity *> *dataArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation Env_SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _model.CategoryName;
    _dataArray = [NSMutableArray arrayWithArray:_model.valueArray];
    _selectArray = [NSMutableArray array];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)save {
    [self.navigationController popViewControllerAnimated:YES];
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
    EnvironmentAssessmentItmeEntity *model = _dataArray[indexPath.row];
    
    static NSString *ideitifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
    }
    cell.textLabel.text = model.ItemTitle;
    if (model.DataItemValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!_isMultiple) {
        for (int i=0; i<_dataArray.count; i++) {
            _dataArray[i].DataItemValue = nil;
        }
    }
    
    if (_isMultiple && [_dataArray[indexPath.row].DataItemValue isEqualToString:_dataArray[indexPath.row].ItemValue]) {
        _dataArray[indexPath.row].DataItemValue = nil;
    } else {
        _dataArray[indexPath.row].DataItemValue = _dataArray[indexPath.row].ItemValue;
    }
    [tableView reloadData];
}

@end
