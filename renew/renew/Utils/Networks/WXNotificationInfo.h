//
//  WXNotificationInfo.h
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const WXNFetchUserInfo;
extern NSString *const WXKFetchUserInfo;

extern NSString *const WXNFetchMyTweetsList;
extern NSString *const WXKFetchMyTweetsList;

@class WXUserModel;

@interface WXNotificationInfo : NSObject

@property (nonatomic, copy) NSString *code;  // REST: if [code isEqualToString:@"0"] means Request Successfully
@property (nonatomic, copy) NSString *errorMsg;

@property (nonatomic, strong) NSMutableArray *tweetsList;
@property (nonatomic, strong) WXUserModel *userModel;

- (BOOL)requestExecuteSuccessfully;

@end
