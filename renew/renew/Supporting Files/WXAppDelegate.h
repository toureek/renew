//
//  AppDelegate.h
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WXMainFrameViewController;

@interface WXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) WXMainFrameViewController *mainPage;

- (void)showMainPage;

@end

