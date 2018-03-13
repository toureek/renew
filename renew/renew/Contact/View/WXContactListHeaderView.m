//
//  WXContactListHeaderView.m
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXContactListHeaderView.h"
#import "WXUIFactory.h"


NSString *const kWXContactListHeaderViewTag = @"kWXContactListHeaderViewTag";
CGFloat const kWXContactListHeaderViewHeight = 22.0f;
static CGFloat const kWXContactHeaderMarginSpace = 30.0f;
static CGFloat const kWXContactHeaderThinMarginSpace = 10.0f;

@interface WXContactListHeaderView ()

@property (nonatomic, strong) UILabel *indexTitleLabel;

@end

@implementation WXContactListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpViewAndLayout];
    }
    return self;
}

- (void)setUpViewAndLayout {
    _indexTitleLabel = [WXUIFactory buildLabelWithTextColor:[UIColor WX_SubmainContentTextColor]
                                                       font:[UIFont systemFontOfSize:16]
                                            backgroundColor:[UIColor clearColor]
                                              textAlignment:NSTextAlignmentLeft
                                              numberOfLines:1];
    _indexTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_indexTitleLabel];
    
    if (@available(iOS 9.0, *)) {
        [_indexTitleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-kWXContactHeaderMarginSpace].active = YES;
        [_indexTitleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:kWXContactHeaderThinMarginSpace].active = YES;
        [_indexTitleLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        [_indexTitleLabel.heightAnchor constraintEqualToConstant:17].active = YES;
    } else {
        NSLayoutConstraint *rightConstrains = [NSLayoutConstraint constraintWithItem:_indexTitleLabel
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1
                                                                            constant:-kWXContactHeaderMarginSpace];
        
        NSLayoutConstraint *leftConstrains = [NSLayoutConstraint constraintWithItem:_indexTitleLabel
                                                                          attribute:NSLayoutAttributeLeft
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeLeft
                                                                         multiplier:1
                                                                           constant:kWXContactHeaderThinMarginSpace];
        
        NSLayoutConstraint *centerYConstrains = [NSLayoutConstraint constraintWithItem:_indexTitleLabel
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1
                                                                              constant:0];
        
        NSLayoutConstraint *heightConstrains = [NSLayoutConstraint constraintWithItem:_indexTitleLabel
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                                           multiplier:1
                                                                             constant:17];
        
        [self addConstraints:@[rightConstrains, leftConstrains, centerYConstrains, heightConstrains]];
    }
}

- (void)refresh {
    _indexTitleLabel.text = _indexTitle ? : @"";
}


@end
