//
//  WXTimeLineHeaderTableViewHeader.m
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXTimeLineHeaderTableViewHeader.h"
#import "WXUserModel.h"
#import "WXUIFactory.h"

#import "UIImageView+WebCache.h"
#import <Masonry.h>


NSString *const kWXTimeLineHeaderTableViewHeaderTag = @"kWXTimeLineHeaderTableViewHeaderTag";
CGFloat const kWXTimeLineHeaderTableViewHeaderHeight = 240.0f;
static CGFloat const kWXTimeLineHeaderViewAvatorSize = 60.0f;
static CGFloat const kWXTimeLineHeaderViewThinLeftPadding = 10.0f;

@interface WXTimeLineHeaderTableViewHeader ()

@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;

@end

@implementation WXTimeLineHeaderTableViewHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _profileImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_profileImageView];
    
    _avatorImageView = [[UIImageView alloc] init];
    _avatorImageView.layer.borderWidth = 1;
    _avatorImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.contentView addSubview:_avatorImageView];
    
    _nickNameLabel = [WXUIFactory buildLabelWithTextColor:[UIColor WX_MainContentTextColor]
                                                     font:[UIFont boldSystemFontOfSize:16]];
    [self.contentView addSubview:_nickNameLabel];
    
    [self.contentView bringSubviewToFront:_avatorImageView];
    [self.contentView bringSubviewToFront:_nickNameLabel];
}

- (void)addSubViewsLayout {
    [_profileImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self.contentView);
        make.height.equalTo(@(kWXTimeLineHeaderTableViewHeaderHeight-(kWXTimeLineHeaderViewAvatorSize/2)));
    }];
    
    [_avatorImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-(kWXTimeLineHeaderViewThinLeftPadding/2.0));
        make.right.equalTo(self.contentView).offset(-kWXTimeLineHeaderViewThinLeftPadding);
        make.size.mas_equalTo(CGSizeMake(kWXTimeLineHeaderViewAvatorSize, kWXTimeLineHeaderViewAvatorSize));
    }];
    
    [_nickNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_avatorImageView);
        make.right.equalTo(_avatorImageView.mas_left).offset(-kWXTimeLineHeaderViewThinLeftPadding*2);
        make.height.equalTo(@15);
    }];
}

- (void)updateConstraints {
    [self addSubViewsLayout];
    
    [super updateConstraints];
}

- (void)setUserItem:(WXUserModel *)userItem {
    _userItem = userItem;
    if (_userItem) {
        UIImage *placeholderImg = [UIColor WX_imageFactoryWithColor:[UIColor clearColor]];
        [_profileImageView sd_setImageWithURL:[NSURL URLWithString:[_userItem userItemProfileImagePath]]
                             placeholderImage:placeholderImg];
        
        [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:[_userItem userItemAvatarImagePath]]
                            placeholderImage:placeholderImg];
        
        _nickNameLabel.text = [_userItem userItemTimelineDisplayName];
    }
}

@end
