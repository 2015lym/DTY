//
//  classLiftParts.h
//  Sea_northeast_asia
//
//  Created by 邓玉 on 2018/10/19.
//  Copyright © 2018年 SongQues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface classLiftParts : NSObject
@property (strong, nonatomic) NSString *LiftId;
@property (strong, nonatomic) NSString *LiftNum;
@property (strong, nonatomic) NSString *CertificateNum;
@property (strong, nonatomic) NSString *AddressPath;//辽宁省 沈阳市 沈河区
@property (strong, nonatomic) NSString *InstallationAddress;

@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) NSMutableArray *listType;
@end
