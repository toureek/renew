//
//  WXTimeLineTableViewCell.m
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXTimeLineTableViewCell.h"
#import "WXTimeLineSubTableViewCell.h"
#import "WXTimeLineSubCollectionViewCell.h"
#import "WXCommentModel.h"
#import "WXImageModel.h"
#import "WXTweetModel.h"
#import "WXUserModel.h"
#import "WXUIFactory.h"

#import <UIImageView+WebCache.h>
#import <Masonry.h>


NSString *const kWXTimeLineTableViewCellTag = @"kWXTimeLineTableViewCellTag";
static NSString *const kWXTimeLineCellCollectionViewTag = @"kWXTimeLineCellCollectionViewTag";
static CGFloat const kImageAvatorSize = 45.0f;
static CGFloat const kUserNameFontHeight = 17.0f;
static CGFloat const kLeftRightPadding = 10.0f;
static CGFloat const kGoldenScalePoint = 0.618;
static CGFloat const kWithoutContentTextWidth = 10+45+10+10.0f;
static CGFloat const kSubViewCenterYOffsetPadding = 3.0f;
static CGFloat const kWXTimeLineViewCellTopPadding = 15.0f;

@interface WXTimeLineTableViewCell ()

@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UICollectionView *pictureCollectionView;
@property (nonatomic, strong) UILabel *dateTimeLabel;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) UILabel *splitorLineLabel;

@end

@implementation WXTimeLineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initAndSetupViews];
    }
    return self;
}

+ (CGFloat)height:(WXTweetModel *)tweet
{
    CGFloat height = 0;
    height += kWXTimeLineViewCellTopPadding;
    if ([tweet existContentText]) {
        CGSize size = [WXTimeLineTableViewCell getStringRect:tweet.content ? : @""
                                                   WithWidth:SCREEN_WIDTH-kWithoutContentTextWidth
                                                    WithFont:16];
        CGFloat calculateContentHeight = ceil(size.height+1);
        if (calculateContentHeight < (kImageAvatorSize-kUserNameFontHeight)) {
            height += kImageAvatorSize;
        } else {
            height += kImageAvatorSize/2.0;
            height += kSubViewCenterYOffsetPadding;
            height += ceil(calculateContentHeight);
        }
        height += [self heightForTweets:tweet];
    } else {
        height += [self heightForTweets:tweet];
    }
    
    return ceil(height);
}

+ (CGFloat)heightForTweets:(WXTweetModel *)tweet
{
    CGFloat height = 0;
    height += [self calculateForTweetsImageHeight:tweet];
    
    height += kLeftRightPadding;
    height += 11;  // FontSize is 10 with the borderHeight, LabelHeight will be 11 in calculating.
    height += 2;
    
    height += [self calculateForCommentsHeight:tweet];
    height += [self calculateTweetStyleHeight:tweet];
    
    return ceil(height);
}

+ (CGFloat)calculateForTweetsImageHeight:(WXTweetModel *)tweet
{
    CGFloat height = 0;
    CGFloat collectionViewWidth = ceil(floor(SCREEN_WIDTH-10-45-10-15-6)/3)*3+6;
    if ([tweet existPictures] && (tweet.imagesList.count == kOneLineMinImageCountsInTweetsPictures)) {
        height += kLeftRightPadding;
        height += collectionViewWidth*kGoldenScalePoint;
    } else if ([tweet existPictures] && (tweet.imagesList.count < kTwoLineMinImageCountsInTweetsPictures)) {
        height += kLeftRightPadding;
        height += collectionViewWidth/3.0+2;  // iamge with one-line height
    } else if ([tweet existPictures] && (tweet.imagesList.count < kThreeLineMinImageCountsInTweetsPictures)) {
        height += kLeftRightPadding;
        height += collectionViewWidth/3.0*2+4;  // iamge with two-line height
    } else if ([tweet existPictures] && (tweet.imagesList.count < kFourLineMinImageCountsInTweetsPictures)) {
        height += kLeftRightPadding;
        height += collectionViewWidth/3.0*3+6;  // iamge with three-line height
    } else {
        height += kImageAvatorSize/2.0;  // no-image-height
        height += kSubViewCenterYOffsetPadding;
    }
    
    return ceil(height);
}

