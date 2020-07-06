//
//  NFCTagViewController.h
//  dtyios
//
//  Created by Lym on 2020/6/26.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import "YMBaseViewController.h"
@class MaintenanceNFCPartsModel;

@protocol NFCTagViewControllerDelegate <NSObject>

- (void)returnNFCData:(NSMutableDictionary *)dic;

@end

@interface NFCTagViewController : YMBaseViewController
@property (nonatomic, strong) MaintenanceNFCPartsModel *model;
@property (nonatomic, copy) NSString *writeString;
@property (nonatomic, copy) NSString *liftId;
@property (nonatomic, copy) NSString *maintenanceItemId;

@property (nonatomic, weak) id<NFCTagViewControllerDelegate> delegate;

@end

