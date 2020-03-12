//
//  Task_RiskSelectPartDetailViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/25.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_RiskSelectPartDetailViewController.h"
#import "Task_InputTableViewCell.h"

@interface Task_RiskSelectPartDetailViewController ()<EnvFormDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray<PartAttributeEntityList*> *dataArray;

@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *sectionArray;
@property (weak, nonatomic) IBOutlet UIButton *addButton;


@end

@implementation Task_RiskSelectPartDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择部件";
    [self configData];
    if (!_isPreview) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(save)];
        self.navigationItem.rightBarButtonItem = rightButton;
    } else {
        _addButton.hidden = YES;
    }
}

- (void)configData {
    _sectionArray = [NSMutableArray array];
    
    if (_dataArray && _dataArray.count > 0) {
        NSMutableArray *idArray = [NSMutableArray array];
        for (PartAttributeEntityList *model in _dataArray) {
            if ([idArray containsObject:model.ElevatorPartRecordId]) {
                continue;
            } else {
                [idArray addObject:model.ElevatorPartRecordId];
            }
        }
        
        for (NSString *ElevatorPartRecordId in idArray) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (PartAttributeEntityList *model in _itemArray) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[model yy_modelToJSONObject]];
                for (PartAttributeEntityList *vmodel in _dataArray) {
                    if ([vmodel.ElevatorPartRecordId isEqualToString:ElevatorPartRecordId] &&
                        [vmodel.PartAttributeName isEqualToString:model.PartAttributeName]) {
                        dic[@"PartAttributeValue"] = vmodel.PartAttributeValue;
                    }
                }
                [tempArray addObject:dic];
            }
            [_sectionArray addObject:tempArray];
        }
    } else {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (PartAttributeEntityList *model in _itemArray) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[model yy_modelToJSONObject]];
            [tempArray addObject:dic];
        }
        [_sectionArray addObject:tempArray];
    }
}

- (void)save {
    NSMutableArray *saveArray = [NSMutableArray array];
    for (NSInteger i=0; i<_sectionArray.count; i++) {
        NSMutableArray *array = _sectionArray[i];
        NSInteger num = 0;
        for (NSMutableDictionary *dic in array) {
            dic[@"ElevatorPartRecordId"] = [NSString stringWithFormat:@"%@%zd", [BaseFunction getTimestamp], i];
            PartAttributeEntityList *item = [PartAttributeEntityList yy_modelWithDictionary:dic];
            if (item.PartAttributeValue && item.PartAttributeValue > 0) {
                num += 1;
                [saveArray addObject:item];
            }
        }
        if (num == 0) {
            [self showInfo:@"请填写信息！"];
            return;
        }
    }

    if ([self.delegate respondsToSelector:@selector(saveData:andIndexPath:)]) {
        [self.delegate saveData:saveArray andIndexPath:_indexPath];
    }
    [self showSuccess:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addAction:(id)sender {
    if (!_itemArray || _itemArray.count == 0) {
        [self showInfo:@"没有选项数据"];
        return;
    }
    if (_sectionArray.count == 10) {
        [self showInfo:@"最多添加10组数据"];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (PartAttributeEntityList *model in _itemArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[model yy_modelToJSONObject]];
        [tempArray addObject:dic];
    }
    [_sectionArray addObject:tempArray];
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_sectionArray.count - 1, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                              inSection:_sectionArray.count - 1]
                          atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - ---------- 每个Section的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionArray.count;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sectionArray[section].count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task_InputTableViewCell *cell = [Task_InputTableViewCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
    cell.isPreview = _isPreview;
    cell.model = _sectionArray[indexPath.section][indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)updateText:(NSString *)text andIndexPath:(NSIndexPath *)indexPath {
    _sectionArray[indexPath.section][indexPath.row][@"PartAttributeValue"] = text;
}

- (void)deleteSectionAtIndexPath:(NSIndexPath *)indexPath {
    [_sectionArray removeObjectAtIndex:indexPath.section];
    [self.tableView beginUpdates];
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.section, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
