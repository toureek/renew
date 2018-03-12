//
//  WXMainFrameViewController.h
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WXMainFrameViewController : UITabBarController

@property (nonatomic, strong) UINavigationController *chatNavigation;
@property (nonatomic, strong) UINavigationController *contactNavigation;
@property (nonatomic, strong) UINavigationController *discoverNavigation;
@property (nonatomic, strong) UINavigationController *meNavigation;

@property (nonatomic, strong) NSArray *tabBarNavigationList;

@end
