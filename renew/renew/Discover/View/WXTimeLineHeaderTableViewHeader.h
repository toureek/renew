//
//  WXTimeLineHeaderTableViewHeader.h
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kWXTimeLineHeaderTableViewHeaderTag;
extern CGFloat const kWXTimeLineHeaderTableViewHeaderHeight;

@class WXUserModel;

@interface WXTimeLineHeaderTableViewHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) WXUserModel *userItem;

- (void)setUserItem:(WXUserModel *)userItem;

@end
