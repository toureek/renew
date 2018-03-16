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


#import "WXTweetModel.h"

QuickSpecBegin(WXTweetModelSpec)

describe(@"-isTweetValid", ^{
    it(@"should return NO when tweet type is Unknow", ^{
        WXTweetModel *tweet = [[WXTweetModel alloc] init];
        BOOL result = [tweet isTweetValid];
        expect(result).to(beFalse());
        NSLog(@"--------------------------------------------------------------------");
    });
});

describe(@"-zzz", ^{
    it(@"should return YES", ^{
        NSInteger index = 6;
        NSInteger indez = 7;
        expect(index < indez).to(beTrue());
        NSLog(@"--------------------------------------------------------------------");
    });
});


QuickSpecEnd


