//
//  WXDiscoverViewController.m
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXDiscoverViewController.h"
#import "WXTimeLineViewController.h"

#import <Masonry/Masonry.h>


static NSString *const kWXDiscoverTableViewTag = @"kWXDiscoverTableViewTag";
static CGFloat const kWXDiscoverTableViewRowHeight = 45.0f;
static CGFloat const kWXDiscoverAvatorSize = 32.0f;
static CGFloat const kWXDiscoverThinPaddingSpace = 10.0f;
static CGFloat const kWXDiscoverHeaderViewHeight = 15.0f;
static CGFloat const kWXDiscoverBadgeViewSize = 8.0f;

@interface WXDiscoverViewController () <UITableViewDataSource, UITableViewDelegate, WXTimeLineViewControllerDelegate>

@property (nonatomic, strong) WXTimeLineViewController *timelineViewController;
@property (nonatomic, strong) NSMutableArray *stackViewControllerList;
@property (nonatomic, strong) UITableView *discoverTableView;
@property (nonatomic, strong) UIImageView *avatorImageView;
@property (nonatomic, strong) UIView *badgeView;

@end

@implementation WXDiscoverViewController {
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
    
    self.navigationItem.title = @"Discover";
    [self initFakeDataAndSetUpView];
}

- (void)initFakeDataAndSetUpView {
    _dataList = @[@[@[kPlaceholderImageName], @[kPlaceholderImageName], @[kPlaceholderImageName], @[kPlaceholderImageName]],
                  @[@[@"Moments"], @[@"Scan QR Code"], @[@"Games"], @[@"Mini Program"]]];
    _stackViewControllerList = [NSMutableArray arrayWithCapacity:1];
    
    _discoverTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _discoverTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _discoverTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _discoverTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _discoverTableView.dataSource = self;
    _discoverTableView.delegate = self;
    if (@available(iOS 9.0, *)) {
        _discoverTableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self.view addSubview:_discoverTableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ([_discoverTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_discoverTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_discoverTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_discoverTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _discoverTableView.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ((NSArray *)[_dataList firstObject]).count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)[_dataList firstObject][section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWXDiscoverTableViewTag];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:kWXDiscoverTableViewTag];
    }
    cell.textLabel.text = ((NSArray *)[_dataList lastObject])[indexPath.section][indexPath.row];
    NSString *iconName = ((NSArray *)[_dataList firstObject])[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:iconName ? : @""];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (!_avatorImageView) {
            _avatorImageView = [[UIImageView alloc] init];
            _avatorImageView.image = [UIImage imageNamed:kPlaceholderImageName];
            [cell.contentView addSubview:_avatorImageView];
            
            [_avatorImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(kWXDiscoverAvatorSize, kWXDiscoverAvatorSize));
                make.right.equalTo(cell.contentView).offset(-kWXDiscoverThinPaddingSpace/2.0);
            }];
        }
        
        if (!_badgeView) {
            _badgeView = [[UIView alloc] init];
            _badgeView.backgroundColor = [UIColor redColor];
            _badgeView.layer.masksToBounds = YES;
            _badgeView.layer.cornerRadius = kWXDiscoverBadgeViewSize/2;
            [cell.contentView addSubview:_badgeView];
            
            [_badgeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kWXDiscoverBadgeViewSize, kWXDiscoverBadgeViewSize));
                make.centerY.equalTo(_avatorImageView.mas_top);
                make.centerX.equalTo(_avatorImageView.mas_right);
            }];
        }
        [cell.contentView bringSubviewToFront:_badgeView];
    } else {
        // do nothing...
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWXDiscoverTableViewRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? kWXDiscoverThinPaddingSpace : kWXDiscoverHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (!_timelineViewController) {
            _discoverTableView.userInteractionEnabled = NO;
            _timelineViewController = [[WXTimeLineViewController alloc] init];
            _timelineViewController.delegate = self;
            [self.navigationController pushViewController:_timelineViewController animated:YES];
        } else if (_stackViewControllerList.count == 1) {
            _discoverTableView.userInteractionEnabled = NO;
            [self.navigationController pushViewController:[_stackViewControllerList firstObject] animated:YES];
        } else {
            // do nothing...
        }
    }
}

#pragma mark - WXTimeLineViewControllerDelegate

- (void)triggerToResponseAfterLeaveTimeLineViewController:(BaseViewController *)vc {
    if (vc && [vc isKindOfClass:[WXTimeLineViewController class]]) {
        [_stackViewControllerList removeAllObjects];
        [_stackViewControllerList addObject:vc];
    }
}

@end

