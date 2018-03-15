//
//  WXTweetModel.m
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXTweetModel.h"
#import "WXImageModel.h"
#import "WXUserModel.h"
#import "WXCommentModel.h"


NSUInteger const kOneLineMinImageCountsInTweetsPictures = 1;
NSUInteger const kTwoLineMinImageCountsInTweetsPictures = 4;
NSUInteger const kThreeLineMinImageCountsInTweetsPictures = 7;
NSUInteger const kFourLineMinImageCountsInTweetsPictures = 10;

@implementation WXTweetModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"error"            : @"error",
             @"imagesList"       : @"images",
             @"sender"           : @"sender",
             @"commentsList"     : @"comments",
             @"content"          : @"content"};
}

+ (NSValueTransformer *)imagesListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WXImageModel class]];
}

+ (NSValueTransformer *)commentsListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WXCommentModel class]];
}

+ (NSValueTransformer *)senderJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[WXUserModel class]];
}


#pragma mark - Getter

- (WXTweetType)tweetType {
    if (_error && [_error length] > 0) {
        return WXTweetTypeError;
    } else if (_sender &&
             (_content && [_content length] > 0) &&
             (_imagesList && (_imagesList.count > 0)) &&
             (_commentsList && (_commentsList.count > 0))) {
        return WXTweetTypeContentPictureCommentsType;
    } else if (_sender &&
             (_content && [_content length] > 0) &&
             (_imagesList && (_imagesList.count > 0))) {
        return WXTweetTypeContentPictureType;
    } else if (_sender &&
             (_content && [_content length] > 0) &&
             (_commentsList && (_commentsList.count > 0))) {
        return WXTweetTypeContentCommentsType;
    } else if (_sender &&
             (_imagesList && (_imagesList.count > 0)) &&
             (_commentsList && (_commentsList.count > 0))) {
        return WXTweetTypePictureCommentsType;
    } else if (_sender &&
             (_imagesList && (_imagesList.count > 0))) {
        return WXTweetTypePictureOnly;
    } else if (_sender &&
             (_content && [_content length] > 0)) {
        return WXTweetTypeContentOnly;
    } else {
        return WXTweetTypeUnknow;
    }
}

- (BOOL)isTweetValid {
    return ((self.tweetType != WXTweetTypeUnknow) && (self.tweetType != WXTweetTypeError));
}

- (BOOL)existContentText {
    return (self.tweetType != WXTweetTypePictureOnly) && (self.tweetType != WXTweetTypePictureCommentsType) && [self isTweetValid];
}

- (BOOL)existPictures {
    return (self.tweetType != WXTweetTypeContentOnly) && (self.tweetType != WXTweetTypeContentCommentsType) && [self isTweetValid];
}

@end

