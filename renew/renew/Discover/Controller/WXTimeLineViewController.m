//
//  WXTimeLineViewController.m
//  renew
//
//  Created by younghacker on 3/13/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXTimeLineViewController.h"
#import "WXEngine.h"
#import "WXUserModel.h"
#import "WXImageModel.h"
#import "WXTweetModel.h"
#import "WXTimeLineTableViewCell.h"
#import "WXTimeLineHeaderTableViewHeader.h"
#import "WXTimeLineSubCollectionViewCell.h"
#import "WXPagingArray.h"
#import "WXMeViewController.h"
#import "WXWebViewViewController.h"

#import <MWPhoto.h>
#import <MWPhotoBrowser.h>
#import <MJRefresh.h>
#import <Masonry.h>
#import <SVProgressHUD.h>


@interface WXTimeLineViewController () <UITableViewDataSource, UITableViewDelegate, WXTimeLineTableViewCellDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *tweetList;
@property (nonatomic, strong) WXUserModel *userModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WXPagingArray *dataList;
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation WXTimeLineViewController {
    WXEngine *_networkingEngine;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Timeline";
    _photos = [NSMutableArray arrayWithCapacity:4];
    [self registerNotificationObservers];
    [self setUpTableViewAndLayout];
    [self invokeNetworkingRequest];
}

- (void)registerNotificationObservers {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    for (NSString *notificationName in @[WXNFetchUserInfo, WXNFetchMyTweetsList]) {
        [nc addObserver:self
               selector:@selector(didNetworkingResponseForObserverReceived:)
                   name:notificationName
                 object:nil];
    }
}

- (void)setUpTableViewAndLayout {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[WXTimeLineHeaderTableViewHeader class]
forHeaderFooterViewReuseIdentifier:kWXTimeLineHeaderTableViewHeaderTag];
    [_tableView registerClass:[WXTimeLineTableViewCell class]
       forCellReuseIdentifier:kWXTimeLineTableViewCellTag];
    [self addPullToRefreshAndInfinityScrollingToTableView];
    if (@available(iOS 9.0, *)) {
        _tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self.view addSubview:_tableView];
    
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)addPullToRefreshAndInfinityScrollingToTableView {
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                            refreshingAction:@selector(loadNewTweetsListWithPullToRefresh)];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                             refreshingAction:@selector(loadMoreTweetsListWithInfinityScrolling)];
    footer.stateLabel.textColor = [UIColor WX_SubmainContentTextColor];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    _tableView.mj_footer = footer;
}

