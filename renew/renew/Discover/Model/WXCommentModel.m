//
//  WXCommentModel.m
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXCommentModel.h"
#import "WXUserModel.h"


@implementation WXCommentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"sender" : @"sender"};
}

+ (NSValueTransformer *)senderJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[WXUserModel class]];
}

- (NSString *)commentContent {
    return [NSString stringWithFormat:@"%@ : %@", (_sender.nick ? : @""), (_content ? : @"")];
}


@end
