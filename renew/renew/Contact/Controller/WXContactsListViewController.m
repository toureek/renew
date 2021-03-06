//
//  WXContactsListViewController.m
//  renew
//
//  Created by younghacker on 3/12/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXContactsListViewController.h"
#import "WXContactListHeaderView.h"
#import "WXContactModel.h"
#import <AddressBook/AddressBook.h>
#import "pinyin.h"


static CGFloat const kWXSearchBarHeight = 44.0f;
static CGFloat const kContentCommonPaddingSpace = 10.0f;
static CGFloat const kWXContactsListItemRowHeight = 50.0f;
static NSString *const kWXContactsListTableViewTag = @"kWXContactsListTableViewTag";

@interface WXContactsListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UITableViewController *searchResultController;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *contactListTableView;
@property (nonatomic, strong) NSMutableDictionary *dataDictionary;  // All-Contacts DataSource

@end

@implementation WXContactsListViewController {
    NSArray *_titleIndexList;
    NSArray *_searchResultList;
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
    
    [self setUpContactsListViewControllerStyle];
    [self setUpViews];
    [self authorizedToLoadContacts];
}

- (void)setUpContactsListViewControllerStyle {
    self.navigationItem.title = @"Contacts";
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.definesPresentationContext = YES;
}

- (void)setUpViews {
    [self setUpInitiationDataAndTableView];
    [self setUpSearchResultController];
    [self setUpSearchingStyleAndDelegations];
}

- (void)setUpInitiationDataAndTableView {
    _titleIndexList = [[NSArray alloc] init];
    _dataDictionary = [NSMutableDictionary dictionary];
    
    _contactListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _contactListTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _contactListTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_contactListTableView registerClass:[WXContactListHeaderView class]
      forHeaderFooterViewReuseIdentifier:kWXContactListHeaderViewTag];
    _contactListTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _contactListTableView.sectionIndexColor = [UIColor WX_MainContentTextColor];
    _contactListTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    if (@available(iOS 9.0, *)) {
        _contactListTableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [self.view addSubview:_contactListTableView];
}

- (void)setUpSearchResultController {
    _searchResultController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    _searchResultController.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _searchResultController.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _searchResultController.tableView.sectionIndexColor = [UIColor WX_ColorWithHexString:@"#555555"];
    _searchResultController.tableView.backgroundColor = [UIColor whiteColor];
    _searchResultController.automaticallyAdjustsScrollViewInsets = YES;
    _searchResultController.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 9.0, *)) {
        _searchResultController.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
}

- (void)setUpSearchingStyleAndDelegations {
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.backgroundColor = [UIColor WX_AppMainColor];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultController];
    _searchController.searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, kWXSearchBarHeight);
    _searchController.extendedLayoutIncludesOpaqueBars = YES;
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    _searchController.searchBar.translucent = YES;
    _searchController.searchBar.layer.borderWidth = CGFLOAT_MIN;
    _searchController.searchBar.tintColor = [UIColor blueColor];
    _searchController.searchBar.backgroundColor = [UIColor clearColor];
    _searchController.searchBar.searchBarStyle = UISearchBarStyleProminent;
    _searchController.searchBar.barStyle = UIBarStyleDefault;
    _searchController.searchBar.barTintColor = [UIColor WX_SeperatorLineColor];
    _searchController.searchBar.layer.borderWidth = 1;
    _searchController.searchBar.layer.borderColor = [[UIColor WX_SeperatorLineColor] CGColor];
    [_searchController.searchBar sizeToFit];

    _searchResultController.tableView.dataSource = _contactListTableView.dataSource = self;
    _searchResultController.tableView.delegate = _contactListTableView.delegate = self;
    
    _contactListTableView.tableHeaderView = _searchController.searchBar;
    _contactListTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    _contactListTableView.tableFooterView = [UIView new];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ([_contactListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_contactListTableView setSeparatorInset:UIEdgeInsetsMake(0, kContentCommonPaddingSpace, 0, 0)];
    }
    if ([_contactListTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_contactListTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)authorizedToLoadContacts {
    __weak WXContactsListViewController *weakSelf = self;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            CFErrorRef *error1 = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
            NSArray *dataSource = [WXContactModel loadAndSortAllContacts:addressBook];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf updateToLatestDataSourceList:dataSource];
            });
        });
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        CFErrorRef *error = NULL;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        NSArray *dataSource = [WXContactModel loadAndSortAllContacts:addressBook];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateToLatestDataSourceList:dataSource];
        });
    } else {
        NSLog(@"暂无数据，请查看APP访问您的通讯录权限后重试");
    }
}

- (void)updateToLatestDataSourceList:(NSArray *)array {
    if (!array || array.count != 2) {  // it is not a magic-number.
        return;
    }
    
    _titleIndexList = [array firstObject];
    _dataDictionary = [array lastObject];
    if (_titleIndexList.count > 0) {
        [_contactListTableView reloadData];
    } else {
        NSLog(@"暂无通讯录联系人");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView == _searchResultController.tableView ? 1 : _titleIndexList.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _searchResultController.tableView == tableView ? [NSArray new] : _titleIndexList;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _searchResultController.tableView) {
        return _searchResultList.count;
    }
    
    NSString *key = [_titleIndexList objectAtIndex:section];
    NSArray *dataList = [_dataDictionary objectForKey:key];
    return dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWXContactsListTableViewTag];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:kWXContactsListTableViewTag];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == _searchResultController.tableView) {
        WXContactModel *contact = [_searchResultList objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:kPlaceholderImageName];
        cell.textLabel.text = contact.name ? : @"";
    } else {
        if (_titleIndexList.count > 0) {
            NSString *key = [_titleIndexList objectAtIndex:indexPath.section];
            NSArray *dataList = [_dataDictionary objectForKey:key];
            WXContactModel *contact = [dataList objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:kPlaceholderImageName];
            cell.textLabel.text = contact.name ? : @"";
        } else {
            cell.imageView.image = nil;
            cell.textLabel.text = @"";
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kWXContactsListItemRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _searchResultController.tableView) {
        return [UIView new];
    }
    
    WXContactListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kWXContactListHeaderViewTag];
    BOOL existData = (_titleIndexList && _titleIndexList.count > 0);
    headerView.indexTitle = existData ? _titleIndexList[section] : @"";
    [headerView refresh];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView == _searchResultController.tableView ? CGFLOAT_MIN : kWXContactListHeaderViewHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchResultList = [NSArray new];
    NSArray *allContactArray = [_dataDictionary allValues];
    _searchResultList = [WXContactModel filterSearchingResult:allContactArray matchKeywords:searchText];
    [_searchResultController.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (@available(iOS 10.0, *)) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (@available(iOS 10.0, *)) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _searchController.searchBar.isFirstResponder ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSLog(@"Searching:%@ ",searchController.searchBar.text);
}

@end
