//
//  BrowserViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-8.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()
{
    UIView *_toolbar;
    UITextField *_locationField;
    UIWebView *_webView;
    UIButton *_reloadButton;
    UIButton *_stopButton;
    UIButton *_popButton;
    
    int _loadIndicatorCount;
    UIActivityIndicatorView *_loadingView;
    
    UIView *_bottomView;
    UIButton *_rightButton, *_leftButton;
    CGFloat initialContentOffset;
    CGFloat previousContentDelta;
}

@end

@implementation BrowserViewController

- (id)initWithURL:(NSString *)url {
    if (self = [super init]) {
        self.url = url;
        self.view.autoresizesSubviews = YES;
    }
    
    return self;
}

- (void)dealloc {
    _webView.delegate = nil;
    [_webView stopLoading];
    _webView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        [self.view addSubview:_webView];
        _webView.scrollView.delegate = self;
        [_webView setGestureRecognizers:[NSMutableArray array]];        
        
        if (_url) {
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
        }
    }
    
    [super addRightGes:_webView];

    if (!_toolbar) {
        _toolbar = [[UIView alloc] init];
        [self.view addSubview:_toolbar];
        _toolbar.backgroundColor = [UIColor blackColor];
        _toolbar.alpha = 0.8;
        _toolbar.userInteractionEnabled = YES;
    }    
        
    if (!_locationField) {
        _locationField = [[UITextField alloc] init];
        _locationField.borderStyle = UITextBorderStyleNone;
        _locationField.layer.borderColor = [[UIColor grayColor] CGColor];
        _locationField.layer.borderWidth = 1;
        _locationField.backgroundColor = [UIColor whiteColor];
        _locationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;        
        _locationField.textColor = [UIColor grayColor];
        _locationField.font = T12_FONT;
        _locationField.returnKeyType = UIReturnKeyGo;
        _locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _locationField.keyboardAppearance = UIKeyboardAppearanceAlert;
        _locationField.keyboardType = UIKeyboardTypeURL;
        _locationField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _locationField.autocorrectionType = UITextAutocorrectionTypeNo;
        _locationField.delegate = self;
        _locationField.placeholder = NSLocalizedString(@"请输入网址", @"");
        [_toolbar addSubview:_locationField];
        _locationField.text = _url;
    }
    
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        [_reloadButton setImage:[UIImage imageNamed:@"location_reload"] forState:UIControlStateNormal];
        [_reloadButton sizeToFit];
        [_toolbar addSubview:_reloadButton];
    }
    
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton addTarget:self action:@selector(stopClick:) forControlEvents:UIControlEventTouchUpInside];
        [_stopButton setImage:[UIImage imageNamed:@"location_stop"] forState:UIControlStateNormal];
        [_stopButton setImage:[UIImage imageNamed:@"location_stops"] forState:UIControlStateHighlighted];        
        [_stopButton sizeToFit];
        [_toolbar addSubview:_stopButton];
    }    
        
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self.view addSubview:_bottomView];
        [self.view bringSubviewToFront:_bottomView];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.5;
        _bottomView.userInteractionEnabled = YES;
    }
    
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton setImage:[UIImage imageNamed:@"left_arrow"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"left_arrows"] forState:UIControlStateHighlighted];
        [_leftButton sizeToFit];
        [_bottomView addSubview:_leftButton];
    }
    
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"right_arrows"] forState:UIControlStateHighlighted];
        [_rightButton sizeToFit];
        [_bottomView addSubview:_rightButton];
    }
    
    if (!_popButton) {
        _popButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_popButton setImage:[UIImage imageNamed:@"left_arrows"] forState:UIControlStateNormal];
        [_popButton addTarget:self action:@selector(popClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_popButton];
        
    }
    
    [self layoutView];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)leftClick:(id)sender
{
    [_webView goBack];
    [self updateButtonState];    
}

