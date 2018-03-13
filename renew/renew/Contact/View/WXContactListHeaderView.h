//
//  WXContactListHeaderView.h
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kWXContactListHeaderViewTag;
extern CGFloat const kWXContactListHeaderViewHeight;

@interface WXContactListHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *indexTitle;

- (void)refresh;

@end
