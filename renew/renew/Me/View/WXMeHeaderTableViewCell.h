//
//  WXMeHeaderTableViewCell.h
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kWXMeHeaderTableViewCellTag;
extern CGFloat const kWXMeHeaderTableViewCellHeight;
extern CGFloat const kWXCommonLeftRightPaddingSpace;

@class WXUserModel;
@interface WXMeHeaderTableViewCell : UITableViewCell

// Demo中如此设计该View的数据结构，实际上登录用户的UserModel应以单例形式存在
@property (nonatomic, strong) WXUserModel *userModel;

- (void)setUserModel:(WXUserModel *)userModel;

@end
