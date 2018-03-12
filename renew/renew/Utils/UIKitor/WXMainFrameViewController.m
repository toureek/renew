//
//  WXMainFrameViewController.m
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXMainFrameViewController.h"
#import "WXChatListViewController.h"
#import "WXContactsListViewController.h"
#import "WXDiscoverViewController.h"
#import "WXMeViewController.h"


NSString *const kTabBarImageIndex0 = @"main_tab_index0";
NSString *const kTabBarTitleIndex0 = @"Chats";
NSString *const kTabBarImageIndex1 = @"main_tab_index1";
NSString *const kTabBarTitleIndex1 = @"Contacts";
NSString *const kTabBarImageIndex2 = @"main_tab_index2";
NSString *const kTabBarTitleIndex2 = @"Discover";
NSString *const kTabBarImageIndex3 = @"main_tab_index3";
NSString *const kTabBarTitleIndex3 = @"Me";
NSString *const kTabBarItemSelectedImageSuffix = @"%@_select";
NSUInteger const kTotalTabBarCount = 4;

@interface WXMainFrameViewController ()

@end

@implementation WXMainFrameViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUITabBarContentViews];
}

- (void)setUpUITabBarContentViews {
    NSArray *tabBarItemImagesList = @[kTabBarImageIndex0, kTabBarImageIndex1, kTabBarImageIndex2, kTabBarImageIndex3];
    NSArray *tabBarItemTitleList = @[kTabBarTitleIndex0, kTabBarTitleIndex1, kTabBarTitleIndex2, kTabBarTitleIndex3];
    NSMutableArray *contentPages = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < kTotalTabBarCount; index ++) {
        [contentPages addObject:[self createAndSetUpTabBarNavigationController:tabBarItemImagesList[index]
                                                                         title:tabBarItemTitleList[index]
                                                                       atIndex:index]];
    }
    _tabBarNavigationList = [contentPages copy];
    [self setViewControllers:_tabBarNavigationList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UINavigationController *)createAndSetUpTabBarNavigationController:(NSString *)imageName
                                                               title:(NSString *)title
                                                             atIndex:(NSUInteger)index {
    BaseViewController *vc;
    if (index == 0) {
        vc = [[WXChatListViewController alloc] init];
    }
    else if (index == 1) {
        vc = [[WXContactsListViewController alloc] init];
    }
    else if (index == 2) {
        vc = [[WXDiscoverViewController alloc] init];
    }
    else if (index == 3) {
        vc = [[WXMeViewController alloc] init];
    }
    
    UIImage *iconImage = [UIImage imageNamed:imageName];
    UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:kTabBarItemSelectedImageSuffix, imageName]];
    
    UIImage *img = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImg = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabItem = [[UITabBarItem alloc] initWithTitle:title
                                                          image:img
                                                  selectedImage:selectedImg];
    
    UIColor *foregroundColor = [UIColor greenColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:foregroundColor, NSForegroundColorAttributeName, nil];
    [tabItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.tabBarItem = tabItem;
    
    return navigationController;
}

@end


