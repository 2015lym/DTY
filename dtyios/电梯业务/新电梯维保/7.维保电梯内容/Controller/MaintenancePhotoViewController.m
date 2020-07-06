//
//  MaintenancePhotoViewController.m
//  dtyios
//
//  Created by Lym on 2020/7/5.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "MaintenancePhotoViewController.h"
#import "MaintenanceContentModel.h"
#import "MaintenancePhotoTableViewCell.h"

@interface MaintenancePhotoViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MaintenancePhotoTableViewCell *cell;
@end

@implementation MaintenancePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"部件照片";
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)save {
    NSLog(@"%@", _cell.dataArray);
    if ([self.delegate respondsToSelector:@selector(returnPhotoData:andIndexPath:)]) {
        [self.delegate returnPhotoData:_cell.dataArray andIndexPath:_indexPath];
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

#pragma mark - ---------- Section的数量 ----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - ---------- 每个Cell的高度 ----------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - ---------- Cell的数量 ----------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

#pragma mark - ---------- 每个Cell的内容 ----------
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [MaintenancePhotoTableViewCell cellWithTableView:tableView];
    _cell.model = _item;
    [_cell changeUI];
    return _cell;
}

#pragma mark - ---------- TableView 点击事件 ----------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
