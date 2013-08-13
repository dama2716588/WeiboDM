//
//  WeiboDetailViewController.m
//  WeiboDM
//
//  Created by ma yulong on 13-6-11.
//  Copyright (c) 2013年 ma yulong. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "SinaCommentsModel.h"
#import "JSONKit.h"
#import "PersonViewController.h"
#import "ToAWeiboViewController.h"
#import "BrowserViewController.h"
#import "ImageDisplayController.h"

#define COMMENTS_PER_PAGE @"10"

@interface WeiboContentHeaderView : UIView

@property (nonatomic, strong)  UIImageView *iconImageView;
@property (nonatomic, strong)  UILabel *nameLabel;
@property (nonatomic, strong)  UIView *lineView;

@end

@implementation WeiboContentHeaderView
- (id)initWithFrame:(CGRect)frame SinaWeiboModel:(SinaWeiboModel *)model {
    if (self = [super initWithFrame:frame]) {
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        _iconImageView.layer.cornerRadius = 25;
        _iconImageView.clipsToBounds = YES;
        [_iconImageView setImageWithURL:[NSURL URLWithString:model.sinaUser.profile_image_url]];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 50)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.text = model.sinaUser.name;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 1)];
        _lineView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
        
        [self addSubview:_iconImageView];
        [self addSubview:_nameLabel];
        [self addSubview:_lineView];
    }
    return self;
}


@end

@interface WeiboDetailViewController ()

@end

@implementation WeiboDetailViewController
{
    SinaWeiboModel *_SinaWeiboModel;
    WeiboContentHeaderView *_pinHeaderView;
    UIView *_pinFooterView;
    UIScrollView *_scrollView;
    OHAttributedLabel *_originLabel;
    UIImageView *_originImageView;
    UIView *_repostBg;    
    OHAttributedLabel *_repostLabel;
    UIImageView *_repostImageView;
    UITableView *_tableView;
    PTSinaWeiboClient *_sinaWeiboClient;
    NSMutableArray *_commentsArray;
    BOOL _hasMore;
    int _currentPage;
    UIView *_moreCommentsView;
    
    UIButton *_pinButton;
    UIButton *_zhuanButton;
    UILabel *_pinLable;
    UILabel *_zhuanLabel;
    UILabel*_timeLable;
    UIView *_lineView;
    UIView *_bottomBarView;
    ImageDisplayController *_imageDisplayController;
}

