//
//  ViewController.h
//  ble_nfc_sdk
//
//  Created by sahmoL on 16/6/22.
//  Copyright © 2016年 Lochy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "XXNet.h"
@interface NFCSBNewViewController : UIViewController
{
    UILabel *labMemo;
    UILabel *labMemo1;
}
@property (nonatomic,strong) AppDelegate *app;
@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Memo;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *NFCCode;
@property (strong, nonatomic) NSString *NFCNum;
@property (strong, nonatomic) NSString *type;//""read;"write"write
@property (strong, nonatomic) NSString *writeString;//""read;"write"write
@end

