//
//  WXEngine.h
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXNotificationInfo.h"


extern NSString *const kBaseAPI;
extern NSString *const kAPIRequestForUserInfo;
extern NSString *const kAPIRequestForFetchingUserTweet;

@interface WXEngine : NSObject

- (void)fetchAllFormatedTweetsAndPostHandlingNotificationInfo;
- (void)fetchUserInfoAndPostHandlingNotificationInfo;

@end