- (id)initWithSinaWeiboModel:(SinaWeiboModel *)model
{
    if (self = [super init]) {
        _SinaWeiboModel = model;
        _sinaWeiboClient = [[PTSinaWeiboClient alloc] init];
        _sinaWeiboClient.delegate = self;
        _commentsArray = [NSMutableArray array];        
        _hasMore = YES;
        _currentPage = 1;
        [self loadWeiboContent];        
    }
    
    return self;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RELOAD_COMMENT_TABLE object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];        
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView:) name:RELOAD_COMMENT_TABLE object:nil];
	
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    
    _pinHeaderView = [[WeiboContentHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80) SinaWeiboModel:_SinaWeiboModel];
    _pinHeaderView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPerson:)];
    _pinHeaderView.userInteractionEnabled = YES;
    [_pinHeaderView addGestureRecognizer:tap];
    
    _originLabel = [[OHAttributedLabel alloc] init];
    _originLabel.delegate = self;
    _originLabel.numberOfLines = 0;
    _originLabel.backgroundColor = [UIColor clearColor];
    _originLabel.textColor = [UIColor blackColor];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_SinaWeiboModel.text];
    [text setFont:T16_FONT];
    _originLabel.attributedText = text;
    
    
    _originImageView = [[UIImageView alloc] init];
    _originImageView.backgroundColor = [UIColor whiteColor];
    [_originImageView setClipsToBounds:YES];
    _originImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_originImageView setImageWithURL:[NSURL URLWithString:_SinaWeiboModel.bmiddle_pic] placeholderImage:[UIImage imageNamed:@""]];
    _originImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [_originImageView addGestureRecognizer:tapImage];
    
    
    _repostBg = [[UIView alloc] init];
    _repostBg.backgroundColor = [UIColor colorWithRed:228/255.0f green:228/255.0f blue:228/255.0f alpha:1.0f];
    _repostBg.layer.cornerRadius = 2;
    
    if (_SinaWeiboModel.sinaRepost.text) {
        _repostLabel = [[OHAttributedLabel alloc] init];
        _repostLabel.delegate = self;
        _repostLabel.numberOfLines = 0;
        _repostLabel.backgroundColor = [UIColor clearColor];
        _repostLabel.textColor = [UIColor blackColor];
        NSMutableAttributedString *textR = [[NSMutableAttributedString alloc] initWithString:_SinaWeiboModel.sinaRepost.text];
        [textR setFont:T14_FONT];
        _repostLabel.attributedText = textR;
        [_repostBg addSubview:_repostLabel];
    }
    
    if (_SinaWeiboModel.sinaRepost.bmiddle_pic) {
        _repostImageView = [[UIImageView alloc] init];
        _repostImageView.backgroundColor = [UIColor whiteColor];
        [_repostImageView setClipsToBounds:YES];
        _repostImageView.userInteractionEnabled = YES;
        _repostImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_repostImageView setImageWithURL:[NSURL URLWithString:_SinaWeiboModel.sinaRepost.bmiddle_pic] placeholderImage:[UIImage imageNamed:@""]];
        [_repostBg addSubview:_repostImageView];
        
        UITapGestureRecognizer *repostImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRepostImage:)];
        [_repostImageView addGestureRecognizer:repostImage];
    }
    
    _pinFooterView = [[UIView alloc] init];
    _pinFooterView.backgroundColor = [UIColor clearColor];
    
    
    _pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_pinButton setBackgroundImage:[UIImage imageNamed:@"pinglun_small_icon.png"] forState:UIControlStateNormal];
    
    _zhuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_zhuanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_zhuanButton setBackgroundImage:[UIImage imageNamed:@"zhuanfa_small_icon.png"] forState:UIControlStateNormal];
    
    _pinLable = [[UILabel alloc] init];
    _zhuanLabel = [[UILabel alloc] init];
    _pinLable.backgroundColor = [UIColor clearColor];
    _zhuanLabel.backgroundColor = [UIColor clearColor];
    _pinButton.layer.cornerRadius = 10;
    _zhuanButton.layer.cornerRadius = 10;
    _pinButton.clipsToBounds = YES;
    _zhuanButton.clipsToBounds = YES;
    _pinLable.textColor = [UIColor lightGrayColor];
    _zhuanLabel.textColor = [UIColor lightGrayColor];
    
    _timeLable = [[UILabel alloc] init];
    _timeLable.backgroundColor = [UIColor clearColor];
    _timeLable.textColor = [UIColor lightGrayColor];
    _timeLable.font = T12_FONT;
    
    _pinLable.text = [NSString stringWithFormat:@"%d",_SinaWeiboModel.comments_count];
    _zhuanLabel.text = [NSString stringWithFormat:@"%d",_SinaWeiboModel.reposts_count];
    [_pinLable sizeToFit];
    [_zhuanLabel sizeToFit];
    
    _timeLable.text = [self getFormatString:_SinaWeiboModel.created_at];
    [_timeLable sizeToFit];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    [_pinFooterView addSubview:_lineView];
    
    
    [_pinFooterView addSubview:_pinButton];
    [_pinFooterView addSubview:_zhuanButton];
    [_pinFooterView addSubview:_pinLable];
    [_pinFooterView addSubview:_zhuanLabel];
    [_pinFooterView addSubview:_timeLable];    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    _moreCommentsView = [[UIView alloc] init];
    _moreCommentsView.frame = CGRectMake(0, 0, self.view.width,50);
    _moreCommentsView.backgroundColor = [UIColor clearColor];
    _moreCommentsView.userInteractionEnabled = YES;
    UILabel *moreCommemtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    moreCommemtLabel.text = @"点击查看更多评论";
    moreCommemtLabel.textAlignment = UITextAlignmentCenter;
    moreCommemtLabel.textColor = [UIColor orangeColor];
    moreCommemtLabel.backgroundColor = [UIColor clearColor];
    [_moreCommentsView addSubview:moreCommemtLabel];
    [_tableView setTableFooterView:_moreCommentsView];
    
    UITapGestureRecognizer *moreTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadMoreCommemts:)];
    [_moreCommentsView addGestureRecognizer:moreTap];
        
    [_scrollView addSubview:_pinHeaderView];
    [_scrollView addSubview:_originLabel];
    [_scrollView addSubview:_originImageView];
    [_scrollView addSubview:_repostBg];
    [_scrollView addSubview:_pinFooterView];
    [_scrollView addSubview:_tableView];
    [self.view addSubview:_scrollView];
    
    _bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-90, 320, 90)];
    _bottomBarView.backgroundColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:0.9];
    _bottomBarView.alpha = 0.8;
    [self.view addSubview:_bottomBarView];
    
    UIButton *comButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [comButton setFrame:CGRectMake(10, 10, 30, 30)];
    [comButton setBackgroundImage:[UIImage imageNamed:@"pinglun_big_icon"] forState:UIControlStateNormal];
    [comButton addTarget:self action:@selector(clickComButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBarView addSubview:comButton];

    UIButton *resButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resButton setFrame:CGRectMake(80, 10, 30, 30)];
    [resButton setBackgroundImage:[UIImage imageNamed:@"zhuanfa_big_icon"] forState:UIControlStateNormal];
    [resButton addTarget:self action:@selector(clickResButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomBarView addSubview:resButton];
    
    [self layoutViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    [BrowserViewController openWithURL:[linkInfo.URL absoluteString] viewController:self];
    return NO;
}

- (void)reloadTableView:(NSNotification *)notify
{
    [_commentsArray removeAllObjects];
    [self loadWeiboContent];
}

- (void)clickComButton:(id)sender
{
    ToAWeiboViewController *svc = [[ToAWeiboViewController alloc] initWithType:CommentType andModel:_SinaWeiboModel];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
    nc.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController presentModalViewController:nc animated:YES];
}

