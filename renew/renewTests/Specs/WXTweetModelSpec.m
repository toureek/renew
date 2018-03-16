//
//  WXTweetModelSpec.m
//  renewTests
//
//  Created by younghacker on 3/16/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <XCTest/XCTest.h>
@import Nimble;
@import Quick;
@import Mantle;

#import "WXUserModel.h"
#import "WXTweetModel.h"
#import "WXImageModel.h"
#import "WXCommentModel.h"

QuickSpecBegin(WXTweetModelSpec)

describe(@"tweetType", ^{
    
    __block WXTweetModel *tweet = nil;
    beforeEach(^{
        tweet = [[WXTweetModel alloc] init];
    });
    
    afterEach(^{
        tweet = nil;
    });
    
    it(@"should equal WXTweetTypeError when tweetFeed contains ErrorMessage and ErrorMessage has content", ^{
        tweet.error = @"Error Message";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeError));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains ErrorMessage without content", ^{
        tweet.error = @"";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender without username", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.nick = @"";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender without username", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.profileImage = @"http://www.baidu.com";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender without username", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.avatar = @"http://www.baidu.com";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender without username", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.nick = @"";
        tweet.sender.avatar = @"http://www.baidu.com";
        tweet.sender.profileImage = @"http://www.baidu.com";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender without username", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"";
        tweet.sender.nick = @"";
        tweet.sender.avatar = @"http://www.baidu.com";
        tweet.sender.profileImage = @"http://www.baidu.com";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender with username Only", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        tweet.sender.nick = @"";
        tweet.sender.avatar = @"http://www.baidu.com";
        tweet.sender.profileImage = @"http://www.baidu.com";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender with username(blanks) Only", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender with content(blanks)", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        tweet.content = @"";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeContentOnly when tweetFeed contains Sender with content(no blanks)", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        tweet.content = @"www.baidu.com";
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeContentOnly));
    });
    
    it(@"should equal WXTweetTypePictureOnly when tweetFeed contains Sender with imageList(a few images)", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        WXImageModel *itemA = [[WXImageModel alloc] init];
        WXImageModel *itemB = [[WXImageModel alloc] init];
        tweet.imagesList = @[itemA, itemB];
        expect(@(tweet.tweetType)).to(equal(WXTweetTypePictureOnly));
    });
    
    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender with imageList(no image)", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        tweet.imagesList = @[];
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypeContentPictureType when tweetFeed contains Sender with imageList(a few image)", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        tweet.content = @"www.baidu.com";
        WXImageModel *item = [[WXImageModel alloc] init];
        tweet.imagesList = @[item];
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeContentPictureType));
    });
    
    it(@"should equal WXTweetTypeContentCommentsType when tweetFeed contains Sender, conent, commentList(a few comments)", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        tweet.content = @"www.baidu.com";
        WXCommentModel *item = [[WXCommentModel alloc] init];
        tweet.commentsList = @[item];
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeContentCommentsType));
    });

    it(@"should equal WXTweetTypeUnknow when tweetFeed contains Sender, conent(blanks), commentList(no comment)", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        tweet.content = @"";
        tweet.commentsList = @[];
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeUnknow));
    });
    
    it(@"should equal WXTweetTypePictureCommentsType when tweetFeed contains Sender, conent(blanks), commentList(a few comments), imageList(a few images)", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        tweet.content = @"";
        WXCommentModel *item = [[WXCommentModel alloc] init];
        tweet.commentsList = @[item];
        WXImageModel *image = [[WXImageModel alloc] init];
        tweet.imagesList = @[image];
        expect(@(tweet.tweetType)).to(equal(WXTweetTypePictureCommentsType));
    });
    
    it(@"should equal WXTweetTypeContentPictureCommentsType when tweetFeed contains Sender, conent(no blanks), commentList(a few comments), imageList(a few images)", ^{
        tweet.sender = [[WXUserModel alloc] init];
        tweet.sender.username = @"baidu";
        tweet.content = @"www.baidu.com";
        WXCommentModel *item = [[WXCommentModel alloc] init];
        tweet.commentsList = @[item];
        WXImageModel *image = [[WXImageModel alloc] init];
        tweet.imagesList = @[image];
        expect(@(tweet.tweetType)).to(equal(WXTweetTypeContentPictureCommentsType));
    });
    
});

QuickSpecEnd