+ (CGFloat)calculateForCommentsHeight:(WXTweetModel *)tweet
{
    CGFloat height = 0;
    if (tweet.commentsList.count > 0) {
        for (WXCommentModel *item in tweet.commentsList) {
            height += ceil([WXTimeLineSubTableViewCell height:[item commentContent]]);
            height += 2;
        }
        height += 10;
    } else {
        height += CGFLOAT_MIN;
        height += 1.5;
    }
    return ceil(height);
}

+ (CGFloat)calculateTweetStyleHeight:(WXTweetModel *)tweet
{
    CGFloat height = 0;
    if (tweet.tweetType == WXTweetTypePictureOnly) {
        height += 20;  // CollectionViewImage TopPadding
    } else if (tweet.tweetType == WXTweetTypeContentOnly) {
        height -= 15;  // No CollectionViewImage Height
    } else if (tweet.tweetType == WXTweetTypeContentPictureType) {
        height += 5;  // Within Padding on WXTweetTypeContentPictureType
    } else if (tweet.tweetType == WXTweetTypeContentCommentsType || (tweet.tweetType == WXTweetTypePictureCommentsType)) {
        height += kSubViewCenterYOffsetPadding;
    } else if (tweet.tweetType == WXTweetTypeContentPictureCommentsType) {
        height += 10;
    }
    
    return ceil(height);
}

- (void)initAndSetupViews {
    [self setUpAvatorImageView];
    [self setUpUsenameLabel];
    [self setUpContentLabel];
    [self setUpCollectionView];
    [self setUpDateTimeLabel];
    [self setUpCommentButton];
    [self setUpCommentTableView];
    [self setUpSplitorLineLabel];
}

- (void)setUpAvatorImageView {
    _avatorImageView = [[UIImageView alloc] init];
    _avatorImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_avatorImageView];
}

- (void)setUpUsenameLabel {
    _userNameLabel = [WXUIFactory buildLabelWithTextColor:[UIColor blueColor]
                                                     font:[UIFont systemFontOfSize:16]];
    _userNameLabel.numberOfLines = 1;
    [self.contentView addSubview:_userNameLabel];
}

- (void)setUpContentLabel {
    _contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    _contentLabel.font = [UIFont systemFontOfSize:16];
    _contentLabel.textColor = [UIColor WX_MainContentTextColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink | NSTextCheckingTypePhoneNumber;
    _contentLabel.delegate = self;
    _contentLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_contentLabel];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = layout.minimumInteritemSpacing = 1.5;
    _pictureCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _pictureCollectionView.layer.borderColor = [UIColor clearColor].CGColor;
    _pictureCollectionView.backgroundColor = [UIColor clearColor];
    _pictureCollectionView.layer.borderWidth = CGFLOAT_MIN;
    _pictureCollectionView.alwaysBounceVertical = YES;
    _pictureCollectionView.scrollEnabled = NO;
    _pictureCollectionView.dataSource = self;
    _pictureCollectionView.delegate = self;
    [_pictureCollectionView registerClass:[WXTimeLineSubCollectionViewCell class]
               forCellWithReuseIdentifier:kWXTimeLineSubCollectionViewTag];
    [self.contentView addSubview:_pictureCollectionView];
}

- (void)setUpDateTimeLabel {
    _dateTimeLabel = [WXUIFactory buildLabelWithTextColor:[UIColor WX_SubmainContentTextColor]
                                                     font:[UIFont systemFontOfSize:10]];
    _dateTimeLabel.numberOfLines = 1;
    [self.contentView addSubview:_dateTimeLabel];
}

- (void)setUpCommentButton {
    _commentButton = [WXUIFactory buildButtonWithTitle:@""
                                       backgroundImage:kPlaceholderImageName
                                                  font:[UIFont systemFontOfSize:10]
                                                target:self
                                                action:@selector(didCommentButtonClicked:)];
    [self.contentView addSubview:_commentButton];
}