- (void)clickResButton:(id)sender
{
    ToAWeiboViewController *svc = [[ToAWeiboViewController alloc] initWithType:RepostType andModel:_SinaWeiboModel];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:svc];
    nc.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController presentModalViewController:nc animated:YES];
}

-(void)clickedUserIcon:(SinaUserModel *)sinaUser
{
    PersonViewController *pvc = [[PersonViewController alloc] initWithSinaUserModel:sinaUser];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (NSString *)getFormatString:(NSString *)aString
{
    NSString *myDateString = aString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en"]];
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss z yyyy"];
    NSDate *theDate  = [dateFormatter dateFromString:myDateString];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *newDateString = [dateFormatter stringFromDate:theDate];
    
    return newDateString;
}

- (void)layoutViews
{
    
    CGSize repostSize = CGSizeZero;
    CGSize textSize = CGSizeZero;
    
    if(_SinaWeiboModel.text){
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_SinaWeiboModel.text];
        [text setFont:T16_FONT];
        textSize = [text sizeConstrainedToSize:CGSizeMake(self.view.width - GAP_20, 300)];
    }
    
    if(_SinaWeiboModel.sinaRepost.text){
        NSMutableAttributedString *retext = [[NSMutableAttributedString alloc] initWithString:_SinaWeiboModel.sinaRepost.text];
        [retext setFont:T14_FONT];
        repostSize = [retext sizeConstrainedToSize:CGSizeMake(self.view.width - GAP_40, 360)];
    }
    
    _originLabel.frame = CGRectMake(10, _pinHeaderView.maxY, 300, textSize.height);
    
    if (_SinaWeiboModel.bmiddle_pic) {
        _originImageView.frame = CGRectMake(GAP_10, GAP_10 + _originLabel.maxY , self.view.width-GAP_20, 300);
    } else {
        _originImageView.frame = CGRectZero;
    }
    
    if(_SinaWeiboModel.sinaRepost.text){
        _repostLabel.frame = CGRectMake(GAP_10, GAP_10, self.view.width-GAP_40, repostSize.height);
    } else {
        _repostLabel.frame = CGRectZero;
    }
    
    if (_SinaWeiboModel.sinaRepost.bmiddle_pic){
        _repostImageView.frame = CGRectMake(GAP_10, _repostLabel.height + GAP_20, 280,300);
    } else {
        _repostImageView.frame = CGRectZero;
    }
    
    if (_SinaWeiboModel.sinaRepost) {
        CGFloat gapH = _SinaWeiboModel.sinaRepost.bmiddle_pic ? GAP_20 : GAP_10;
       _repostBg.frame = CGRectMake(GAP_10, _originLabel.maxY + GAP_10, 300, _repostLabel.maxY + _repostImageView.height + gapH);
    } else {
        _repostBg.frame = CGRectZero;
    }
    
    CGFloat h0 = _originLabel.maxY + GAP_10;
    CGFloat h1 = _SinaWeiboModel.bmiddle_pic ? _originImageView.height +GAP_10 : 0;
    CGFloat h2 = _SinaWeiboModel.sinaRepost.text ? repostSize.height + GAP_30 : 0;
    CGFloat h3 = _SinaWeiboModel.sinaRepost.bmiddle_pic ? _repostImageView.height + GAP_10: 0;
    
    _pinFooterView.frame = CGRectMake(0, h0 + h1 + h2 + h3 + GAP_10 , self.view.width, 60);
    _pinButton.frame = CGRectMake(10, _pinFooterView.height - GAP_40, 20, 20);
    _pinLable.center = CGPointMake(_pinButton.maxX + _pinLable.width/2 + GAP_10, _pinButton.centerY);
    _zhuanButton.frame = CGRectMake(_pinLable.maxX + GAP_20, _pinFooterView.height - GAP_40, 20, 20);
    _zhuanLabel.center = CGPointMake(_zhuanButton.maxX + _zhuanLabel.width/2 + GAP_10, _zhuanButton.centerY);
    _timeLable.frame = CGRectMake(180, _pinFooterView.height - GAP_40, 160, 20);
    _lineView.frame = CGRectMake(0, _pinFooterView.height-1, 320, 1);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 320, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0];
    [_pinFooterView addSubview:lineView];    
    
    // reset frame
    _tableView.frame = CGRectMake(0, _pinFooterView.maxY, self.view.width, _tableView.contentSize.height);
    _scrollView.frame = CGRectMake(0, 0, 320, self.view.height-90);
}

