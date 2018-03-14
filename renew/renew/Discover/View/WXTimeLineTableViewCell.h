//
//  WXTimeLineTableViewCell.h
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"


extern NSString *const kWXTimeLineTableViewCellTag;

@protocol WXTimeLineTableViewCellDelegate <NSObject>

@optional
- (void)triggerToResponseAfterContentTapped:(BOOL)isExtend atIndex:(NSInteger)index;
- (void)triggerToResponseAfterCommentButtonClickedAtIndex:(NSInteger)index;
- (void)triggerToResponseAfterPictureTappedAtIndexItem:(NSInteger)indexA atIndexImg:(NSInteger)indexB;

@end

@class WXUserModel;
@class WXTweetModel;

@interface WXTimeLineTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate,
UITableViewDataSource, UITableViewDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, weak) id<WXTimeLineTableViewCellDelegate> delegate;
@property (nonatomic, strong) WXTweetModel *tweetModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)refresh;
+ (CGFloat)height:(WXTweetModel *)tweet;

@end
