//
//  WXTimeLineSubCollectionViewCell.m
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXTimeLineSubCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#import <Masonry.h>


NSString *const kWXTimeLineSubCollectionViewTag = @"kWXTimeLineSubCollectionViewTag";

@interface WXTimeLineSubCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WXTimeLineSubCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViewsAndSetupLayout];
    }
    return self;
}

- (void)initViewsAndSetupLayout {
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)refresh {
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imgURL ? : @""]
                  placeholderImage:[UIImage imageNamed:kPlaceholderImageName]
                           options:SDWebImageRetryFailed];
}

@end
