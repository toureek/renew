//
//  WXChatList.m
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXChatListViewController.h"


@implementation WXChatListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Wechat";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
