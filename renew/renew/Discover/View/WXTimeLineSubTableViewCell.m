//
//  WXTimeLineSubTableViewCell.m
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXTimeLineSubTableViewCell.h"
#import "WXUIFactory.h"

#import <Masonry.h>


NSString *const kWXTimeLineSubTableTag = @"kWXTimeLineSubTableTag";
static CGFloat const kWXTimeLineSubTableViewCellLeftPadding = 5.0f;
static CGFloat const kWXTimeLineSubTableViewCommitBlankSpace = 75.0f;

@interface WXTimeLineSubTableViewCell ()

@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation WXTimeLineSubTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViewsAndSetupLayout];
    }
    return self;
}

+ (CGFloat)height:(NSString *)text
{
    CGFloat height = 12;
    CGSize size = [self getStringRect:text ? : @"" WithWidth:(SCREEN_WIDTH-kWXTimeLineSubTableViewCommitBlankSpace) WithFont:12];
    height += size.height+1;
    return ceil(height);
}

- (void)initViewsAndSetupLayout {
    _commentLabel = [WXUIFactory buildLabelWithTextColor:[UIColor WX_SubmainContentTextColor]
                                                    font:[UIFont systemFontOfSize:12]
                                         backgroundColor:[UIColor clearColor]
                                           textAlignment:NSTextAlignmentLeft
                                           numberOfLines:0];
    [self.contentView addSubview:_commentLabel];
    
    [_commentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(kWXTimeLineSubTableViewCellLeftPadding);
        make.right.equalTo(self.contentView).offset(-kWXTimeLineSubTableViewCellLeftPadding);
    }];
}

- (void)refresh {
    _commentLabel.text = _commentText ? : @"";
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _commentLabel.text = @"";
}

+ (CGSize)getStringRect:(NSString*)aString WithWidth:(CGFloat) width WithFont:(CGFloat)font
{
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = [UIFont systemFontOfSize:font];
    CGSize size = [aString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:attrDict
                                        context:nil].size;
    
    return size;
}

@end
