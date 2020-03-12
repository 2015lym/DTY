//
//  Examine_ContentViewController.m
//  Sea_northeast_asia
//
//  Created by Lym on 2019/6/27.
//  Copyright © 2019 SongQues. All rights reserved.
//

#import "Examine_ContentViewController.h"
#import "Examine_ContentTableViewCell.h"
#import "ExamineProjectListModel.h"
#import "Examine_RecordModel.h"

#import "ExamineUtils.h"

@interface Examine_ContentViewController ()<Examine_ContentTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation Examine_ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"检验内容与要求";

    _dataArray = [NSMutableArray array];
    _saveArray = [NSMutableArray array];
    
    for (ExamineProjectListModel *model in _allArray) {
        if (model.CategoryLevel == 3) {
            model.hasFour = NO;
            for (ExamineProjectListModel *nmodel in _allArray) {
                if (nmodel.CategoryLevel == 4 && [nmodel.CategoryNameThree isEqualToString:model.CategoryNameThree]) {
                    model.hasFour = YES;
                }
            }
        }
        [_dataArray addObject:model];
    }
    
    if (_model.hasValue) {
        for (NSDictionary *dic in [ExamineUtils getExaminesArray:_taskId categoryId:_model.Id]) {
            Examine_RecordModel *model = [Examine_RecordModel yy_modelWithDictionary:dic];
            if (model.CreateUserId && ![model.CreateUserId isEqualToString:[UserService getOldUserInfo].UserId]) {
                _isPreview = YES;
            }
            [_saveArray addObject:model];
        }
    }
    
    if (!_isPreview) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(save)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}

- (void)save {
    if (_saveArray.count != _dataArray.count) {
        [self showInfo:@"有选项未选择，请选择！"];
    } else {
        [ExamineUtils saveExamines:_taskId categoryId:_model.Id data:_saveArray];
        [self showInfo:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    ExamineProjectListModel *model = _dataArray[indexPath.row];
    if (model.hasFour) {
        return 50;
    } else {
        if (model.CategoryLevel == 3) {
            return [self getCellHeight:model.CategoryNameThree];
        } else {
            return [self getCellHeight:model.CategoryNameFour];
        }
    }
}

- (CGFloat)getCellHeight:(NSString *)title {
    CGFloat rowHeight = 0;
    rowHeight += 15;
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 1000)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    rowHeight += titleRect.size.height;
    rowHeight += 15;
    rowHeight += 21;
    rowHeight += 15;
    rowHeight += 25;
    rowHeight += 15;
    return rowHeight;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExamineProjectListModel *model = _dataArray[indexPath.row];
    if (model.hasFour) {
        static NSString *ideitifier = @"cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ideitifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ideitifier];
        }
        cell.textLabel.text = model.CategoryNameThree;
        return cell;
    } else {
        Examine_ContentTableViewCell *cell = [Examine_ContentTableViewCell cellWithTableView:tableView];
        if (model.CategoryLevel == 3) {
            cell.titleLabel.text = model.CategoryNameThree;
        } else {
            cell.titleLabel.text = model.CategoryNameFour;
        }
        cell.examineCategoryId = model.Id;
        cell.isPreview = _isPreview;
        if (_model.hasValue) {
            for (Examine_RecordModel *rmodel in _saveArray) {
                if ([rmodel.ExamineCategoryId isEqualToString:model.Id]) {
                    cell.examineResult = rmodel.ExamineResult;
                    break;
                }
            }
        }
        cell.delegate = self;
        return cell;
    }
}

- (void)changeId:(NSString *)examineCategoryId andResult:(NSString *)examineResult {
    for (int i = 0; i<_saveArray.count; i++) {
        Examine_RecordModel *model = _saveArray[i];
        if ([model.ExamineCategoryId isEqualToString:examineCategoryId]) {
            model.ExamineResult = examineResult;
            _saveArray[i] = model;
            NSLog(@"%@", [_saveArray yy_modelToJSONObject]);
            return;
        }
    }
    
    Examine_RecordModel *model = [[Examine_RecordModel alloc] init];
    model.ExamineCategoryId = examineCategoryId;
    model.ExamineResult = examineResult;
    [_saveArray addObject:model];
    NSLog(@"%@", [_saveArray yy_modelToJSONObject]);
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