- (void)setUpCommentTableView {
    _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _commentTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _commentTableView.scrollEnabled = NO;
    _commentTableView.dataSource = self;
    _commentTableView.delegate = self;
    [_commentTableView registerClass:[WXTimeLineSubTableViewCell class]
              forCellReuseIdentifier:kWXTimeLineSubTableTag];
    if (@available(iOS 9.0, *)) {
        _commentTableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self.contentView addSubview:_commentTableView];
}

- (void)setUpSplitorLineLabel {
    _splitorLineLabel = [[UILabel alloc] init];
    _splitorLineLabel.backgroundColor = [UIColor WX_SeperatorLineColor];
    [self.contentView addSubview:_splitorLineLabel];
}

- (void)refresh {
    if (_tweetModel) {
        [_avatorImageView sd_setImageWithURL:[NSURL URLWithString:[_tweetModel.sender userItemAvatarImagePath]]
                            placeholderImage:[UIImage imageNamed:kPlaceholderImageName]];
        _userNameLabel.text = [_tweetModel.sender userItemName];
        _contentLabel.text = _tweetModel.content ? : @"";
        _dateTimeLabel.text = @"Jan 1st";
        [_pictureCollectionView reloadData];
        [_commentTableView reloadData];
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self addAvatorImageViewLayout];
    [self addUserNameLabelLayout];
    [self addContentLabelLayout];
    [self addPictureCollectionViewLayout];
    [self addDateTimeLabelLayout];
    [self addCommentTableViewLayout];
    [self addSplitorLineLabelLayout];
    
    [super updateConstraints];
}

- (void)addAvatorImageViewLayout {
    [_avatorImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(kLeftRightPadding);
        make.top.equalTo(self.contentView).offset(kWXTimeLineViewCellTopPadding);
        make.size.mas_equalTo(CGSizeMake(kImageAvatorSize, kImageAvatorSize));
    }];
}

- (void)addUserNameLabelLayout {
    [_userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatorImageView);
        make.height.equalTo(@(kUserNameFontHeight));
        make.left.equalTo(_avatorImageView.mas_right).offset(kLeftRightPadding);
        make.right.lessThanOrEqualTo(self.contentView).offset(-kLeftRightPadding);
    }];
}

- (void)addContentLabelLayout {
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if ([_tweetModel existContentText]) {  // Exist Content
            _contentLabel.hidden = NO;
            CGSize size = [WXTimeLineTableViewCell getStringRect:_tweetModel.content ? : @""
                                                       WithWidth:SCREEN_WIDTH-kWithoutContentTextWidth
                                                        WithFont:16];
            CGFloat calculateContentHeight = ceil(size.height+1);
            if (calculateContentHeight < (kImageAvatorSize-kUserNameFontHeight)) {  // 像微信一样，比对一行文本的高度，文本永远对齐参照View
                make.bottom.equalTo(_avatorImageView.mas_bottom);
                make.height.equalTo(@(calculateContentHeight));
            } else {
                make.top.equalTo(_avatorImageView.mas_centerY).offset(kSubViewCenterYOffsetPadding);
                make.height.equalTo(@(calculateContentHeight));
            }
            make.left.equalTo(_userNameLabel);
            make.right.equalTo(self.contentView).offset(-kLeftRightPadding);
        } else {
            _contentLabel.hidden = YES;
        }
    }];
}

- (void)addPictureCollectionViewLayout {
    // Magic Numbers:
    [_pictureCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if ([_tweetModel existPictures] && _tweetModel.imagesList.count > 0) {
            _pictureCollectionView.hidden = NO;
            make.left.equalTo(_userNameLabel);
            if ([_tweetModel existContentText]) {  // Exist Content
                make.top.equalTo(_contentLabel.mas_bottom).offset(kLeftRightPadding);
            } else {
                make.top.equalTo(_avatorImageView.mas_centerY).offset(kSubViewCenterYOffsetPadding);
            }
            
            CGFloat collectionViewWidth = ceil(floor(SCREEN_WIDTH-10-45-10-15-6)/3)*3+6;
            if (_tweetModel.imagesList.count == kOneLineMinImageCountsInTweetsPictures) {
                make.size.mas_offset(CGSizeMake(collectionViewWidth, collectionViewWidth*kGoldenScalePoint));
            } else if (_tweetModel.imagesList.count < kTwoLineMinImageCountsInTweetsPictures) {
                make.size.mas_offset(CGSizeMake(ceil(collectionViewWidth), collectionViewWidth/3.0+2));
            } else if (_tweetModel.imagesList.count < kThreeLineMinImageCountsInTweetsPictures) {
                make.size.mas_offset(CGSizeMake(ceil(collectionViewWidth), collectionViewWidth/3.0*2+4));
            } else if (_tweetModel.imagesList.count < kFourLineMinImageCountsInTweetsPictures) {
                make.size.mas_offset(CGSizeMake(ceil(collectionViewWidth), collectionViewWidth/3.0*3+6));
            }
        } else {
            _pictureCollectionView.hidden = YES;
        }
    }];
}

