//
//  MainViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-5-24.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "MainViewController.h"
#import "SinaWeiboModel.h"
#import "SettingViewController.h"
#import "BrowserViewController.h"
#import "WeiboDetailViewController.h"
#import "PersonViewController.h"
#import "NotifyView.h"
#import "NotifyViewController.h"
#import "SendWeiboViewController.h"
#import "DMStatusBar.h"

#define RLOAD_BUTTON_TAG 20000

@interface MainViewController ()

@end

@implementation MainViewController
{
    CGRect _frame;
    NSUInteger _columnNum;
    SinaWeiboType *_weiboType;
    
    NSMutableArray *_collectionViewData;
    PTSinaWeiboClient *_sinaWeiboClient;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIView *_refreshFooterView;
    BOOL _reloading;
    BOOL _noMoreData;
    float _lastScrollYPositionForCollectionView;
    BOOL _getMoreWeibo;
    int _sinaWeiboCurPage;
    UIInterfaceOrientation _interfaceOrientation;
    UIImageView *_headerBG;
    
    CGFloat initialContentOffset;
    CGFloat previousContentDelta;
    
    NSMutableSet * _sinaRequests;
    
    NotifyView *_badgeButton;
    NSDictionary *notifyDic;
    UIButton *_leftButton;
    DMStatusBar *_dmStatusBar;
    
}

static NSString *SINAWEIBO_CELL_IDENTIFIER = @"SINAWEIBO_CELL_IDENTIFIER";
static float CELL_WIDTH = 0;

+ (float)cellWidth {
    return CELL_WIDTH;
}

- (id)init
{
    if (self = [super init]) {
        [self getWeiboData:nil frame:CGRectZero];
        
        _dmStatusBar = [[DMStatusBar alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        
        _badgeButton = [[NotifyView alloc] initWithTarget:self action:@selector(toNotifyCenter)];
        UIBarButtonItem * rightBtnOne = [[UIBarButtonItem alloc] initWithCustomView:_badgeButton];
        self.navigationItem.rightBarButtonItem = rightBtnOne;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotify:) name:@"CHECKING_UNREAD_COUNT" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUnreadWeibo:) name:@"GET_UNREAD_WEIBO" object:nil];
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, 20, 20);
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"pinglun_small_icon.png"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(sendWeibo:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    }
    
    return self;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)toNotifyCenter
{
    NotifyViewController *nvc = [[NotifyViewController alloc] initWithNotify:notifyDic];
    [self.navigationController pushViewController:nvc animated:YES];
}

- (void)sendWeibo:(id)sender
{
    SendWeiboViewController *svc = [[SendWeiboViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
    nc.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController presentModalViewController:nc animated:YES];
}

- (void)showNotify:(NSNotification *)notify
{
    NSLog(@"unread_notify : %@",notify.userInfo);
    notifyDic = [NSDictionary dictionaryWithDictionary:notify.userInfo];
    
    int status = [[notify.userInfo objectForKey:@"status"] integerValue]; //新评论
    int cmt = [[notify.userInfo objectForKey:@"cmt"] integerValue]; //新评论
    int dm = [[notify.userInfo objectForKey:@"dm"] integerValue]; //新私信
    int mention_status = [[notify.userInfo objectForKey:@"mention_status"] integerValue]; //新提及我的微博数
    int mention_cmt = [[notify.userInfo objectForKey:@"mention_cmt"] integerValue]; //新提及我的评论数
    int follower = [[notify.userInfo objectForKey:@"follower"] integerValue]; //新粉丝数
    int totalCount = cmt + dm + mention_cmt + mention_status + follower;
    [_badgeButton setBadgeCount:totalCount];
    
    UIViewController *currentVC = self.navigationController.visibleViewController;
    if ([currentVC isKindOfClass:[MainViewController class]] && status > 0) {
       [_dmStatusBar showStatusMessage:[NSString stringWithFormat:@"%d条未读",status]];
    }
}

- (void)getUnreadWeibo:(NSNotification *)notify
{
    [_dmStatusBar hide];    
    [self getWeiboData:nil frame:CGRectZero];
}

- (id)initWithType:(SinaWeiboType *)type
{
    if (self = [super init]) {
        [self getWeiboData:type frame:CGRectZero];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    return self;
}

- (void)getWeiboData:(SinaWeiboType *)type frame:(CGRect)frame
{
    _weiboType = type;
    _frame = self.view.bounds;
    _sinaWeiboCurPage = 1;
    _collectionViewData = [[NSMutableArray alloc] init];
    _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
    _sinaWeiboClient.delegate = self;
    _sinaRequests = [[NSMutableSet alloc] init];
    [self getHomeLineDataWithType:@"0" withHUD:[NSNumber numberWithBool:YES]];
}

- (void)dealloc
{
    for (SinaWeiboRequest *request in _sinaRequests) {
        [request disconnect];
        request.delegate = nil;
    }
    [_sinaRequests removeAllObjects];
    _sinaRequests = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CHECKING_UNREAD_COUNT" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GET_UNREAD_WEIBO" object:nil];    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_badgeButton setBadgeCount:@"0".integerValue];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"主页";
	// Do any additional setup after loading the view.
    
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    layout.delegate = self;
    _collectionView = [[PSUICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];
    [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerClass:[SinaWeiboCell class] forCellWithReuseIdentifier:SINAWEIBO_CELL_IDENTIFIER];
    [self.view addSubview:_collectionView];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSHourCalendarUnit fromDate:now];
    int hour = components.hour;
    int imageIndex = ((int)(hour / 4.8) - 1) % 5 + 1;
    if (imageIndex == 0) {
        imageIndex = 5;
    }
    
    _headerBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"refresh_bg%d.png", imageIndex]]];
    _headerBG.frame = CGRectMake(0, -180, self.view.width, 180);
    _headerBG.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_collectionView addSubview:_headerBG];
    
    [self layoutViews];
    [self configCollectionLayout];
    [self createLoadingHeaderView];    
