//
//  WXMeHeaderTableViewCell.m
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXMeHeaderTableViewCell.h"
#import "WXUserModel.h"
#import "WXUIFactory.h"
#import <UIImageView+WebCache.h>


NSString *const kWXMeHeaderTableViewCellTag = @"kWXMeHeaderTableViewCellTag";
CGFloat const kWXMeHeaderTableViewCellHeight = 90.0f;
CGFloat const kWXCommonLeftRightPaddingSpace = 15.0f;
static CGFloat const kWXThinLeftRightPadddingSpace = 10.0f;
static CGFloat const kWXAvatorImageSize = 70.0f;
static CGFloat const kWXUserNameLabelHeight = 17.0f;

@interface WXMeHeaderTableViewCell ()

@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *identifierLabel;
@property (nonatomic, strong) UIImageView *qrCodeImageView;

@end

@implementation WXMeHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    [self setUpAvatorImageView];
    [self setUpNameLabel];
    [self setUpIdentifierLabel];
    [self setUpQRCodeImageView];
}

- (void)setUpAvatorImageView {
    _avatorImageView = [[UIImageView alloc] init];
    _avatorImageView.image = [UIImage imageNamed:kPlaceholderImageName];
    _avatorImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_avatorImageView];
}

- (void)setUpNameLabel {
    _nameLabel = [WXUIFactory buildLabelWithTextColor:[UIColor WX_MainContentTextColor]
                                                 font:[UIFont systemFontOfSize:16]];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _nameLabel.text = @"I_Am_A_Tour";
    [self.contentView addSubview:_nameLabel];
}

- (void)setUpIdentifierLabel {
    _identifierLabel = [WXUIFactory buildLabelWithTextColor:[UIColor WX_MainContentTextColor]
                                                       font:[UIFont systemFontOfSize:16]];
    _identifierLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _identifierLabel.text = @"Wechat ID: Rio";
    [self.contentView addSubview:_identifierLabel];
}

- (void)setUpQRCodeImageView {
    _qrCodeImageView = [[UIImageView alloc] init];
    _qrCodeImageView.image = [UIImage imageNamed:kPlaceholderImageName];
    _qrCodeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_qrCodeImageView];
}

- (void)updateConstraints {
    [self addAvatorImageViewLayout];
    [self addUserNameLabelLayout];
    [self addIdentifierLabelLayout];
    [self addQRCodeLayout];
    
    [super updateConstraints];
}

- (void)addAvatorImageViewLayout {
    _avatorImageView.backgroundColor = [UIColor redColor];
    if (@available(iOS 9.0, *)) {
        [_avatorImageView.widthAnchor constraintEqualToConstant:kWXAvatorImageSize].active = YES;
        [_avatorImageView.heightAnchor constraintEqualToConstant:kWXAvatorImageSize].active = YES;
        [_avatorImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        [_avatorImageView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:kWXCommonLeftRightPaddingSpace].active = YES;
    } else {
        NSLayoutConstraint *leftConstrains = [NSLayoutConstraint constraintWithItem:_avatorImageView
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.contentView
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1
                                                                           constant:kWXCommonLeftRightPaddingSpace];
        
        NSLayoutConstraint *centerYConstrains = [NSLayoutConstraint constraintWithItem:_avatorImageView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1
                                                                              constant:0];
        
        NSLayoutConstraint *widthConstrains = [NSLayoutConstraint constraintWithItem:_avatorImageView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1
                                                                            constant:kWXAvatorImageSize];
        
        NSLayoutConstraint *heightConstrains = [NSLayoutConstraint constraintWithItem:_avatorImageView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1
                                                                             constant:kWXAvatorImageSize];
        
        [self.contentView addConstraints:@[leftConstrains, centerYConstrains, widthConstrains, heightConstrains]];
    }
}

- (void)addUserNameLabelLayout {
    if (@available(iOS 9.0, *)) {
        [_nameLabel.bottomAnchor constraintEqualToAnchor:_avatorImageView.centerYAnchor constant:(-kWXThinLeftRightPadddingSpace/2.0)].active = YES;
        [_nameLabel.leftAnchor constraintEqualToAnchor:_avatorImageView.rightAnchor constant:kWXThinLeftRightPadddingSpace].active = YES;
        [_nameLabel.heightAnchor constraintEqualToConstant:kWXUserNameLabelHeight].active = YES;
    } else {
        NSLayoutConstraint *leftConstrains = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_avatorImageView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1
                                                                           constant:kWXThinLeftRightPadddingSpace];
        
        NSLayoutConstraint *bottomConstrains = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                            attribute:NSLayoutAttributeBottom
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_avatorImageView
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1
                                                                             constant:(-kWXThinLeftRightPadddingSpace/2.0)];
       
        NSLayoutConstraint *heightConstrains = [NSLayoutConstraint constraintWithItem:_nameLabel
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1
                                                                             constant:kWXUserNameLabelHeight];
        
        [self.contentView addConstraints:@[leftConstrains, bottomConstrains, heightConstrains]];
    }
}

