//
//  WXContactModelSpec.m
//  renewTests
//
//  Created by younghacker on 3/16/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <XCTest/XCTest.h>
@import Nimble;
@import Quick;
@import Mantle;

#import "WXContactModel.h"

QuickSpecBegin(WXContactModelSpec)

describe(@"+filterSearchingResult:matchKeywords:", ^{
    
    __block WXContactModel *contactA;
    __block WXContactModel *contactB;
    __block WXContactModel *contactC;
    __block WXContactModel *contactD;
    __block WXContactModel *contactE;
    __block WXContactModel *contactF;
    __block NSArray *dataList;
    __block NSInteger matchItemTotalCount;

    beforeEach(^{
        contactA = [[WXContactModel alloc] init];
        contactA.identifier = @"1";
        contactA.name = @"AppleseedJohn";
        contactA.indexTitle = @"A";
        contactA.phone = @"888-555-5512";
        
        contactB = [[WXContactModel alloc] init];
        contactB.identifier = @"2";
        contactB.name = @"HigginsDaniel";
        contactB.indexTitle = @"H";
        contactB.phone = @"555-478-7672";
        
        contactC = [[WXContactModel alloc] init];
        contactC.identifier = @"3";
        contactC.name = @"HaroAnna";
        contactC.indexTitle = @"H";
        contactC.phone = @"555-522-8243";
        
        contactD = [[WXContactModel alloc] init];
        contactD.identifier = @"4";
        contactD.name = @"TaylorDavid";
        contactD.indexTitle = @"T";
        contactD.phone = @"555-610-5512";
        
        contactE = [[WXContactModel alloc] init];
        contactE.identifier = @"5";
        contactE.name = @"BellKate";
        contactE.indexTitle = @"B";
        contactE.phone = @"(555)564-8583";
        
        contactF = [[WXContactModel alloc] init];
        contactF.identifier = @"6";
        contactF.name = @"ZakroffHank";
        contactF.indexTitle = @"Z";
        contactF.phone = @"(555)766-4823";
        
        dataList = @[@[contactA], @[contactB, contactC], @[contactD], @[contactE], @[contactF]];
        matchItemTotalCount = 0;
    });
    
    it(@"should equal YES when filterList contains all results which match the inputKeyWords", ^{
        NSArray *array = [WXContactModel filterSearchingResult:@[] matchKeywords:@"1"];
        expect(array).to(equal(@[]));
    });
    
    it(@"should equal YES when filterList contains all results which match the inputKeyWords", ^{
        NSArray *array = [WXContactModel filterSearchingResult:nil matchKeywords:@"1"];
        expect(array).to(equal(@[]));
    });
    
    
    it(@"should equal YES when filterList contains all results which match the inputKeyWords", ^{
        NSArray *array = [WXContactModel filterSearchingResult:dataList matchKeywords:@"1"];
        [array enumerateObjectsUsingBlock:^(WXContactModel *obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqual:contactA] || [obj isEqual:contactD]) {
                matchItemTotalCount++;
            }
        }];
        expect(@(matchItemTotalCount)).to(equal(@2));
    });
    
    it(@"should equal YES when filterList contains all results which match the inputKeyWords", ^{
        NSArray *array = [WXContactModel filterSearchingResult:dataList matchKeywords:@"6"];
        expect(array).to(equal(@[contactB, contactD, contactE, contactF]));
    });
    
    it(@"should equal YES when filterList contains all results which match the inputKeyWords", ^{
        NSArray *array = [WXContactModel filterSearchingResult:dataList matchKeywords:@"ta"];
        expect(array).to(equal(@[contactD]));
    });
    
    it(@"should equal YES when filterList contains all results which match the inputKeyWords", ^{
        NSArray *array = [WXContactModel filterSearchingResult:dataList matchKeywords:@"*"];
        expect(array).to(equal(@[]));
    });
});

QuickSpecEnd



