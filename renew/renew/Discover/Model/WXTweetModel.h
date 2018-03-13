//
//  WXTweetModel.h
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXBaseModel.h"


typedef NS_ENUM(NSUInteger, WXTweetType) {
    WXTweetTypeUnknow = 0,                       // 未知类型
    WXTweetTypeError = 1,
    WXTweetTypeContentOnly = 2,
    WXTweetTypePictureOnly = 3,
    WXTweetTypeContentPictureType = 4,
    WXTweetTypeContentCommentsType = 5,
    WXTweetTypePictureCommentsType = 6,
    WXTweetTypeContentPictureCommentsType = 7,
};

@class WXUserModel;

@interface WXTweetModel : WXBaseModel

@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSArray *imagesList;
@property (nonatomic, copy) NSArray *commentsList;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) WXUserModel *sender;
@property (nonatomic, assign) WXTweetType tweetType;

- (BOOL)isTweetValid;
- (BOOL)existContentText;
- (BOOL)existPictures;

@end
