//
//  WXUserModel.h
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXBaseModel.h"


@interface WXUserModel : WXBaseModel

@property (nonatomic, copy) NSString *profileImage;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *username;

- (BOOL)existUserInfo;

- (NSString *)userItemName;
- (NSString *)userItemAvatarImagePath;
- (NSString *)userItemProfileImagePath;
- (NSString *)userItemDisplayedNickName;
- (NSString *)userItemTimelineDisplayName;

#pragma mark - FakeData

+ (NSArray *)meViewControllerDataSourceList;

@end
