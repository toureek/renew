//
//  WXTimeLineViewController.h
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "BaseViewController.h"


@protocol WXTimeLineViewControllerDelegate <NSObject>

@optional
- (void)triggerToResponseAfterLeaveTimeLineViewController:(BaseViewController *)vc;

@end

@interface WXTimeLineViewController : BaseViewController

@property (nonatomic, weak) id<WXTimeLineViewControllerDelegate> delegate;

@end
