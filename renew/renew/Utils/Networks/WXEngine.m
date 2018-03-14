//
//  WXEngine.m
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXEngine.h"
#import "WXTweetModel.h"
#import "WXUserModel.h"
#import <AFNetworking/AFNetworking.h>


NSString *const kBaseAPI = @"http://thoughtworks-ios.herokuapp.com/";
NSString *const kAPIRequestForUserInfo = @"user/jsmith";
NSString *const kAPIRequestForFetchingUserTweet = @"user/jsmith/tweets";

@implementation WXEngine

- (void)fetchAllFormatedTweetsAndPostHandlingNotificationInfo {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseAPI, kAPIRequestForFetchingUserTweet];
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    [client GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WXNotificationInfo *info = [[WXNotificationInfo alloc] init];
        if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
            NSArray *itemList = [MTLJSONAdapter modelsOfClass:WXTweetModel.class
                                                fromJSONArray:responseObject
                                                        error:nil];
            if (itemList && itemList.count > 0) {
                info.code = @"0";
                NSMutableArray *infoList = [NSMutableArray arrayWithCapacity:4];
                for (WXTweetModel *tweet in itemList) {
                    if ([tweet isTweetValid]) {
                        [infoList addObject:tweet];
                    }
                }
                info.tweetsList = infoList;
            } else if (itemList) {
                info.code = @"0";
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WXNFetchMyTweetsList
                                                            object:nil
                                                          userInfo:@{WXKFetchMyTweetsList : info}];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WXNotificationInfo *info = [[WXNotificationInfo alloc] init];
        info.errorMsg = @"Networking Failed";
        info.code = @"-1";
        [[NSNotificationCenter defaultCenter] postNotificationName:WXNFetchMyTweetsList
                                                            object:nil
                                                          userInfo:@{WXKFetchMyTweetsList : info}];
    }];
}

- (void)fetchUserInfoAndPostHandlingNotificationInfo {
    NSString *url = [NSString stringWithFormat:@"%@%@", kBaseAPI, kAPIRequestForUserInfo];
    AFHTTPRequestOperationManager *client = [AFHTTPRequestOperationManager manager];
    [client GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WXNotificationInfo *info = [[WXNotificationInfo alloc] init];
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            WXUserModel *userModel = [MTLJSONAdapter modelOfClass:[WXUserModel class]
                                               fromJSONDictionary:responseObject
                                                            error:nil];
            if (userModel) {
                info.userModel = userModel;
                info.code = @"0";
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:WXNFetchUserInfo
                                                            object:nil
                                                          userInfo:@{WXKFetchUserInfo : info}];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WXNotificationInfo *info = [[WXNotificationInfo alloc] init];
        info.errorMsg = @"Networking Failed";
        info.code = @"-1";
        [[NSNotificationCenter defaultCenter] postNotificationName:WXNFetchUserInfo
                                                            object:nil
                                                          userInfo:@{WXKFetchUserInfo : info}];
    }];
}


@end
