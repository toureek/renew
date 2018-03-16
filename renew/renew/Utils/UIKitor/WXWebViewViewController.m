//
//  WXWebViewViewController.m
//  renew
//
//  Created by younghacker on 3/16/18.
//  Copyright © 2018 toureek. All rights reserved.
//

#import "WXWebViewViewController.h"

#import <WebKit/WebKit.h>
#import <Masonry.h>


static CGFloat const kActivityIndicatorSize = 50.0f;

@interface WXWebViewViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;  // using UIWebView under iOS8
@property (nonatomic, strong) WKWebView *webViewer;  // using WKWebView
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation WXWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _webViewTitle ? : @"";
    [self setUpWebViewsAndActivityView];
    [self.view setNeedsUpdateConstraints];
    [self loadWebView];
}

- (void)setUpWebViewsAndActivityView {
    if (@available(iOS 8.0, *)) {
        _webViewer = [[WKWebView alloc] init];
        _webViewer.backgroundColor = self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webViewer];
    } else {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = self.view.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
    }

    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityView];
}

- (void)updateViewConstraints {
    if (@available(iOS 8.0, *)) {
        [_webViewer mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    } else {
        [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kActivityIndicatorSize, kActivityIndicatorSize));
        make.bottom.equalTo(self.view.mas_centerY).offset(-(kActivityIndicatorSize));
    }];
    
    [super updateViewConstraints];
}

- (void)loadWebView {
    NSString *finalURL = [self httpRequestURLValidator:_url];
    NSString *URL = [finalURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    if (@available(iOS 8.0, *)) {
        [_webViewer loadRequest:request];
    } else {
        [_webView loadRequest:request];
    }
}

- (NSString *)httpRequestURLValidator:(NSString *)strURL {
    if ([strURL length] > 0) {
        if ([strURL containsString:@"http"] || [strURL containsString:@"HTTP"]) {
            return strURL;
        }
        return [NSString stringWithFormat:@"http://%@", strURL];
    }
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _activityView.hidden = NO;
    [_activityView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityView stopAnimating];
    _activityView.hidesWhenStopped = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_activityView stopAnimating];
    _activityView.hidesWhenStopped = YES;
    return;
}

@end