- (void)addDateTimeLabelLayout {
    [_dateTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (([_tweetModel existContentText] && [_tweetModel existPictures]) || [_tweetModel existPictures]) {
            make.top.equalTo(_pictureCollectionView.mas_bottom).offset(kLeftRightPadding);
        } else if ([_tweetModel existContentText]) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(kLeftRightPadding);
        }
        make.right.equalTo(self.contentView.mas_centerX);
        make.left.equalTo(_userNameLabel);
        make.height.equalTo(@11);
    }];
}

- (void)commentButtonLayout {
    [_commentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-kLeftRightPadding);
        make.centerY.equalTo(_dateTimeLabel);
        make.height.equalTo(@11);
        make.size.mas_equalTo(CGSizeMake(11, 11));
    }];
}

- (void)addCommentTableViewLayout {
    [_commentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (_tweetModel.commentsList.count > 0) {
            _commentTableView.hidden = NO;
            CGFloat height = 0;
            for (WXCommentModel *item in _tweetModel.commentsList) {
                height += ceil([WXTimeLineSubTableViewCell height:[item commentContent]]);
                height += 2;
            }
            make.top.equalTo(_dateTimeLabel.mas_bottom).offset(kLeftRightPadding);
            make.right.equalTo(self.contentView).offset(-kLeftRightPadding);
            make.left.equalTo(_userNameLabel);
            make.height.equalTo(@(height));
        } else {
            _commentTableView.hidden = YES;
        }
    }];
}

- (void)addSplitorLineLabelLayout {
    [_splitorLineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tweetModel.imagesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WXTimeLineSubCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWXTimeLineSubCollectionViewTag forIndexPath:indexPath];
    WXImageModel *item = _tweetModel.imagesList[indexPath.row];
    cell.imgURL = item.url ? : @"";
    [cell refresh];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return _tweetModel.imagesList.count > 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterPictureTappedAtIndexItem:atIndexImg:)]) {
        [_delegate triggerToResponseAfterPictureTappedAtIndexItem:_indexPath.row atIndexImg:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
layout:(UICollectionViewLayout*)collectionViewLayout
sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_tweetModel.imagesList.count == 1) {
        return CGSizeMake(SCREEN_WIDTH-10-45-10-15-5, ceil((SCREEN_WIDTH-10-45-10-15-5)*kGoldenScalePoint));
    }
    
    CGFloat collectionViewWidth = ceil(floor(SCREEN_WIDTH-10-45-10-15-6)/3)*3;
    return CGSizeMake(floor(collectionViewWidth/3.0), ceil(collectionViewWidth/3));
}

- (CGSize)collectionView:(UICollectionView *)collectionView
layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake((SCREEN_WIDTH-10-45-10-15-5), CGFLOAT_MIN);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake((SCREEN_WIDTH-10-45-10-15-5), CGFLOAT_MIN);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tweetModel.commentsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXTimeLineSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWXTimeLineSubTableTag];
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WXCommentModel *item = _tweetModel.commentsList[indexPath.row];
    cell.commentText = [item commentContent];
    [cell refresh];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXCommentModel *item = _tweetModel.commentsList[indexPath.row];
    return [WXTimeLineSubTableViewCell height:[item commentContent]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Button SEL

- (void)didCommentButtonClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterCommentButtonClickedAtIndex:)]) {
        [_delegate triggerToResponseAfterCommentButtonClickedAtIndex:_indexPath.row];
    }
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

