//
//  WXMeViewController.m
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXMeViewController.h"
#import "WXMeHeaderTableViewCell.h"
#import "WXUserModel.h"


NSString *const kDidFetchUserInfoNotificationReceived = @"kDidFetchUserInfoNotificationReceived";
static CGFloat const kWXMeTableViewCellRowHeight = 45.0f;
static CGFloat const kWXMeNormalHeaderViewHeight = 10.0f;
static CGFloat const kWXMeLongHeaderViewHeight = 15.0f;
static NSString *const kWXMeTableViewTag = @"kWXMeTableViewTag";

@interface WXMeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) WXUserModel *userModel;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WXMeViewController {
    NSArray *_dataList;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Me";
    [self initTableViewAndSetupLayout];
    [self registerNetworkingRequestObserver];
}

- (void)initTableViewAndSetupLayout {
    _dataList = [WXUserModel meViewControllerDataSourceList];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[WXMeHeaderTableViewCell class]
       forCellReuseIdentifier:kWXMeHeaderTableViewCellTag];
    if (@available(iOS 9.0, *)) {
        _tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self.view addSubview:_tableView];
}

- (void)registerNetworkingRequestObserver {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(didFetchUserInfoNotificationReceived:)
               name:kDidFetchUserInfoNotificationReceived
             object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, kWXCommonLeftRightPaddingSpace, 0, 0)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notification SEL

- (void)didFetchUserInfoNotificationReceived:(NSNotification *)notification {
    if (!notification.object) {
        return;
    }
    
    self.userModel = (WXUserModel *)notification.object;
    [_tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ((NSArray *)[_dataList firstObject]).count;  // FakeDataSource
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[_dataList firstObject][section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WXMeHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWXMeHeaderTableViewCellTag
                                                                        forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUserModel:self.userModel];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWXMeTableViewTag];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:kWXMeTableViewTag];
        }
        cell.textLabel.text = ((NSArray *)[_dataList firstObject])[indexPath.section][indexPath.row];
        NSString *iconName = ((NSArray *)_dataList[1])[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:iconName ? : @""];
        cell.detailTextLabel.text = ((NSArray *)[_dataList lastObject])[indexPath.section][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? kWXMeHeaderTableViewCellHeight : kWXMeTableViewCellRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kWXMeNormalHeaderViewHeight;
    }
    return section == 1 ? CGFLOAT_MIN : kWXMeLongHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
