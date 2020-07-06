//
//  MaintenanceNFCPartsModel.h
//  dtyios
//
//  Created by Lym on 2020/7/2.
//  Copyright © 2020 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MaintenanceNFCPartsModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger Sort;
@property (nonatomic, copy) NSString *LastModifyTime;
@property (nonatomic, copy) NSString *PartRemark;
@property (nonatomic, copy) NSString *CreateTime;
@property (nonatomic, copy) NSString *PartName;
@property (nonatomic, copy) NSString *CreateUserId;
@property (nonatomic, copy) NSString *LastModifyUserId;

@end
