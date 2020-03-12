//
//  Task_SelectTextViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/8/16.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Task_SelectTextViewController.h"
#import "SelectTextModel.h"

@interface Task_SelectTextViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<SelectTextModel *> *dataArray;
@end

@implementation Task_SelectTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择话语模板";
    [self netRequest];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)save {
    NSArray<NSIndexPath *> *indexArray = [_tableView indexPathsForSelectedRows];
    if (indexArray.count > 0) {
        NSMutableArray *stringArray = [NSMutableArray array];
        for (NSIndexPath *indexPath in indexArray) {
            NSString *text = _dataArray[indexPath.row].DiscourseContent;
            [stringArray addObject:text];
        }
        if ([self.delegate respondsToSelector:@selector(selectText:)]) {
            [self.delegate selectText:stringArray];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self showInfo:@"请选择"];
    }
}

- (void)netRequest {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [self showProgress];
    [NetRequest OLD_POST:task_getDiscourseTemplateManagements params:dic callback:^(OldElevatorBaseModel *baseModel) {
        if (baseModel.Success) {
            self.dataArray = [NSMutableArray array];
            for (NSDictionary *dic in [StringFunction stringToJson:baseModel.Data]) {
                SelectTextModel *model = [SelectTextModel yy_modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        } else {
            [self showInfo:baseModel.Message];
        }
        [self hideProgress];
    } errorCallback:^(NSError *error) {
        [self hideProgress];
    }];
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

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getCellHeight:_dataArray[indexPath.row]];
}

- (CGFloat)getCellHeight:(SelectTextModel *)model {
    CGFloat height = 15;
    CGRect titleRect = [model.DiscourseContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 22 - 15 - 15, 1000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    height += titleRect.size.height;
    height += 15;
    return height;
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
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.text = _dataArray[indexPath.row].DiscourseContent;
    return cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = cell.selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}
@end
