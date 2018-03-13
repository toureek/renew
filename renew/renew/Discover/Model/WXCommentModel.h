//
//  WXCommentModel.h
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXBaseModel.h"


@class WXUserModel;

@interface WXCommentModel : WXBaseModel

// 即使tweetModel与commentModel数据结构相差不大，依然进行解耦。
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) WXUserModel *sender;

- (NSString *)commentContent;

@end