- (void)addIdentifierLabelLayout {
    if (@available(iOS 9.0, *)) {
        [_identifierLabel.heightAnchor constraintEqualToConstant:17].active = YES;
        [_identifierLabel.leftAnchor constraintEqualToAnchor:_avatorImageView.rightAnchor constant:kWXThinLeftRightPadddingSpace].active = YES;
        [_identifierLabel.topAnchor constraintEqualToAnchor:_avatorImageView.centerYAnchor constant:(kWXThinLeftRightPadddingSpace/2.0)].active = YES;
    } else {
        NSLayoutConstraint *topConstrains = [NSLayoutConstraint constraintWithItem:_identifierLabel
                                                                         attribute:NSLayoutAttributeTop
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_avatorImageView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1
                                                                          constant:(kWXThinLeftRightPadddingSpace/2.0)];
        
        NSLayoutConstraint *leftConstrains = [NSLayoutConstraint constraintWithItem:_identifierLabel
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_avatorImageView
                                                                          attribute:NSLayoutAttributeRight
                                                                         multiplier:1
                                                                           constant:kWXThinLeftRightPadddingSpace];
        
        NSLayoutConstraint *heightConstrains = [NSLayoutConstraint constraintWithItem:_identifierLabel
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1
                                                                             constant:kWXUserNameLabelHeight];
        [self.contentView addConstraints:@[topConstrains, leftConstrains, heightConstrains]];
    }
}

- (void)addQRCodeLayout {
    if (@available(iOS 9, *)) {
        [_qrCodeImageView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:(-kWXThinLeftRightPadddingSpace/2.0)].active = YES;
        [_qrCodeImageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
        [_qrCodeImageView.heightAnchor constraintEqualToConstant:16].active = YES;
        [_qrCodeImageView.widthAnchor constraintEqualToConstant:16].active = YES;
    } else {
        NSLayoutConstraint *rightConstrains = [NSLayoutConstraint constraintWithItem:_qrCodeImageView
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.contentView
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1
                                                                            constant:(-kWXThinLeftRightPadddingSpace/2.0)];
        
        NSLayoutConstraint *widthConstrains = [NSLayoutConstraint constraintWithItem:_qrCodeImageView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                                          multiplier:1
                                                                            constant:16];
        
        NSLayoutConstraint *heightConstrains = [NSLayoutConstraint constraintWithItem:_qrCodeImageView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1
                                                                             constant:16];
        
        NSLayoutConstraint *centerYConstrains = [NSLayoutConstraint constraintWithItem:_qrCodeImageView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1
                                                                              constant:0];
        
        [self.contentView addConstraints:@[rightConstrains, widthConstrains, heightConstrains, centerYConstrains]];
    }
}

- (void)setUserModel:(WXUserModel *)userModel {
    _userModel = userModel;
    if (_userModel) {
        _nameLabel.text = [_userModel userItemName];
        _identifierLabel.text = [_userModel userItemDisplayedNickName];
        [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:[_userModel userItemAvatarImagePath]]
                            placeholderImage:[UIImage imageNamed:kPlaceholderImageName]];
    }
    [self.contentView setNeedsUpdateConstraints];
}

@end
