//
//  WXUserModel.m
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXUserModel.h"


@implementation WXUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"profileImage" : @"profile-image",
             @"nick"         : @"nick",
             @"username"     : @"username",
             @"avatar"       : @"avatar"};
}

- (BOOL)existUserInfo {
    return _username && [_username length] > 0;
}

- (NSString *)userItemName {
    return _username ? : @"";
}

- (NSString *)userItemAvatarImagePath {
    return _avatar ? : @"";
}

- (NSString *)userItemProfileImagePath {
    return _profileImage ? : @"";
}

- (NSString *)userItemDisplayedNickName {
    NSString *userName = _nick ? : @"";
    return ([userName length] > 0) ? ([NSString stringWithFormat:@"Wechat ID: %@", userName]) : (@"");
}

- (NSString *)userItemTimelineDisplayName {
    return _nick ? : @"";
}

+ (NSArray *)meViewControllerDataSourceList
{
    return @[@[@[@""], @[@"Watch WeChat"], @[@"Wallet"], @[@"Favourites", @"My Posts", @"Cards & Offers", @"Sticker Gallery"], @[@"Settings"]],
             @[@[@""], @[kPlaceholderImageName], @[kPlaceholderImageName], @[kPlaceholderImageName, kPlaceholderImageName, kPlaceholderImageName, kPlaceholderImageName], @[kPlaceholderImageName]],
             @[@[@""], @[@""], @[@""], @[@"", @"", @"", @""], @[@"Unprotected"]]];
}

@end
