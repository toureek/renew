//
//  AppDelegate.m
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXAppDelegate.h"
#import "WXMainFrameViewController.h"

#import <SDWebImageManager.h>
#import <JPFPSStatus.h>


CGFloat const kUINavigationLeftItemBackSpace = 64;

@interface WXAppDelegate ()

@end

@implementation WXAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUpApplicationGUI];
    [self showMainPage];
    [self cleanImageCache];
    
    [self setUpFPSTool];
    
    return YES;
}

- (void)setUpApplicationGUI {
    [self renderingUIWindows];
    [self customUIStatusBarStyle];
    [self customUINavigationBarStyle];
}

- (void)renderingUIWindows {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
}

- (void)customUIStatusBarStyle {
    if ([self isTheOldestSupportedOperationSystem]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }  // UIViewController will handle with StatusBarStyle itself when iOS9+.
}

- (BOOL)isTheOldestSupportedOperationSystem {
    return [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0;
}

- (void)setUpFPSTool {
#if defined(DEBUG)||defined(_DEBUG)
    [[JPFPSStatus sharedInstance] open];
#endif
}

- (void)customUINavigationBarStyle {
    NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:18],
                                 NSForegroundColorAttributeName : [UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor WX_AppMainColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    if (@available(iOS 11, *)) {
        // do nothing... UIModernBarButton changes in iOS11
    } else {
        [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -kUINavigationLeftItemBackSpace)
                                                           forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)showMainPage {
    _mainPage = [[WXMainFrameViewController alloc] init];
    _mainPage.view.backgroundColor = [UIColor WX_SeperatorLineColor];
    self.window.rootViewController = _mainPage;
    [self.window makeKeyAndVisible];
}

- (void)cleanImageCache {
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDWebImageManager sharedManager] cancelAll];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [self cleanImageCache];
}

@end

