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
             @"avatar"       : @"avatar"};
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
             @[@[@""], @[@"contactapp"], @[@"contactapp"], @[@"contactapp", @"contactapp", @"contactapp", @"contactapp"], @[@"contactapp"]],
             @[@[@""], @[@""], @[@""], @[@"", @"", @"", @""], @[@"Unprotected"]]];
}

@end
