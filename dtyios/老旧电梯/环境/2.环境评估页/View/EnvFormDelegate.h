//
//  EnvFormDelegate.h
//  Sea_northeast_asia
//
//  Created by Lym on 2019/7/15.
//  Copyright © 2019 SongQues. All rights reserved.
//

#ifndef EnvFormDelegate_h
#define EnvFormDelegate_h


@protocol EnvFormDelegate <NSObject>

@optional

- (void)updateText:(NSString *)text andIndexPath:(NSIndexPath *)indexPath;

- (void)updateRadio:(NSInteger)number andIndexPath:(NSIndexPath *)indexPath;

- (void)deleteSectionAtIndexPath:(NSIndexPath *)indexPath;

@end


#endif /* EnvFormDelegate_h */