- (void)invokeNetworkingRequest {
    _networkingEngine = [[WXEngine alloc] init];
    [_networkingEngine fetchUserInfoAndPostHandlingNotificationInfo];
    [_networkingEngine fetchAllFormatedTweetsAndPostHandlingNotificationInfo];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self.navigationController.viewControllers containsObject:self]) {
        if (_delegate && [_delegate respondsToSelector:@selector(triggerToResponseAfterLeaveTimeLineViewController:)]) {
            [_delegate triggerToResponseAfterLeaveTimeLineViewController:self];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Pull-To-Refresh && Infinity-Scrolling

- (void)loadNewTweetsListWithPullToRefresh {
    [_tableView.mj_header beginRefreshing];
    [_networkingEngine fetchAllFormatedTweetsAndPostHandlingNotificationInfo];
}

- (void)loadNewTweetsList {
    [self setUpFirstPagePagingDataSource];
    [self handleWithAnimationAfterPullToRefreshOrInfinityScrollingFinished];
}

- (void)loadMoreTweetsListWithInfinityScrolling {
    [_tableView.mj_footer beginRefreshing];
    [self setUpNonFirstPagePagingDataSource];
    [self handleWithAnimationAfterPullToRefreshOrInfinityScrollingFinished];
}

- (void)setUpFirstPagePagingDataSource {
    _dataList = [[WXPagingArray alloc] init];
    if (_tweetList && _tweetList.count > 0) {
        NSArray *firstFiveObjList = @[_tweetList[0], _tweetList[1], _tweetList[2], _tweetList[3], _tweetList[4]];
        [_dataList addObjectsFromArray:firstFiveObjList];
        _dataList.page = 1;
        _dataList.pageSize = 5;
        _dataList.totalSize = self.tweetList.count;
    }
}

- (void)setUpNonFirstPagePagingDataSource {
    NSInteger count = _dataList.count;
    for (NSInteger i=count; ((i<self.tweetList.count) && (i<count+5)); i++) {
        [_dataList addObject:self.tweetList[i]];
    }
    _dataList.page += 1;
    _dataList.pageSize = 5;
    _dataList.totalSize = self.tweetList.count;
}

- (void)handleWithAnimationAfterPullToRefreshOrInfinityScrollingFinished {
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    BOOL existMoreData = [_dataList hasMore];
    if (!existMoreData) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
    _tableView.mj_footer.hidden = !existMoreData;
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXTimeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWXTimeLineTableViewCellTag
                                                                    forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tweetModel = _dataList[indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    [cell refresh];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WXTweetModel *tweetModel = _dataList[indexPath.row];
    return [WXTimeLineTableViewCell height:tweetModel];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WXTimeLineHeaderTableViewHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kWXTimeLineHeaderTableViewHeaderTag];
    [headerView setUserItem:self.userModel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.dataList.count > 0 ? kWXTimeLineHeaderTableViewHeaderHeight : CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - WXTimeLineTableViewCellDelegate

- (void)triggerToResponseAfterPictureTappedAtIndexItem:(NSInteger)indexA atIndexImg:(NSInteger)indexB {
    if (self.dataList.count > 0) {
        WXTweetModel *tweetModel = self.dataList[indexA];
        [_photos removeAllObjects];
        for (WXImageModel *img in tweetModel.imagesList) {
            MWPhoto *photoItem = [MWPhoto photoWithURL:[NSURL URLWithString:img.url]];
            [_photos addObject:photoItem];
        }
        MWPhotoBrowser *browser = [WXTimeLineSubCollectionViewCell setUpPhotoBroswerObject];
        browser.displayActionButton = browser.enableDeleteMode = NO;
        browser.delegate = self;
        [self.navigationController pushViewController:browser animated:YES];
        
        double delayInSeconds = 0.15f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [browser setCurrentPhotoIndex:indexB];
        });
    }
}

- (void)triggerToResponseAfterContentURLLinkTapped:(NSURL *)url {
    if (self.dataList.count > 0) {
        WXWebViewViewController *webView = [[WXWebViewViewController alloc] init];
        webView.url = [url absoluteString];
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count) {
        return [_photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - Notification SEL

- (void)didNetworkingResponseForObserverReceived:(NSNotification *)notification {
    if ([notification.name isEqualToString:WXNFetchUserInfo] && notification.userInfo) {
        WXNotificationInfo *info = [notification.userInfo objectForKey:WXKFetchUserInfo];
        if ([info requestExecuteSuccessfully]) {
            self.userModel = info.userModel;
            WXTimeLineHeaderTableViewHeader *headerView = (WXTimeLineHeaderTableViewHeader *)[_tableView headerViewForSection:0];
            [headerView setUserItem:self.userModel];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:kDidFetchUserInfoNotificationReceived object:info.userModel];
        } else {
            [SVProgressHUD showErrorWithStatus:info.errorMsg];
        }
    } else if ([notification.name isEqualToString:WXNFetchMyTweetsList] && notification.userInfo) {
        WXNotificationInfo *info = [notification.userInfo objectForKey:WXKFetchMyTweetsList];
        if ([info requestExecuteSuccessfully]) {
            self.tweetList = info.tweetsList;
            [self loadNewTweetsList];
        } else {
            [_tableView.mj_header endRefreshing];
            [_tableView reloadData];
            [SVProgressHUD showErrorWithStatus:info.errorMsg];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