//    [super createAwesomeMenuAbove:_collectionView];
}

#pragma mark - AwesomeMenuDelegate

- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
    SettingViewController *svc = [[SettingViewController alloc] init];
    
    switch (idx) {
        case 0:
            //
            break;
        case 1:
            //
            break;
        case 2:
            //
            break;
        case 3:
            //
            break;
        case 4:
            [self.navigationController pushViewController:svc animated:YES];
            break;
            
        default:
            break;
    }
    
}
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    _interfaceOrientation = toInterfaceOrientation;
    [self layoutCollectionView];
}

- (void)layoutCollectionView {
    float x = self.view.minX;
    float y = self.view.minY;
    float parentWidth = self.view.superview.width;
    float parentHeight = self.view.superview.height;
    self.view.frame = CGRectMake(x, y, parentWidth, parentHeight - y);
    _collectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self configCollectionLayout];
}

- (void)layoutViews {
    if (UIDeviceOrientationIsPortrait(self.interfaceOrientation)) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_v.jpg"]];
    } else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_h.jpg"]];
    }
}

- (void)configCollectionLayout {
    
    UICollectionViewWaterfallLayout *layout = (UICollectionViewWaterfallLayout *) _collectionView.collectionViewLayout;
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIDeviceOrientationLandscapeLeft || statusBarOrientation == UIDeviceOrientationLandscapeRight) {
        _columnNum = 3;
    } else {
        _columnNum = 2;
    }
    
    CELL_WIDTH = self.view.width / _columnNum;
    layout.itemWidth = CELL_WIDTH;
    layout.columnCount = _columnNum;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, GAP_15, 0);
}

#pragma mark PSUICollectionView stuff

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(PSUICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectionViewData.count;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PSUICollectionViewCell *cell = nil;
    
    if(_collectionViewData.count == 0) return nil;

    cell = [collectionView dequeueReusableCellWithReuseIdentifier:SINAWEIBO_CELL_IDENTIFIER forIndexPath:indexPath];
    if (indexPath.row < _collectionViewData.count) {
        SinaWeiboModel *weiboModel = _collectionViewData[(NSUInteger) indexPath.row];
        [(SinaWeiboCell *) cell updateCellWithData:weiboModel];
        ((SinaWeiboCell *) cell).delegate = self;
    }
    
    return cell;
}

#pragma mark PSUICollectionViewDelegate
- (void)collectionView:(PSTCollectionView *)collectionView didEndDisplayingCell:(PSTCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%d --- %d ....... %f --- %f",indexPath.row,_collectionViewData.count,collectionView.contentOffset.y,_lastScrollYPositionForCollectionView);
    
    if ((indexPath.row == _collectionViewData.count-10) && collectionView.contentOffset.y > 0 && (collectionView.contentOffset.y - _lastScrollYPositionForCollectionView >= 0)) {
        [self loadNextPageData];
    }
    _lastScrollYPositionForCollectionView = collectionView.contentOffset.y;
}

