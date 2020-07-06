//
//  MaintenancePhotoViewController.h
//  dtyios
//
//  Created by Lym on 2020/7/5.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"

@class AppMaintenanceItemDtos;

@protocol MaintenancePhotoViewControllerDelegate <NSObject>

- (void)returnPhotoData:(NSMutableArray *)array andIndexPath:(NSIndexPath *)indexPath;

@end

@interface MaintenancePhotoViewController : YMBaseViewController
@property (nonatomic, strong) AppMaintenanceItemDtos *item;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, weak) id<MaintenancePhotoViewControllerDelegate> delegate;

@end

