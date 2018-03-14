//
//  WXNotificationInfo.m
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXNotificationInfo.h"
#import "WXUserModel.h"


NSString *const WXNFetchUserInfo = @"WXNFetchUserInfo";
NSString *const WXKFetchUserInfo = @"WXKFetchUserInfo";

NSString *const WXNFetchMyTweetsList = @"WXNFetchMyTweetsList";
NSString *const WXKFetchMyTweetsList = @"WXKFetchMyTweetsList";

@implementation WXNotificationInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        _tweetsList = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

- (BOOL)requestExecuteSuccessfully {
    return [_code isEqualToString:@"0"];
}

@end