- (void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WeiboDetailViewController *swdvc = [[WeiboDetailViewController alloc] initWithSinaWeiboModel:[_collectionViewData objectAtIndex:indexPath.row]];
    swdvc.title = @"微博详情";
    [self.navigationController pushViewController:swdvc animated:YES];
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate

- (CGFloat)collectionView:(PSUICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SinaWeiboModel *model = _collectionViewData[(NSUInteger) indexPath.row];
    return [SinaWeiboCell calculateCardHeight:model];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getHomeLineDataWithType:(NSString *)type withHUD:(NSNumber *)hasHUDNumber
{
    
    if ([hasHUDNumber boolValue]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    }
    
    NSString *curPage = [NSString stringWithFormat:@"%d",_sinaWeiboCurPage];
    SinaWeibo *sinaWeibo = _sinaWeiboClient.sinaWeibo;
    NSString *accessToken = sinaWeibo.accessToken;
    
    if ([_weiboType.type isEqualToString: @"atme"]) {
    [_sinaRequests addObject:[sinaWeibo requestWithURL:SINA_ATME_PATH params:[@{@"access_token":accessToken,@"feature":type,@"page":curPage} mutableCopy] httpMethod:@"GET" delegate:self]];
    } else {
      [_sinaRequests addObject:[sinaWeibo requestWithURL:SINA_HOME_TIMELINE_PATH params:[@{@"access_token":accessToken,@"feature":type,@"page":curPage} mutableCopy] httpMethod:@"GET" delegate:self]];
    }
}

#pragma mark - SinaWeiboRequestDelegate

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [_sinaRequests removeObject:request];
    [_dmStatusBar setHidden:YES];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSArray *allWeibo = [result objectForKey:@"statuses"];
    NSLog(@"allWeibo : %@",allWeibo);
    
    for (NSDictionary *dic in allWeibo) {
        SinaWeiboModel *weiboModel = [[SinaWeiboModel alloc] initWithDictionary:dic];
        [_collectionViewData addObject:weiboModel];
    }
    
    NSArray *array = _collectionViewData;
    if (array.count == 0) {
        _noMoreData = YES;
    }
    
    if (_getMoreWeibo) {
        [self removeLoadingFooterView];
    } else {
        _sinaWeiboCurPage = 1;
        [_collectionView setContentOffset:CGPointZero];
    }
    
    [self configCollectionLayout];
    [self finishReloadingData];
    [_collectionView reloadData];
}

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [_sinaRequests removeObject:request];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载失败...";
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self removeLoadingFooterView];
    
    NSLog(@"get sinaweibo failed %@",error);
    
    if (_collectionViewData.count == 0) {                
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = RLOAD_BUTTON_TAG;
        button.frame = CGRectMake(0, 0, 200, 80);
        button.center = self.view.centerOfView;
        [button setTitle:@"重新加载 ..." forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reloadFirstTime:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)reloadFirstTime:(id)sender
{
    [[self.view viewWithTag:RLOAD_BUTTON_TAG] removeFromSuperview];    
    [self getWeiboData:nil frame:CGRectZero];
}

#pragma methods for creating and removing the header footer view

- (void)createLoadingHeaderView {
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.height, self.view.width, self.view.height)];
    _refreshHeaderView.delegate = self;
    [_collectionView addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)setLoadingFooterView {
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, 40)];
    _refreshFooterView.backgroundColor = [UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:0.5f];
    UILabel *lbl = [[UILabel alloc] initWithFrame:_refreshFooterView.bounds];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont boldSystemFontOfSize:20];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"Loading...";
    [_refreshFooterView addSubview:lbl];
    [self.view addSubview:_refreshFooterView];
    [UIView animateWithDuration:0.2 animations:^{
        _refreshFooterView.frame = CGRectMake(0, self.view.height - 40, self.view.width, 40);
    }];
}

- (void)removeLoadingFooterView {
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [UIView animateWithDuration:0.2 animations:^{
            _refreshFooterView.frame = CGRectMake(0, self.view.height, self.view.width, 40);
        }                completion:^(BOOL finished) {
            [_refreshFooterView removeFromSuperview];
        }];
    }
}

#pragma mark -
#pragma mark data loading logic
- (void)refreshDataWithHUD:(NSNumber *)hasHUDNumber {
    _noMoreData = NO;
    _sinaWeiboCurPage = 1;
    [_collectionViewData removeAllObjects];
    if ([hasHUDNumber boolValue]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    }
    
    [self getHomeLineDataWithType:@"0" withHUD:[NSNumber numberWithBool:NO]];
}

- (void)loadNextPageData {
    
    if (_noMoreData) {
        return;
    }
    _getMoreWeibo = YES;
    _sinaWeiboCurPage += 1;
    [self setLoadingFooterView];
    [self getHomeLineDataWithType:@"0" withHUD:[NSNumber numberWithBool:NO]];
}

#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass
- (void)beginToReloadData:(EGORefreshPos)aRefreshPos {
    _reloading = YES;
    if (aRefreshPos == EGORefreshHeader) {
        [self performSelector:@selector(refreshDataWithHUD:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.5];
    }
}
#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData {
    _reloading = NO;
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_collectionView];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    CGFloat prevDelta = previousContentDelta;
    CGFloat delta = scrollView.contentOffset.y - initialContentOffset;
    if (delta > 0.f && prevDelta <= 0.f) {
        NSLog(@"down down");
    } else if (delta < 0.f && prevDelta >= 0.f) {
        NSLog(@"up up");
    }
    previousContentDelta = delta;    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    initialContentOffset = scrollView.contentOffset.y;
    previousContentDelta = 0.f;
}

#pragma mark EGORefreshTableDelegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos {
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view {
    return _reloading;
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view {
    return [NSDate date]; // should return date data source was last changed
}

- (void)openWeiboWithUrl:(NSString *)url
{
    [BrowserViewController openWithURL:url viewController:self];
}

- (void)gotoPersonWith:(SinaUserModel *)sinaUser
{
    PersonViewController *pvc = [[PersonViewController alloc] initWithSinaUserModel:sinaUser];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