- (void)gotoPerson:(UITapGestureRecognizer *)tap
{
    PersonViewController *pvc = [[PersonViewController alloc] initWithSinaUserModel:_SinaWeiboModel.sinaUser];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (void)clickImage:(UITapGestureRecognizer *)tap
{
    if(_SinaWeiboModel.original_pic.length == 0) return;
    
    NSString *url = _SinaWeiboModel.original_pic;
    NSArray *array = [[NSArray alloc] initWithObjects:url, nil];
    NSArray *preArray = [[NSArray alloc] initWithObjects:_originImageView.image, nil];
    
    if (_imageDisplayController == nil) {
        _imageDisplayController = [[ImageDisplayController alloc] initWithImagesUrl:array preImage:preArray];
        
    }else{
        [_imageDisplayController reloadData:array preImage:preArray];
    }
    [_imageDisplayController showToView:self.parentViewController.view];
    
}

- (void)clickRepostImage:(UITapGestureRecognizer *)tap
{
    if(_SinaWeiboModel.sinaRepost.original_pic.length == 0) return;
    
    NSString *url = _SinaWeiboModel.sinaRepost.original_pic;
    NSArray *array = [[NSArray alloc] initWithObjects:url, nil];
    NSArray *preArray = [[NSArray alloc] initWithObjects:_repostImageView.image, nil];

    if (_imageDisplayController == nil) {
        _imageDisplayController = [[ImageDisplayController alloc] initWithImagesUrl:array preImage:preArray];
        
    }else{
        [_imageDisplayController reloadData:array preImage:preArray];
    }
    [_imageDisplayController showToView:self.parentViewController.view];    
}

- (void)loadMoreCommemts:(UITapGestureRecognizer *)tap
{
    _currentPage += 1;
    [self loadWeiboContent];
}

- (void)loadWeiboContent
{
    SinaWeibo *sinaWeibo = _sinaWeiboClient.sinaWeibo;
    NSString *accessToken = sinaWeibo.accessToken;
    NSLog(@"weibo_access_token:%@",sinaWeibo.accessToken);
    [sinaWeibo requestWithURL:SINA_COMMENTS_SHOW_PATH
                       params:[@{@"access_token":accessToken,@"id":_SinaWeiboModel.mid,@"page":[NSString stringWithFormat:@"%d",_currentPage],@"count":COMMENTS_PER_PAGE} mutableCopy]
                   httpMethod:@"GET"
                     delegate:self];
}

-(void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSArray *commArray = [result objectForKey:@"comments"];
    if (commArray.count < COMMENTS_PER_PAGE.intValue) {
        _hasMore = NO;
        [_tableView setTableFooterView:nil];
    }
    
    for (NSDictionary *dic in commArray) {
        NSLog(@"comments text : %@",[[dic objectForKey:@"text"] JSONString]);
        SinaCommentsModel *model = [[SinaCommentsModel alloc] initWithDictionary:dic];
        [_commentsArray addObject:model];
    }
    NSLog(@"_commentsArray : %@",_commentsArray);
    [_tableView reloadData];
    
    _tableView.frame = CGRectMake(_tableView.origin.x, _tableView.origin.y, _tableView.width, _tableView.contentSize.height);
    _scrollView.contentSize = CGSizeMake(self.view.width, _tableView.maxY);
}

-(void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"weibo request error : %@",error);
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_IDENTIFIER = @"COMMENTS_CELL";
    WeiboCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[WeiboCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_IDENTIFIER];
        cell.delegate = self;
    }
    SinaCommentsModel *commentModel = [_commentsArray objectAtIndex:indexPath.row];
    [cell updateCellWithComment:commentModel];
    return cell;
}
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SinaCommentsModel *model = _commentsArray[(NSUInteger) indexPath.row];
    NSLog(@"weibo_detail_cell_height : %f",[WeiboCommentCell getCellHeight:model]);
    return [WeiboCommentCell getCellHeight:model];
}

@end