- (void)rightClick:(id)sender
{
    [_webView goForward];
    [self updateButtonState];
}

- (void)reloadClick:(id)sender
{
    [_webView reload];
    [self updateButtonState];    
}

- (void)stopClick:(id)sender
{
    [_loadingView stopAnimating];
    [_loadingView removeFromSuperview];
    [_webView stopLoading];
    [self updateButtonState];
}

- (void)popClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)layoutView {
    self.view.backgroundColor = [UIColor clearColor];
    
    _toolbar.frame = CGRectMake(0, 0, self.view.width, 40);
    _locationField.frame = CGRectMake(10, GAP_10-2, _toolbar.width - 100, 40 - GAP_15);
    _webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.height);
    _stopButton.frame = CGRectMake(_locationField.maxX + GAP_10, 0, 40, 40);
    _reloadButton.frame = CGRectMake(_stopButton.maxX + 2, 0, 40, 40);
    
    _bottomView.frame = CGRectMake(0, self.view.height - 40, self.view.width, 40);
    _leftButton.frame = CGRectMake(self.view.width - 80 - GAP_20*2, 0, 40, 40);
    _rightButton.frame = CGRectMake(self.view.width - 40 - GAP_20, 0, 40, 40);
    _popButton.frame = CGRectMake(10, 0, 40, 40);
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat prevDelta = previousContentDelta;
    CGFloat delta = scrollView.contentOffset.y - initialContentOffset;
    if (delta > 0.f && prevDelta <= 0.f) {
        NSLog(@"down down");
        [_bottomView setHiddenAnimated:YES andAlpha:0.5];
    } else if (delta < 0.f && prevDelta >= 0.f) {
        [_bottomView setHiddenAnimated:NO andAlpha:0.5];
        NSLog(@"up up");
    }
    
    previousContentDelta = delta;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    initialContentOffset = scrollView.contentOffset.y;
    previousContentDelta = 0.f;
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self updateButtonState];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self loadURL:textField.text];
    [self updateButtonState];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)updateButtonState {
    _leftButton.enabled = [_webView canGoBack];
    _rightButton.enabled = [_webView canGoForward];
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self loadURL:_url];
}

- (void)loadURL:(NSString *)url {
    _url = url;
    
    _loadIndicatorCount = 0;
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange rangeOfHttp = [url rangeOfString:@"http"];
    
    _locationField.text = url;
    if (rangeOfHttp.location == NSNotFound || rangeOfHttp.location != 0) {
        url = [NSString stringWithFormat:@"http://%@", url];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self updateButtonState];
    [self setLoadingIndicator:1];
    
    if(_loadingView) [_loadingView removeFromSuperview];
    
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loadingView.center = CGPointMake(_webView.width / 2.0, _webView.height / 2.0);
    _loadingView.tag = 1000;
    [_webView addSubview:_loadingView];
    [_loadingView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _locationField.text = [self currentUrl];
    
    [_loadingView stopAnimating];
    [_loadingView removeFromSuperview];
    
    NSLog(@"current url: %@", self.url);
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:
                                                     @"document.querySelector('meta[name=viewport]').setAttribute('content', 'width=%d;', false); ",(int)webView.frame.size.width]];
    
    [self updateButtonState];
    
    [self setLoadingIndicator:-1];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if (error.code == -1009) {
        NSLog(@"网络或者服务器连接错误");
    }
    [self updateButtonState];
    
    [self setLoadingIndicator:-1];
}

- (void)setLoadingIndicator:(int)count {
    _loadIndicatorCount += count;
    
    if (_loadIndicatorCount > 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (NSString *)currentUrl {
    return _webView.request.URL.absoluteString;
}

+ (void)openWithURL:(NSString *)url viewController:(UIViewController *)viewController
{
    BrowserViewController *bv = [[BrowserViewController alloc] initWithURL:url];
    [viewController.navigationController pushViewController:bv animated:YES];    
}

@end
