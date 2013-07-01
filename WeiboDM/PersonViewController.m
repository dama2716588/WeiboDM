//
//  PersonViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-16.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "PersonViewController.h"
#import "JSONKit.h"
#import "PersonCell.h"
#import "WeiboDetailViewController.h"

#define COMMENTS_PER_PAGE @"10"

@interface PersonViewController ()

@end

@implementation PersonViewController
{
    PTSinaWeiboClient *_sinaWeiboClient;
    UIScrollView *_scrollView;
    UITableView *_tableView;
    SinaUserModel *_sinaUserModel;
    
    NSMutableArray *_weiboArray;
    BOOL _hasMore;
    int _currentPage;
    UIView *_moreWeiboView;
    UIView *_headerView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id)initWithSinaUserModel:(SinaUserModel *)sinaUser
{
    if (self = [super init]) {
        _sinaUserModel = sinaUser;
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
        _weiboArray = [NSMutableArray array];
        _hasMore = YES;
        _currentPage = 1;
        [self loadWeibo];        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = _sinaUserModel.name;
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0];
	
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    
    _headerView = [[UIView alloc] init];
    _headerView.frame = CGRectMake(0, 0, 320, 220);
    [_headerView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"person_header_bg"]]];
    [_scrollView addSubview:_headerView];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.frame = CGRectMake(250, 150, 40, 40);
    iconImage.layer.cornerRadius = 20;
    iconImage.clipsToBounds = YES;
    [iconImage setImageWithURL:[NSURL URLWithString:_sinaUserModel.profile_image_url]];
    [_headerView addSubview:iconImage];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _moreWeiboView = [[UIView alloc] init];
    _moreWeiboView.frame = CGRectMake(0, 0, self.view.width,50);
    _moreWeiboView.backgroundColor = [UIColor clearColor];
    _moreWeiboView.userInteractionEnabled = YES;
    UILabel *moreCommemtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    moreCommemtLabel.text = @"点击查看更多";
    moreCommemtLabel.textAlignment = UITextAlignmentCenter;
    moreCommemtLabel.textColor = [UIColor orangeColor];
    moreCommemtLabel.backgroundColor = [UIColor clearColor];
    [_moreWeiboView addSubview:moreCommemtLabel];
    [_tableView setTableFooterView:_moreWeiboView];
    
    UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMoreCommemts:)];
    [_moreWeiboView addGestureRecognizer:moreTap];
        
    [_scrollView addSubview:_tableView];
    [self.view addSubview:_scrollView];
    
    [self layoutViews];    
}

- (void)layoutViews
{    
    // reset frame
    _tableView.frame = CGRectMake(0, _headerView.maxY + GAP_20, self.view.width, _tableView.contentSize.height);
    _scrollView.contentSize = CGSizeMake(self.view.width, _tableView.maxY);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMoreCommemts:(UITapGestureRecognizer *)tap
{
    _currentPage += 1;
    [self loadWeibo];
}

- (void)loadWeibo
{
    SinaWeibo *sinaWeibo = _sinaWeiboClient.sinaWeibo;
    NSString *accessToken = sinaWeibo.accessToken;
    NSLog(@"weibo_access_token:%@",sinaWeibo.accessToken);
    [sinaWeibo requestWithURL:SINA_USER_TIMELINE_PATH
                       params:[@{@"access_token":accessToken,@"uid":_sinaUserModel.idstr,@"page":[NSString stringWithFormat:@"%d",_currentPage],@"count":COMMENTS_PER_PAGE} mutableCopy]
                   httpMethod:@"GET"
                     delegate:self];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSArray *commArray = [result objectForKey:@"statuses"];
    NSLog(@"person : %@",result);
    
    if (commArray.count < COMMENTS_PER_PAGE.intValue) {
        _hasMore = NO;
        [_tableView setTableFooterView:nil];
    }
    
    for (NSDictionary *dic in commArray) {
        NSLog(@"comments text : %@",[[dic objectForKey:@"text"] JSONString]);
        SinaWeiboModel *model = [[SinaWeiboModel alloc] initWithDictionary:dic];
        [_weiboArray addObject:model];
    }
    NSLog(@"_commentsArray : %@",_weiboArray);
    [_tableView reloadData];
    
    _tableView.frame = CGRectMake(_tableView.origin.x, _headerView.maxY + GAP_20, _tableView.width, _tableView.contentSize.height);
    _scrollView.frame = CGRectMake(0, 0, 320, self.view.height);    
    _scrollView.contentSize = CGSizeMake(self.view.width, _tableView.maxY);
}

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];    
    NSLog(@"weibo request error : %@",error);
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _weiboArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"COMMENTS_CELL";
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
    }
    SinaWeiboModel *commentModel = [_weiboArray objectAtIndex:indexPath.row];
    [cell updateCellWithData:commentModel];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SinaWeiboModel *model = _weiboArray[(NSUInteger) indexPath.row];
    NSLog(@"weibo_detail_cell_height : %f",[PersonCell calculateCardHeight:model]);
    return [PersonCell calculateCardHeight:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WeiboDetailViewController *wvc = [[WeiboDetailViewController alloc] initWithSinaWeiboModel:[_weiboArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:wvc animated:YES];
}

@end
