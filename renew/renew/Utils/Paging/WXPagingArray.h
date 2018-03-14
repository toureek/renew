//
//  WXPagingArray.h
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WXPagingArray : NSMutableArray

@property (nonatomic, assign) NSInteger totalSize;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL hasNextPage; // 返回无total时使用

@end
