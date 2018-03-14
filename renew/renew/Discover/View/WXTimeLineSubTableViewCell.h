//
//  WXTimeLineSubTableViewCell.h
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kWXTimeLineSubTableTag;

@interface WXTimeLineSubTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *commentText;

- (void)refresh;
+ (CGFloat)height:(NSString *)text;

@end
