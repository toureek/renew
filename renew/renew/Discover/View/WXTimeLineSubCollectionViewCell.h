//
//  WXTimeLineSubCollectionViewCell.h
//  renew
//
//  Created by younghacker on 3/14/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kWXTimeLineSubCollectionViewTag;

@interface WXTimeLineSubCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imgURL;

- (void)refresh;

@end
