//
//  MaintenanceNFCListViewController.h
//  dtyios
//
//  Created by Lym on 2020/7/2.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
@class AppMaintenanceItemDtos;


@protocol MaintenanceNFCListViewControllerDelegate <NSObject>

- (void)returnPartsData:(AppMaintenanceItemDtos *)item andIndexPath:(NSIndexPath *)indexPath;

@end

@interface MaintenanceNFCListViewController : YMBaseViewController
@property (nonatomic, strong) AppMaintenanceItemDtos *item;
@property (nonatomic, copy) NSString *liftId;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSIndexPath *indexPath;

@property (nonatomic, weak) id<MaintenanceNFCListViewControllerDelegate> delegate;

@end
