//
//  Task_RiskSelectPartPreviewViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/8/20.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_RiskSelectPartPreviewViewController.h"
#import "Task_RiskPartModel.h"
#import "Task_RiskSelectPartPreviewTableViewCell.h"

@interface Task_RiskSelectPartPreviewViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<PartsCategoryEntityList *> *dataArray;
@end

@implementation Task_RiskSelectPartPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"部件信息";
    _dataArray = [NSMutableArray array];
    for (NSDictionary *dic in self.lastArray) {
        PartsCategoryEntityList *model = [PartsCategoryEntityList yy_modelWithDictionary:dic];
        [_dataArray addObject:model];
    }
}

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PartsCategoryEntityList *model = _dataArray[indexPath.row];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (PartAttributeEntityList *entity in model.itemArray) {
        if (![StringFunction isBlankString:entity.PartAttributeValue]) {
            [valueArray addObject:entity];
        }
    }
    return 15 + 21 + 8 + valueArray.count*8 + valueArray.count*14.5 + 15;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task_RiskSelectPartPreviewTableViewCell *cell = [Task_RiskSelectPartPreviewTableViewCell cellWithTableView:tableView];
    cell.model = _dataArray[indexPath.row];
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
