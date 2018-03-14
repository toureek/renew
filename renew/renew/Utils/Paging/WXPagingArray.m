//
//  WXPagingArray.m
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXPagingArray.h"


@implementation WXPagingArray {
    NSMutableArray * _pagingList;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _pagingList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super initWithCapacity:numItems];
    if (self) {
        _pagingList = [[NSMutableArray alloc] initWithCapacity:numItems];
    }
    return self;
}

- (NSUInteger)count {
    return [_pagingList count];
}

- (instancetype)objectAtIndex:(NSUInteger)index {
    return [_pagingList objectAtIndex:index];
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    [super addObjectsFromArray:otherArray];
    
    if ([otherArray isKindOfClass:[WXPagingArray class]]) {
        WXPagingArray * arr = (WXPagingArray *)otherArray;
        self.totalSize = arr.totalSize;
        self.page = arr.page;
        self.pageSize = arr.pageSize;
    }
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    return [_pagingList insertObject:anObject atIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    return [_pagingList removeObjectAtIndex:index];
}

- (void)addObject:(id)anObject {
    return [_pagingList addObject:anObject];
}

- (void)removeLastObject {
    return [_pagingList removeLastObject];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    return [_pagingList replaceObjectAtIndex:index withObject:anObject];
}

- (BOOL)hasMore {
    return (self.totalSize > self.page * self.pageSize);
}

@end

