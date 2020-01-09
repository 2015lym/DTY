//
//  MainViewDelegate.h
//  YONChat
//
//  Created by SongQues on 14/11/27.
//
//

#import <Foundation/Foundation.h>

@protocol MainViewDelegate <NSObject>

@required
#pragma mark - Badge
-(void) Badge_PeopleNearby:(int)badgeValue;
-(void) Badge_MessageCenter:(int)badgeValue;
-(void) Badge_SurpriseView:(int)badgeValue;
-(void) Badge_MeView:(int)badgeValue;
@end
